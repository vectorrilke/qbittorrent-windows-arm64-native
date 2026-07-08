# Native ARM64 Workflow Explanation

This repository uses one CI path: a native Windows ARM64 build of qBittorrent using MSVC ARM64 cross tools on GitHub Actions.

Workflow file:

- .github/workflows/ci_windows_arm64_native.yaml

## Current repository baseline

The repo is intentionally minimal:

- one default branch: main
- one active workflow: ci_windows_arm64_native.yaml
- one build strategy: MSVC-based ARM64 native executable

Legacy workflows and MinGW helper files were removed to reduce confusion and maintenance overhead.

## Trigger model

The workflow runs on:

- push to main
- push of tags matching v*
- manual workflow_dispatch

This supports continuous prerelease builds from main and stable release builds from version tags.

## Version control surface

The main values to update for new builds are in the workflow env block:

- boost_version
- libt_version
- qbt_version
- qt_version
- vcpkg_triplet

Keeping versions centralized makes upgrades predictable.

## Toolchain and dependency model

The job uses:

- ilammy/msvc-dev-cmd for ARM64 cross compilation
- lukka/run-vcpkg with a pinned baseline commit
- Ninja for CMake builds

All dependency resolution is aligned to one triplet:

- arm64-windows-static-release

That triplet is used consistently for OpenSSL, zlib, Qt configuration, libtorrent, and qBittorrent.

## Build stages

1. Setup compiler and tools
2. Initialize vcpkg and install dependencies
3. Build Qt target libraries for ARM64
4. Build libtorrent for ARM64
5. Build qBittorrent
6. Package artifact
7. Publish artifact/release

## Packaging and publishing

Packaged files include:

- qbittorrent.exe
- dist/windows/qt.conf from qBittorrent sources

Publishing rules:

- pushes to main create prerelease artifacts
- v* tags create release artifacts

## Notes

- This cleanup simplifies CI maintenance.
- Runtime issues in a specific qBittorrent version may still require upstream fixes and are not always CI-related.
