@echo off
chcp 65001 >nul
cls
echo ========================================
echo    检查 GitHub 推送状态
echo ========================================
echo.

cd /d "%~dp0"

echo 当前 Git 状态：
echo.
git status
echo.

echo ========================================
echo    推送历史（最近 5 次）：
echo ========================================
echo.
git log --oneline -5
echo.

echo ========================================
echo    检查与远程的差异：
echo ========================================
echo.
git log origin/main..HEAD --oneline
echo.

echo ========================================
echo    开始推送到 GitHub...
echo ========================================
echo.

git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo    推送成功！
    echo ========================================
    echo.
    echo 现在可以访问以下链接查看 Actions：
    echo https://github.com/r0779/RestReminder/actions
    echo.
    start https://github.com/r0779/RestReminder/actions
) else (
    echo.
    echo ========================================
    echo    推送失败
    echo ========================================
    echo.
    echo 请检查网络连接或 GitHub 访问权限
)

echo.
pause
