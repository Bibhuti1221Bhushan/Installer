#!/bin/bash

# ---------------------------------------------------------- #
# ------------------- SET SOME VARIABLES ------------------- #
# ---------------------------------------------------------- #

# SET GENERAL VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~~~~
USERNAME="Bibhuti"				         # SET USER-NAME
NICKNAME="Bibhuti Bhushan"		         # SET NICK-NAME
HOSTNAME="iTunes"			      	     # SET HOST-NAME
TIMEZONE="Asia/Kolkata"	    	         # SET TIME-ZONE
KEYBOARD="us" 				      	     # SET KEYBOARD
LOCALE="en_US.UTF-8"			         # SET LOCALE

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/vda                            # SET DISK FOR INSTALLATION

# SET PARTITION SIZE :
# ~~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550                            # SET BOOT PARTITION SIZE
ROOT_SIZE=15                             # SET ROOT PARTITION SIZE
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET SWAP SIZE :
# ~~~~~~~~~~~~~~~
SWAP=1                                   # 0 = NO SWAP , 1 = SWAP PARTITION & 2 = SWAP FILE 
SWAP_SIZE=2                              # SET SIZE OF SWAP PARTITION OR SWAPFILE

# SET PACKAGES :
# ~~~~~~~~~~~~~~
KERNEL="linux-lts"                       # SET KERNEL PACKAGES
EXTRA="git neovim"                       # EXTRA PACKAGES LIKE EDITOR

# SET LOG FILE :
# ~~~~~~~~~~~~~~
LOGFILE="Installer.log"

# ---------------------------------------------------------- #
# -------------------- COSMETICS THINGS -------------------- #
# ---------------------------------------------------------- #

# COLOR VARIABLES :
# ~~~~~~~~~~~~~~~~~ 
BREDD="\e[1;31m"
BGREE="\e[1;32m"
BYELO="\e[1;33m"
BBLUE="\e[1;34m"
BPINK="\e[1;35m"
BCYAN="\e[1;36m"
RESET="\e[0m"

# PRETTY PRINT FUNCTIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print () {
    echo -ne "\r${BCYAN}! NOTE !${BYELO} - $1${RESET}\n"
}

Done_Print () {
    echo -ne "\r${BGREE}! DONE !${BBLUE} - $1${RESET}\n"
}

Warn_Print () {
    echo -ne "\r${BREDD}! WARN !${BBLUE} - $1${RESET}\n"
}

# TITLE PRINT FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~
Title_Print() {
    COLUMNS=$(tput cols)
    SIZE=$1
    INDENT=$(( (COLUMNS - SIZE) / 2 ))
    PADDING=''
    for ((i=1; i<=INDENT; i++)) ; do
        PADDING+=' '
    done
    echo -e "${BPINK}${PADDING}${2}${RESET}"
}

# SPIN FUNCTION :
# ~~~~~~~~~~~~~~~
Spin(){
VAR="$1"
case "$VAR" in
    4)
        SPIN=("+===" "=+==" "==+=" "===+" "==+=" "=+==");
        ;;
    5)
        SPIN=("+====" "=+===" "==+==" "===+=" "====+" "===+=" "==+==" "=+===");
        ;;
    6)
        SPIN=("+=====" "=+====" "==+===" "===+==" "====+=" "=====+" "====+=" "===+==" "==+===" "=+====");
        ;;
    7)
        SPIN=("+======" "=+=====" "==+====" "===+===" "====+==" "=====+=" "======+" "=====+=" "====+==" "===+===" "==+====" "=+=====");
        ;;
    8)
        SPIN=("+=======" "=+======" "==+=====" "===+====" "====+===" "=====+==" "======+=" "=======+" "======+=" "=====+==" "====+===" "===+====" "==+=====" "=+======");
        ;;
    9)
        SPIN=("+========" "=+=======" "==+======" "===+=====" "====+====" "=====+===" "======+==" "=======+=" "========+" "=======+=" "======+==" "=====+===" "====+====" "===+=====" "==+======" "=+=======");
        ;;
    10)
        SPIN=("+=========" "=+========" "==+=======" "===+======" "====+=====" "=====+====" "======+===" "=======+==" "========+=" "=========+" "========+=" "=======+==" "======+===" "=====+====" "====+=====" "===+======" "==+=======" "=+========");
        ;;
    11)
        SPIN=("+==========" "=+=========" "==+========" "===+=======" "====+======" "=====+=====" "======+====" "=======+===" "========+==" "=========+=" "==========+" "=========+=" "========+==" "=======+===" "======+====" "=====+=====" "====+======" "===+=======" "==+========" "=+=========");
        ;;
    12)
        SPIN=("+===========" "=+==========" "==+=========" "===+========" "====+=======" "=====+======" "======+=====" "=======+====" "========+===" "=========+==" "==========+=" "===========+" "==========+=" "=========+==" "========+===" "=======+====" "======+=====" "=====+======" "====+=======" "===+========" "==+=========" "=+==========");
        ;;
    13)
        SPIN=("+============" "=+===========" "==+==========" "===+=========" "====+========" "=====+=======" "======+======" "=======+=====" "========+====" "=========+===" "==========+==" "===========+=" "============+" "===========+=" "==========+==" "=========+===" "========+====" "=======+=====" "======+======" "=====+=======" "====+========" "===+=========" "==+==========" "=+===========");
        ;;
    14)
        SPIN=("+=============" "=+============" "==+===========" "===+==========" "====+=========" "=====+========" "======+=======" "=======+======" "========+=====" "=========+====" "==========+===" "===========+==" "============+=" "=============+" "============+=" "===========+==" "==========+===" "=========+====" "========+=====" "=======+======" "======+=======" "=====+========" "====+=========" "===+==========" "==+===========" "=+============");
        ;;
    15)
        SPIN=("+==============" "=+=============" "==+============" "===+===========" "====+==========" "=====+=========" "======+========" "=======+=======" "========+======" "=========+=====" "==========+====" "===========+===" "============+==" "=============+=" "==============+" "=============+=" "============+==" "===========+===" "==========+====" "=========+=====" "========+======" "=======+=======" "======+========" "=====+=========" "====+==========" "===+===========" "==+============" "=+=============");
        ;;
esac
while [ 1 ]
  do 
    for INTERVAL in ${SPIN[@]}; 
    do 
      echo -ne "\r${BYELO}! WAIT ! - ${BBLUE}${2}${RESET}${BGREE} ${INTERVAL}${RESET}";
      sleep 0.3;
    done;
done
}

# MICROCODE DETECT FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Microcode_Detector () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        MICROCODE="amd-ucode"
    elif [[ "$CPU" == *"GenuineIntel"* ]]; then
        MICROCODE="intel-ucode"
    fi
}

# GRAPHICS DRIVERS CHECK FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Graphics_Detect () {
    GPU=$(lspci)
    if grep -E "NVIDIA|GeForce" <<< ${GPU}; then
        arch-chroot /mnt pacman -S --noconfirm nvidia nvidia-utils
    elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
        arch-chroot /mnt pacman -S --noconfirm --needed xf86-video-amdgpu
    elif grep -E "Integrated Graphics Controller" <<< ${GPU}; then
        arch-chroot /mnt pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
    elif grep -E "Intel Corporation UHD" <<< ${GPU}; then
        arch-chroot /mnt pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
    fi
}

# VIRTUALIZATION CHECK FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
VM_Check () {
    DETECT=$(systemd-detect-virt)
    case $DETECT in
        kvm )       Info_Print "KVM HAS BEEN DETECTED, SETTING UP GUEST TOOLS."
                    arch-chroot /mnt pacman -S --noconfirm qemu-guest-agent &>> $LOGFILE
                    arch-chroot /mnt systemctl enable qemu-guest-agent &>> $LOGFILE
                    Done_Print "SETTING UP KVM GUEST TOOLS."
                    ;;
        vmware )    Info_Print "VMWARE WORKSTATION HAS BEEN DETECTED, SETTING UP GUEST TOOLS."
                    arch-chroot /mnt pacman -S --noconfirm open-vm-tools &>> $LOGFILE
                    arch-chroot /mnt systemctl enable vmtoolsd &>> $LOGFILE
                    arch-chroot /mnt systemctl enable vmware-vmblock-fuse &>> $LOGFILE
                    Done_Print "SETTING UP VMWARE GUEST TOOLS."
                    ;;
        oracle )    Info_Print "VIRTUALBOX HAS BEEN DETECTED, SETTING UP GUEST TOOLS."
                    arch-chroot /mnt pacman -S --noconfirm virtualbox-guest-utils &>> $LOGFILE
                    arch-chroot /mnt systemctl enable vboxservice &>> $LOGFILE
                    Done_Print "SETTING UP VIRTUALBOX GUEST TOOLS."
                    ;;
        microsoft ) Info_Print "HYPER-V HAS BEEN DETECTED, SETTING UP GUEST TOOLS."
                    arch-chroot /mnt pacman -S --noconfirm hyperv &>> $LOGFILE
                    arch-chroot /mnt systemctl enable hv_fcopy_daemon &>> $LOGFILE
                    arch-chroot /mnt systemctl enable hv_kvp_daemon &>> $LOGFILE
                    arch-chroot /mnt systemctl enable hv_vss_daemon &>> $LOGFILE
                    Done_Print "SETTING UP HYPER-V GUEST TOOLS."
                    ;;
    esac
}

# ---------------------------------------------------------- #
# ----------------- SCRIPT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
clear

# TITLE SHOW :
# ~~~~~~~~~~~~
echo
Title_Print 80 "@@@@@@@@   @@@@@@    @@@@@@   @@@ @@@      @@@@@@   @@@@@@@    @@@@@@@  @@@  @@@"
Title_Print 80 "@@@@@@@@  @@@@@@@@  @@@@@@@   @@@ @@@     @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@  @@@"
Title_Print 80 "@@!       @@!  @@@  !@@       @@! !@@     @@!  @@@  @@!  @@@  !@@       @@!  @@@"
Title_Print 80 "!@!       !@!  @!@  !@!       !@! @!!     !@!  @!@  !@!  @!@  !@!       !@!  @!@"
Title_Print 80 "@!!!:!    @!@!@!@!  !!@@!!     !@!@!      @!@!@!@!  @!@!!@!   !@!       @!@!@!@!"
Title_Print 80 "!!!!!:    !!!@!!!!   !!@!!!     @!!!      !!!@!!!!  !!@!@!    !!!       !!!@!!!!"
Title_Print 80 "!!:       !!:  !!!       !:!    !!:       !!:  !!!  !!: :!!   :!!       !!:  !!!"
Title_Print 80 ":!:       :!:  !:!      !:!     :!:       :!:  !:!  :!:  !:!  :!:       :!:  !:!"
Title_Print 80 ".:: ::::  ::   :::  :::: ::      ::       ::   :::  ::   :::   ::: :::  ::   :::"
Title_Print 80 ": :: ::.  .:   : :  :: : :       :        .:   : :  .:   : :   :: :: :   :   : :"
echo
Title_Print 84 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo

# VERIFY BOOT MODE :
# ~~~~~~~~~~~~~~~~~~
if [ ! -d /sys/firmware/efi/efivars ]; then
  Warn_Print "YOU ARE NOT BOOTED IN UEFI."
  exit 1
fi

# CHECK VARIABLE :
# ~~~~~~~~~~~~~~~~
Var_Checking () {
    if [[ -z "$USERNAME"  ]]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE USERNAME."
        exit 1
    elif [ -z "$NICKNAME" ]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE NICKNAME."
        exit 1
    elif [ -z "$HOSTNAME" ]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE HOSTNAME."
        exit 1
    elif [ -z "$TIMEZONE" ]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE TIMEZONE."
        exit 1
    elif [ -z "$KEYBOARD" ]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE KEYBOARD."
        exit 1
    elif [ -z "$LOCALE" ]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE LOCALE."
        exit 1
    elif [[ ! $DISK =~ ^/dev/.* ]]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE DISK."
        exit 1
    elif [[ $BOOT_SIZE -lt 500 ]]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE BOOT_SIZE."
        exit 1
    elif [[ $ROOT_SIZE -lt 5 ]]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE ROOT_SIZE."
        exit 1
    elif [[ $SWAP != 0 && $SWAP != 1 && $SWAP != 2 ]]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE SWAP."
        exit 1
    elif [[ $SWAP_SIZE -lt 2 ]];  then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE SWAP_SIZE."
        sleep 5
        exit 1
    elif [[ ! $KERNEL == linux* ]]; then
        Warn_Print "PLEASE EDIT & SPECIFY VARIABLE KERNEL."
        exit 1
    fi
    Done_Print "CHECKING VARIABLE."
}

Info_Print "CHECKING VARIABLE."
Var_Checking
echo

# SYNC TIME AND DATE :
# ~~~~~~~~~~~~~~~~~~~~
Date_Time () {
    Spin 13 SYNCING &
    PID=$!
    if 
        timedatectl set-ntp true &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "SYNCING TIME AND DATE."
    else
        kill $PID
        Warn_Print "SYNCING TIME AND DATE."
        sleep 1
    fi
}

Info_Print "SYNCING TIME AND DATE."
Date_Time
echo

# UPDATE KEYRING :
# ~~~~~~~~~~~~~~~~
KRings () {
    Spin 8 UPDATING &
    PID=$!
    if 
        pacman -Sy --noconfirm --disable-download-timeout archlinux-keyring &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "UPDATING KEYRINGS."
    else
        kill $PID
        Warn_Print "UPDATING KEYRINGS."
        sleep 1
    fi
}

# Info_Print "UPDATING KEYRINGS."
# KRings
# echo

# WIPE THE DISK :
# ~~~~~~~~~~~~~~~
Wiping_Drive () {
    Spin 4 WIPING &
    PID=$!
    if 
        wipefs -af "$DISK" &> $LOGFILE
        sgdisk -Zo "$DISK" &>> $LOGFILE
        partprobe "$DISK" &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "WIPING DISK."
    else
        kill $PID
        Warn_Print "WIPING DISK."
        sleep 1
    fi
}
Info_Print "WIPING DISK."
Wiping_Drive
echo


# PARTITION THE DISK :
# ~~~~~~~~~~~~~~~~~~~~
Creating_Partition () {
    Spin 10 CREATING &
    PID=$!
    if 
        if [[ "$SWAP" == "1" ]]; then
            parted "$DISK" -s mklabel gpt &>> $LOGFILE
            parted "$DISK" -s mkpart ESP fat32 1MiB "$BOOT_SIZE"M &>> $LOGFILE
            parted "$DISK" -s set 1 esp on &>> $LOGFILE
            parted "$DISK" -s mkpart SWAP linux-swap "$BOOT_SIZE"M "$SWAP_SIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart ROOT ext4 "$SWAP_SIZE"G "$ROOT_SIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart HOME ext4 "$ROOT_SIZE"G 100% &>> $LOGFILE
        else
            parted "$DISK" -s mklabel gpt &>> $LOGFILE
            parted "$DISK" -s mkpart ESP fat32 1MiB "$BOOT_SIZE"M &>> $LOGFILE
            parted "$DISK" -s set 1 esp on &>> $LOGFILE
            parted "$DISK" -s mkpart ROOT ext4 "$BOOT_SIZE"M "$ROOT_SIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart HOME ext4 "$ROOT_SIZE"G 100% &>> $LOGFILE
        fi
    then
        sleep 1
        kill $PID
        Done_Print "CREATING PARTITIONS."
    else
        kill $PID
        Warn_Print "CREATING PARTITIONS."
        sleep 1
    fi
}

Info_Print "CREATING PARTITIONS."
Creating_Partition
echo


# FORMAT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~
Formatting_Partition () {
    Spin 10 FORMATTING &
    PID=$!
    if 
        if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
                mkfs.fat -F 32 -n ESP "$DISK"p1 &>> $LOGFILE
                mkswap -L SWAP "$DISK"p2 &>> $LOGFILE
                mkfs.ext4 -L ROOT "$DISK"p3 &>> $LOGFILE
                mkfs.ext4 -L HOME "$DISK"p4 &>> $LOGFILE
            else
                mkfs.fat -F 32 -n ESP "$DISK"p1 &>> $LOGFILE
                mkfs.ext4 -L ROOT "$DISK"p2 &>> $LOGFILE
                mkfs.ext4 -L HOME "$DISK"p3 &>> $LOGFILE
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                mkfs.fat -F 32 -n ESP "$DISK"1 &>> $LOGFILE
                mkswap -L SWAP "$DISK"2 &>> $LOGFILE
                mkfs.ext4 -L ROOT "$DISK"3 &>> $LOGFILE
                mkfs.ext4 -L HOME "$DISK"4 &>> $LOGFILE
            else
                mkfs.fat -F 32 -n ESP "$DISK"1 &>> $LOGFILE
                mkfs.ext4 -L ROOT "$DISK"2 &>> $LOGFILE
                mkfs.ext4 -L HOME "$DISK"3 &>> $LOGFILE
            fi
        fi
    then
        sleep 1
        kill $PID
        Done_Print "FORMATTING PARTITIONS."
    else
        kill $PID
        Warn_Print "FORMATTING PARTITIONS."
        sleep 1
    fi
}

Info_Print "FORMATTING PARTITIONS."
Formatting_Partition
echo