#!/bin/bash

# ---------------------------------------------------------- #
# Author : Bibhuti Bhushan                                   #
# Github : https://github.com/Bibhuti1221Bhushan/Installer   #
# ---------------------------------------------------------- #

# SET GENERAL VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~~~~
USERNAME="Bibhuti"                       # SET USER-NAME
NICKNAME="Bibhuti Bhushan"               # SET NICK-NAME
ROOTPASS="////"                          # SET ROOT-PASS
USERPASS="////"                          # SET USER-PASS
HOSTNAME="iTunes"                        # SET HOST-NAME
TIMEZONE="Asia/Kolkata"                  # SET TIME-ZONE
KEYBOARD="us"                            # SET KEYBOARDS
LOCALE="en_US.UTF-8"                     # SET AN LOCALE

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/sda                            # SET DISK FOR INSTALLATION

# SET PARTITION SIZE :
# ~~~~~~~~~~~~~~~~~~~~
BOOTSIZE=500                             # SET BOOT PARTITION SIZE ( NOTE - SIZE IS IN MB )
ROOTSIZE=50                              # SET ROOT PARTITION SIZE ( NOTE - SIZE IS IN GB )
HOMESIZE=                                # REMAINING SPACE FOR HOME PARTITION

# SET SWAP SIZE :
# ~~~~~~~~~~~~~~~
SWAP=2                                   # 0 = NO SWAP , 1 = SWAP PARTITION & 2 = SWAP FILE 
SWAPSIZE=8                               # SET SIZE OF SWAP PARTITION OR SWAP FILE ( NOTE - SIZE IS IN GB )

# SET BOOT LOADER :
# ~~~~~~~~~~~~~~~~~
BOOTLOADER=1                             # 0 = GRUB & 1 = SYSTEMD-BOOT

# SET PACKAGES :
# ~~~~~~~~~~~~~~
KERNEL="linux-lts"                       # SET KERNEL PACKAGES
PACKAGES="git neovim"                       # EXTRA PACKAGES LIKE EDITOR

# SET LOG FILE :
# ~~~~~~~~~~~~~~
LOGFILE="Installer.log"

# ---------------------------------------------------------- #
# -------------------- COSMETICS THINGS -------------------- #
# ---------------------------------------------------------- #

# COLOR VARIABLES :
# ~~~~~~~~~~~~~~~~~
BR="\e[1;31m"
BG="\e[1;32m"
BY="\e[1;33m"
BB="\e[1;34m"
BP="\e[1;35m"
BC="\e[1;36m"
NO="\e[0m"

# PRETTY PRINT FUNCTIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~~
_Info_Print () {
    echo -ne "\r${BCYAN}     $1${BREDD} - $2${RESET}\n"
    echo -e "# $1" &>> $LOGFILE
}

_Error_Print () {
    echo 
    tput civis
    echo -ne "\r${BG}     ! ERROR !${BB} - $1${NO}\n"
    read -n 1 -s -r _
    tput cnorm  
    exit 1
}

# TITLE PRINT FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~
_Title_Print () {
    COLUMNS=$(tput cols)
    SIZE=$1
    INDENT=$(( (COLUMNS - SIZE) / 2 ))
    PADDING=''
    for ((i=1; i<=INDENT; i++)) ; do
        PADDING+=' '
    done
    echo -e "${BP}${PADDING}${2}${NO}"
}

# SPIN FUNCTION :
# ~~~~~~~~~~~~~~~
Spin(){
    VAR="$1"
    case "$VAR" in
        3)  SPIN=("+==" "=+=" "==+" "=+=");
            ;;
        4)
            SPIN=("+===" "=+==" "==+=" "===+" "==+=" "=+==");
            ;;
        5)
            SPIN=("+====" "=+===" "==+==" "===+=" "====+" "===+=" "==+==" "=+===");
            ;;
    esac
    while [ 1 ]
      do
        for INTERVAL in ${SPIN[@]};
        do
          echo -ne "\r${BYELO}          ! WAIT ! - ${BBLUE}${2}${RESET}${BGREE} ${INTERVAL}${RESET}";
          sleep 0.3;
        done;
    done
}

# ---------------------------------------------------------- #
# -------------------- FUNCTIONS PRESET -------------------- #
# ---------------------------------------------------------- #

# DETECTING MICROCODE :
# ~~~~~~~~~~~~~~~~~~~~~
_Detcting_Microcode () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        MICROCODE="amd-ucode"
    elif [[ "$CPU" == *"GenuineIntel"* ]]; then
        MICROCODE="intel-ucode"
    fi
}

# OUTLINE MENU :
# ~~~~~~~~~~~~~~
_Checking_BMode_Complete=false
_Checking_Var_Complete=false
_Setting_DTime_Complete=false
_Configuring_Pacman_Complete=false
_Checking_Dep_Complete=false
_Wiping_Disks_Complete=false
_Creating_Partition_Complete=false
_Formating_Partition_Complete=false
_Mounting_Partition_Complete=false
_Installing_Base_Complete=false
_Generating_FSTab_Complete=false

_Configuring_Localization_Complete=false    # -- tzone locale lang console
_Configuring_NManager_Complete=false        # -- hosts hostname nm
_Configuring_PacManager_Complete=false      # -- pacman reflector
_Configuring_Extra_Complete=false              # -- extra stuff wdog shutdowntime initramfs
_Configuring_BLoader_Complete=false
_Installing_Packages_Complete=false
_Creating_SFile_Complete=false
_Setting_RPass_Complete=false
_Setting_User_Complete=false
_Coping_Logs_Complete=false

# DISPLAY INCOMPLETE/COMPLETE STEPS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_Install_Outline_Steps () {
    
    _Install_Title

    if [ "${_Checking_BMode_Complete}" = true ]; then
        echo -ne "\r${BC}     1.0  Checking Boot Mode${BG}              - [ Complete ]${NO}\n"                     
    else
        echo -ne "\r${BY}     1.0  Checking Boot Mode${BR}              - [ Incomplete ]${NO}\n"                     
    fi

    if [ "${_Checking_Var_Complete}" = true ]; then
        echo -ne "\r${BC}     1.1  Checking Variables${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.1  Checking Variables${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Setting_DTime_Complete}" = true ]; then
        echo -ne "\r${BC}     1.2  Setting Date & Time${BG}             - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.2  Setting Date & Time${BR}             - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Configuring_Pacman_Complete}" = true ]; then
        echo -ne "\r${BC}     1.3  Configuring Pacman${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.3  Configuring Pacman${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Checking_Dep_Complete}" = true ]; then
        echo -ne "\r${BC}     1.4  Checking Dependencies${BG}           - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.4  Checking Dependencies${BR}           - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Wiping_Disks_Complete}" = true ]; then
        echo -ne "\r${BC}     1.5  Wiping Disks${BG}                    - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.5  Wiping Disks${BR}                    - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Creating_Partition_Complete}" = true ]; then
        echo -ne "\r${BC}     1.6  Creating Partitions${BG}             - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.6  Creating Partitions${BR}             - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Formating_Partition_Complete}" = true ]; then
        echo -ne "\r${BC}     1.7  Formating Partitions${BG}            - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.7  Formating Partitions${BR}            - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Mounting_Partition_Complete}" = true ]; then
        echo -ne "\r${BC}     1.8  Mounting Partitions${BG}             - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.8  Mounting Partitions${BR}             - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Installing_Base_Complete}" = true ]; then
        echo -ne "\r${BC}     1.9  Installing Base Packages${BG}        - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     1.9  Installing Base Packages${BR}        - [ Incomplete ]${NO}\n"
    fi
     
    if [ "${_Generating_FSTab_Complete}" = true ]; then
        echo -ne "\r${BC}     2.0  Generating FSTab${BG}                - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.0  Generating FSTab${BR}                - [ Incomplete ]${NO}\n"
    fi

}

_Chroot_Outline_Steps () {

    _Chroot_Title
    
    if [ "${_Configuring_Localization_Complete}" = true ]; then
        echo -ne "\r${BC}     2.1  Configuring Localization${BG}    - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.1  Configuring Localization${BR}    - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Configuring_NManager_Complete}" = true ]; then
        echo -ne "\r${BC}     2.2  Configuring Network Manager${BG}            - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.2  Configuring Network Manager${BR}            - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Configuring_PacManager_Complete}" = true ]; then
        echo -ne "\r${BC}     2.3  Configuring Package Manager${BG}            - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.3  Configuring Package Manager${BR}            - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Configuring_Extra_Complete}" = true ]; then
        echo -ne "\r${BC}     2.4  Configuring Extra Stuff${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.4  Configuring Extra Stuff${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Configuring_BLoader_Complete}" = true ]; then
        echo -ne "\r${BC}     2.5  Configuring Boot Loader${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.5  Configuring Boot Loader${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Installing_Packages_Complete}" = true ]; then
        echo -ne "\r${BC}     2.6  Installing Extra Packages${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.6  Installing Extra Packages${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Creating_SFile_Complete}" = true ]; then
        echo -ne "\r${BC}     2.7  Creating Swap File${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.7  Creating Swap File${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Setting_RPass_Complete}" = true ]; then
        echo -ne "\r${BC}     2.8  Setting Root Password${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.8  Creating Root Password${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Setting_User_Complete}" = true ]; then
        echo -ne "\r${BC}     2.9  Setting User Account${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     2.9  Setting User Account${BR}              - [ Incomplete ]${NO}\n"
    fi

    if [ "${_Coping_Logs_Complete}" = true ]; then
        echo -ne "\r${BC}     3.0  Coping Logs File${BG}              - [ Complete ]${NO}\n"
    else
        echo -ne "\r${BY}     3.0  Coping Logs File${BR}              - [ Incomplete ]${NO}\n"
    fi
}

# ---------------------------------------------------------- #
# ----------------- SCRIPT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

# TITLE SHOW :
# ~~~~~~~~~~~~
_Install_Title () {
    echo
    _Title_Print 17 "╔═══════════════╗"
    _Title_Print 17 "║  ARCH INSTALL ║"
    _Title_Print 17 "╚═══════════════╝"
    echo
}

# CHECKING BOOT MODE :
# ~~~~~~~~~~~~~~~~~~~~
_Checking_BMode () {
    clear
    if [ ! -d /sys/firmware/efi/efivars ]; then
        _Install_Outline_Steps
        _Error_Print "YOU MUST BOOT INTO UEFI MODE."
    else
        _Checking_BMode_Complete=true
    fi    
}

_Checking_Vars () {
    clear
    _Install_Outline_Steps
    if [[ -z "$USERNAME"  ]]; then
        _Error_Print "SPECIFY VARIABLE USERNAME."
    elif [ -z "$NICKNAME" ]; then
        _Error_Print "SPECIFY VARIABLE NICKNAME."
    elif [ -z "$HOSTNAME" ]; then
        _Error_Print "SPECIFY VARIABLE HOSTNAME."
    elif [ -z "$TIMEZONE" ]; then
        _Error_Print "SPECIFY VARIABLE TIMEZONE."
    elif [ -z "$KEYBOARD" ]; then
        _Error_Print "SPECIFY VARIABLE KEYBOARD."
    elif [ -z "$LOCALE" ]; then
        _Error_Print "SPECIFY  VARIABLE  LOCALE."
    elif [[ ! $DISK =~ ^/dev/.* ]]; then
        _Error_Print "SPECIFY THE VARIABLE DISK."
    elif [[ $BOOTSIZE -lt 500 ]]; then
        _Error_Print "SPECIFY VARIABLE BOOTSIZE."
    elif [[ $ROOTSIZE -lt 5 ]]; then
        _Error_Print "SPECIFY VARIABLE ROOTSIZE."
    elif [[ $SWAP != 0 && $SWAP != 1 && $SWAP != 2 ]]; then
        _Error_Print "SPECIFY THE VARIABLE SWAP."
    elif [[ $SWAPSIZE -lt 2 ]];  then
        _Error_Print "SPECIFY VARIABLE SWAPSIZE."
    elif [[ $BOOTLOADER != 0 && $BOOTLOADER != 1 ]]; then
        _Error_Print "SPECIFY THE VARIABLE BOOTLOADER."
    elif [[ ! $KERNEL == linux* ]]; then
        _Error_Print "SPECIFY THE VARIABLE KERNEL."
    else
        _Checking_Var_Complete=true
    fi
}

_Setting_DTime () {
    clear
    _Install_Outline_Steps
    if
        timedatectl set-ntp true &>> $LOGFILE
    then
        _Setting_DTime_Complete=true
    else
        _Error_Print "SYNCING TIME AND DATE."
    fi
}

_Configuring_Pacman () {
    clear
    _Install_Outline_Steps
    if
        # systemctl restart pacman-init &>> $LOGFILE
        # killall gpg-agent &>> $LOGFILE
        # rm -rf /etc/pacman.d/gnupg/ &>> $LOGFILE
        # pacman-key --init &>> $LOGFILE
        # pacman-key --populate archlinux &>> $LOGFILE
        sed -i 's/#Color/Color\nILoveCandy/' /etc/pacman.conf &>> $LOGFILE
        sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf &>> $LOGFILE
        sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf &>> $LOGFILE
        sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf &>> $LOGFILE
    then
        _Configuring_Pacman_Complete=true
    else
        _Error_Print "CONFIGURING PACMAN."
    fi
}

_Checking_Dep () {
    clear
    _Install_Outline_Steps
    if
        pacman -Sy --noconfirm --disable-download-timeout archlinux-keyring &>> $LOGFILE
    then
        _Checking_Dep_Complete=true
    else
        _Error_Print "CHECKING DEPENDENCIES."
    fi
}

_Wiping_Disks () {
    clear
    _Install_Outline_Steps
    if
        echo
        wipefs -af "$DISK" &> $LOGFILE
        sleep 0.5
        sgdisk -Zo "$DISK" &>> $LOGFILE
        sleep 0.5
    then
        _Wiping_Disks_Complete=true
    else
        _Error_Print "WIPE DISK."
    fi
}

_Creating_Partition () {
    clear
    _Install_Outline_Steps
    if
        if [[ "$SWAP" == "1" ]]; then
            parted "$DISK" -s mklabel gpt &>> $LOGFILE
            parted "$DISK" -s mkpart ESP fat32 1MiB "$BOOTSIZE"M &>> $LOGFILE
            parted "$DISK" -s mkpart SWAP linux-swap "$BOOTSIZE"M "$SWAPSIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart ROOT ext4 "$SWAPSIZE"G "$ROOTSIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart HOME ext4 "$ROOTSIZE"G 100% &>> $LOGFILE
            parted "$DISK" -s set 1 esp on &>> $LOGFILE
            parted "$DISK" -s set 2 swap on &>> $LOGFILE
            parted "$DISK" -s set 3 root on &>> $LOGFILE
            parted "$DISK" -s set 4 linux-home on &>> $LOGFILE
        else
            parted "$DISK" -s mklabel gpt &>> $LOGFILE
            parted "$DISK" -s mkpart ESP fat32 1MiB "$BOOTSIZE"M &>> $LOGFILE
            parted "$DISK" -s mkpart ROOT ext4 "$BOOTSIZE"M "$ROOTSIZE"G &>> $LOGFILE
            parted "$DISK" -s mkpart HOME ext4 "$ROOTSIZE"G 100% &>> $LOGFILE
            parted "$DISK" -s set 1 esp on &>> $LOGFILE
            parted "$DISK" -s set 2 root on &>> $LOGFILE
            parted "$DISK" -s set 3 linux-home on &>> $LOGFILE
        fi
    then    
        _Creating_Partition_Complete=true
    else
        _Error_Print "CREATING PARTITIONS."
    fi
}

_Formating_Partition () {
    clear
    _Install_Outline_Steps
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
        _Formating_Partition_Complete=true
    else
        _Error_Print "FORMATTING PARTITIONS."
    fi
}

_Mounting_Partition () {
    clear
    _Install_Outline_Steps
    if
        if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
                mount -v "$DISK"p3 /mnt
                mount --mkdir -v "$DISK"p1 /mnt/boot &>> $LOGFILE
                mount --mkdir -v "$DISK"p4 /mnt/home &>> $LOGFILE
                swapon -v "$DISK"p2 &>> $LOGFILE
            else
                mount -v "$DISK"p2 /mnt
                mount --mkdir -v "$DISK"p1 /mnt/boot &>> $LOGFILE
                mount --mkdir -v "$DISK"p3 /mnt/home &>> $LOGFILE
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                mount -v "$DISK"3 /mnt &>> $LOGFILE
                mount --mkdir -v "$DISK"1 /mnt/boot &>> $LOGFILE
                mount --mkdir -v "$DISK"4 /mnt/home &>> $LOGFILE
                swapon -v "$DISK"2 &>> $LOGFILE
            else
                mount -v "$DISK"2 /mnt &>> $LOGFILE
                mount --mkdir -v "$DISK"1 /mnt/boot &>> $LOGFILE
                mount --mkdir -v "$DISK"3 /mnt/home &>> $LOGFILE
            fi
        fi
    then
        _Mounting_Partition_Complete=true
    else
        _Error_Print "MOUNTING PARTITIONS."
    fi
}

_Installing_Base () {
    clear
    _Install_Outline_Steps
    if
        pacstrap -K /mnt --noconfirm --disable-download-timeout base base-devel linux-firmware $KERNEL $KERNEL-headers $MICROCODE &>> $LOGFILE
    then
        _Installing_Base_Complete=true
    else
        _Error_Print "INSTALLING BASE SYSTEM."
    fi
}

_Generating_FSTab () {
    clear
    _Install_Outline_Steps
    if
        genfstab -U /mnt >> /mnt/etc/fstab &>> $LOGFILE
    then
        _Generating_FSTab_Complete=true
    else
        _Error_Print "GENERATING FSTAB."
    fi
}

_Installing () {
    _Checking_BMode
    _Checking_Vars
    _Setting_DTime
    _Configuring_Pacman
    _Checking_Dep
    _Wiping_Disks
    _Creating_Partition
    _Formating_Partition
    _Mounting_Partition
    _Installing_Base
    _Generating_FSTab
    clear
    _Install_Outline_Steps
}

_Installing


# ---------------------------------------------------------- #
# ----------------- CHROOT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

_Chroot_Title () {
    echo
    _Title_Print 17 "╔═══════════════╗"
    _Title_Print 17 "║  ARCH CHROOT  ║"
    _Title_Print 17 "╚═══════════════╝"
    echo
}

_Configuring_Localization () {
    clear
    if
        arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &>> $LOGFILE
        arch-chroot /mnt hwclock --systohc &>> $LOGFILE
        
        arch-chroot /mnt sed -i "s/#$LOCALE/$LOCALE/g" /etc/locale.gen
        arch-chroot /mnt locale-gen &>> $LOGFILE

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
        echo "LC_TIME=$LOCALE" >> /mnt/etc/locale.conf

        echo "KEYMAP=$KEYBOARD" > /mnt/etc/vconsole.conf
        echo "XKBLAYOUT=$KEYBOARD" >> /mnt/etc/vconsole.conf

    then
        _Configuring_Localization_Complete=true
    else
        _Error_Print "CONFIGURING LOCALIZATION."
    fi
}

_Configuring_NManager () {
    clear
    _Chroot_Outline_Steps
    if
        echo "$HOSTNAME" > /mnt/etc/hostname
        
        echo "127.0.0.1      localhost" >> /mnt/etc/hosts
        echo "::1            localhost" >> /mnt/etc/hosts
        echo "127.0.1.1      $HOSTNAME.localdomain     $HOSTNAME" >> /mnt/etc/hosts

        arch-chroot /mnt pacman -S --noconfirm networkmanager &>> $LOGFILE
        arch-chroot /mnt systemctl enable NetworkManager &>> $LOGFILE
    then
        _Configuring_NManager_Complete=true
    else
        _Error_Print "CONFIGURING NETWORK MANAGER."
    fi
}

_Configuring_PacManager () {
    clear
    _Chroot_Outline_Steps
    if
        sed -i 's/#Color/Color\nILoveCandy/' /mnt/etc/pacman.conf &>> $LOGFILE
        sed -i '/\[multilib\]/,/Include/s/^#//' /mnt/etc/pacman.conf &>> $LOGFILE
        sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /mnt/etc/pacman.conf &>> $LOGFILE
        sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /mnt/etc/pacman.conf &>> $LOGFILE

        arch-chroot /mnt pacman -Sy --noconfirm reflector &>> $LOGFILE
        arch-chroot /mnt reflector --save /etc/pacman.d/mirrorlist --download-timeout 60 --protocol https --country India,Singapore --age 20 --sort rate --verbose &>> $LOGFILE
        echo "--save /etc/pacman.d/mirrorlist" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--country India,Singapore" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--download-timeout 60" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--protocol https" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--sort rate" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--age 20" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--verbose" > /mnt/etc/xdg/reflector/reflector.conf

    then
        _Configuring_PacManager_Complete=true
    else
        _Error_Print "CONFIGURING PACKAGE MANAGER."
    fi
}

_Configuring_Extra () {
    clear
    _Chroot_Outline_Steps
    if
        echo "blacklist iTCO_wdt" > /mnt/etc/modprobe.d/nowatchdog.conf
        sed -i "s/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=10s/" /mnt/etc/systemd/system.conf

        arch-chroot /mnt mkinitcpio -P &>> $LOGFILE
    then
        _Configuring_Extra_Complete=true
    else
        _Error_Print "CONFIGURING EXTRA STUFF."
    fi
}

_Configuring_BLoader () {
    clear
    _Chroot_Outline_Steps
    if
        if [[ "$BOOTLOADER" == "1" ]]; then
            arch-chroot /mnt bootctl install --esp-path=/boot/ &>> $LOGFILE
            echo "default arch.conf" >> /mnt/boot/loader/loader.conf
            echo "timeout 0" >> /mnt/boot/loader/loader.conf
            echo "title   Arch Linux" >> /mnt/boot/loader/entries/arch.conf
            echo "linux   /vmlinuz-$KERNEL" >> /mnt/boot/loader/entries/arch.conf
            echo "initrd  /$MICROCODE.img" >> /mnt/boot/loader/entries/arch.conf
            echo "initrd  /initramfs-$KERNEL.img" >> /mnt/boot/loader/entries/arch.conf
            if [[ $DISK =~ ^/dev/nvme.* ]]; then
                if [[ "$SWAP" == "1" ]]; then
                   echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}p3) quiet splash rw" >> /mnt/boot/loader/entries/arch.conf
                else
                   echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}p2) quiet splash rw" >> /mnt/boot/loader/entries/arch.conf
                fi
            else
                if [[ "$SWAP" == "1" ]]; then
                    echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}3) quiet splash rw" >> /mnt/boot/loader/entries/arch.conf
                else
                    echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}2) quiet splash rw" >> /mnt/boot/loader/entries/arch.conf
                fi
            fi
        else
            arch-chroot /mnt pacman -S --noconfirm grub efibootmgr &>> $LOGFILE
            arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id="Boot Manager" --recheck &>> $LOGFILE
            arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg &>> $LOGFILE
        fi

    then
        _Configuring_BLoader_Complete=true
    else
        _Error_Print "CONFIGURING BOOT LOADER."
    fi
}

_Installing_Packages () {
    clear
    _Chroot_Outline_Steps
    if
        arch-chroot /mnt pacman -S --noconfirm $PACKAGES &>> $LOGFILE
    then
        _Installing_Packages_Complete=true
    else
        _Error_Print "INSTALLING PACKAGES."
    fi
}

_Creating_SFile () {
    clear
    _Chroot_Outline_Steps
    if
        if [[ "$SWAP" == "2" ]]; then
            mkdir -vp /mnt/swap &>> $LOGFILE
            arch-chroot /mnt dd if=/dev/zero of=/swap/swapfile bs=1M count=$(("$SWAPSIZE" * 1024)) &>> $LOGFILE
            arch-chroot /mnt chmod 600 /swap/swapfile &>> $LOGFILE
            arch-chroot /mnt mkswap /swap/swapfile &>> $LOGFILE
            arch-chroot /mnt swapon /swap/swapfile &>> $LOGFILE
            echo '/swap/swapfile                      none       swap       sw 0 0' | tee -a /mnt/etc/fstab &>> $LOGFILE
        fi
    then
        _Creating_SFile_Complete=true
    else
        _Error_Print "CREATING SWAP FILE."
    fi
}

_Setting_RPass () {
    clear
    _Chroot_Outline_Steps
    if
        printf "%s\n%s" "${ROOTPASSWORD}" "${ROOTPASSWORD}" | arch-chroot /mnt passwd &>> $LOGFILE
    then
        _Setting_RPass_Complete=true
    else
        _Error_Print "SETTING ROOT PASSWORD."
    fi
}

_Setting_User () {
    clear
    _Chroot_Outline_Steps
    if
        arch-chroot /mnt useradd -mG wheel,audio,video,storage,network,power,optical -c "${NICKNAME}" -s "${which bash}" "${USERNAME}"
        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers

        printf "%s\n%s" "${USERPASSWORD}" "${USERPASSWORD}" | arch-chroot /mnt passwd $USERNAME &>> $LOGFILE
    then
        _Setting_User_Complete=true
    else
        _Error_Print "SETTING USER."
    fi
}

_Coping_Logs () {
    clear
    _Chroot_Outline_Steps
    if
        cp Installer.log /mnt/home/$USERNAME &>> $LOGFILE
    then
        _Coping_Logs_Complete=true
    else
        _Error_Print "COPING LOGS."
    fi
}

_Chrooting () {
    _Configuring_Localization
    _Configuring_NManager
    _Configuring_PacManager
    _Configuring_Extra
    _Configuring_BLoader
    _Installing_Packages
    _Creating_SFile
    _Setting_RPass
    _Setting_User
    _Coping_Logs
    clear
    _Chroot_Outline_Steps
}

_Chrooting