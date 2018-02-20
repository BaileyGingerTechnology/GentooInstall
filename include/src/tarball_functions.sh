#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/25/2017
# Purpose : Functiona used to get the stage3 tarball

function emerge_update {
	emerge-webrsync
	emerge --sync
}

function resolv_mount {
	echo "Copying over resolv.conf"
	cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
	echo "Copying over the fstab file made earlier"
	cp /tmp/fstab /mnt/gentoo/etc/

	echo "Mount filesystem and chrooting."
	mount --types proc /proc /mnt/gentoo/proc
	mount --rbind /sys /mnt/gentoo/sys
	mount --make-rslave /mnt/gentoo/sys
	mount --rbind /dev /mnt/gentoo/dev
	mount --make-rslave /mnt/gentoo/dev

	if [ "$_DISTRO" != "gentoo" ]; then
		test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
		mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
		chmod 1777 /dev/shm
	fi

	chroot /mnt/gentoo /bin/bash
	source /etc/profile
	export PS1="(chroot) ${PS1}"

	echo "Mounting boot partition."
	mkdir /boot
	mount /dev/$_CONFIGUREDDISK2 /boot

	emerge_update
}

function make_make {
	core_count=$(lscpu |grep CPU |(sed -n 2p) |awk '{print $2}')

	if [[ $_DISTRO -eq "gentoo" ]]; then 
    	greenEcho "Pick the mirror closest to you."
		echo  "Press enter to continue."
		read enter
    	mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
	else
    	echo "Since you are not using Gentoo, mirrorselect will not work. Setting mirror to "
    	#mount ${disks[$choice-1]}4 /mnt/gentoo
	fi
	echo $core_count+1 >> /mnt/gentoo/etc/portage/make.conf

	echo "Portage configured. Preparing for chroot."
	resolv_mount
}

function download_tarball {
	cd /mnt/gentoo

	greenEcho "This is where we get the tarball that will be used to make the base filesystem. Eventually I may be able to automate this part, but for now I am going to open links to Gentoo's mirror page.
	Pick a server close to you, and then the stage 3 .tar.bz2 that best matches your system."
	echo  "Press enter to continue."
	read enter

	links https://www.gentoo.org/downloads/mirrors/

	echo "Unpacking the tarball."
	tar xvjpf stage3-*.tar.bz2 --xattrs --numeric-owner

	echo "Tarball unpacked. Configuring make.conf for Portage."
	make_make
}