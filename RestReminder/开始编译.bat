@echo off
chcp 65001 >nul
cls
echo ========================================
echo    Rest Reminder - APK 编译助手
echo ========================================
echo.
echo 请选择编译方式：
echo.
echo 1. 在 Android Studio 中构建（推荐）
echo 2. 使用命令行编译（需要先在 Android Studio 中同步）
echo 3. 查看详细指南
echo 0. 退出
echo.
set /p choice="请输入选项 (0-3): "

if "%choice%"=="1" goto android_studio
if "%choice%"=="2" goto command_line
if "%choice%"=="3" goto show_guide
if "%choice%"=="0" goto end

:android_studio
cls
echo ========================================
echo    方式 1: Android Studio 构建
echo ========================================
echo.
echo 步骤说明：
echo.
echo 1. 打开 Android Studio
echo 2. 点击 File -^> Open
echo 3. 选择此文件夹: C:\Users\roro\Desktop\RestReminder
echo 4. 等待 Gradle 同步完成（首次需要 5-10 分钟）
echo 5. 点击 Build -^> Build Bundle(s) / APK(s) -^> Build APK(s)
echo 6. 构建完成后，右下角点击 "locate" 查看 APK
echo.
echo APK 位置: app\build\outputs\apk\debug\app-debug.apk
echo.
pause
goto end

:command_line
cls
echo ========================================
echo    方式 2: 命令行编译
echo ========================================
echo.
echo 前提条件：
echo   首次使用前，必须先在 Android Studio 中打开并同步项目
echo.
echo 步骤说明：
echo.
echo 1. 在 Android Studio 中打开此项目
echo 2. 等待 Gradle 同步完成
echo 3. 回到这里，按任意键开始编译
echo.
pause

echo.
echo 开始编译...
echo.

if not exist "gradle\wrapper\gradle-wrapper.jar" (
    echo [错误] 缺少 gradle-wrapper.jar
    echo.
    echo 请先在 Android Studio 中打开并同步项目
    echo Android Studio 会自动生成这个文件
    echo.
    pause
    goto end
)

call gradlew.bat clean assembleDebug

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo    编译成功！
    echo ========================================
    echo.
    echo APK 位置: app\build\outputs\apk\debug\app-debug.apk
    echo.
    explorer app\build\outputs\apk\debug\
) else (
    echo.
    echo [错误] 编译失败
    echo 请检查错误信息
)

pause
goto end

:show_guide
cls
echo ========================================
echo    详细指南
echo ========================================
echo.
echo 正在打开详细指南...
echo.
start 本地编译指南.md
goto end

:end
