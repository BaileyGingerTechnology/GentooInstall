#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/21/2017
# Purpose : Main file of a suite of Gentoo install and config scripts

cd /GentooInstall/

source ./include/src/preflight.sh
source ./include/src/disk_functions.sh
source ./include/src/menu.sh
source ./include/src/tarball_functions.sh
source ./include/src/useful_functions.sh
source ./include/src/profile_functions.sh
source ./include/src/kernel_functions.sh
source ./include/src/system_var_functions.sh

echo "$(tput setaf 3)
    
 _____            _                    
|  __ \          | |                   
| |  \/ ___ _ __ | |_ ___   ___        
| | __ / _ \ '_ \| __/ _ \ / _ \       
| |_\ \  __/ | | | || (_) | (_) |      
 \____/\___|_| |_|\__\___/ \___/       
                                       
                                       
 _____          _        _ _           
|_   _|        | |      | | |          
  | | _ __  ___| |_ __ _| | | ___ _ __ 
  | || '_ \/ __| __/ _\` | | |/ _ \ '__|
 _| || | | \__ \ || (_| | | |  __/ |   
 \___/_| |_|___/\__\__,_|_|_|\___|_|   
                                       

    Version: 1.1
    Email: baileykasin@gmail.com
    For Latest Version Visit https://github.com/BaileyGingerTechnology/GentooInstall

    Copyright (C) 2017-2018 Bailey Kasin || Ginger Technology

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.

$(tput sgr0)";

# Check for root privileges
check_root

echo "Preflight done, should be good to go!"
# Go into the tarball_functions directory and sync/update emerge
emerge_update
# Select the profile
pick_profile
# Download the kernel sources
download_install_kernel
# Go into system_var_functions and configure stuff there
set_hostname
# Configure network interface
configure_network

echo "Now setting password for root user!"
passwd

# Installing system tools
# Logger
emerge app-admin/sysklogd
rc-update add sysklogd default

# Cron manager
emerge sys-process/cronie
rc-update add cronie default

# Indexing system
emerge sys-apps/mlocate

# Set SSH server to start at boot if needed
echo "Do you need SSH access to this computer?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) rc-update add sshd default; break;;
        No ) break;;
    esac
done

# Install DHCP client
emerge net-misc/dhcpcd
# Install wireless tools
emerge net-wireless/iw net-wireless/wpa_supplicant

greenEcho "Installing grub"
# Set value from file to variable again
_CONFIGUREDDISK=$(cat /tmp/diskUsed.txt)
# Install GRUB on that disk
install_grub $_CONFIGUREDDISK

greenEcho "We should be done."

greenEcho "Going to reboot now. Good luck, soldier."
greenEcho "I suggest making a new user after the reboot. Refer to the Finalizing page of the Gentoo handbook for details on that."
orangeEcho "Press enter to reboot"
read enter
reboot