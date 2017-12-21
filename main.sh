#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Main file of a suite of Gentoo install and config scripts

source ./include/src/preflight.sh
source ./include/src/disk_functions.sh
source ./include/src/menu.sh

echo "
    
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
                                       

    Beta Version: 0.0.1
    Email: baileykasin@gmail.com
    For Latest Version Visit https://github.com/BaileyGingerTechnology/GentooInstall

    Copyright (C) 2017 Bailey Kasin || Ginger Technology

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

";

check_root
check_distro

echo "Preflight done, should be good to go!"
echo "First step is disk setup."
declare -a disks="$(ls /dev/*d[a-z])"

generateDialog "options" "Which disk should be used" "${disks[@]}"
read choice

parted -a optimal ${disks[$choice-1]} print
echo "Using disk ${disks[$choice-1]}. This next step will wipe that disk, is that okay?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) partition_disk ${disks[$choice-1]}; break;;
        No ) echo "The install is incomplete and rebooting will either take you to the existing OS, or restart the process."; exit;;
    esac
done

if [[ $_DISTRO -eq "gentoo" ]]; then 
    mount ${disks[$choice-1]}4 /mnt/gentoo
else
    mkdir /mnt/gentoo
    mount ${disks[$choice-1]}4 /mnt/gentoo
fi