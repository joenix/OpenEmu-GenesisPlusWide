# OpenEmu GenesisPlus Wide（小咪）

## 项目简介

为 OpenEmu-Silicon 增加独立的 Mega Drive / Genesis 宽屏核心，让用户通过选择核心切换普通与宽屏显示。

选择 `GenesisPlusWide` 即启用宽屏，不检测 ROM 名称、哈希或专属标记。画面在原宽度上增加 80 像素，并非横向拉伸；实际显示效果取决于游戏自身对宽屏的适配。

安装不替换普通 `GenesisPlus` 核心，不修改 OpenEmu 主程序、按键配置或 ROM 内容。当前为实验性版本，适用于 Apple Silicon Mac、macOS 12 及以上的 OpenEmu-Silicon。

## 如何使用

1. 到 [Releases](https://github.com/joenix/OpenEmu-GenesisPlusWide/releases/latest) 下载 `GenesisPlusWide-*-arm64.zip` 并解压。
2. 完全退出 OpenEmu，双击 `Install.command` 安装。
3. 重新打开 OpenEmu，右键点击游戏，选择 **Play With → GenesisPlusWide**，以宽屏模式启动。
4. 普通显示选择 **Play With → GenesisPlus**。希望双击游戏默认使用普通模式时，请在 OpenEmu 的核心设置中将 `GenesisPlus` 设为 MD 默认核心。

切换核心后请重新启动游戏，避免载入另一核心创建的即时存档。如果宽屏边缘显示异常，可切回普通核心。

更新时重复安装步骤即可，安装器会备份旧版宽屏核心。源代码与许可证随项目提供，见 [LICENSE](LICENSE) 和 [LICENSES](LICENSES)。
