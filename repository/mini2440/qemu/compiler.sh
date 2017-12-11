#!/bin/bash
#Copyright (c) 2017.  jielong.lin@qq.com, 2017-12-10,12:12:18,  All rights reserved.
#Author:   JLLim (jielong.ling@qq.com) 
#Email:    jielong.lin@qq.com
#

_out_="$(pwd)/"



if [ ! -e /root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/qemu_mini2440/qemu ]; then 
    mkdir -pv /root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/qemu_mini2440/qemu
fi
 
cd /root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/qemu_mini2440/mini2440
./configure --target-list=arm-softmmu --prefix=/root/Desktop/qemu_for_uboot_linux/run_qemu_for_mini2440/qemu_mini2440/qemu
make
make install
cd -

