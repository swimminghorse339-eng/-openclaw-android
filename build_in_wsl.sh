#!/bin/bash

# Android APK Build Script for Windows Remote App
# Run this in WSL Ubuntu

PROJECT_DIR="/mnt/c/Users/swimm/.openclaw/workspace/android_remote"
VENV_DIR="$PROJECT_DIR/venv"

# Fix for SDL2_ttf harfbuzz issue
export P4A_BRANCH="v2024.01.21"
export SDL2_TTF_VERSION="2.20.1"

echo "=== Windows Remote Android APK Builder ==="
echo ""

# Clean previous build caches to ensure fresh build
echo "Cleaning previous build caches..."
cd "$PROJECT_DIR" || { echo "Failed to enter project directory!"; exit 1; }
rm -rf build/ .buildozer/android/platform/build*/

echo "Step 1: Updating package lists..."
sudo apt-get update

echo ""
echo "Step 2: Installing Java 17 and build tools..."
sudo apt-get install -y openjdk-17-jdk git zip unzip wget

echo ""
echo "Step 3: Installing Python and venv..."
sudo apt-get install -y python3-pip python3-venv python3-full

echo ""
echo "Step 4: Creating Python virtual environment..."
# Remove old venv if exists and create fresh one
if [ -d "$VENV_DIR" ]; then
    echo "Removing existing virtual environment..."
    rm -rf "$VENV_DIR"
fi
python3 -m venv venv
source venv/bin/activate
echo "Virtual environment activated"

echo ""
echo "Step 5: Installing buildozer and dependencies in venv..."
# Install setuptools first for Python 3.12+ compatibility (distutils was removed)
pip install setuptools wheel packaging
pip install buildozer cython

# Patch buildozer for Python 3.12+ compatibility
echo "Patching buildozer for Python 3.12+ compatibility..."
PYTHON_VERSION=$(python3 --version | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
BUILDOZER_TARGET="$VENV_DIR/lib/python$PYTHON_VERSION/site-packages/buildozer/targets/android.py"
if [ -f "$BUILDOZER_TARGET" ]; then
    sed -i 's/from distutils.version import LooseVersion/try:\n    from distutils.version import LooseVersion\nexcept ImportError:\n    from packaging.version import Version as LooseVersion/g' "$BUILDOZER_TARGET" 2>/dev/null || true
    echo "Patched android.py"
fi
BUILDOZER_INIT="$VENV_DIR/lib/python$PYTHON_VERSION/site-packages/buildozer/__init__.py"
if [ -f "$BUILDOZER_INIT" ]; then
    sed -i 's/from distutils.version import LooseVersion/try:\n    from distutils.version import LooseVersion\nexcept ImportError:\n    from packaging.version import Version as LooseVersion/g' "$BUILDOZER_INIT" 2>/dev/null || true
    echo "Patched __init__.py"
fi

echo ""
echo "Step 6: Installing Kivy requirements..."
pip install kivy requests

echo ""
echo "Step 7: Starting Android build..."
echo "This will take 30+ minutes on first run as it downloads:"
echo "  - Android SDK"
echo "  - Android NDK"
echo "  - Build tools"
echo ""
echo "Press Ctrl+C to abort, or wait to continue..."
sleep 5

# Run buildozer from venv with nohup to prevent hanging
# Using p4a.branch from env variable
buildozer android debug

echo ""
echo "=== Build Complete! ==="
echo ""

if ls bin/*.apk 1> /dev/null 2>&1; then
    echo "APK file created successfully:"
    ls -lh bin/*.apk
    echo ""
    echo "Absolute path in WSL: $PROJECT_DIR/bin/"
else
    echo "APK file not found. Build may have failed."
    echo "Checking for APK in alternative locations:"
    find . -name "*.apk" -type f 2>/dev/null | head -5
    echo ""
    echo "Check buildozer.log for details:"
    ls -la .buildozer/android/platform/build-*/buildozer.log 2>/dev/null || echo "No log file found"
fi
