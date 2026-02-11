# Build Instructions for Windows Remote Android App

## Overview
This is a Kivy-based Android app for controlling a Windows PC remotely.

## Features
- **Lock Screen**: Lock the remote Windows PC
- **Volume Control**: Adjust volume up/down
- **Mouse Control**: Click left/right buttons
- **Keyboard**: Send keyboard shortcuts and type text
- **Screenshots**: Take and view screenshots
- **App Launcher**: Launch Notepad, Chrome

## Connection
- **Direct WiFi**: Connect via local network (default: http://192.168.1.100:5000)
- **ngrok**: Can work through ngrok tunneling

## Requirements

### Python Dependencies
```
kivy>=2.2.0
requests>=2.31.0
python-for-android
buildozer>=1.5.0
cython
```

### Build Tools Required (Linux/macOS)
- Python 3.8-3.11 (buildozer has issues with 3.12+)
- Android SDK
- Android NDK
- JDK 17

### System Dependencies (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y \
    git zip unzip openjdk-17-jdk autoconf libtool pkg-config \
    zlib1g-dev libncurses5-dev libncursesw5-dev libtinfo5 \
    cmake libffi-dev libssl-dev automake help2man wget
```

## Build Methods

### Method 1: GitHub Actions (Recommended for Windows users)
Push code to GitHub and the workflow will automatically build the APK.

```bash
git add .
git commit -m "Add Android remote control app"
git push origin main
```

The APK will be available as a downloadable artifact.

### Method 2: WSL (Windows Subsystem for Linux)
If you have WSL2 enabled:

```bash
# In WSL terminal
cd /mnt/c/path/to/android_remote
sudo apt-get update
sudo apt-get install -y python3 python3-pip openjdk-17-jdk
pip3 install buildozer cython
buildozer android debug
```

### Method 3: Linux/macOS Native
```bash
cd android_remote
pip install buildozer cython
buildozer android debug
```

The APK will be in `bin/windowsremote-0.1-arm64-v8a_armeabi-v7a-debug.apk`

### Method 4: Docker (if available)
```bash
cd android_remote
docker build -t android-remote-build .
docker run -v $(pwd):/app android-remote-build buildozer android debug
```

## Configuration

### buildozer.spec
Key settings:
- `title`: Windows Remote
- `package.name`: windowsremote
- `version`: 0.1
- `requirements`: python3,kivy,requests,urllib3
- `android.archs`: arm64-v8a,armeabi-v7a
- `android.permissions`: INTERNET

### Server Configuration
Edit `main.py` to change:
```python
DEFAULT_SERVER = "http://YOUR_PC_IP:5000"
DEFAULT_TOKEN = "your-secret-token"
```

## Installation

1. Build or download the APK
2. Transfer to Android device
3. Install APK (may need to enable "Unknown sources")
4. Ensure server is running on Windows PC
5. Enter server URL and token in app

## Troubleshooting

### Build fails on Windows
Buildozer requires Linux. Use GitHub Actions or WSL.

### "FancyURLopener" error on Python 3.14+
This is a compatibility issue. Use Python 3.11 for building.

### Android SDK not found
Set environment variables:
```bash
export ANDROID_HOME=$HOME/.buildozer/android/platform/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
```

### App crashes on startup
- Check that INTERNET permission is granted
- Verify server URL is accessible
- Check token matches server configuration

## Current Build Status
- Buildozer: Installed (with Python 3.14 patch)
- Android SDK: Not configured
- WSL: Not available
- Docker: Not available
- **Recommendation**: Use GitHub Actions for automated builds
