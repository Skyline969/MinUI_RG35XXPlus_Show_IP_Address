#!/bin/bash
DIR="$(dirname "$0")"
cd "$DIR"
rm -f ./ip.png
sync

# Ensure wifi is connected, show an error and exit if not
if [ `cat /sys/class/net/wlan0/operstate` != "up" ]; then
	show.elf "$DIR/wifi.png" 8
	exit 0
fi

GMAGICK=$(which gm)
if [[ $? != 0 ]]; then
	show.elf "$DIR/gmagick.png" 900 &
	apt -y update && apt -y install graphicsmagick
	sync
	killall show.elf
fi

# Get the IP and generate the image
ADDRESS="$(hostname -I | awk '{print $1}')"
gm convert -size 640x480 xc:black -fill white -pointsize 48 -gravity Center -font /mnt/sdcard/.system/res/BPreplayBold-unhinted.otf -draw "text 0,0 'IP Address:\n$ADDRESS'" ./ip.png
sync

if [ -f "$DIR/ip.png" ]; then
	show.elf "$DIR/ip.png" 8
else
	show.elf "$DIR/ipfail.png" 8
fi
