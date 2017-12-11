#!/bin/bash
#Copyright (c) 2015.  lin_jie_long@126.com, 2017-12-10,12:12:29,  All rights reserved.
#Author:   Vanquisher(lin_jie_long@126.com)
#Email:    lin_jie_long@126.com                                            
#

Our_Path=`pwd`

if [ ! -e "$Our_Path/qemu_mini2440/mini2440/mini2440/mini2440_start_v1.sh" ]; then
    echo "[jielong.lin] Sorry, invalid path"
    exit 0
fi

Our_Nand="$Our_Path/mini2440_nand128.bin"
Our_Nand_qemu="$Our_Path/qemu_mini2440/mini2440/mini2440"
if [ -e "$Our_Nand" ]; then
    read -p "[jielong.lin] Copy \"$Our_Nand\" to \"$Our_Nand_qemu\" if <y> ?   "  Our_YesNo
    if [ "$Our_YesNo" = "y" ]; then 
        cp -rvf $Our_Nand  $Our_Nand_qemu
    fi
fi


Our_uboot="$Our_Path/uboot/uboot_mini2440/u-boot.bin"
Our_uboot_qemu="$Our_Path/u-boot.bin"
if [ ! -e "$Our_uboot" ]; then
    echo "[jielong.lin] Error: Not exist \"$Our_uboot\""
    echo "[jielong.lin] Continue to run if <y>"
    read My_IsContinue
    if [ "$My_IsContinue" = "y" ]; then
        echo "[jielong.lin] Continue to run without \"$Our_uboot_qemu\"" 
    else
        exit 0
    fi 
else
    cp -rvf  $Our_uboot  $Our_uboot_qemu 
    if [ ! -e "$Our_uboot_qemu" ]; then
        echo "[jielong.lin] Error: Not exist \"$Our_uboot_qemu\""
        exit 0 
    fi
fi

Our_uImage="$Our_Path/linux/linux_mini2440/arch/arm/boot/uImage" 
Our_uImage_qemu="$Our_Path/uImage"
if [ ! -e "$Our_uImage" ]; then
    echo "[jielong.lin] Error: Not exist \"$Our_uImage\""
    rm -rvf $Our_uboot_qemu
    exit 0 
fi
cp -rvf  $Our_uImage  $Our_uImage_qemu 
if [ ! -e "$Our_uImage_qemu" ]; then
    echo "[jielong.lin] Error: Not exist \"$Our_uImage_qemu\""
fi

Our_qemu_envsetup="$Our_Path/qemu_mini2440/envsetup.sh" 
if [ ! -e "$Our_qemu_envsetup" ]; then
    echo "[jielong.lin] Error: Not exist \"$Our_qemu_envsetup\""
    rm -rvf $Our_uImage_qemu
    rm -rvf $Our_uboot_qemu
    exit 0 
fi


Our_IsExist=`ifconfig tap0`
if [ -z "$Our_IsExist" ]; then
    tunctl -u $USER -t tap0
    ifconfig tap0 10.0.0.4
    ifconfig tap0
fi
Our_IsExist=`ifconfig tap0`
if [ -z "$Our_IsExist" ]; then
    echo "[jielong.lin] Error: No tap0 device"
    rm -rvf $Our_uImage_qemu
    rm -rvf $Our_uboot_qemu
    exit 0
fi 

source  $Our_qemu_envsetup
if [ -e "$Our_Path/qemu_mini2440/mini2440/mini2440/" ]; then
    echo "[jielong.lin] Remove all bin files in \"$Our_Path/qemu_mini2440/mini2440/mini2440/\" if <y> ?    "
    read Our_Select
    if [ "$Our_Select" = "y" ]; then
        rm -rvf $Our_Path/qemu_mini2440/mini2440/mini2440/*.bin
    fi
fi


if [ -e "$Our_uImage_qemu" ]; then
    $Our_Path/qemu_mini2440/mini2440/mini2440/mini2440_start_v1.sh  -kernel $Our_uImage_qemu 
    rm -rvf $Our_uImage_qemu
    rm -rvf $Our_uboot_qemu
    exit 0
fi


$Our_Path/qemu_mini2440/mini2440/mini2440/mini2440_start_v1.sh  $*
rm -rvf $Our_uboot_qemu
 
