@echo off
chcp 65001 >nul
setlocal

REM 一键把本目录提交并推送到 GitHub
REM 用法：双击本文件，或在 PowerShell / cmd 里执行 scripts\push.bat

cd /d "%~dp0.."
echo.
echo  仓库目录: %CD%
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo  [错误] 没有找到 git。
  echo         请先安装 Git for Windows: https://git-scm.com/download/win
  echo         安装后重新打开这个窗口再试。
  pause
  exit /b 1
)

set REPO=git@github.com:Yitiaoyu686/MOTO-around.git
set BRANCH=main

if not exist ".git" (
  echo  [1/4] 初始化仓库…
  git init
  git branch -M %BRANCH%
  git remote add origin %REPO%
) else (
  git remote get-url origin >nul 2>nul
  if errorlevel 1 (
    echo  [1/4] 补上 remote origin…
    git remote add origin %REPO%
  ) else (
    echo  [1/4] 仓库已存在，跳过初始化。
  )
)

echo.
echo  [2/4] 拉取远端已有提交…
git fetch origin %BRANCH% 2>nul
git rev-parse --verify %BRANCH% >nul 2>nul
if errorlevel 1 (
  git checkout -b %BRANCH% 2>nul
) else (
  git checkout %BRANCH% 2>nul
)
git pull --rebase --allow-unrelated-histories origin %BRANCH% 2>nul

echo.
echo  [3/4] 暂存并提交…
git add -A
git commit -m "docs: 设计文档 + 玩法原型 + 视觉方向" 
if errorlevel 1 echo      （没有新改动，跳过提交）

echo.
echo  [4/4] 推送…
git push -u origin %BRANCH%
if errorlevel 1 (
  echo.
  echo  [推送失败] 常见原因：
  echo    1. SSH 密钥未授权：ssh -T git@github.com 验证一下
  echo    2. 远端有别人的提交：先执行  git pull --rebase origin %BRANCH%
  echo    3. 分支名不是 main：去仓库页面确认默认分支名
)

echo.
git log --oneline -5
echo.
pause
