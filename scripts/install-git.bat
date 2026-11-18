@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM =====================================================================
REM  安装 Git for Windows（静默）
REM  用法：右键「以管理员身份运行」，或直接双击
REM  方式：优先 winget，失败则从 GitHub 官方 Release 下载安装包
REM =====================================================================

echo.
echo  ┌────────────────────────────────────┐
echo  │   安装 Git for Windows             │
echo  └────────────────────────────────────┘
echo.

REM ---------- 已经装了？ ----------
if exist "%ProgramFiles%\Git\bin\bash.exe" (
  echo  [✓] 已经装好了：%ProgramFiles%\Git\bin\bash.exe
  echo.
  git --version 2>nul
  echo.
  pause
  exit /b 0
)

REM ---------- 方式一：winget ----------
where winget >nul 2>nul
if errorlevel 1 goto :fallback

echo  [1/3] 用 winget 安装 Git.Git …
winget install --id Git.Git -e --source winget ^
  --accept-package-agreements --accept-source-agreements ^
  --disable-interactivity
if not errorlevel 1 goto :done
echo  [!] winget 安装失败，改用下载安装包的方式。
echo.

:fallback
echo  [1/3] 正在从 github.com/git-for-windows 获取最新安装包地址 …
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$r = Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest' -UseBasicParsing;" ^
  "$a = $r.assets | Where-Object { $_.name -like '*-64-bit.exe' -and $_.name -notlike '*Portable*' } | Select-Object -First 1;" ^
  "if(-not $a){ throw '没有找到 64 位安装包' };" ^
  "Write-Host ('      版本: ' + $a.name);" ^
  "Invoke-WebRequest -Uri $a.browser_download_url -OutFile \"$env:TEMP\git-setup.exe\" -UseBasicParsing;"
if errorlevel 1 (
  echo.
  echo  [×] 下载失败。请手动安装：
  echo      https://git-scm.com/download/win
  pause
  exit /b 1
)

echo  [2/3] 下载完成，开始静默安装（几分钟，请勿关闭窗口）…
"%TEMP%\git-setup.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS
if errorlevel 1 (
  echo.
  echo  [×] 安装失败。请手动安装：https://git-scm.com/download/win
  pause
  exit /b 1
)

:done
echo.
echo  [3/3] 验证…
if exist "%ProgramFiles%\Git\bin\bash.exe" (
  echo  [✓] 安装成功
  set "PATH=%ProgramFiles%\Git\cmd;!PATH!"
  git --version
  echo.
  echo  接下来回到 Pi，输入 /reload 或重启 Pi，bash 工具就能用了。
) else (
  echo  [!] 安装程序跑完了，但没在默认位置找到 Git。
  echo      如果装在别处，请在 ~/.pi/agent/settings.json 里设置 shellPath。
)

echo.
pause
