#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/21/2018
# Purpose : Configure networking

function configure_network
{
    # Install netifrc
    emerge --noreplace net-misc/netifrc

    # Make array of network interfaces
    interfaces=( $(ls /sys/class/net |grep -v lo |sort -u -) ) 

    # Have user select one from the array to start by default
    generateDialog "options" "Which is the primary interface you want to use?" "${interfaces[@]}"
    read choice

    # Send the selected one to a file
    echo 'config_${interfaces[$choice-1]}="dhcp"'

    # Set that interface to start at boot
    cd /etc/init.d
    ln -s net.lo net.${interfaces[$choice-1]}
    rc-update add net.${interfaces[$choice-1]} default
}