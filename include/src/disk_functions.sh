#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Function used for disk setup

function set_filesystems {

	mkfs.vfat -F 32 $12
	mkfs.ext4 $14
	mkswap $13
	swapon $13

	echo "Filesystems set. Mounting partition where system will be built."
}

function partition_disk {

	echo "Using parted to label disk GPT."
	parted -a optimal $1 mklabel gpt
	parted -a optimal $1 unit mib
	echo "Setting partition format as recommended in Gentoo Handbook."
	parted -a optimal $1 mkpart primary 1 3
	parted -a optimal $1 name 1 grub
	parted -a optimal $1 set 1 bios_grub on
	parted -a optimal $1 mkpart primary 3 131
	parted -a optimal $1 name 2 boot
	parted -a optimal $1 mkpart primary 131 643
	parted -a optimal $1 name 3 swap
	parted -a optimal $1 mkpart primary 643 -- -1
	parted -a optimal $1 name 4 rootfs
	parted -a optimal $1 set 2 boot on
	parted -a optimal $1 print

	echo "Formatting disks complete. Now setting file system types."
	set_filesystems $1
}

