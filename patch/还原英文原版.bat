@echo off
rem MicMixer Chinese localization patch - restore original English version
net session >nul 2>&1
if %errorlevel% equ 0 goto :admin
echo Requesting administrator rights...
pwsh -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b
:admin
cd /d "%~dp0"
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0patch.ps1" -Mode Restore
