#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/21/2018
# Purpose : Step two of the Gentoo install

source ./include/src/preflight.sh
source ./include/src/disk_functions.sh
source ./include/src/menu.sh
source ./include/src/tarball_functions.sh
source ./include/src/useful_functions.sh
source ./include/src/profile_functions.sh
source ./include/src/kernel_functions.sh

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

check_root
check_distro

echo "Preflight done, should be good to go!"

# Move the GentooInstall director into the chroot zone
cd ../
mv GentooInstall /mnt/gentoo/GentooInstall

greenEcho "Step two done. Now go back to the original terminal and run step_three.sh."