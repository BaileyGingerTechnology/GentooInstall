#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/21/2018
# Purpose : Configure networking

function configure_network {
    emerge --noreplace net-misc/netifrc

    interfaces=( $(ls /sys/class/net |grep -v lo |sort -u -) ) 

    generateDialog "options" "Which is the primary interface you want to use?" "${interfaces[@]}"
    read choice

    echo 'config_${interfaces[$choice-1]}="dhcp"'

    cd /etc/init.d
    ln -s net.lo net.${interfaces[$choice-1]}
    rc-update add net.${interfaces[$choice-1]} default
}