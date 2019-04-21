#!/bin/bash
# Get Arduino core for ESP32 chip

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

ESP32_VER=`cat config.json | jq '.espVersions.ESP32_VER' | cut -d "\"" -f 2`

# Git clone to a specific commit matching the version number
git clone -b $ESP32_VER --single-branch https://github.com/espressif/arduino-esp32 esp32-$ESP32_VER

cd esp32-$ESP32_VER && git submodule update --init --recursive
cd ..
if [ "$OSTYPE" == "cygwin" ]; then
	chmod +x esp32-$ESP32_VER/tools/get.exe
	chmod +x esp32-$ESP32_VER/tools/espota.exe
	chmod +x esp32-$ESP32_VER/tools/gen_esp32part.exe
	cd esp32-$ESP32_VER/tools && ./get.exe
else
	chmod +x esp32-$ESP32_VER/tools/get.py
	cd esp32-$ESP32_VER/tools && ./get.py
fi
