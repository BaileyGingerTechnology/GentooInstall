#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Find system info before starting everything

function check_root
{
    redEcho "Super user access is needed as disk partition modification and mounting will happen."

    if [ "$EUID" != 0 ]; then
      redEcho "$_MSGERROR No Super User access....now exiting..";
      exit 0;
    fi
}

function not_gentoo
{
    orangeEcho "Since you are not on Gentoo, some extra steps will need to be taken
    during portions of this install, but it should still all go fine."
}

function check_distro
{
    # This Variable will be output to a file.
    # Then later be used in determining package managers
    # And other distro dependent configs, services or commands.

    _ID=0
    _DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|gentoo|arch)' | uniq )

    if [ -z $_DISTRO ]; then
      _DISTRO='$_MSGERROR Distrobution Detection Failed!'
    fi

    echo -e "\n"

    if [ "$_DISTRO" = "debian" ]; then
      _ID=1
      _NAME=Debian
      apt-get -y install build-essential
      apt-get -y install python2.3 python2.3-dev
      apt-get -y install wget rsync bzip2 git
      not_gentoo
    fi


    if [ "$_DISTRO" = "ubuntu" ]; then
      _ID=2
      _NAME=Ubuntu
      apt-get -y install build-essential
      apt-get -y install python2.3 python2.3-dev
      apt-get -y install wget rsync bzip2 git
      not_gentoo
    fi


    if [ "$_DISTRO" = "red hat" ]; then
      _ID=3
      _NAME=RedHat
      yum -y install gcc gcc-c++ make openssl-devel wget rsync git
      not_gentoo
    fi


    if [ "$_DISTRO" = "centos" ]; then
      _ID=4
      _NAME=CentOS
      yum -y install gcc gcc-c++ make openssl-devel wget rsync git
      not_gentoo
    fi


    if [ "$_DISTRO" = "gentoo" ]; then
      _ID=5
      _NAME=Gentoo
      orangeEcho "Since you are on Gentoo, everything should go fine and be bit a faster during
      the install process."
    fi

    if [ "$_DISTRO" = "arch" ]; then
      _ID=6
      _NAME=Arch
      _BANNER=""
      pacman -S --noconfirm base-devel rsync git wget
      not_gentoo
    fi

    echo $_DISTRO > /tmp/_DISTRO
}