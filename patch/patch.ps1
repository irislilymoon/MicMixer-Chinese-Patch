# MicMixer 汉化补丁 安装/还原脚本
# 用法: patch.ps1 -Mode Install  (安装汉化)
#       patch.ps1 -Mode Restore  (还原英文原版)
param([ValidateSet('Install','Restore')][string]$Mode = 'Install')
$ErrorActionPreference = 'Stop'

# --- 管理员自检,不够就自提权 ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "需要管理员权限,正在弹出 UAC..."
    Start-Process pwsh -Verb RunAs -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$PSCommandPath`"",' -Mode',$Mode)
    exit
}

# --- 定位安装目录 ---
$target = "$env:ProgramFiles\MicMixer"
if (-not (Test-Path (Join-Path $target 'MicMixer.exe'))) {
    $keys = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
              'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
              'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')
    $loc = Get-ItemProperty $keys -ErrorAction SilentlyContinue |
           Where-Object { $_.DisplayName -eq 'MicMixer' -and $_.InstallLocation } |
           Select-Object -First 1 -ExpandProperty InstallLocation
    if ($loc) { $target = $loc.TrimEnd('\') }
}
if (-not (Test-Path (Join-Path $target 'MicMixer.exe'))) {
    Write-Host "!! 没找到 MicMixer 安装目录。请先安装官方原版,或把本补丁文件夹放到安装目录旁再试。"
    Read-Host "按回车退出"
    exit 1
}
$filesDir = Join-Path $PSScriptRoot 'files'
Write-Host "目标目录: $target"

# --- 停进程 ---
foreach ($n in 'MicMixer','MicMixer.Launcher') {
    Get-Process -Name $n -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Milliseconds 800

$apps = 'MicMixer.exe','MicMixer.Launcher.exe'

if ($Mode -eq 'Install') {
    # --- .NET 10 桌面运行时检测(瘦版补丁依赖它) ---
    $rt = & dotnet --list-runtimes 2>$null | Select-String 'WindowsDesktop\.App 10\.'
    if (-not $rt) {
        Write-Host "!! 缺少 .NET 10 桌面运行时,补丁版无法启动。"
        $open = Read-Host "是否打开下载页?(y/n)"
        if ($open -eq 'y') { Start-Process 'https://dotnet.microsoft.com/download/dotnet/10.0' }
        Read-Host "装好运行时后重新运行本补丁。按回车退出"
        exit 1
    }

    # --- 备份原版(仅首次;还原 always 用第一份备份) ---
    foreach ($a in $apps) {
        $exe = Join-Path $target $a
        $bak = Join-Path $target "$a.en.bak"
        if ((Test-Path $exe) -and -not (Test-Path $bak)) {
            Copy-Item $exe $bak
            Write-Host "  已备份: $a -> $a.en.bak"
        }
    }
    $origVer = (Get-Item (Join-Path $target 'MicMixer.exe.en.bak')).VersionInfo.ProductVersion
    if ($origVer -and $origVer -notlike '2026.11*') {
        Write-Host "!! 注意: 原版版本是 $origVer,本补丁针对 2026.11.1 制作,其他版本界面可能残留英文。"
    }

    # --- 覆盖汉化文件 ---
    Copy-Item (Join-Path $filesDir '*') $target -Force
    if (-not (Test-Path (Join-Path $target 'MicMixer.dll'))) { throw "复制后未找到 MicMixer.dll,安装失败" }
    Write-Host ""
    Write-Host "=== 汉化完成! ==="
    Write-Host "  双击 MicMixer 启动即是中文界面。"
    Write-Host "  游戏语音里的麦克风记得选 MicMixer Output (只需一次)。"
    Write-Host "  想恢复英文原版: 运行同目录的 还原英文原版.bat"
}
else {
    # --- 还原 ---
    $restored = 0
    foreach ($a in $apps) {
        $bak = Join-Path $target "$a.en.bak"
        if (Test-Path $bak) {
            Copy-Item $bak (Join-Path $target $a) -Force
            Write-Host "  已还原: $a"
            $restored++
        } else {
            Write-Host "  跳过: $a (没有 .en.bak 备份)"
        }
    }
    if ($restored -gt 0) {
        Write-Host "=== 已还原英文原版。想再变中文: 重新运行 安装汉化补丁.bat ==="
    }
}
Read-Host "按回车关闭窗口"
