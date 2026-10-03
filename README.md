# <img src="assets/icon.svg" height="32" align="absmiddle" alt=""> qBittorrent for Windows ARM64

[![Build and release](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/actions/workflows/release.yml/badge.svg)](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/actions/workflows/release.yml) [![Prerelease](https://img.shields.io/github/v/release/vectorrilke/qbittorrent-windows-arm64-native?include_prereleases&labelColor=2b3137&color=orange&label=prerelease)](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/releases/latest) [![Release](https://img.shields.io/github/v/release/vectorrilke/qbittorrent-windows-arm64-native?labelColor=2b3137&color=6e40c9)](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/releases/latest) [![Upstream](https://img.shields.io/github/v/release/qbittorrent/qBittorrent?label=upstream&logo=qbittorrent&labelColor=2b3137&color=2f67ba)](https://github.com/qbittorrent/qBittorrent/releases) ![Platform](https://img.shields.io/badge/platform-Windows%2011%20ARM64-a52a4a?logo=windows11&logoColor=white&labelColor=2b3137)

The goal of this repository is to provide native Windows ARM64 builds of [qBittorrent](https://www.qbittorrent.org), because the qBittorrent project currently has [no plans](https://github.com/qbittorrent/qBittorrent/discussions/23613#discussioncomment-15508814) to publish official ARM64 binaries.

Builds are produced through:

- native Windows ARM64 compilation with MSVC on the `windows-11-arm` GitHub Actions runner
- a main workflow, `.github/workflows/release.yml`, which runs two build workflows in parallel and publishes both results in one release:
  - `.github/workflows/build-zip.yml`: qBittorrent with the Qt DLLs bundled next to it
  - `.github/workflows/build-static.yml`: a single self-contained `qbittorrent.exe` (static Qt)

Each build workflow can also be run on its own and then only produces a workflow artifact.

> [!NOTE]
> **Recommended download: the static exe.** It is a single file, so there is nothing to extract or set up: download it, put it anywhere and run it. The zip does the same job but has to be extracted first and comes with a folder of Qt DLLs and plugins.

## Latest updates
#### October 2, 2026
> * Completely redone workflows files. 
> * Implemented caching. 
> * Release now offers both static (single-file, portable) and dynamic builds (with shared libraries, e.g. .dll / .so files)

#### October 1, 2026
> * Added some beta/rc releases.

  
## About and thank you

This project was heavily inspired by [minnyres' work](https://github.com/minnyres/qbittorrent-windows-arm64). That repository appears to have been inactive for some time, but its early work remains the foundation this project builds on.
Many thanks for the original effort and groundwork.

  
## Downloads

- Download the [latest ARM64 release](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/releases/latest).

Each release has two files:

| File | What it is |
|------|------------|
| `qbittorrent_<version>_arm64.zip` | qBittorrent plus the Qt DLLs and plugins. Extract and run, no installer. |
| `qbittorrent_<version>_arm64_static.exe` | One exe with everything built in: no DLLs, no extra folders. |

Both keep their settings in `%APPDATA%`, so neither behaves like a fully self-contained portable app by default.

The notes of each release list the qBittorrent, Qt, libtorrent and Boost versions it was built with. Components mirror upstream versions.

  
## Useful links

> [!TIP]
> #### Theming qBittorrent
> I thought it could be useful for someone to know that qbittorrent can be themed, and there are lot of precompiled `.qbtheme` files out there.
> Here is rather incomplete list for repositories to download them, most of the links contain screenshots and "how-to" for apply, compile or creating your own theme:

> - **Dracula** official: https://github.com/dracula/qbittorrent
> - **Catpuccin** official including flavours and light/dark variants: https://github.com/catppuccin/qbittorrent
> - **Material Design** - https://github.com/BaraShiro/Material-qBittorrent
> - **Fluent Design** - https://github.com/witalihirsch/qBitTorrent-fluent-theme
> - **Nord** - https://github.com/Zabooby/qbittorrent-config
> - **AyU** - https://github.com/maboroshin/qBittorrentDarktheme
> - **Solarized** - same repo as above
> - **Dark** - same repo as above
> - Mumble, Breeze and other - https://github.com/jagannatharjun/qbt-theme

Another great, curated, up-to-date **selection of great themes** is available in repo [MahdiMirzadeh/qbittorrent](https://github.com/MahdiMirzadeh/qbittorrent).  
There is also (incomplete) [list](https://github.com/qbittorrent/qBittorrent/wiki/List-of-known-qBittorrent-themes) list by authors of qBittorrent.  
I am sure plenty of other themes exists, this just to save you from googling.
