#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ROM="${1:?Usage: smoke.sh /absolute/path/to/rom}"
PRODUCTS="$ROOT/build/Build/Products/Release"
OUTPUT="$(mktemp -d "${TMPDIR:-/tmp}/openemu-wide-smoke.XXXXXX")"
xcrun clang -fobjc-arc -arch arm64 -mmacosx-version-min=12.0 -framework Cocoa \
  -F "$PRODUCTS" -framework OpenEmuBase -Wl,-rpath,"$PRODUCTS" \
  "$ROOT/Tests/core-smoke.m" -o "$OUTPUT/core-smoke"
"$OUTPUT/core-smoke" "$PRODUCTS/GenesisPlusWide.oecoreplugin" "$ROM" "$OUTPUT"
echo "Results: $OUTPUT"
