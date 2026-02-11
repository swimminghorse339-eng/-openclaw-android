@echo off
echo ================================================
echo  Windows Remote - Android APK Builder
echo ================================================
echo.
echo This will open WSL Ubuntu and run the build process.
echo You may be asked for your WSL sudo password.
echo.
echo The build typically takes 30-60 minutes on first run
echo while downloading Android SDK and NDK components.
echo.
echo Press any key to start the build...
pause >nul

echo.
echo Starting WSL build process...
echo.

wsl -d Ubuntu -e bash -c "cd /mnt/c/Users/swimm/.openclaw/workspace/android_remote && chmod +x build_in_wsl.sh && ./build_in_wsl.sh"

echo.
echo ================================================
echo Build process finished!
echo.
if exist "\Users\swimm\.openclaw\workspace\android_remote\bin\*.apk" (
    echo APK file found at:
    dir "\Users\swimm\.openclaw\workspace\android_remote\bin\*.apk" /b /s
echo.
) else (
    echo No APK file found. Check the build output above for errors.
echo)
echo Press any key to exit...
pause >nul
