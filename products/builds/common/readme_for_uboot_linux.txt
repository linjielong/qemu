
-----------------------------------------------------------------------
 create nand flash image file for qemu 
-----------------------------------------------------------------------
Create the empty Nand Flash Image with 128MB by Linux Shell Command dd
# dd if=/dev/zero of="mini2440_nand128.bin" bs=2112 count=65536
start u-boot.bin : cleanup all bad blocks, create all bad block tags, set environment location, 
                   save rootfs environment loaded from nfs and so on.
But it is done so slowly, hence suggest do the follows step for generating mini2440_nand128.bin:
Linux # ./run_armlinux_onMini2440.sh
Please type <y> for creating the empty nand flash image with 128MB.
Then initialize mini2440_nand128.bin by use u-boot commands:
<1>.earse all nandflash space and create the bad block tags
MINI2440 # nand scrub
MINI2440 # nand createbbt
MINI2440 # reset

<2>.set environment location: offset=0x40000
MINI2440 # dynenv set 40000
MINI2440 # saveenv

<3>.set nfs for mounting rootfs
MINI2440 # setenv ifconfig ip=${ipaddr}:${serverip}::${netmask}:mini2440:eth0
MINI2440 # setenv root_nfs /mnt/nfs/rootfs_qtopia_qt4
MINI2440 # run set_bootargs_nfs 
MINI2440 # saveenv

<4>.exit the u-boot context and then backup mini2440_nand.bin finally from "qemu_mini2440/mini2440/mini2440/" path.

<5>.when enter u-boot context, you can boot linux kernel directly.
MINI2440 # bootm
 

