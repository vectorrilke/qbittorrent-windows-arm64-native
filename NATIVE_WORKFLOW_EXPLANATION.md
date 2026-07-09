# Native ARM64 Workflow Explanation

This repository uses a single CI workflow that builds native Windows ARM64 qBittorrent binaries with MSVC cross tools on GitHub Actions.

Workflow file:

- .github/workflows/ci_windows_arm64_native.yaml

## Current repository baseline

The repo is intentionally minimal:

- one default branch: main
- one active workflow: ci_windows_arm64_native.yaml
- one build strategy: MSVC-based ARM64 native executable matrixed by libtorrent branch

Legacy workflows and MinGW helper files were removed to reduce confusion and maintenance overhead.

## Trigger model

The workflow runs on:

- push to main
- push of tags matching v*
- manual workflow_dispatch

This supports continuous prerelease builds from main and stable release builds from version tags.

## Version control surface

The workflow has global versions and matrix-specific versions.

Global values are in the workflow env block:

- qbt_version
- qt_version
- vcpkg_triplet

Matrix values are in strategy.matrix.include:

- libt_variant
- libt_ref
- boost_version
- libt_version_display
- archive_suffix
- artifact_name

This split allows lt12 and lt20 to use different Boost versions safely.

Current matrix at the time of writing:

- lt12: libtorrent 1.2.20+gitc5ff6c3186 with Boost 1.86.0
- lt20: libtorrent 2.0.13+gitda7a68a440 with Boost 1.91.0

## Toolchain and dependency model

The job uses:

- ilammy/msvc-dev-cmd for ARM64 cross compilation
- lukka/run-vcpkg with a pinned baseline commit
- Ninja for CMake builds

All dependency resolution is aligned to one triplet:

- arm64-windows-static-release

That triplet is used consistently for OpenSSL, zlib, Qt configuration, libtorrent, and qBittorrent.

vcpkg is pinned to a fixed baseline commit to reduce random breakage from upstream package changes.

## Build stages

1. Setup compiler and tools
2. Initialize vcpkg and install dependencies
3. Resolve source URLs for qBittorrent and matrix-selected Boost
4. Download and unpack Boost
5. Build Qt target libraries for ARM64
6. Build libtorrent for ARM64 from exact commit ref in matrix
7. Build qBittorrent (RelWithDebInfo)
8. Package artifact zip and optional symbols folder
9. Upload one artifact per matrix entry
10. Publish both matrix artifacts in one release job

## Packaging and publishing

Packaged files include:

- qbittorrent.exe
- dist/windows/qt.conf from qBittorrent sources

Generated artifact names:

- lt12: qbittorrent_<qbt_version>_arm64.zip
- lt20: qbittorrent_<qbt_version>_lt20_arm64.zip

PDB files are not included in release ZIP files. If present, they are uploaded under a symbols folder inside the CI artifact.

Publishing rules:

- pushes to main create prerelease releases with both artifacts
- v* tags create stable releases with both artifacts

## Notes

- If a matrix entry starts failing, check the exact first compiler/linker error in that variant job before changing shared workflow logic.
- A known compatibility rule is that libtorrent 1.2.20 requires Boost 1.86.0 in this pipeline.
- Runtime issues in a specific qBittorrent version may still require upstream fixes and are not always CI-related.
