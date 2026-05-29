# Migration to kukaraf fork

This manifest currently tracks the upstream `ytmdesktop/ytmdesktop` releases. To point it at the kukaraf fork and include the changes made there (ad blocker integration, version bump to 2.0.12), the following must be updated.

## 1. Source URLs and SHA512 hashes

The two `sources` entries (x86_64 and aarch64) download the pre-built `.deb` from GitHub releases. Both the URL and the sha512 checksum must be updated once the kukaraf fork publishes a release.

**Current (upstream):**
```yaml
url: https://github.com/ytmdesktop/ytmdesktop/releases/download/v2.0.11/youtube-music-desktop-app_2.0.11_amd64.deb
sha512: 2ee9894702790611564fdcacf...
```

**Change to:**
```yaml
url: https://github.com/kukaraf/ytmdesktop/releases/download/v2.0.12/youtube-music-desktop-app_2.0.12_amd64.deb
sha512: <sha512 of the new .deb>
```

Repeat for the `aarch64` entry (replace `amd64` with `arm64`).

To compute the sha512 of a new release asset:
```bash
sha512sum youtube-music-desktop-app_2.0.12_amd64.deb
```

## 2. x-checker-data (auto-update bot)

The Flathub update bot reads `x-checker-data` to auto-bump versions. Change the repo reference so it tracks the kukaraf fork instead of upstream:

```yaml
x-checker-data:
  type: json
  url: https://api.github.com/repos/kukaraf/ytmdesktop/releases/latest
  version-query: .tag_name
  url-query: .assets[] | select(.name|endswith("_amd64.deb")) | .browser_download_url
```

## 3. Publish a GitHub release from the kukaraf fork

The manifest pulls a pre-built `.deb` — it does not build from source. So the kukaraf fork of `ytmdesktop` must have a GitHub release with the `.deb` and `.rpm` artifacts attached.

To build the release artifacts from the `~/dev/ytmdesktop` repo:
```bash
yarn make
```
Then create a GitHub release (`gh release create v2.0.12`) and upload the `.deb` files from `out/make/deb/`.

## 4. App ID (optional)

The current app ID is `app.ytmdesktop.ytmdesktop`. If this Flatpak is intended to coexist with the upstream release rather than replace it, change the ID to something like `app.kukaraf.ytmdesktop` and update every reference to it:

- `app-id:` in the manifest
- The desktop file filename and `StartupWMClass`
- The metainfo XML `<id>` field and filename
- The icon install path

If the goal is to simply replace the upstream package on a personal machine, keeping the same app ID is fine.

## 5. Nothing else needs to change

The build process, `finish-args`, wrapper script, and install commands are all app-agnostic — they work identically regardless of which fork provides the `.deb`.
