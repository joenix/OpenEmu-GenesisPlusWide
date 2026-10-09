#!/bin/bash
set -euo pipefail
PACKAGE="$(cd "$(dirname "$0")" && pwd)"
if [ "$(uname -m)" != arm64 ]; then echo '需要 Apple Silicon Mac。'; exit 1; fi
set +e
pgrep -x 'OpenEmu|OpenEmuHelper' >/dev/null
PROCESS_STATUS=$?
set -e
if [ "$PROCESS_STATUS" -eq 0 ]; then
 echo '请完全退出 OpenEmu 后重新运行安装器。'; exit 1
elif [ "$PROCESS_STATUS" -ne 1 ]; then
 echo '无法确认 OpenEmu 是否已退出，安装已停止。'; exit 1
fi
cd "$PACKAGE"
shasum -a 256 -c CORE-SHA256SUMS.txt
SOURCE="$PACKAGE/GenesisPlusWide.oecoreplugin"
IDENTIFIER=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$SOURCE/Contents/Info.plist")
[ "$IDENTIFIER" = local.xiaomi.GenesisPlusWide ] || { echo '插件标识不符。'; exit 1; }
codesign --verify --deep --strict "$SOURCE"
CORES="${OPENEMU_WIDE_TEST_CORES_DIR:-$HOME/Library/Application Support/OpenEmu/Cores}"
BACKUPS="${OPENEMU_WIDE_TEST_BACKUPS_DIR:-$HOME/Library/Application Support/OpenEmu/WideCoreBackups}"
mkdir -p "$CORES" "$BACKUPS"
STAGING="$(mktemp -d "$CORES/.wide-install.XXXXXX")"
DEST="$CORES/GenesisPlusWide.oecoreplugin"
BACKUP=""
SUCCESS=0
cleanup() {
 if [ "$SUCCESS" -eq 0 ] && [ -n "$BACKUP" ] && [ ! -e "$DEST" ]; then mv "$BACKUP" "$DEST"; fi
 rm -rf "$STAGING"
}
trap cleanup EXIT
ditto "$SOURCE" "$STAGING/GenesisPlusWide.oecoreplugin"
(cd "$STAGING" && shasum -a 256 -c "$PACKAGE/CORE-SHA256SUMS.txt")
if [ -e "$DEST" ]; then
 BACKUP="$BACKUPS/GenesisPlusWide-$(date +%Y%m%d-%H%M%S)-$$.oecoreplugin"
 mv "$DEST" "$BACKUP"
fi
mv "$STAGING/GenesisPlusWide.oecoreplugin" "$DEST"
SUCCESS=1
echo "安装完成：$DEST"
[ -z "$BACKUP" ] || echo "旧版备份：$BACKUP"
echo '重新打开 OpenEmu，为支持的 ROM 选择 GenesisPlusWide 核心并冷启动。'
