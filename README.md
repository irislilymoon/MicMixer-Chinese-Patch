# MicMixer 简体中文汉化补丁

非官方简体中文界面补丁,适用于 [MicMixer](https://github.com/benjibutten/MicMixer) **v2026.11.1**(Windows)。

MicMixer 是一款开源(Apache-2.0)的虚拟麦克风混音工具:把你的麦克风 + 音乐 / 任意应用的声音混成一路"虚拟麦克风",供游戏语音、直播、Discord 等使用。本仓库仅将界面文本翻译为**简体中文**,未修改任何功能代码。

## 安装

1. 先安装官方原版 [MicMixer v2026.11.1](https://github.com/benjibutten/MicMixer/releases)(安装时勾选安装 VB-CABLE 虚拟声卡)
2. 从本仓库 [Releases](../../releases) 下载 `MicMixer汉化补丁.zip`,解压
3. 双击 `安装汉化补丁.bat`,UAC 弹窗点"是"
4. 启动 MicMixer 即为中文界面;游戏/语音软件的**麦克风**选 `MicMixer Output (VB-Audio Virtual Cable)`(只需一次)

**要求**:Windows 10/11 x64;[.NET 10 Desktop Runtime](https://dotnet.microsoft.com/download/dotnet/10.0)(补丁脚本自动检测);PowerShell 7 (pwsh)

## 还原英文

双击 `还原英文原版.bat`。首次打补丁时原版已自动备份为 `*.en.bak`。

## 注意

- **不要在应用内点"检查更新"**:官方更新会把英文版装回来;更新后重新打补丁(跨大版本需等本仓库适配)
- 系统**默认"输出"**保持你的耳机/音箱,**不要**选虚拟设备;只有游戏里的"**输入(麦克风)**"才选 MicMixer Output
- 补丁不含 VB-CABLE 驱动本体;没装过的话先跑一遍官方安装器

## 变声功能

- 变声有三种模式:**关闭** / **变声软件**(需自行安装 Voicemod 等外部变声器,然后在 设置›设备 里选它的虚拟麦克风)/ **MicMixer 内置变声**(在 设置›设备›变声 里"创建变声…",录样本调音色)
- "音乐忽略按键说话"仅在开启按键说话后可勾;"监听"仅 MP3/YouTube 模式可用(外部应用模式下应用本身就在出声)

## 许可

- MicMixer 原项目基于 **Apache-2.0** 授权,本补丁依其条款再分发并声明:本仓库二进制文件为 MicMixer v2026.11.1 的修改版本,仅翻译界面文本。见 [LICENSE.txt](LICENSE.txt) / [NOTICE.txt](NOTICE.txt) / [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt)
- 本补丁与 MicMixer 原作者(BenjiButten)无关;汉化相关问题请到本仓库反馈
