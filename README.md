# qBittorrent Windows ARM64 Native

Aim of this repository is to provide native ARM64 builds of qBittorrent, since creators of qBittorrent have currently [no intentions](https://github.com/qbittorrent/qBittorrent/discussions/23613#discussioncomment-15508814) to provide them themselves.

It is done through: 
- native Windows ARM64 build using MSVC cross tools on GitHub Actions
- single CI workflow: `.github/workflows/ci_windows_arm64_native.yaml`
arm64
## About and thank you
This project was heavily influenced by [minnyres'](https://github.com/minnyres/qbittorrent-windows-arm64) project, but sadly he seems to not mantain his repository anymore.


## Latest build: v5.2.3

Component versions:
- qBittorrent: `5.2.3`
- libtorrent: `2.0.13`
- Boost: `1.91.0`
- Qt: `6.10.3`
