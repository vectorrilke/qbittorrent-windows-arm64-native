# qBittorrent Windows ARM64 Native

The goal of this repository is to provide native Windows ARM64 builds of qBittorrent, because the qBittorrent project currently has [no plans](https://github.com/qbittorrent/qBittorrent/discussions/23613#discussioncomment-15508814) to publish official ARM64 binaries.

Builds are produced through:
- native Windows ARM64 cross-compilation with MSVC toolchains on GitHub Actions
- a single CI workflow: `.github/workflows/ci_windows_arm64_native.yaml`

## About and thank you
This project was heavily inspired by [minnyres' work](https://github.com/minnyres/qbittorrent-windows-arm64). Many thanks for the original effort and groundwork.


## Latest build: v5.2.3

Downloads:
- libtorrent 1.2 build: [qbittorrent_5.2.3_arm64.zip](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/releases/latest/download/qbittorrent_5.2.3_arm64.zip)
- libtorrent 2.0 build: [qbittorrent_5.2.3_lt20_arm64.zip](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/releases/latest/download/qbittorrent_5.2.3_lt20_arm64.zip)

Component versions:
- qBittorrent: `5.2.3`
- libtorrent (lt12): `1.2.20+gitc5ff6c3186`
- Boost (lt12): `1.86.0`
- libtorrent (lt20): `2.0.13+gitda7a68a440`
- Boost (lt20): `1.91.0`
- Qt: `6.10.3`

Sidenote:
If qBittorrent fails to start, or hangs while loading torrents on startup, try deleting `*.fastresume` files from `%LOCALAPPDATA%/qBittorrent/BT_Backup` and then resume your torrents manually.
This removes restore metadata only and does not delete your actual downloaded torrent payload files.
