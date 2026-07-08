# Native ARM64 Workflow Explanation

This branch contains a fresh GitHub Actions workflow intended to build qBittorrent as a native Windows ARM64 executable using the MSVC ARM64 cross toolchain on GitHub's standard x64 Windows runner.

## Why this workflow exists

The older workflow evolved through many fixes and experiments. This file is a clean rebuild that keeps the useful parts:

- one visible version block
- one consistent vcpkg triplet
- a single MSVC-based ARM64 build path
- explicit release and prerelease publishing rules

The new workflow file is:

- `.github/workflows/ci_windows_arm64_native.yaml`

## How the workflow is organized

### 1. Triggers

The workflow runs when:

- you push to branch `main`
- you push a tag like `v5.2.3`
- you start it manually with `workflow_dispatch`

### 2. Version block

At the top of the job you will see:

```yaml
boost_version: "1.91.0"
libt_version: "2.0.13"
qbt_version: "5.2.3"
qt_version: "6.10.3"
```

This is the main update surface. If you want to build a newer qBittorrent or Qt version later, this is the first place you edit.

### 3. Toolchain setup

The workflow uses:

- `ilammy/msvc-dev-cmd` to load the MSVC ARM64 cross compiler
- `lukka/run-vcpkg` to use the preinstalled vcpkg tree on the runner
- `ninja` for faster builds

Important detail: the build still happens on GitHub's normal x64 Windows machine, but the compiler target is ARM64, so the produced `qbittorrent.exe` is a native ARM64 executable.

### 4. Dependency installation

The workflow builds against one vcpkg triplet only:

- `arm64-windows-static-release`

That triplet is used for:

- OpenSSL
- zlib
- Qt configuration
- libtorrent
- qBittorrent

The goal is to avoid mixing dependency models.

### 5. Qt build

The workflow installs:

- host Qt tools for x64 from `install-qt-action`
- target Qt for ARM64 by building Qt from source

The host Qt is needed because the build system runs helper tools on the x64 runner while compiling target libraries for ARM64.

### 6. libtorrent build

libtorrent is built from source with the same vcpkg triplet and the same ARM64 target model as qBittorrent.

### 7. qBittorrent build

qBittorrent is built from the official source tarball for the selected `qbt_version`.

One compatibility hotfix is still used:

- the workflow prepends a small `find_package(OpenSSL)` and `find_package(ZLIB)` block into qBittorrent's `CheckPackages.cmake`

That hotfix is kept because it was already needed in your existing working builds to make imported CMake targets visible consistently.

### 8. Packaging

The workflow currently packages:

- `qbittorrent.exe`
- qBittorrent's own `dist/windows/qt.conf`

This matches the packaging pattern already used in the existing workflow.

### 9. Publishing behavior

There are two publishing modes:

- tagged releases for `v*` tags
- prereleases for pushes to `main`

That means every push on `main` can produce a downloadable prerelease artifact without touching version tags.

## Repository baseline after cleanup

For this new native MSVC workflow, the key files are:

- `.github/workflows/ci_windows_arm64_native.yaml`
- `README.md`
- `NATIVE_WORKFLOW_EXPLANATION.md`

The following legacy files are now removed from this repository baseline:

- `.github/workflows/ci_windows_arm64.yaml`
- `.github/workflows/ci_mingw_arm64.yaml`
- `build.sh`
- `Toolchain-llvm-mingw.cmake`
- `patches/`
- root-level `qt.conf`

## Important caution

This new workflow can make the build logic cleaner, but it may not fix an upstream qBittorrent runtime regression by itself. If qBittorrent 5.2.3 still crashes after startup, that may still be an application-level issue rather than a workflow issue.
