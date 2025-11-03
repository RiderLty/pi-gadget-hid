#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi
cat config.txt > /boot/firmware/config.txt
cat modules > /etc/modules
cp enable_hid.service /lib/systemd/system/
cp enable_hid.sh /usr/bin/
chmod +x /usr/bin/enable_hid.sh
systemctl enable enable_hid.service