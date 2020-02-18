Trickshot - Suckless build system for Android app

Version 0.0.3

Copyright (C) 2018-2020 Minho Jo <whitestone8214@gmail.com>

License: MIT (see license.txt)

Required:
	- BASH
	- OpenJDK 8 and/or Kotlin
	- Android SDK
	- App source code to build
	- Java KeyStore file (.jks) to sign the app
	- ADB (to install the app)
	
Usage:
	- You can install it into /usr/bin, or top of the source tree.
	- Run it on the top of the source tree.
	- You must adjust the variables in script to fit to your environment, manually.
	- trickshot.sh build :: Build app
	- trickshot.sh install :: Install app (Build first if it doesn't exist)
	- trickshot.sh install forcerebuild :: Delete, rebuild and install app
	
Limitations / Todo:
	- Java/Kotlin mixed code is not tested yet.
	- Multiple .dex is not supported for now.
	- AIDL(.aidl) is not supported for now.
	- R8 is not supported for now.
	- Android < 8.1(Oreo, API 27) is not supported and no plan to do.
	- Maybe other limitations I didn't find...
