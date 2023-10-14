#!/bin/bash

# -------------------------------------------------------- #
# Author : Bibhuti Bhushan                                 #
# Github : https://github.com/Bibhuti1221Bhushan/Installer #
# -------------------------------------------------------- #

# ------------------------ #
# --- COSMETICS THINGS --- #
# ------------------------ # 

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

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/vda                            # SET DISK FOR INSTALL

# SET SIZE OF DRIVE :
# ~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550MiB                         # SET BOOT PARTITION SIZE
SWAP_SIZE=1GiB                           # SET SWAP PARTITION SIZE
ROOT_SIZE=15GiB                          # SET ROOT PARTITION SIZE
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET PACKAGES :
# ~~~~~~~~~~~~~~
KERNEL="linux-lts"                       # SET KERNEL

# SET LOG FILE :
# ~~~~~~~~~~~~~~
INSTLOG="Installer.log"

# ------------------------------- #
# --- SCRIPT START FROM HERE ---  #
# ------------------------------- #

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
clear

# TITLE SHOW :
# ~~~~~~~~~~~~
echo
echo -ne "${BOLD}${BBLUE}
███████╗ █████╗ ███████╗██╗   ██╗      █████╗ ██████╗  ██████╗██╗  ██╗
██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
█████╗  ███████║███████╗ ╚████╔╝█████╗███████║██████╔╝██║     ███████║
██╔══╝  ██╔══██║╚════██║  ╚██╔╝ ╚════╝██╔══██║██╔══██╗██║     ██╔══██║
███████╗██║  ██║███████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
======================================================================
${RESET}"

# VERIFY BOOT MODE :
# ~~~~~~~~~~~~~~~~~~
if [ ! -d /sys/firmware/efi/efivars ]; then
  Issue_Print "YOU ARE NOT BOOTED IN UEFI"
  exit 1
fi

# SYNC TIME AND DATE : 
# ~~~~~~~~~~~~~~~~~~~~
Info_Print "SYNCING TIME AND DATE..."
timedatectl set-ntp true
sleep 3
Done_Print "DONE - SYNCING TIME AND DATE..."
echo

# WIPE THE DISK :
# ~~~~~~~~~~~~~~~
Info_Print "WIPING DISK..."
wipefs -af "$DISK" &>> $INSTLOG
sgdisk -Zo "$DISK" &>> $INSTLOG
Done_Print "DONE - WIPING DISK..."
echo

# PARTITION THE DISK :
# ~~~~~~~~~~~~~~~~~~~~
Info_Print "CREATING PARTITIONS..."
parted "$DISK" -s mklabel gpt
parted "$DISK" -s mkpart ESP fat32 1MiB $BOOT_SIZE
parted "$DISK" -s set 1 esp on
parted "$DISK" -s mkpart primary linux-swap $BOOT_SIZE $SWAP_SIZE
parted "$DISK" -s mkpart primary ext4 $SWAP_SIZE $ROOT_SIZE
parted "$DISK" -s mkpart primary ext4 $ROOT_SIZE 100%
Done_Print "DONE - CREATING PARTITIONS..."
echo

# FORMAT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "FORMATING PARTITIONS..."
mkfs.fat -F 32 -n ESP "$DISK"1 &>> $INSTLOG
mkswap -L SWAP "$DISK"2 &>> $INSTLOG
mkfs.ext4 -L ROOT "$DISK"3 &>> $INSTLOG
mkfs.ext4 -L HOME "$DISK"4 &>> $INSTLOG
Done_Print "DONE - FORMATING PARTITIONS..."
echo

# MOUNT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~
Info_Print "MOUNTING PARTITIONS..."
mount "$DISK"3 /mnt
mkdir -p /mnt/boot
mount "$DISK"1 /mnt/boot
mkdir /mnt/home 
mount "$DISK"4 /mnt/home
swapon "$DISK"2
Done_Print "DONE - MOUNTING PARTITIONS..."
echo

# MICROCODE DETECTIOR :
# ~~~~~~~~~~~~~~~~~~~~~
Microcode_Detector

# INSTALLING BASE SYSTEM :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "INSTALLING BASE SYSTEM PACKAGES..."
pacstrap -K /mnt --noconfirm --needed base sudo linux-firmware $KERNEL $MICROCODE &>> $INSTLOG
Done_Print "DONE - INSTALLING BASE SYSTEM PACKAGES..."
echo

# GENERATE THE FSTAB FILE :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "GENERATING FSTAB FILE..."
genfstab -U /mnt >> /mnt/etc/fstab
Done_Print "DONE - GENERATING FSTAB FILE..."
echo


# TITLE SHOW :
# ~~~~~~~~~~~~
echo
echo -ne "${BOLD}${BBLUE}
 █████╗ ██████╗  █████╗ ██╗  ██╗       █████╗ ██╗  ██╗██████╗  █████╗  █████╗ ████████╗
██╔══██╗██╔══██╗██╔══██╗██║  ██║      ██╔══██╗██║  ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝
███████║██████╔╝██║  ╚═╝███████║█████╗██║  ╚═╝███████║██████╔╝██║  ██║██║  ██║   ██║   
██╔══██║██╔══██╗██║  ██╗██╔══██║╚════╝██║  ██╗██╔══██║██╔══██╗██║  ██║██║  ██║   ██║   
██║  ██║██║  ██║╚█████╔╝██║  ██║      ╚█████╔╝██║  ██║██║  ██║╚█████╔╝╚█████╔╝   ██║   
╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝       ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝  ╚════╝    ╚═╝   
======================================================================
${RESET}"

