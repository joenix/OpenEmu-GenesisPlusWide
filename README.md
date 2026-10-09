# OpenEmu GenesisPlus Wide（小咪）

为 OpenEmu-Silicon 提供独立的 Mega Drive 宽屏核心。当前输出为 **400 × 224**，普通 ROM 继续使用原有 GenesisPlus 核心。

**当前为实验性预发布版。** 已通过本机核心 API 的启动、渲染、输入及即时存档检查；完整图形界面与真实键盘验收尚未完成。真实键盘的输入监控权限与宿主兼容性需要继续验收，不能把本版视作已完成兼容性验收的稳定版本。

## 下载与安装

到 [Releases](https://github.com/joenix/OpenEmu-GenesisPlusWide/releases) 下载 `GenesisPlusWide-v0.1.0-alpha.1-arm64.zip` 并解压。

1. 完全退出 OpenEmu。
2. 双击 `Install.command` 安装；或把 `GenesisPlusWide.oecoreplugin` 放入 `~/Library/Application Support/OpenEmu/Cores/`。
3. 重新打开 OpenEmu，在目标游戏的“Play With / 使用核心”中选择 `GenesisPlusWide`。
4. 首次使用请从冷启动进入游戏，避免载入由另一核心创建的自动即时存档。

安装器只写入独立宽屏核心；如果已有该核心，会先备份到 `~/Library/Application Support/OpenEmu/WideCoreBackups/`。不修改 OpenEmu 主程序、普通 GenesisPlus 核心、按键配置或默认核心。此包未做 Apple 公证；如果系统阻止运行，请按 macOS 的正常安全提示处理，不需要关闭系统安全保护。

适用平台：Apple Silicon（arm64），macOS 12 及以上；本机使用 OpenEmu-Silicon 1.3.0（build 22）。其他宿主版本、Intel Mac、手柄及跨核心旧即时存档尚未验收。macOS 12 是编译部署目标，不代表所有系统版本均已测试。

## 支持的 ROM

本版仅接受以下内容指纹，文件改名不影响识别：

- 光之继承者 / Beyond Oasis Extended v1.4 的 ALI 困难模式全道具强化开局 v1 宽屏版本
- 文件长度：3,145,728 字节
- SHA-256：`de30cf4f3913df51033f386ba303ce3c4f5860b39b9920528ab24900a5bb9895`

项目与安装包不提供 ROM，也不会修改 ROM 内容。其他 ROM 请使用普通 GenesisPlus 核心；当前没有自动为所有宽屏 ROM 选择核心的功能。

## 本次改动

相对于上游普通核心的主要差异可查看 [changes.patch](docs/changes.patch)。

- 独立插件标识、类名和安装目录，保留普通 MD 核心。
- 接入 Genesis Plus GX Wide 的 VDP 渲染实现。
- 为受支持 ROM 增加 10 个 8 像素宽度列，按 400 × 224 显示。
- 通过文件长度和 SHA-256 限定适用 ROM，避免误用。
- 不启用自动核心更新，后续版本从本项目 Releases 手动更新。

游戏内 ALI 困难模式、全道具和强化开局属于既有 ROM 功能，不是本核心增加的功能。

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

问题反馈请附宿主版本、macOS 版本、核心版本、ROM SHA-256 及复现步骤，不要上传 ROM 或个人存档。
