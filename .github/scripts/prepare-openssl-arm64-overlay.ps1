param(
    [Parameter(Mandatory = $true)]
    [string]$VcpkgRoot,

    [Parameter(Mandatory = $true)]
    [string]$OverlayRoot,

    [Parameter(Mandatory = $true)]
    [string]$RepositoryRoot
)

$ErrorActionPreference = 'Stop'

$sourcePort = Join-Path $VcpkgRoot 'ports/openssl'
$overlayPort = Join-Path $OverlayRoot 'openssl'
$portfilePath = Join-Path $overlayPort 'portfile.cmake'
$patchPath = Join-Path $RepositoryRoot '.github/vcpkg/openssl-arm64-stack-probe.patch'

if (-not (Test-Path $sourcePort)) {
    throw "The vcpkg OpenSSL port was not found at $sourcePort"
}

if (-not (Test-Path $patchPath)) {
    throw "The ARM64 OpenSSL stack-probe patch was not found at $patchPath"
}

if (Test-Path $OverlayRoot) {
    Remove-Item $OverlayRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $OverlayRoot -Force | Out-Null
Copy-Item -Path $sourcePort -Destination $overlayPort -Recurse

$portfile = [System.IO.File]::ReadAllText($portfilePath)
$anchor = '        unix/no-static-libs-for-shared.patch'
if (([regex]::Matches($portfile, [regex]::Escape($anchor))).Count -ne 1) {
    throw "The pinned vcpkg OpenSSL port layout changed; cannot add the ARM64 patch safely"
}

$newline = if ($portfile.Contains("`r`n")) { "`r`n" } else { "`n" }
$portfile = $portfile.Replace($anchor, "$anchor$newline        openssl-arm64-stack-probe.patch")
[System.IO.File]::WriteAllText($portfilePath, $portfile)
Copy-Item -Path $patchPath -Destination (Join-Path $overlayPort 'openssl-arm64-stack-probe.patch')
