#!/bin/bash

# (C) 2018-2020 Minho Jo <whitestone8214@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Version of this script
_versionThisMajor=0
_versionThisMinor=0
_versionThisMicro=3

# Path to SDK
_pathSDK="/opt/sdk/android"

# Path to source tree (i.e. src)
_pathSourceTree="src"

# Version of build toolchain (aapt, d8, zipalign, ...)
_versionBuildToolchain="28.0.3"

# Version of SDK
_versionSDK="28"

# Version of Android
_versionAndroid="9.0.0"

# Resources
# Example: _listResources=(res ./libraries/support-v4/res)
_listResources=(res)
_optionResources=()
for x in ${_listResources[@]}; do
	_optionResources+=(-S)
	_optionResources+=(${x})
done

# Libraries
# Example: _listLibraries=(${_pathSDK}/platforms/android-${_versionSDK}/android.jar ./libraries/support-v4/classes.jar)
_listLibraries=(${_pathSDK}/platforms/android-${_versionSDK}/android.jar)
_optionLibrariesAsArray=()
_optionLibrariesAsArrayForD8=()
_optionLibrariesAsString=""
for x in ${_listLibraries[@]}; do
	_optionLibrariesAsArray+=(-I)
	_optionLibrariesAsArray+=(${x})
	if (test "${x}" != "${_pathSDK}/platforms/android-${_versionSDK}/android.jar"); then
		_optionLibrariesAsArrayForD8+=(${x})
	fi
	_optionLibrariesAsString+=":${x}"
done

# Path to Keystore
_pathKeystore="${HOME}/keystore.jks"

# Name of key
_nameKey="key1"


if (test "$1" = "build"); then
	# Initialize
	echo ":: Initialize"
	rm -rf classes.dex outlet proguard_options public_resources.xml sources-*.txt unfinished.apk finished.apk || exit 1
	for x in $(find . -name R.java); do
		rm -f $x
	done
	mkdir -p assets outlet || exit 1
	
	# Generate R.java
	echo ":: R.java"
	${_pathSDK}/build-tools/${_versionBuildToolchain}/aapt package --auto-add-overlay -m -J ${_pathSourceTree} -A assets -M AndroidManifest.xml -P public_resources.xml -G proguard_options --min-sdk-version ${_versionSDK} --target-sdk-version ${_versionSDK} --version-code ${_versionSDK} --version-name ${_versionAndroid} ${_optionResources[@]} ${_optionLibrariesAsArray[@]} || exit 1
	
	# Compile to JVM bytecode
	if (test -e "/usr/bin/kotlinc"); then
		echo ":: JVM bytecode from Kotlin sourcecode"
		find ${_pathSourceTree} -name '*.kt' >> sources-kotlin-unsorted.txt
		tr ' ' '\n' < sources-kotlin-unsorted.txt | sort -u > sources-kotlin.txt
		kotlinc -d outlet -classpath ${_optionLibrariesAsString:1} @sources-kotlin.txt || exit 1
	fi
	if (test -e "/usr/bin/javac"); then
		echo ":: JVM bytecode from Java sourcecode"
		find ${_pathSourceTree} -name '*.java' >> sources-java-unsorted.txt
		tr ' ' '\n' < sources-java-unsorted.txt | sort -u > sources-java.txt
		javac -d outlet -classpath ${_optionLibrariesAsString:1} -sourcepath ${_pathSourceTree} @sources-java.txt || exit 1
	fi
	
	# Compile to Dalvik bytecode
	echo ":: Dalvik bytecode"
	${_pathSDK}/build-tools/${_versionBuildToolchain}/d8 --release $(find outlet -name "*.class") ${_optionLibrariesAsArrayForD8[@]} || exit 1
	
	# Generate APK
	echo ":: APK"
	${_pathSDK}/build-tools/${_versionBuildToolchain}/aapt package -u --auto-add-overlay -M AndroidManifest.xml -A assets --min-sdk-version ${_versionSDK} --target-sdk-version ${_versionSDK} --version-code ${_versionSDK} --version-name ${_versionAndroid} ${_optionResources[@]} ${_optionLibrariesAsArray[@]} -F unfinished.apk || exit 1
	
	# Insert Dalvik bytecode into APK
	echo ":: Merge Dalvik bytecode into APK"
	zip -qj unfinished.apk classes.dex || exit 1
	
	# Sign APK
	echo ":: Sign APK"
	jarsigner -keystore ${_pathKeystore} unfinished.apk ${_nameKey} || exit 1
		
	# Realign APK
	echo ":: Realign APK"
	${_pathSDK}/build-tools/${_versionBuildToolchain}/zipalign -f 4 unfinished.apk finished.apk || exit 1
	
	echo "Done."
elif (test "$1" = "install"); then
	if (test "$2" = "forcerebuild"); then
		rm -f finished.apk || exit 1
	fi
	if (!(test -e "finished.apk")); then
		${0} build || exit 1
	fi
	
	adb install -r finished.apk
else
	echo
	echo "Usage:"
	echo "${0} build :: Build app"
	echo "${0} install :: Install app (Build first if it doesn't exist)"
	echo "${0} install forcerebuild :: Delete, rebuild and install app"
	echo
	
	exit 1
fi
