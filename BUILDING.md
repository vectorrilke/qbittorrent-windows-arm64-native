# Building qBittorrent for Windows ARM64

## How it works

The main workflow `.github/workflows/release.yml` is a manual dispatch trigger that orchestrates the build and release process. It calls two reusable workflows in parallel:

- `build-zip.yml`: qBittorrent with Qt DLLs bundled next to it
- `build-static.yml`: a single self-contained `qbittorrent.exe` (static Qt)

After both complete, a release job downloads the artifacts (`qbittorrent-zip` and `qbittorrent-static`), publishes one GitHub Release tagged `v<version>-arm64`, and applies pre-release status if the version contains `rc` or `beta`. The release is published as long as the zip build succeeds; if the static exe build fails, it is simply omitted from the release.

The `publish` toggle controls whether a GitHub Release is created (otherwise only artifacts are built).

## What each build does

**Zip build** (`build-zip.yml`):
- Runs on `windows-11-arm` with MSVC
- Boost (headers only, not compiled; default 1.91.0)
- Qt prebuilt via aqtinstall with host `windows_arm64` (default 6.10.3)
- OpenSSL and zlib from vcpkg (triplet `arm64-windows-static-md`)
- libtorrent built with shared MSVC runtime
- qBittorrent built and packaged with `windeployqt` into a zip

**Static exe build** (`build-static.yml`):
- Same toolchain and dependencies, but Qt is built from source (qtbase, qtsvg, qttools) with `-static -static-runtime` flags
- Everything uses static MSVC runtime so the exe needs no Qt or VC++ DLLs
- Includes verification: checks that the exe is ARM64 and imports only system DLLs
- Includes a smoke test: starts the exe and verifies it stays running for 20 seconds
- First run is slow due to Qt compilation; later runs restore from cache (`QT_STATIC_CACHE_REV`)

All builds cache Boost headers, vcpkg packages, Qt, and libtorrent to speed up repeated builds. Version env vars are set at the top of each workflow file and kept identical between the two.

## Running it

1. Go to Actions tab and select **Build and release (Windows ARM64)**
2. Click **Run workflow**
3. Leave version fields empty for the 5.2.3 defaults (recommended), or fill ALL FOUR fields (`qbt_tag`, `libtorrent_ref`, `qt_version`, `boost_version`) to build another version

The version fields are also set in the `env:` block at the top of `build-zip.yml` and `build-static.yml`—keep those two files identical there. Defaults are:
- `qbt_tag: release-5.2.3`
- `libtorrent_ref: da7a68a440` (2.0.13)
- `qt_version: 6.10.3`
- `boost_version: 1.91.0`

The `qbt_tag` must be an upstream qBittorrent tag like `release-5.2.4`. Qt >= 6.8 is needed for prebuilt ARM64 packages. Only the 5.x CMake build has been tested.

Re-running the workflow with the same versions updates the existing release rather than creating a new one.

## Private trackers

Some private trackers have client bans. Builds with qBittorrent 5.3.0rc1 were rejected as "banned client" on one tracker, while 5.2.3 (libtorrent 2.0.x) was accepted. Some trackers also ban libtorrent 2.1. Check your tracker's approved-client list before choosing a version.

## Status

- **Zip build:** verified working
- **Static exe build:** verified working (built, passed the self-contained check and smoke test, and tested by hand).
- **Release job:** not yet confirmed. Update this section once a release with both files has been published.

See [CHANGES.md](CHANGES.md) for the history of the workflows and [PLAN.md](PLAN.md) for the original design.
