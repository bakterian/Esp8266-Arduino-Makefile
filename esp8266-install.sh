#!/bin/bash

checkIfPrereqPresent ()
{
	command -v $1 >/dev/null 2>&1 || { echo "I require a binary called: $1 , but it's not installed.  Aborting."; exit 1; }
}

checkIfPrereqPresent jq
checkIfPrereqPresent wget
checkIfPrereqPresent unzip
checkIfPrereqPresent python
checkIfPrereqPresent sed
checkIfPrereqPresent make

ESP8266_VER=`cat config.json | jq '.espVersions.ESP8266_VER' | cut -d "\"" -f 2`
DOWNLOAD_CACHE=`cat config.json | jq '.paths.cacheFolder' | cut -d "\"" -f 2`

mkdir $DOWNLOAD_CACHE

# Get Arduino core for ESP8266 chip
wget --no-clobber https://github.com/esp8266/Arduino/releases/download/$ESP8266_VER/esp8266-$ESP8266_VER.zip -P $DOWNLOAD_CACHE
unzip -o $DOWNLOAD_CACHE/esp8266-$ESP8266_VER.zip
mkdir esp8266-$ESP8266_VER/package
wget --no-clobber http://arduino.esp8266.com/versions/$ESP8266_VER/package_esp8266com_index.json -O esp8266-$ESP8266_VER/package/package_esp8266com_index.template.json
cd esp8266-$ESP8266_VER/tools && ./get.py && cd ../..
if [ "$OSTYPE" == "cygwin" ] || [ "$OSTYPE" == "msys" ]; then
	chmod +x ./esp8266-$ESP8266_VER/tools/esptool/esptool.exe
	chmod +x ./esp8266-$ESP8266_VER/tools/mkspiffs/mkspiffs.exe
fi
#cleanup
rm -fr $DOWNLOAD_CACHE

