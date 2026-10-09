# OpenEmu GenesisPlus Wide（小咪）

为 OpenEmu-Silicon 提供独立的 Mega Drive 宽屏核心。宽屏作为用户主动选择的显示模式；普通 ROM 继续使用原有 GenesisPlus 核心。

**当前为实验性预发布版。** 已通过本机核心 API 的启动、渲染、输入及即时存档检查；完整图形界面与真实键盘验收尚未完成。真实键盘的输入监控权限与宿主兼容性需要继续验收，不能把本版视作已完成兼容性验收的稳定版本。

## 下载与安装

到 [Releases](https://github.com/joenix/OpenEmu-GenesisPlusWide/releases) 下载 `GenesisPlusWide-v0.1.1-alpha.1-arm64.zip` 并解压。

1. 完全退出 OpenEmu。
2. 双击 `Install.command` 安装；或把 `GenesisPlusWide.oecoreplugin` 放入 `~/Library/Application Support/OpenEmu/Cores/`。
3. 重新打开 OpenEmu，在目标游戏的“Play With / 使用核心”中选择 `GenesisPlusWide`。
4. 首次使用请从冷启动进入游戏，避免载入由另一核心创建的自动即时存档。

安装器只写入独立宽屏核心；如果已有该核心，会先备份到 `~/Library/Application Support/OpenEmu/WideCoreBackups/`。不修改 OpenEmu 主程序、普通 GenesisPlus 核心、按键配置或默认核心。此包未做 Apple 公证；如果系统阻止运行，请按 macOS 的正常安全提示处理，不需要关闭系统安全保护。

适用平台：Apple Silicon（arm64），macOS 12 及以上；本机使用 OpenEmu-Silicon 1.3.0（build 22）。其他宿主版本、Intel Mac、手柄及跨核心旧即时存档尚未验收。macOS 12 是编译部署目标，不代表所有系统版本均已测试。

## 如何启用宽屏

本核心通过用户选择的模拟核心确定显示模式，不检测具体游戏：

- 选择 `GenesisPlusWide`：启用扩展宽屏渲染。
- 选择原有 `GenesisPlus`：使用普通显示模式。

不使用 ROM 名称、文件名、文件大小、哈希白名单或游戏专属标识来判定宽屏。普通 MD ROM 与宽屏 MD ROM 没有本项目可以通用、可靠使用的自动识别规则，因此本版采用手动选择核心的方式。

宽屏模式在游戏原有水平分辨率上增加 80 像素（10 个 8 像素列），高度沿用游戏视频模式；320 像素模式输出 400 像素宽，256 像素模式输出 336 像素宽。这是扩展渲染范围，并非把原画面横向拉伸。

选择宽屏核心不会让游戏逻辑自动适配宽屏。边缘物体、滚动、HUD 或遮挡能否正确显示取决于游戏自身实现；显示异常时，可切回普通核心。不同游戏的完整兼容性需要分别验收。

项目与安装包不提供 ROM，也不会修改 ROM 内容、游戏难度、道具或角色属性。SHA-256 校验仅用于验证下载的安装包与插件文件完整性，不参与游戏识别。

## 本次改动

相对于上游普通核心的主要差异可查看 [changes.patch](docs/changes.patch)。

- 独立插件标识、类名和安装目录，保留普通 MD 核心。
- 接入 Genesis Plus GX Wide 的 VDP 渲染实现。
- 用户选择宽屏核心后，增加 10 个 8 像素宽度列，高度沿用游戏的视频模式。
- 宽屏模式与 ROM 内容解耦，通过选择独立核心启用。
- 不启用自动核心更新，后续版本从本项目 Releases 手动更新。

旧即时存档存在核心版本与内部格式兼容风险；出现版本不匹配提示时，请保留原存档并冷启动。游戏内存档与即时存档是不同机制。本项目未承诺旧即时存档可跨核心迁移。

## 从源码编译

安装完整 Xcode 和 Command Line Tools 后，在 Apple Silicon Mac 上运行：

```sh
./Scripts/build.sh
```

产物：`build/Build/Products/Release/GenesisPlusWide.oecoreplugin`。构建不会自动安装到用户目录。完整核心、OpenEmuBase SDK、rcheevos 以及所需宿主接口源代码都在本仓库中。

如需在自己的合法 ROM 上运行独立检查：

```sh
./Scripts/smoke.sh /absolute/path/to/rom
```

检查输出保存在新建的临时目录，不读取或写入 OpenEmu 的用户存档。该检查调用核心 API，不能替代真实键盘与宿主 UI 验收。

## 来源与许可

本项目是第三方实验性扩展，与 OpenEmu、OpenEmu-Silicon 及原游戏权利人无隶属或背书关系。

- [OpenEmu-Silicon](https://github.com/OpenEmu-Silicon/OpenEmu-Silicon)，基线提交 `bbf5d1555841b21c221e4dd87c664e0245478b26`：核心适配层、SDK、宿主接口与 vendored rcheevos 12.4。
- [Genesis Plus GX Wide](https://github.com/libretro/Genesis-Plus-GX-Wide)，基线提交 `b7ad005431f5f0b55e559f6d598d1ed2479bf13b`：宽屏渲染器及许可说明。

各组件遵循各自原有许可证，见 [LICENSE](LICENSE)、[LICENSES](LICENSES) 及文件内声明。Genesis Plus GX 衍生版本禁止销售或商业用途；发布修改后的二进制时需要同时提供完整源码。Release 附有对应的完整源码归档；仓库保留原有版权声明。

问题反馈请附宿主版本、macOS 版本、核心版本、所选显示模式及复现步骤，不要上传 ROM 或个人存档。
