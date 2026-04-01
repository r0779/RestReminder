@echo off
chcp 65001 >nul
cls
echo ========================================
echo    推送到 GitHub 并构建 APK
echo ========================================
echo.

cd /d "%~dp0"

echo 步骤 1: 添加文件到 Git...
git add .

echo.
echo 步骤 2: 提交更改...
git commit -m "Update project and prepare for build"

echo.
echo 步骤 3: 推送到 GitHub...
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo    推送成功！
    echo ========================================
    echo.
    echo 下一步操作：
    echo.
    echo 1. 打开浏览器访问：
    echo    https://github.com/r0779/RestReminder/actions
    echo.
    echo 2. 点击 "Build Android APK" 工作流
    echo.
    echo 3. 点击 "Run workflow" 按钮
    echo.
    echo 4. 等待构建完成（约 3-5 分钟）
    echo.
    echo 5. 构建完成后，下载 "rest-reminder-apk"
    echo.
    echo 正在打开 GitHub Actions 页面...
    start https://github.com/r0779/RestReminder/actions
) else (
    echo.
    echo ========================================
    echo    推送失败
    echo ========================================
    echo.
    echo 请检查错误信息
)

echo.
pause
