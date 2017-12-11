#!/bin/bash
#Copyright (c) 2015.  lin_jie_long@126.com, 2017-12-10,12:12:20,  All rights reserved.
#Author:   Vanquisher(lin_jie_long@126.com) 
#Email:    lin_jie_long@126.com
#

if [ ! -e "/opt/FriendlyARM/toolschain/4.4.3/bin" ]; then 
    if [ ! -e "/root/Desktop/qemu_for_uboot_linux/virtualization/qemu@mini2440/arm-linux-gcc-4.4.3-20100728.tar.gz" ]; then
        echo "Error: \"/root/Desktop/qemu_for_uboot_linux/virtualization/qemu@mini2440/arm-linux-gcc-4.4.3-20100728.tar.gz\" do not exist"
        echo "Exit 0"
        exit 0
    fi
    tar -zvxf /root/Desktop/qemu_for_uboot_linux/virtualization/qemu@mini2440/arm-linux-gcc-4.4.3-20100728.tar.gz -C /
    if [ ! -e "/opt/FriendlyARM/toolschain/4.4.3/bin" ]; then 
        echo "Error: Can not install toolschain for arm linux"
        echo "Exit 0"
        exit 0
    fi
fi

export PATH=$PATH:/opt/FriendlyARM/toolschain/4.4.3/bin

cd /root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/uboot/uboot_mini2440
make mini2440_config
find . -newer .
make -j4 ARCH=arm CROSS_COMPILE=arm-linux- 
cp -rvf /root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/uboot/uboot_mini2440/tools/mkimage  /usr/local/bin/
chmod +x /usr/local/bin/mkimage
cd -

