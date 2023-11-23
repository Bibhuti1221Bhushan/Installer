#!/bin/bash

# ---------------------------------------------------------- #
# ------------------- SET SOME VARIABLES ------------------- #
# ---------------------------------------------------------- #

# SET GENERAL VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~~~~
USERNAME="Bibhuti"                       # SET USER-NAME
NICKNAME="Bibhuti Bhushan"               # SET NICK-NAME
HOSTNAME="iTunes"                        # SET HOST-NAME
TIMEZONE="Asia/Kolkata"                  # SET TIME-ZONE
KEYBOARD="us"                            # SET KEYBOARD
LOCALE="en_US.UTF-8"                     # SET LOCALE

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/sda                            # SET DISK FOR INSTALLATION

# SET PARTITION SIZE :
# ~~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550                            # SET BOOT PARTITION SIZE ( NOTE - SIZE IS IN MB )
ROOT_SIZE=15                             # SET ROOT PARTITION SIZE ( NOTE - SIZE IS IN GB )
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET SWAP SIZE :
# ~~~~~~~~~~~~~~~
SWAP=2                                   # 0 = NO SWAP , 1 = SWAP PARTITION & 2 = SWAP FILE 
SWAP_SIZE=2                              # SET SIZE OF SWAP PARTITION OR SWAP FILE ( NOTE - SIZE IS IN GB )

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
Microcode_Detect () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        MICROCODE="amd-ucode"
    elif [[ "$CPU" == *"GenuineIntel"* ]]; then
        MICROCODE="intel-ucode"
    fi
}

# GRAPHICS DRIVERS DETECT FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
Variable_Checking () {
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
Variable_Checking
echo

# SYNC TIME AND DATE :
# ~~~~~~~~~~~~~~~~~~~~
Date_Time () {
    Spin 13 SYNCING &
    PID=$!
    if 
        timedatectl set-ntp true &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "SYNCING TIME AND DATE."
    else
        kill $PID
        Warn_Print "SYNCING TIME AND DATE."
        exit 1
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
        pacman -Sy --noconfirm --disable-download-timeout archlinux-keyring &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "UPDATING KEYRINGS."
    else
        kill $PID
        Warn_Print "UPDATING KEYRINGS."
        exit 1
    fi
}

Info_Print "UPDATING KEYRINGS."
KRings
echo

# WIPE THE DISK :
# ~~~~~~~~~~~~~~~
Wiping_Drive () {
    Spin 4 WIPING &
    PID=$!
    if 
        wipefs -af "$DISK" &> $LOGFILE
        sleep 0.5
        sgdisk -Zo "$DISK" &>> $LOGFILE
        sleep 0.5
        partprobe "$DISK" &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "WIPING DISK."
    else
        kill $PID
        Warn_Print "WIPING DISK."
        exit 1
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
            parted "$DISK" -s mkpart SWAP linux-swap "$BOOT_SIZE"M "$SWAP_SIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart ROOT ext4 "$SWAP_SIZE"G "$ROOT_SIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart HOME ext4 "$ROOT_SIZE"G 100% &>> $LOGFILE
            parted "$DISK" -s set 1 esp on &>> $LOGFILE
            parted "$DISK" -s set 2 swap on &>> $LOGFILE
            parted "$DISK" -s set 3 root on &>> $LOGFILE
            parted "$DISK" -s set 4 linux-home on &>> $LOGFILE
        else
            parted "$DISK" -s mklabel gpt &>> $LOGFILE
            parted "$DISK" -s mkpart ESP fat32 1MiB "$BOOT_SIZE"M &>> $LOGFILE
            parted "$DISK" -s mkpart ROOT ext4 "$BOOT_SIZE"M "$ROOT_SIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart HOME ext4 "$ROOT_SIZE"G 100% &>> $LOGFILE
            parted "$DISK" -s set 1 esp on &>> $LOGFILE
            parted "$DISK" -s set 2 root on &>> $LOGFILE
            parted "$DISK" -s set 3 linux-home on &>> $LOGFILE
        fi
    then
        sleep 1
        kill $PID
        Done_Print "CREATING PARTITIONS."
    else
        kill $PID
        Warn_Print "CREATING PARTITIONS."
        exit 1
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
        exit 1
    fi
}

Info_Print "FORMATTING PARTITIONS."
Formatting_Partition
echo

# MOUNT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~
Mounting_Partition () {
    Spin 10 MOUNTING &
    PID=$!
    if 
        if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
                mount "$DISK"p3 /mnt
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount "$DISK"p1 /mnt/boot
                mkdir -vp /mnt/home &>> $LOGFILE
                mount "$DISK"p4 /mnt/home
                swapon "$DISK"p2 &>> $LOGFILE
            else
                mount "$DISK"p2 /mnt
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount "$DISK"p1 /mnt/boot
                mkdir -vp /mnt/home &>> $LOGFILE
                mount "$DISK"p3 /mnt/home
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                mount "$DISK"3 /mnt
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount "$DISK"1 /mnt/boot
                mkdir -vp /mnt/home &>> $LOGFILE
                mount "$DISK"4 /mnt/home
                swapon "$DISK"2 &>> $LOGFILE
            else
                mount "$DISK"2 /mnt
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount "$DISK"1 /mnt/boot
                mkdir -vp /mnt/home &>> $LOGFILE
                mount "$DISK"3 /mnt/home
            fi
        fi
    then
        sleep 1
        kill $PID
        Done_Print "MOUNTING PARTITIONS."
    else
        kill $PID
        Warn_Print "MOUNTING PARTITIONS."
        sleep 1
        exit 1
    fi
}

Info_Print "MOUNTING PARTITIONS."
Mounting_Partition
echo

# MICROCODE DETECTIOR :
# ~~~~~~~~~~~~~~~~~~~~~
Microcode_Detect

# INSTALLING BASE SYSTEM :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Installing_Base () {
    Spin 11 INSTALLING &
    PID=$!
    if 
        pacstrap -K /mnt --noconfirm --disable-download-timeout base base-devel linux-firmware $KERNEL $KERNEL-headers $MICROCODE &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "INSTALLING BASE SYSTEM."
    else
        kill $PID
        Warn_Print "INSTALLING BASE SYSTEM."
        sleep 1
        exit 1
    fi
}

Info_Print "INSTALLING BASE SYSTEM."
Installing_Base
echo

# GENERATE THE FSTAB FILE :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Generating_FTab () {
    Spin 11 INSTALLING &
    PID=$!
    if 
        genfstab -U /mnt >> /mnt/etc/fstab &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "GENERATING FSTAB FILE."
    else
        kill $PID
        Warn_Print "GENERATING FSTAB FILE."
        sleep 1
        exit 1
    fi
}

Info_Print "GENERATING FSTAB FILE."
Generating_FTab
echo

# ---------------------------------------------------------- #
# ----------------- CHROOT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

# SET TIME-ZONE :
# ~~~~~~~~~~~~~~~
Setting_Timezone () {
    Spin 9 SETTING &
    PID=$!
    if 
        arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &>> $LOGFILE
        arch-chroot /mnt hwclock --systohc &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "SETTING TIME-ZONE."
    else
        kill $PID
        Warn_Print "SETTING TIME-ZONE."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING TIME-ZONE."
Setting_Timezone
echo


# GENERATE LOCALE :
# ~~~~~~~~~~~~~~~~~
Generating_Locale () {
    Spin 6 GENERATING &
    PID=$!
    if 
        arch-chroot /mnt sed -i "s/#$LOCALE/$LOCALE/g" /etc/locale.gen
        arch-chroot /mnt locale-gen &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "GENERATING LOCALE."
    else
        kill $PID
        Warn_Print "GENERATING LOCALE."
        sleep 1
        exit 1
    fi
}

Info_Print "GENERATING LOCALE."
Generating_Locale
echo

# SET LOCALE UNITS :
# ~~~~~~~~~~~~~~~~~~
Setting_Locale () {
    Spin 12 SETTING &
    PID=$!
    if 
        echo "LANG=$LOCALE" > /mnt/etc/locale.conf
        echo "LC_COLLATE=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_ADDRESS=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_CTYPE=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_IDENTIFICATION=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_MEASUREMENT=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_MESSAGES=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_MONETARY=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_NAME=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_NUMERIC=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_PAPER=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_TELEPHONE=$LOCALE" >> /mnt/etc/locale.conf
        echo "LC_TIME=$LOCALE" >> /mnt/etc/locale.conf; then
        sleep 1
        kill $PID
        Done_Print "SETTING LOCALE UNITS."
    else
        kill $PID
        Warn_Print "SETTING LOCALE UNITS."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING LOCALE UNITS."
Setting_Locale
echo


# SET HOST-NAME :
# ~~~~~~~~~~~~~~~
Setting_Hostname () {
    Spin 9 SETTING &
    PID=$!
    if 
        echo "$HOSTNAME" > /mnt/etc/hostname; then
        sleep 1
        kill $PID
        Done_Print "SETTING HOST-NAME."
    else
        kill $PID
        Warn_Print "SETTING HOST-NAME."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING HOST-NAME."
Setting_Hostname
echo

# SET HOSTS :
# ~~~~~~~~~~~
Setting_Hosts () {
    Spin 10 SETTING &
    PID=$!
    if 
        echo "127.0.0.1      localhost" >> /mnt/etc/hosts
        echo "::1            localhost" >> /mnt/etc/hosts
        echo "127.0.1.1      $HOSTNAME.localdomain     $HOSTNAME" >> /mnt/etc/hosts; then
        sleep 1
        kill $PID
        Done_Print "SETTING HOSTS FILE."
    else
        kill $PID
        Warn_Print "SETTING HOSTS FILE."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING HOSTS FILE."
Setting_Hosts
echo

# SET CONSOLE KEYMAP :
# ~~~~~~~~~~~~~~~~~~~~
Setting_Console () {
    Spin 14 SETTING &
    PID=$!
    if 
        echo "KEYMAP=$KEYBOARD" > /mnt/etc/vconsole.conf
        echo "XKBLAYOUT=$KEYBOARD" >> /mnt/etc/vconsole.conf; then
        sleep 1
        kill $PID
        Done_Print "SETTING CONSOLE KEYMAP."
    else
        kill $PID
        Warn_Print "SETTING CONSOLE KEYMAP."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING CONSOLE KEYMAP."
Setting_Console
echo

# MODIFYING PACMAN :
# ~~~~~~~~~~~~~~~~~~
Modifing_Pacman () {
    Spin 13 MODIFYING &
    PID=$!
    if 
        sed -i 's/#Color/Color\nILoveCandy/' /etc/pacman.conf
        sed -i '/\[multilib\]/,/Include/s/^#//' /mnt/etc/pacman.conf
        sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /mnt/etc/pacman.conf
        sed -i 's/^#ParallelDownloads/ParallelDownloads/' /mnt/etc/pacman.conf; then
        sleep 1
        kill $PID
        Done_Print "MODIFYING PACMAN CONFIG."
    else
        kill $PID
        Warn_Print "MODIFYING PACMAN CONFIG."
        sleep 1
        exit 1
    fi
}

Info_Print "MODIFYING PACMAN CONFIG."
Modifing_Pacman
echo

# INITIALISING PACMAN KEYRINGS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Initialising_Pacman () {
    Spin 15 INITIALISING &
    PID=$!
    if 
        arch-chroot /mnt pacman-key --init &>> $LOGFILE
        arch-chroot /mnt pacman-key --populate &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "INITIALISING PACMAN KEYRINGS."
    else
        kill $PID
        Warn_Print "INITIALISING PACMAN KEYRINGS."
        sleep 1
        exit 1
    fi
}

Info_Print "INITIALISING PACMAN KEYRINGS."
Initialising_Pacman
echo

# SYNC FASTEST MIRRORS :
# ~~~~~~~~~~~~~~~~~~~~~~
Setting_Reflector () {
    Spin 15 SYNCING &
    PID=$!
    if 
        arch-chroot /mnt pacman -Sy --needed --noconfirm reflector &>> $LOGFILE
        arch-chroot /mnt reflector --country India --sort rate --save /etc/pacman.d/mirrorlist --download-timeout 60 --verbose &>> $LOGFILE
        echo "--verbose" > /mnt/etc/xdg/reflector/reflector.conf
        echo "--sort rate" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--latest 20" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--fastest 20" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--protocol https" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--save /etc/pacman.d/mirrorlist" >> /mnt/etc/xdg/reflector/reflector.conf; then
        sleep 1
        kill $PID
        Done_Print "SYNCING FASTEST MIRRORS."
    else
        kill $PID
        Warn_Print "SYNCING FASTEST MIRRORS."
        sleep 1
        exit 1
    fi
}

Info_Print "SYNCING FASTEST MIRRORS."
Setting_Reflector
echo

# SET NETWORK MANAGER :
# ~~~~~~~~~~~~~~~~~~~~~
Setting_NetManager () {
    Spin 15 SETTING &
    PID=$!
    if 
        arch-chroot /mnt pacman -S --needed --noconfirm networkmanager &>> $LOGFILE
        arch-chroot /mnt systemctl enable NetworkManager &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "SETTING NETWORK MANAGER."
    else
        kill $PID
        Warn_Print "SETTING NETWORK MANAGER."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING NETWORK MANAGER."
Setting_NetManager
echo

# NO WATCH-DOG :
# ~~~~~~~~~~~~~~
Disabling_WatchDog () {
    Spin 13 DISABLING &
    PID=$!
    if 
        echo "blacklist iTCO_wdt" > /mnt/etc/modprobe.d/nowatchdog.conf; then
        sleep 1
        kill $PID
        Done_Print "DISABLING WATCH-DOG LOG."
    else
        kill $PID
        Warn_Print "DISABLING WATCH-DOG LOG."
        sleep 1
        exit 1
    fi
}

Info_Print "DISABLING WATCH-DOG LOG."
Disabling_WatchDog
echo

# REDUCE SHUTDOWN TIME :
# ~~~~~~~~~~~~~~~~~~~~~~
Reducing_Time () {
    Spin 13 REDUCING &
    PID=$!
    if 
        sed -i "s/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=10s/" /mnt/etc/systemd/system.conf; then
        sleep 1
        kill $PID
        Done_Print "REDUCING SHUTDOWN TIME."
    else
        kill $PID
        Warn_Print "REDUCING SHUTDOWN TIME."
        sleep 1
        exit 1
    fi
}

Info_Print "REDUCING SHUTDOWN TIME."
Reducing_Time
echo

# RE-INITIALIZE INITRAMFS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Initialising_Kernel () {
    Spin 9 RE-INITIALISING &
    PID=$!
    if 
        arch-chroot /mnt mkinitcpio -P &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "RE-INITIALISING INITRAMFS."
    else
        kill $PID
        Warn_Print "RE-INITIALISING INITRAMFS."
        sleep 1
        exit 1
    fi
}

Info_Print "RE-INITIALISING INITRAMFS."
Initialising_Kernel
echo

# SET BOOT LOADER :
# ~~~~~~~~~~~~~~~~~
Setting_BootLoader () {
    Spin 11 SETTING &
    PID=$!
    if
        arch-chroot /mnt bootctl install --esp-path=/boot/ &>> $LOGFILE
        echo "title   Boot Manager" >> /mnt/boot/loader/entries/Arch.conf
        echo "linux   /vmlinuz-$KERNEL" >> /mnt/boot/loader/entries/Arch.conf
        echo "initrd  /$MICROCODE.img" >> /mnt/boot/loader/entries/Arch.conf
        echo "initrd  /initramfs-$KERNEL.img" >> /mnt/boot/loader/entries/Arch.conf
        
        echo "default Arch.conf" >> /mnt/boot/loader/loader.conf
        echo "console-mode max" >> /mnt/boot/loader/loader.conf
        echo "timeout 0" >> /mnt/boot/loader/loader.conf
        echo "editor yes" >> /mnt/boot/loader/loader.conf
        if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
               echo "options root=${DISK}p3 rw rootfstype=ext4" >> /mnt/boot/loader/entries/Arch.conf
            else
               echo "options root=${DISK}p2 rw rootfstype=ext4" >> /mnt/boot/loader/entries/Arch.conf
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                echo "options root=${DISK}3 rw rootfstype=ext4" >> /mnt/boot/loader/entries/Arch.conf
            else
                echo "options root=${DISK}2 rw rootfstype=ext4" >> /mnt/boot/loader/entries/Arch.conf
            fi
        fi
        then
        sleep 1
        kill $PID
        Done_Print "SETTING BOOT LOADER."
    else
        kill $PID
        Warn_Print "SETTING BOOT LOADER."
        sleep 1
        exit 1
    fi
}

Info_Print "SETTING BOOT LOADER."
Setting_BootLoader
echo

# INSTALL PACKAGES :
# ~~~~~~~~~~~~~~~~~~
Installing_Extra () {
    Spin 14 INSTALLING &
    PID=$!
    if 
        arch-chroot /mnt pacman -S --needed --noconfirm $EXTRA pacman-contrib &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "INSTALLING EXTRA PACKAGES."
    else
        kill $PID
        Warn_Print "INSTALLING EXTRA PACKAGES."
        sleep 1
        exit 1
    fi
}
Info_Print "INSTALLING EXTRA PACKAGES."
Installing_Extra
echo

# SET ROOT PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
Setting_RootPassWd () {
    Spin 13 SETTING &
    PID=$!
    if 
        printf "%s\n%s" "${ROOT_PASSWORD}" "${ROOT_PASSWORD}" | arch-chroot /mnt passwd &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "SETTING ROOT PASSWORD."
    else
        kill $PID
        Warn_Print "SETTING ROOT PASSWORD."
        sleep 1
        exit 1
    fi
}

echo -en "${BCYAN}! NOTE !${BYELO} - ENTER ROOT PASSWORD :  ${RESET}"
read ROOT_PASSWORD
Info_Print "SETTING ROOT PASSWORD."
Setting_RootPassWd
echo

# CREATE USER ACCOUNT :
# ~~~~~~~~~~~~~~~~~~~~~
Creating_Account () {
    Spin 12 CREATING &
    PID=$!
    if 
        arch-chroot /mnt useradd -m -g users -G wheel,audio,video,storage,network,power,optical -c "${FULL_NAME}" -s /bin/bash "${USER_NAME}"
        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers; then
        sleep 1
        kill $PID
        Done_Print "CREATING USER ACCOUNT."
    else
        kill $PID
        Warn_Print "CREATING USER ACCOUNT."
        sleep 1
        exit 1
    fi
}

Info_Print "CREATING USER ACCOUNT."
Creating_Account
echo

# SET USER PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
Setting_AccountPassWd () {
    Spin 13 SETTING &
    PID=$!
    if 
        printf "%s\n%s" "${USER_PASSWORD}" "${USER_PASSWORD}" | arch-chroot /mnt passwd $USER_NAME &>> $LOGFILE; then
        sleep 1
        kill $PID
        Done_Print "SETTING USER PASSWORD."
    else
        kill $PID
        Warn_Print "SETTING USER PASSWORD."
        sleep 1
        exit 1
    fi
}

echo -en "${BCYAN}! NOTE !${BYELO} - ENTER USER PASSWORD :  ${RESET}"
read USER_PASSWORD
Info_Print "SETTING USER PASSWORD."
Setting_AccountPassWd
echo

# ENABLE SERVICES :
# ~~~~~~~~~~~~~~~~~
Enabling_Services () {
    Spin 8 ENABLING &
    PID=$!
    if 
        # arch-chroot /mnt systemctl enable systemd-timesyncd.service &>> $LOGFILE
        arch-chroot /mnt systemctl enable fstrim.timer &>> $LOGFILE
        arch-chroot /mnt systemctl enable paccache.timer &>> $LOGFILE
        arch-chroot /mnt systemctl enable reflector.timer &>> $LOGFILE
        # arch-chroot /mnt systemctl enable systemd-boot-update.service &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "ENABLING SERVICES."
    else
        kill $PID
        Warn_Print "ENABLING SERVICES."
        sleep 1
        exit 1
    fi
}

Info_Print "ENABLING SERVICES."
Enabling_Services
echo

# CREATING SWAP FILE :
# ~~~~~~~~~~~~~~~~~~~~
Creating_Swap () {
    Spin 9 CREATING &
    PID=$!
    if 
        if [[ "$SWAP" == "2" ]]; then
            dd if=/dev/zero of=/opt/swapfile bs=1M count=$(("$SWAP_SIZE" * 1024))
            chmod 600 /opt/swapfile
            mkswap /opt/swapfile
            swapon /opt/swapfile
            echo '/opt/swapfile none swap sw 0 0' | tee -a /etc/fstab
        fi
    then
        sleep 1
        kill $PID
        Done_Print "CREATING SWAP FILE."
    else
        kill $PID
        Warn_Print "CREATING SWAP FILE."
        sleep 1
        exit 1
    fi
}

Info_Print "CREATING SWAP FILE."
Creating_Swap
echo

# SET VM GUEST TOOLS :
# ~~~~~~~~~~~~~~~~~~~~
VM_Check

# COPY LOG FILE :
# ~~~~~~~~~~~~~~~
Coping_Logs () {
    Spin 8 COPING &
    PID=$!
    if 
        cp -r Installer.log /mnt/
    then
        sleep 1
        kill $PID
        Done_Print "COPING LOG FILE."
    else
        kill $PID
        Warn_Print "COPING LOG FILE."
        sleep 1
        exit 1
    fi
}

Info_Print "COPING LOG FILE."
Coping_Logs
echo