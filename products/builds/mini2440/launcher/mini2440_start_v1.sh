#!/bin/bash
#
# Run with script with 
# -sd <SD card image file> to have a SD card loaded
# -kernel <kernel uImage file> to have a kernel preloaded in RAM
#

base=$(dirname $0)

echo Starting in $base

name_nand="$base/mini2440_nand128.bin"

if [ ! -f "$name_nand" ]; then
    echo $0 : creating NAND empty image : "$name_nand"
#   dd if=/dev/zero of="$name_nand" bs=528 count=131072
    dd if=/dev/zero of="$name_nand" bs=2112 count=65536
    echo "** NAND file created - make sure to 'nand scrub' in u-boot"
fi

Parameter:  $*

cat >&1 << vEOF


------- Start with Comment by jielong.lin --------

If use SD device, Please do the follows:
(1).
# fdisk -l
...
/dev/sdb1 ...
/dev/sdb2 ...
/dev/sdb3 ...

# dd if=/dev/sdb of=mini2440_sd.img 

(2).
"-sd $base/mini2440_sd.img \" is appended to cmd

(3).
MINI2440 # mmcinit
trying to detect SD card ...
...
MINI2440 # fatls mmc 0:1
...
MINI2440 # setenv bootcmd 'mmcinit ; fatload mmc 0:1 0x31000000 uImage ; bootm 0x31000000'
MINI2440 # setenv bootargs 'noinitrd rootdelay=3 root=/dev/mmcblkOp2 console=ttySAC0,115200 rootwait'
MINI2440 # saveenv
MINI2440 # reset






For u-boot about how to use:

earse all nandflash space and create the bad block tags
MINI2440 # nand scrub
MINI2440 # nand createbbt
MINI2440 # reset

set environment location: offset=0x40000
MINI2440 # dynenv set 40000
MINI2440 # saveenv

set nfs for mounting rootfs
MINI2440 # setenv ifconfig ip=\${ipaddr}:\${serverip}::\${netmask}:mini2440:eth0
MINI2440 # setenv root_nfs /mnt/nfs/rootfs_qtopia_qt4
MINI2440 # run set_bootargs_nfs 
MINI2440 # saveenv

boot linux
MINI2440 # bootm

------- End with Comment by jielong.lin --------

vEOF

echo "[jielong.lin] No Graphic if <y>"
read My_IsNoGraphic
if [ "$My_IsNoGraphic" = "y" ]; then

cmd="$base/../arm-softmmu/qemu-system-arm \
    -M mini2440 $* \
    -serial stdio \
    -mtdblock "$name_nand" \
    -nographic   \
    -show-cursor \
    -usb -usbdevice keyboard -usbdevice mouse \
    -net nic,vlan=0 \
    -net tap,vlan=0,ifname=tap0,script=no,downscript=no \
    -monitor telnet::5555,server,nowait"

else

#   -kernel /tftpboot/uImage
cmd="$base/../arm-softmmu/qemu-system-arm \
    -M mini2440 $* \
    -serial stdio \
    -mtdblock "$name_nand" \
    -show-cursor \
    -usb -usbdevice keyboard -usbdevice mouse \
    -net nic,vlan=0 \
    -net tap,vlan=0,ifname=tap0,script=no,downscript=no \
    -monitor telnet::5555,server,nowait"

fi

echo $cmd
$cmd

