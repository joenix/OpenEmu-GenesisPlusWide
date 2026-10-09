#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION=v0.1.1-alpha.1
NAME="GenesisPlusWide-$VERSION-arm64"
mkdir -p "$ROOT/dist"
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/openemu-wide-package.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT
PACKAGE="$STAGE/$NAME"
mkdir -p "$PACKAGE"
ditto "$ROOT/build/Build/Products/Release/GenesisPlusWide.oecoreplugin" "$PACKAGE/GenesisPlusWide.oecoreplugin"
cp "$ROOT/Scripts/Install.command" "$PACKAGE/Install.command"
cp "$ROOT/README.md" "$ROOT/LICENSE" "$PACKAGE/"
ditto "$ROOT/LICENSES" "$PACKAGE/LICENSES"
(cd "$PACKAGE" && find GenesisPlusWide.oecoreplugin -type f -exec shasum -a 256 {} \; | LC_ALL=C sort > CORE-SHA256SUMS.txt)
ditto -c -k --keepParent --norsrc "$PACKAGE" "$ROOT/dist/$NAME.zip"
echo "Package: $ROOT/dist/$NAME.zip"
