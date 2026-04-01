@echo off
chcp 65001 >nul
cls
echo ========================================
echo    开始编译 APK
echo ========================================
echo.

cd /d "%~dp0"

echo 正在清理旧构建...
call gradlew.bat clean
echo.

echo 开始编译 Debug APK...
echo (这可能需要 3-5 分钟，请耐心等待...)
echo.

call gradlew.bat assembleDebug --stacktrace

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo    编译成功！
    echo ========================================
    echo.
    echo APK 位置: app\build\outputs\apk\debug\app-debug.apk
    echo.

    if exist "app\build\outputs\apk\debug\app-debug.apk" (
        echo 正在打开 APK 所在文件夹...
        explorer app\build\outputs\apk\debug\
    )
) else (
    echo.
    echo ========================================
    echo    编译失败
    echo ========================================
    echo.
    echo 请检查上面的错误信息
)

echo.
pause
