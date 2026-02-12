[app]
title = Windows Remote
package.name = windowsremote
package.domain = com.example
source.dir = .
version = 0.1
requirements = python3,kivy,requests,pyjnius,setuptools
orientation = portrait
fullscreen = 0
android.archs = arm64-v8a
android.permissions = INTERNET
android.sdk_path = /home/runner/android-sdk
android.ndk_path = /home/runner/android-sdk/ndk/25.2.9519653

[buildozer]
log_level = 2
warn_on_root = 1
