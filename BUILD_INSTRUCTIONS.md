# Android APK Build Instructions

## Prerequisites
- Windows with WSL Ubuntu installed
- Your WSL user password (required for sudo)

## Method 1: Run the Automated Script

1. Open File Explorer and navigate to:
   ```
   C:\Users\swimm\.openclaw\workspace\android_remote\
   ```

2. Double-click `run_build.bat`

3. When prompted, enter your WSL sudo password

4. Wait for the build to complete (30-60 minutes on first run)

5. The APK will be in the `bin/` folder

## Method 2: Manual Build Steps

Open PowerShell or Command Prompt and run:

```powershell
wsl -d Ubuntu
```

Then in the WSL terminal:

```bash
# Navigate to project
cd /mnt/c/Users/swimm/.openclaw/workspace/android_remote

# Run the build script
chmod +x build_in_wsl.sh
./build_in_wsl.sh
```

## Method 3: Step-by-Step Manual

If you prefer to run each step manually:

```bash
# 1. Enter the project directory
cd /mnt/c/Users/swimm/.openclaw/workspace/android_remote

# 2. Update packages
sudo apt-get update

# 3. Install dependencies
sudo apt-get install -y openjdk-17-jdk git zip unzip python3-pip

# 4. Install buildozer and Cython
pip3 install --user buildozer cython

# 5. Install Kivy
pip3 install --user kivy requests

# 6. Build the APK
~/.local/bin/buildozer android debug

# 7. Find the APK
ls -la bin/*.apk
```

## Expected Build Time

- First build: 30-60 minutes (downloads Android SDK, NDK, Gradle)
- Subsequent builds: 5-10 minutes

## Troubleshooting

**"sudo: command not found"**
- Make sure you're in a proper WSL Ubuntu terminal

**Build fails with Java errors**
- Verify Java 17 is installed: `java -version`

**APK not created**
- Check `buildozer.log` for detailed error messages
- Run `buildozer android clean` and try again

## APK Location After Build

The APK file will be located at:
```
C:\Users\swimm\.openclaw\workspace\android_remote\bin\
```

Example filename: `windowsremote__arm64-v8a_armeabi-v7a-debug.apk`
