#!/bin/bash
#Copyright (c) 2015.  lin_jie_long@126.com, 2017-12-10,12:12:29,  All rights reserved.
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

if [ ! -e /usr/local/bin/mkimage ]; then
    echo "Error: /usr/local/bin/mkimage do not exist"
    echo "Suggestion: Please compile uboot source first or 'apt-get install u-boot-tools'"
    echo "Exit 0"
    exit 0
fi

export PATH=$PATH:/opt/FriendlyARM/toolschain/4.4.3/bin

cd /root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/linux/linux_mini2440
make mini2440_defconfig ARCH=arm
find . -newer .
make -j4 ARCH=arm CROSS_COMPILE=arm-linux- uImage
cd -

