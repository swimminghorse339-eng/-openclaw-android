#!/bin/bash
# Android APK Build Script for Windows Remote App
# Run this in WSL Ubuntu

PROJECT_DIR="/mnt/c/Users/swimm/.openclaw/workspace/android_remote"
VENV_DIR="$PROJECT_DIR/venv"

echo "=== Windows Remote Android APK Builder ==="
echo ""

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
cd "$PROJECT_DIR" || { echo "Failed to enter project directory!"; exit 1; }

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
pip install buildozer cython
echo ""

echo "Step 6: Installing Kivy requirements..."
pip install kivy requests
echo ""

echo "Step 7: Starting Android build..."
echo " This will take 30+ minutes on first run as it downloads:"
echo " - Android SDK"
echo " - Android NDK"
echo " - Build tools"
echo ""
echo " Press Ctrl+C to abort, or wait to continue..."
sleep 5

# Run buildozer from venv
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
    echo "Check buildozer.log for details:"
    ls -la "$PROJECT_DIR/buildozer.log" 2>/dev/null || echo "No log file found"
fi
