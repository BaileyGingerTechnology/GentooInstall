#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/19/2018
# Purpose : Download and install the kernel

function download_install_kernel {
    emerge sys-kernel/gentoo-sources

    greenEcho "So, in the spirit of making life easy, I'm going to use the genkernel method of compiling the kernel. If you wish to use menuconfig and do it yourself,
    cancel the script with ctrl+c, redo the chroot, and pick up from the 'Configuring the Linux kernel' portion of the Gentoo Handbook. If you want to use genkernel,
    press enter to continue."
    read enter

    emerge --ask sys-apps/pciutils sys-kernel/genkernel

    genkernel all

    echo "Do you want to install the linux-firmware package? It is usually needed for network interfaces and such."
    select ynd in "Yes" "No"; do
        case $ynd in
            Yes ) emerge sys-kernel/linux-firmware; break;;
            No ) echo "Okay, moving on."; break;;
        esac
    done
}