# qBittorrent compiled for Windows arm64
This is a fork of minnnyres' [repo](https://github.com/minnyres/qbittorrent-windows-arm64), which seems to be not maintained anymore. I partially rewrote original workflow file with following changes:
-    updated URLs and add env variables for source code
-    updated env vars to versions corresponding to latest qbittorrent build (libtorrent 2.0.13, boost 1.91, qt 6.10.3)
-    fixed issues with Qt 6.10.2+
-    fixed ZLIB issues

All other credit goes to [minnyres](https://github.com/minnyres/qbittorrent-windows-arm64).

## Release Notes
-   **5.2.2 Compatibility:** The updated workflow designed for qBittorrent 5.2.1 remains fully compatible with version 5.2.2.
-   **Automated Publishing:** Starting with version 5.2.2, the workflow now automatically publishes builds directly to GitHub Releases.

