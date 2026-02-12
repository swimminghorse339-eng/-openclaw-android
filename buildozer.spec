[app]
title = Windows Remote
package.name = windowsremote
package.domain = org.example
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 0.1
requirements = python3,kivy,requests,urllib3,pyjnius==1.6.1,setuptools
orientation = portrait

osx.python_version = 3
osx.kivy_version = 2.2.0
fullscreen = 0
android.archs = arm64-v8a,armeabi-v7a
android.permissions = INTERNET

# Buildozer spec for Android Remote Control
# Build with: buildozer android debug deploy run

# Fix for SDL2_tTF harfbuzz build error
# Pin to older SDL2_ttf version without harfbuzz issues
p4a.local_recipes =
p4a.sdl2_ttf.ver = 2.20.1
# Use specific python-for-android version without harfbuzz issues
p4a.branch = v2024.01.21
android.gradle_dependencies = org.jetbrains.kotlin:kotlin-stdlib:1.6.10,com.android.support:support-compat:28.0.0
