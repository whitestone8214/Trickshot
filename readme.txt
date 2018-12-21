Trickshot - Suckless build system for Android app

Version 0.0.2

Copyright (C) 2018 Minho Jo <whitestone8214@gmail.com>

License: MIT (see license.txt)

Required:
	- BASH
	- OpenJDK 8
	- Android SDK
	- App source code to build
	- Java KeyStore file (.jks) to sign the app
	- ADB (to install the app)
	
Usage:
	- You can install it into /usr/bin, or top of the source tree.
	- Run it on the top of the source tree.
	- You must adjust the variables in script to fit to your environment, manually.
	- trickshot.sh build :: Build the app
	- trickshot.sh install :: Install the app (Build first if it doesn't exist)
	- trickshot.sh install forcerebuild :: Delete, rebuild, install the app
	
Limitations / Todo:
	- App written in Kotlin or both Java and Kotlin is not supported for now.
	- Heavy-weight(i.e. Must be compiled in multiple .dex files) app is not supported for now.
	- App that uses AIDL(.aidl) is not supported for now.
	- Compatibility with Android versions below than 8.1 (Oreo, API 27) is not supported nor tested. (No plan to support it for now)
	- Maybe other limitations I don't know...
