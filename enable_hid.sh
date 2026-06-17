#!/bin/bash
# this is a stripped down version of https://github.com/ckuethe/usbarmory/wiki/USB-Gadgets - I don't claim any rights

modprobe libcomposite


cd /sys/kernel/config/usb_gadget/
mkdir -p g1
cd g1
echo 0x054D > idVendor # Sony Interactive Entertainment
echo 0x0ce7 > idProduct # Touch Screen Controller
echo 0x0101 > bcdDevice # v1.0.1
echo 0x0200 > bcdUSB # USB2.0

echo 0x00 > bDeviceClass
echo 0x00 > bDeviceSubClass
echo 0x00 > bDeviceProtocol

mkdir -p strings/0x409
echo "fedcba9876543211" > strings/0x409/serialnumber
echo "Sony Interactive Entertainment" > strings/0x409/manufacturer
echo "DualSense Wireless Controller" > strings/0x409/product

mkdir -p configs/c.1

mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 12 > functions/hid.usb0/report_length
# 真实大小
# echo -ne \\x05\\x0D\\x09\\x04\\xA1\\x01\\x85\\x01\\x09\\x22\\xA1\\x02\\x09\\x42\\x15\\x00\\x25\\x10\\x75\\x01\\x95\\x01\\x81\\x02\\x95\\x07\\x81\\x03\\x09\\x51\\x75\\x08\\x95\\x01\\x81\\x02\\x05\\x01\\x09\\x30\\x15\\x00\\x27\\x00\\xA0\\x05\\x00\\x75\\x20\\x95\\x01\\x81\\x02\\x09\\x31\\x15\\x00\\x27\\x00\\x80\\x0C\\x00\\x75\\x20\\x95\\x01\\x81\\x02\\xC0\\x05\\x0D\\x09\\x54\\x25\\x02\\x75\\x08\\x95\\x01\\x81\\x02\\xC0 > functions/hid.usb0/report_desc
# 最大值
echo -ne \\x05\\x0D\\x09\\x04\\xA1\\x01\\x85\\x01\\x09\\x22\\xA1\\x02\\x09\\x42\\x15\\x00\\x25\\x10\\x75\\x01\\x95\\x01\\x81\\x02\\x95\\x07\\x81\\x03\\x09\\x51\\x75\\x08\\x95\\x01\\x81\\x02\\x05\\x01\\x09\\x30\\x15\\x00\\x27\\xfe\\xff\\xff\\x7f\\x75\\x20\\x95\\x01\\x81\\x02\\x09\\x31\\x15\\x00\\x27\\xfe\\xff\\xff\\x7f\\x75\\x20\\x95\\x01\\x81\\x02\\xC0\\x05\\x0D\\x09\\x54\\x25\\x02\\x75\\x08\\x95\\x01\\x81\\x02\\xC0 > functions/hid.usb0/report_desc
ln -s functions/hid.usb0 configs/c.1/

# OS descriptors
echo 1       > os_desc/use
echo 0xcd    > os_desc/b_vendor_code
echo MSFT100 > os_desc/qw_sign
ln -s configs/c.1 os_desc

mkdir -p configs/c.1/strings/0x409
echo "Touch Screen" > configs/c.1/strings/0x409/configuration
echo 50 > configs/c.1/MaxPower
ls /sys/class/udc > UDC
