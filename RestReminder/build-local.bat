@echo off
chcp 65001 >nul
echo ========================================
echo    本地编译 APK 脚本
echo ========================================
echo.

REM 检查 Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Java，请先安装 JDK
    pause
    exit /b 1
)
echo [✓] Java 已安装
echo.

REM 检查 gradle-wrapper.jar
if not exist "gradle\wrapper\gradle-wrapper.jar" (
    echo [警告] 缺少 gradle-wrapper.jar 文件
    echo.
    echo 请选择编译方式：
    echo 1. 使用 Android Studio 构建（推荐）
    echo 2. 下载 gradle-wrapper.jar 后重新运行此脚本
    echo.
    pause
    exit /b 0
)

echo [✓] Gradle wrapper 准备就绪
echo.

REM 开始编译
echo 正在编译 Debug APK...
echo.
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
    echo [错误] 编译失败，请检查错误信息
)

echo.
pause
