@echo off
REM Build script for Windows Remote Android App
REM Note: Buildozer requires Linux. This script checks for alternatives.

echo ========================================
echo Windows Remote - Android Build Script
echo ========================================
echo.

REM Check for Python
echo Checking Python...
python --version 2>nul
if errorlevel 1 (
    echo ERROR: Python not found. Please install Python 3.11+
    exit /b 1
)

REM Check for buildozer
echo Checking buildozer...
python -c "import buildozer" 2>nul
if errorlevel 1 (
    echo buildozer not found. Installing...
    pip install buildozer cython
)

REM Check for WSL
echo Checking WSL...
wsl --status >nul 2>&1
if %errorlevel% == 0 (
    echo WSL found! Building in WSL environment...
    wsl -e bash -c "cd /mnt/%CD::=% && sudo apt-get update && sudo apt-get install -y openjdk-17-jdk && pip3 install buildozer cython && buildozer android debug"
    goto :end
)

REM Check for Docker
echo Checking Docker...
docker --version >nul 2>&1
if %errorlevel% == 0 (
    echo Docker found! Building with Docker...
    docker build -t android-remote-build .
    docker run --rm -v "%cd%:/app" android-remote-build buildozer android debug
    goto :end
)

echo.
echo ========================================
echo BUILD OPTIONS NOT AVAILABLE
echo ========================================
echo.
echo WSL: Not available or not configured
echo Docker: Not available
echo.
echo RECOMMENDED SOLUTION:
echo 1. Push this code to GitHub
echo 2. The GitHub Actions workflow will automatically build the APK
echo 3. Download the APK from the Actions artifacts
echo.
echo Alternative: Set up WSL2 with Ubuntu
echo   wsl --install
echo.
echo Alternative: Install Docker Desktop
echo   https://www.docker.com/products/docker-desktop
echo.
echo Files ready for GitHub Actions:
echo   - .github/workflows/build.yml
echo   - buildozer.spec
echo   - main.py
echo   - requirements.txt
echo.

:end
echo.
echo Build complete or instructions provided.
pause
