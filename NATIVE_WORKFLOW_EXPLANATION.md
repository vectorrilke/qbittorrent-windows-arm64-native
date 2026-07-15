# Native ARM64 Workflow Explanation

This repository uses one CI workflow to build native Windows ARM64 qBittorrent binaries with MSVC cross tools on GitHub Actions.

Workflow file:

- .github/workflows/ci_windows_arm64_native.yaml

## Current baseline

The pipeline is now single-track and libtorrent version 2+ only:

- default branch: main
- one active workflow
- one libtorrent target (lt20)

The workflow targets libtorrent 2.x only; libtorrent 1.2 (lt12) is retired from CI builds.

## Trigger model

The workflow runs on:

- push to main
- push of tags matching v*-arm64
- manual workflow_dispatch

This gives:

- branch releases from main
- tagged releases from ARM64 version tags

## Version surface

Versions and build identity are defined in top-level env variables:

- qbt_version
- qt_version
- vcpkg_triplet
- libt_variant
- libt_ref
- libt_version_display
- boost_version
- artifact_name

This keeps future version bumps in one place.

## Toolchain and dependency model

The workflow uses:

- ilammy/msvc-dev-cmd for ARM64 cross compilation
- lukka/run-vcpkg pinned to a fixed vcpkg baseline commit
- Ninja for CMake builds

Dependency triplet is fixed to:

- arm64-windows-static-release

## Build stages

1. Setup MSVC ARM64 cross toolchain and build tools.
2. Setup and normalize vcpkg paths.
3. Install dependency packages (OpenSSL and zlib for the triplet).
4. Build source URLs for Boost and qBittorrent tarball.
5. Download/unpack Boost.
6. Install Qt host tools and build Qt target libs for ARM64.
7. Build libtorrent (lt20 ref from env) for ARM64.
8. Build qBittorrent.
9. Package artifact zip.
10. Upload artifact.
11. Run ARM64 smoke validation (PE signature and machine type check).
12. Publish release assets for tag/main rules.

## Important build guards

Two key safeguards are intentionally present:

- libtorrent configure uses -DCMAKE_DISABLE_FIND_PACKAGE_OpenSSL=TRUE
	to avoid duplicate OpenSSL symbol paths in the final static link setup.

- qBittorrent CommonConfig is patched during CI from
	QT_DISABLE_DEPRECATED_UP_TO=0x060500 to 0x040800
	to match Windows static linking compatibility expectations and avoid
	Qt removed_api duplicate symbol linker failures.

## Packaging model

Packaged zip contents:

- qbittorrent.exe
- qt.conf

Artifact zip filename:

- qbittorrent_<qbt_version>_arm64.zip

PDB/symbol artifacts are not packaged or published.

## Release model

Tagged release path:

- tag format: v<qbt_version>-arm64
- release tag_name: v<qbt_version>-arm64
- release title: qBittorrent <qbt_version> (Windows ARM64 Native)
- asset: artifacts/<artifact_name>/qbittorrent_<qbt_version>_arm64.zip

Main-branch release path:

- tag_name: native-arm64-main-<run_number>
- release title: qBittorrent native ARM64 <run_number>
- asset: artifacts/<artifact_name>/qbittorrent_<qbt_version>_arm64.zip

Both release bodies include current qBittorrent/Qt/vcpkg/libtorrent/Boost versions from env.
