#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Main file of a suite of Gentoo install and config scripts

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
                                       

    Version: 1.0
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

rsync -ah --progress include/src/install_mirrorselect.sh /tmp/install_mirrorselect.sh
source ./include/src/preflight.sh

# Check for root privileges
check_root
# Check whether on Gentoo or other OS
check_distro

echo "Preflight done, should be good to go!"
echo "First step is disk setup."
# Make array of possible disks that can be mounted
disks=( $(ls /dev/sd[a-z] | sort -u -) )

greenEcho "For a different disk, select one and then select 'Different' later."
# Generate a menu of the disks for the user to chose from
generateDialog "options" "Which disk should be used?" "${disks[@]}"
read choice

# Print the current partitions of the chosen disk
parted -a optimal ${disks[$choice-1]} print
echo "Using disk ${disks[$choice-1]}. This next step will wipe that disk, is that okay?"
# If the user says yes, continue. No, die. Different, let them type in the name of a disk
select ynd in "Yes" "No" "Different"; do
    case $ynd in
        Yes ) partition_disk ${disks[$choice-1]}; break;;
        No ) echo "The install is incomplete and rebooting will either take you to the existing OS, or restart the process."; exit;;
        Different ) different_disk; break;;
    esac
done

# Get the disk to mount from the file it was saved in and then append 4 to it
_CONFIGUREDDISK=$( cat /tmp/diskUsed.txt )
_CONFIGUREDDISK="${_CONFIGUREDDISK}4"

# Mount that disk to be used as the actual install location
mount $_CONFIGUREDDISK /mnt/gentoo

# Move the diskUsed file over
mkdir /mnt/gentoo/tmp
rsync -ah --progress /tmp/diskUsed.txt /mnt/gentoo/tmp

# Set time
ntpd -q -g

# Move into the tarball_functions script and continue there
download_tarball