# Build APK with Android Studio Gradle
$projectDir = "C:\Users\roro\Desktop\RestReminder"
$gradleJar = "C:\Program Files\Android\Android Studio\plugins\gradle\lib\gradle.jar"

Write-Host "========================================"
Write-Host "   Building APK with Gradle"
Write-Host "========================================"
Write-Host ""

# Check Java
Write-Host "[*] Checking Java..."
java -version
Write-Host ""

# Check Gradle
Write-Host "[*] Checking Gradle..."
if (Test-Path $gradleJar) {
    Write-Host "    Found Gradle"
} else {
    Write-Host "    Gradle not found"
    Write-Host "Please install Android Studio"
    exit 1
}
Write-Host ""

# Change to project directory
Set-Location $projectDir

# Clean old builds
Write-Host "[*] Cleaning old builds..."
java -jar $gradleJar clean --no-daemon 2>&1 | Out-Null
Write-Host "    Clean complete"
Write-Host ""

# Build Debug APK
Write-Host "[*] Building Debug APK..."
Write-Host "    This may take a few minutes..."
Write-Host ""

java -jar $gradleJar assembleDebug --no-daemon --stacktrace

$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "   Build Successful!"
    Write-Host "========================================"
    Write-Host ""

    $apkPath = "app\build\outputs\apk\debug\app-debug.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length / 1KB
        Write-Host "APK Path: $apkPath"
        Write-Host "APK Size: $([math]::Round($apkSize, 2)) KB"
        Write-Host ""

        # Open folder
        explorer "app\build\outputs\apk\debug\"
    } else {
        Write-Host "Warning: APK file not found"
    }
} else {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "   Build Failed!"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Please check the error messages above"
    exit 1
}
