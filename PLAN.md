# Plan: GitHub workflow building qBittorrent for Windows ARM64

## Context
Upstream qBittorrent publishes no native Windows ARM64 build. We want one workflow file, `.github/workflows/build-arm64.yml`, that is the only deliverable. It clones upstream at a chosen tag and builds it natively on a `windows-11-arm` runner. The versions of everything used come from env vars at the top of the file, so any release can be reproduced by editing them. Example, from qbittorrent.org's library table for v5.3.0rc1: libtorrent 2.1.2+gitbe61ae8f44, Qt 6.11.2, Boost 1.92.0.

## Top-of-file config (workflow `env:`; also `workflow_dispatch` inputs that override them)
- `QBT_TAG`: upstream tag, e.g. `release-5.3.0rc1`
- `LIBTORRENT_REF`: tag or commit, e.g. `be61ae8f44`. It is cloned from arvidn/libtorrent with `--recurse-submodules`.
- `QT_VERSION`: e.g. `6.11.2`
- `BOOST_VERSION`: e.g. `1.92.0`
- `OPENSSL_VERSION`, `ZLIB_VERSION`: pinned via the vcpkg baseline or a source build. Not listed on the website, so I choose defaults.
- `MSVC_ARCH=arm64`, `BUILD_TYPE=Release`

A `workflow_dispatch` trigger with inputs for the main versions. Env defaults are used on push or tag.

## Job: `build` on `windows-11-arm`
1. Checkout nothing locally. Clone `qbittorrent/qBittorrent` at `QBT_TAG`.
2. Set up the MSVC ARM64 environment (`ilammy/msvc-dev-cmd`, arch `arm64`), plus Ninja and CMake.
3. **Boost**: download the `BOOST_VERSION` archive from archives.boost.io and use its headers only. libtorrent 2.x and qBittorrent need no compiled Boost libraries.
4. **OpenSSL and zlib**: vcpkg, triplet `arm64-windows-static-md` or similar, with the baseline pinned and cached.
5. **Qt**: `jurplel/install-qt-action` (aqtinstall) with `arch: win64_msvc2022_arm64` at `QT_VERSION`, plus the x64 host tools if the action requires them (they run under emulation). Modules: `qtsvg`, `qttools`. The Qt build is cached.
6. **libtorrent**: configure with CMake/Ninja (`-Ddeprecated-functions=OFF -DBUILD_SHARED_LIBS=OFF -Dstatic_runtime=OFF`, `-DBOOST_ROOT`, OpenSSL/zlib from vcpkg) and install into a prefix.
7. **qBittorrent**: `cmake -G Ninja -DCMAKE_PREFIX_PATH=<qt;libtorrent;vcpkg> -DGUI=ON -DWEBUI=ON -DSTACKTRACE=OFF`, then build and install.
8. **Package**: run `windeployqt --release` on `qbittorrent.exe`, copy the OpenSSL DLLs if they are dynamic, and zip as `qbittorrent-${QBT_TAG}-win-arm64.zip`.
9. **Publish**: `upload-artifact`. When the run is on a tag or a manual run with `release: true`, also attach the zip to a GitHub Release via `softprops/action-gh-release` (needs `contents: write`).
10. Caches (`actions/cache`) for the vcpkg binary cache, Qt, and the libtorrent build, keyed on the version env vars.

## Known risks to validate
- The Qt ARM64 prebuilt binaries may need a matching x64 host Qt for moc/rcc/uic. If aqt can't provide this, fall back to a vcpkg Qt build (slow) or the host-Qt cross setup.
- `windows-11-arm` runners are free only for public repos.
- Older qBittorrent tags may require different CMake options. The workflow targets the 5.x CMake build.

## Verification
- Run `workflow_dispatch` with the v5.3.0rc1 values on a GitHub repo.
- Download the artifact and run `dumpbin /headers qbittorrent.exe` (machine should be `AA64`), then launch it on a Windows ARM64 device.
- Check Help → About to confirm that the Qt, libtorrent and Boost versions match the env vars.
