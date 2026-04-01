# Download and setup Gradle
$ErrorActionPreference = "Stop"

$gradleVersion = "8.2"
$downloadUrl = "https://services.gradle.org/distributions/gradle-${gradleVersion}-bin.zip"
$installDir = "$env:USERPROFILE\.gradle"
$zipPath = "$env:TEMP\gradle-${gradleVersion}-bin.zip"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Downloading Gradle $gradleVersion" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create install directory
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    Write-Host "[*] Created directory: $installDir" -ForegroundColor Green
}

# Download Gradle
Write-Host "[*] Downloading Gradle from: $downloadUrl" -ForegroundColor Yellow
Write-Host "    (This may take a few minutes...)" -ForegroundColor Gray
Write-Host ""

try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
    Write-Host "[✓] Download completed" -ForegroundColor Green
} catch {
    Write-Host "[✗] Download failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Extract
Write-Host "[*] Extracting Gradle..." -ForegroundColor Yellow
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
Write-Host "[✓] Extraction completed" -ForegroundColor Green
Write-Host ""

# Clean up
Remove-Item $zipPath -Force

# Show gradle location
$gradlePath = "$installDir\gradle-${gradleVersion}\bin\gradle.bat"
Write-Host "[✓] Gradle installed at: $gradlePath" -ForegroundColor Cyan
Write-Host ""

# Test
Write-Host "[*] Testing Gradle installation..." -ForegroundColor Yellow
& $gradlePath --version
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "   Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "You can now use Gradle with:" -ForegroundColor Cyan
Write-Host "  $gradlePath" -ForegroundColor Cyan
