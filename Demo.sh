#!/bin/bash


# COLOR VARIABLES :
# ~~~~~~~~~~~~~~~~~ 
BYELLOW='\e[93m'                         # BOLD YELLOW    
BGREEN='\e[92m'                          # BOLD GREEN    
BBLUE='\e[34m'                           # BOLD BLUE      
BRED='\e[91m'                            # BOLD RED   
RESET='\e[0m'                            # RESET       
BOLD='\e[1m'                             # BOLD
       
# PRETTY PRINT FUNCTIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print () {
    echo -e "${BOLD}${BYELLOW}[ ${BGREEN}•${BYELLOW} ] $1${RESET}"
}

Done_Print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
}

Issue_Print () {
    echo -e "${BOLD}${BRED}[ ${BBLUE}•${BRED} ] $1${RESET}"
}

# MICROCODE DETECT FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Microcode_Detector () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        MICROCODE="amd-ucode"
    else
        MICROCODE="intel-ucode"
    fi
}

# ----------------- #
# --- VARIABLES --- #
# ----------------- #

# SET SOME VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
USER_NAME="Bibhuti"                      # SET USER NAME
FULL_NAME="Bibhuti Bhushan"              # SET FULL NAME
USER_PASSWORD="\\"                       # SET USER PASSWORD
ROOT_PASSWORD="\\"                       # SET ROOT PASSWORD
HOSTNAME="iTunes"                        # SET THE HOST NAME
TIMEZONE="Asia/Kolkata"                  # SET TIME-ZONE
LOCALE="en_US.UTF-8"                     # SET LOCALE
KEYBOARD="us"                            # SET KEYBOARD 

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/sda                            # SET DISK FOR INSTALL

# SET SIZE OF DRIVE :
# ~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550MiB                         # SET BOOT PARTITION SIZE
SWAP_SIZE=8GiB                           # SET SWAP PARTITION SIZE
ROOT_SIZE=35GiB                          # SET ROOT PARTITION SIZE
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET PACKAGES :
# ~~~~~~~~~~~~~~
KERNEL="linux-lts"                       # SET KERNEL
EXTRA="git neovim"                       # EXTRA PACKAGES LIKE EDITOR...
MICROCODE="intel-ucode"


# SET LOG FILE :
# ~~~~~~~~~~~~~~
LOGFILE="Installer.log"

# ------------------------------- #
# --- SCRIPT START FROM HERE ---  #
# ------------------------------- #
# touch ~/Desktop/arch.conf
# echo "title   Boot Manager" > ~/Desktop/arch.conf
# echo "linux   /vmlinuz-$KERNEL" >> ~/Desktop/arch.conf
# echo "initrd  /$MICROCODE.img" >> ~/Desktop/arch.conf
# echo "initrd  /initramfs-$KERNEL.img" >> ~/Desktop/arch.conf
# echo "options root=${DISK}3 rw" >> ~/Desktop/arch.conf


cat <<EOF > ~/Desktop/arch.conf
title   Boot Manager
linux   /vmlinuz-$KERNEL
initrd  /$MICROCODE.img
initrd  /initramfs-$KERNEL.img
options root=${DISK}3 rw
EOF