Trickshot - Suckless build system for Android app

Version 0.0.1

Copyright (C) 2018 Minho Jo <whitestone8214@gmail.com>

License: MIT (see license.txt)

Required:
	- BASH
	- OpenJDK 8
	- Android SDK
	- App source code to build
	- Java KeyStore file (.jks) to sign the app
	
Usage:
	- You must adjust the variables in script to fit to your environment, manually.
	- trickshot.sh build :: Build the app
	- trickshot.sh install :: Install the app (Build first if it doesn't exist)
	- trickshot.sh install forcerebuild :: Delete, rebuild, install the app
	
Limitations / Todo:
	- Android Studio is not supported for now. (AFAIK Android Studio also uses SDK to build the app though)
	- App written in Kotlin or both Java and Kotlin is not supported for now.
	- App that uses external libraries (including Android Support Libraries) other than basic framework is not supported for now.
	- Compatibility with Android versions below than 8.1 (Oreo, API 27) is not supported nor tested. (No plan to support it for now)
