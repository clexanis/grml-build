#!/bin/bash
set -e

# Check if this script is running as root
if [ "$EUID" -ne 0 ]; then printf "Please run as root\n" & exit 1; fi

## Variables
ISO_DATE_LONG="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
ISO_DATE="$(date -u +"%Y-%m-%d")"
INPUT="$(pwd)/src/grml-live"	# Set grml-live input directory
OUTPUT="$(pwd)/grml/"	# Set grml-live working directory
LIVE_CONF=${INPUT}/etc/grml/grml-live.conf	# Set grml-live config file.
export INPUT OUTPUT LIVE_CONF	# Export variables to be usable by grml-live
# export variable to env file
printf "ISO_DATE_LONG=${ISO_DATE_LONG}\nISO_DATE=${ISO_DATE}\nOUTPUT=${OUTPUT}" >> .env

## Dependencies
GRML_CONTROL_FILE=${INPUT}/debian/control # Set control file for solving dependencies
# Install dependencies
apt-get update && apt-get install -y debian-archive-keyring $(sed -n '/Package: grml-live/,/^$/{/^$/d; p}' "${GRML_CONTROL_FILE}" | awk '/Depends:/{flag=1; next}/misc:Depends/{flag=0;exit} flag' | sed -e 's/\s(.*)//g' -e 's/,//g')

## Prepare build
## Fast mode
if [[ $@ == *--fast* ]]; then
	# Modify compression algorithm to use lz4 for faster build
	sed -i -e 's/\-comp\ xz/\-comp\ lz4/' -e 's/\-Xdict\-size\ 1M\ //' ./grml-live.conf
	GRML_ARGS="$(echo "${@/\-\-fast/}")"; fi # Remove from passed arguments

## Build
# Run grml-live
"${INPUT}/grml-live" -C ./grml-live.conf -d "${ISO_DATE_LONG}" -F -i grml.iso ${GRML_UPDATE} -v "${ISO_DATE}" ${GRML_ARGS}

## Post build
mv "${OUTPUT}/grml_isos/grml.iso" "${OUTPUT}/grml_isos/grml-full-bullseye-${ISO_DATE}.iso"
sha256sum "${OUTPUT}/grml_isos/grml-full-bullseye-${ISO_DATE}.iso" > "${OUTPUT}/grml_isos/grml-full-bullseye-${ISO_DATE}.iso.sha256"
