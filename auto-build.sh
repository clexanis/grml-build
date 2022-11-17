#!/bin/bash
set -e

# Check if this script is running as root
if [ "$EUID" -ne 0 ]; then printf "Please run as root\n" & exit 1; fi

## Variables
INPUT="$(pwd)/src/grml-live"	# Set grml-live input directory
OUTPUT="$(pwd)/grml/"	# Set grml-live working directory
LIVE_CONF=${INPUT}/etc/grml/grml-live.conf	# Set grml-live config file.
export INPUT OUTPUT LIVE_CONF	# Export variables to be usable by grml-live

## Dependencies
GRML_CONTROL_FILE=${INPUT}/debian/control # Set control file for solving dependencies
# Install dependencies
apt-get update && apt-get install -y debian-archive-keyring $(sed -n '/Package: grml-live/,/^$/{/^$/d; p}' "${GRML_CONTROL_FILE}" | awk '/Depends:/{flag=1; next}/misc:Depends/{flag=0;exit} flag' | sed -e 's/\s(.*)//g' -e 's/,//g')

## Main
# Check if cache exist
if [ -d "${OUTPUT}/grml_chroot" ] || [ -d "${OUTPUT}/grml_cd" ]; then GRML_UPDATE='-u'; else GRML_UPDATE=''; fi
# Run grml-live
"${INPUT}/grml-live" -C ./grml-live.conf -d 'date -u +"%Y-%m-%dT%H:%M:%SZ"' -F -i grml.iso ${GRML_UPDATE} -v $(date -u +"%Y-%m-%d") $@
