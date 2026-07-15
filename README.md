# qBittorrent for Windows ARM64

The goal of this repository is to provide native Windows ARM64 builds of [qBittorrent](https://www.qbittorrent.org), because the qBittorrent project currently has [no plans](https://github.com/qbittorrent/qBittorrent/discussions/23613#discussioncomment-15508814) to publish official ARM64 binaries.

Builds are produced through:

- native Windows ARM64 cross-compilation with MSVC toolchains on GitHub Actions
- a single CI workflow: `.github/workflows/ci_windows_arm64_native.yaml`. Commentary and explanation available [by Github Copilot](/NATIVE_WORKFLOW_EXPLANATION.md).

## About and thank you

This project was heavily inspired by [minnyres' work](https://github.com/minnyres/qbittorrent-windows-arm64). That repository appears to have been inactive for some time, but its early work remains the foundation this project builds on. 
Many thanks for the original effort and groundwork.

## Downloads:

- Download latest version [here](https://github.com/vectorrilke/qbittorrent-windows-arm64-native/releases/latest).

## Latest build: `v5.2.3`

Component versions:

- libtorrent: `2.0.13+gitda7a68a440`
- Boost: `1.91.0`
- Qt: `6.10.3`
