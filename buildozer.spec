[app]
title = Windows Remote
package.name = windowsremote
package.domain = org.example
source.dir = .
version = 0.1
requirements = python3,kivy==2.3.0,requests,urllib3,pyjnius,setuptools
orientation = portrait
fullscreen = 0
android.archs = arm64-v8a,armeabi-v7a
android.permissions = INTERNET

# Fix for SDL2_ttf harfbuzz build issues
p4a.branch = release-2024.01

[buildozer]
log_level = 2
warn_on_root = 1
