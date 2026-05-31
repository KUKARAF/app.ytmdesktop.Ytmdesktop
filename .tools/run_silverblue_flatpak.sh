#!/usr/bin/env bash
set -euo pipefail

MANIFEST="$(cd "$(dirname "$0")/.." && pwd)/app.ytmdesktop.ytmdesktop.yml"

flatpak run org.flatpak.Builder --user --install --force-clean build-dir "$MANIFEST"
flatpak run app.ytmdesktop.ytmdesktop
