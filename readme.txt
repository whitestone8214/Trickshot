Trickshot - Suckless build system for Android app

Version 0.0.4

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
	- You must add kotlin-stdlib .jar(Usually /usr/share/kotlin/lib/kotlin-stdlib.jar) into _listLibraries to build Kotlin code.
	- trickshot.sh build :: Build app (Java & Kotlin mixed; Default)
	- trickshot.sh build javaonly :: Build app (Java-only source tree)
	- trickshot.sh build kotlinonly :: Build app (Kotlin-only source tree)
	- trickshot.sh install :: Install app (Build first if it doesn't exist)
	- trickshot.sh install forcerebuild :: Delete, rebuild and install app
	
Tips:
	- You could get needed libraries from https://mvnrepository.com/ usually.
	
Limitations / Todo:
	- Dependency injection(e.g. Dagger) is not supported for now.
	- Multiple .dex is not supported for now.
	- AIDL(.aidl) is not supported for now.
	- R8 is not supported for now.
	- Android < 8.1(Oreo, API 27) is not supported and no plan to do.
	- Maybe other limitations I didn't find...
