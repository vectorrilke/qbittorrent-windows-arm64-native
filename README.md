# qBittorrent Windows ARM64 Native

This repository is a clean, standalone baseline focused on one build path:

- native Windows ARM64 build using MSVC cross tools on GitHub Actions
- single CI workflow: `.github/workflows/ci_windows_arm64_native.yaml`

## How builds are produced

- push to `main` to run CI and publish a prerelease artifact
- push a `v*` tag (for example `v5.2.3`) to publish a release
- run manually with `workflow_dispatch`

## Build component versions

Current defaults are defined in the workflow env block:

- qBittorrent: `5.2.3`
- libtorrent: `2.0.13`
- Boost: `1.91.0`
- Qt: `6.10.3`

See `NATIVE_WORKFLOW_EXPLANATION.md` for a detailed walkthrough.

