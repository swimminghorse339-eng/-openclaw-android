[app]
title = Windows Remote
package.name = windowsremote
package.domain = org.example
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 0.1
requirements = python3,kivy,requests,urllib3
orientation = portrait

osx.python_version = 3
osx.kivy_version = 2.2.0
fullscreen = 0
android.archs = arm64-v8a,armeabi-v7a
android.permissions = INTERNET

# Buildozer spec for Android Remote Control
# Build with: buildozer android debug deploy run
