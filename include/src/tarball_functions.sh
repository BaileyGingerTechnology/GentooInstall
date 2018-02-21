#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/25/2017
# Purpose : Functiona used to get the stage3 tarball

function emerge_update {
	echo "Mounting boot partition."
	mkdir /boot
	mount /dev/sda2 /boot

	emerge-webrsync
	emerge --sync |tee emergeOutput.txt

	portageUpdate=$(cat emergeOutput.txt |grep "--oneshot portage")

	if [[ $portageUpdate = *"oneshot"* ]]; then
		emerge --oneshot portage
	fi
}

function resolv_mount {
	mkdir --parents /mnt/gentoo/etc/portage/repos.conf
	cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
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

	greenEcho "About to chroot. This will cause the script to exit. After it does, open a new terminal and run step_two.sh with sudo privileges. DO NOT CLOSE THIS TERMINAL."
	read enter
	chroot /mnt/gentoo /bin/bash
	source /etc/profile
	export PS1="(chroot) ${PS1}"
}

function make_make {
	core_count=$(lscpu |grep CPU |(sed -n 2p) |awk '{print $2}')
	let core_count+=1

	if [[ $_DISTRO -eq "gentoo" ]]; then 
    	greenEcho "Pick the mirror closest to you."
		echo  "Press enter to continue."
		read enter
    	mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
	else
    	echo "Since you are not using Gentoo, mirrorselect will not work. Setting mirror to "
    	#mount ${disks[$choice-1]}4 /mnt/gentoo
	fi

	if [[ $core_count = *"+"* ]]; then
		echo "MAKEOPTS=-j2" >> /mnt/gentoo/etc/portage/make.conf
	else
		echo "MAKEOPTS=-j$core_count" >> /mnt/gentoo/etc/portage/make.conf
	fi

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
	tar xvpf stage3-*.tar.xz --xattrs --numeric-owner

	echo "Tarball unpacked. Configuring make.conf for Portage."
	make_make
}