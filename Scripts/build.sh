#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
for entry in 'OpenEmu-SDK/OpenEmu-SDK.xcodeproj:OpenEmuBase' 'GenesisPlusWide/GenesisPlus.xcodeproj:GenesisPlus'; do
  xcodebuild -project "${entry%:*}" -scheme "${entry##*:}" -configuration Release \
    -destination 'platform=macOS,arch=arm64' -derivedDataPath "$ROOT/build" \
    MACOSX_DEPLOYMENT_TARGET=12.0 CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO build
done
PLUGIN="$ROOT/build/Build/Products/Release/GenesisPlusWide.oecoreplugin"
lipo -verify_arch arm64 "$PLUGIN/Contents/MacOS/GenesisPlusWide"
codesign --verify --deep --strict "$PLUGIN"
echo "Built: $PLUGIN"
