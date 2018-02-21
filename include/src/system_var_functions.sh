#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/19/2018
# Purpose : Set system variables such as timezone

function set_locales {
    greenEcho "Eventually, I hope to make this part more automated, but for now I am going to open the file
    and you will have to uncomment the languages that you want. Remove the '#'s next to the ones you want."
    greenEcho "You can use ctrl+w to search the file for the ones you want."
    orangeEcho "Press enter to continue"
    read enter

    nano -w /etc/locale.gen
    locale-gen

    greenEcho "Here is the list of the ones you picked. Which one should be the default? (Enter it's number)"
    eselect locale list
    read localePicked
    eselect locale set $localePicked
    env-update && source /etc/profile && export PS1="(chroot) $PS1"
}

function set_timezone {
    greenEcho "Now setting time zone."

    timezones=( $(for i in $(ls -d /usr/share/timezone/*/ |cut -c21-); do echo ${i%%/}; done) )
    generateDialog "options" "Which region should options be printed for?" "${timezones[@]}"
    read timezonePicked


    timezones=( $(find /usr/share/zoneinfo/${timezones[timezonePicked-1]} |cut -c21-) )
    generateDialog "options" "Which timezone do you want to use?" "${timezones[@]}"
    read timezonePicked

    greenEcho "Sending info into timezone file and updating"
    echo "${timezones[timezonePicked-1]}" > /etc/timezone
    emerge --config sys-libs/timezone-data

    set_locales
}

function set_hostname {
    orangeEcho "What do you want your hostname to be?"
    read userHostname

    echo $userHostname > /etc/conf.d/hostname
}

function install_grub {
    emerge --verbose sys-boot/grub:2
    grub-install $1
    grub-mkconfig -o /boot/grub/grub.cfg
}
