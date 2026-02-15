[app]
# Application
title = Windows Remote
package.name = windowsremote
package.domain = com.example
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 0.1

# Requirements
requirements = python3,kivy,requests,urllib3,charset-normalizer,idna,certifi

# Orientation
orientation = portrait
fullscreen = 0

# Android settings
android.api = 33
android.minapi = 21
android.archs = arm64-v8a
android.permissions = INTERNET

# SDK License (CRITICAL - avoid interactive prompt)
android.accept_sdk_license = True

[buildozer]
log_level = 2
warn_on_root = 1
bin_dir = ./bin
