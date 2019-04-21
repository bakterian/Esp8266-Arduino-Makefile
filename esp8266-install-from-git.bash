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

# Git clone to a specific commit matching the version number
git clone -b $ESP8266_VER --single-branch https://github.com/esp8266/Arduino.git esp8266-$ESP8266_VER

cd esp8266-$ESP8266_VER/tools && ./get.py && cd ../..
if [ "$OSTYPE" == "cygwin" ]; then
	chmod +x ./esp8266-git/tools/esptool/esptool.exe
	chmod +x ./esp8266-git/tools/mkspiffs/mkspiffs.exe
fi


