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
BOOTSIZE=550                            # SET BOOT PARTITION SIZE ( NOTE - SIZE IS IN MB )
ROOTSIZE=15                             # SET ROOT PARTITION SIZE ( NOTE - SIZE IS IN GB )
HOMESIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET SWAP SIZE :
# ~~~~~~~~~~~~~~~
SWAP=2                                   # 0 = NO SWAP , 1 = SWAP PARTITION & 2 = SWAP FILE 
SWAPSIZE=2                              # SET SIZE OF SWAP PARTITION OR SWAP FILE ( NOTE - SIZE IS IN GB )

# SET BOOT LOADER :
# ~~~~~~~~~~~~~~~~~
BOOTLOADER=1                            # 0 = GRUB & 1 = SYSTEMD-BOOT

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
        Warn_Print "SPECIFY VARIABLE USERNAME."
        exit 1
    elif [ -z "$NICKNAME" ]; then
        Warn_Print "SPECIFY VARIABLE NICKNAME."
        exit 1
    elif [ -z "$HOSTNAME" ]; then
        Warn_Print "SPECIFY VARIABLE HOSTNAME."
        exit 1
    elif [ -z "$TIMEZONE" ]; then
        Warn_Print "SPECIFY VARIABLE TIMEZONE."
        exit 1
    elif [ -z "$KEYBOARD" ]; then
        Warn_Print "SPECIFY VARIABLE KEYBOARD."
        exit 1
    elif [ -z "$LOCALE" ]; then
        Warn_Print "SPECIFY  VARIABLE  LOCALE."
        exit 1
    elif [[ ! $DISK =~ ^/dev/.* ]]; then
        Warn_Print "SPECIFY THE VARIABLE DISK."
        exit 1
    elif [[ $BOOT_SIZE -lt 500 ]]; then
        Warn_Print "SPECIFY VARIABLE BOOTSIZE."
        exit 1
    elif [[ $ROOT_SIZE -lt 5 ]]; then
        Warn_Print "SPECIFY VARIABLE ROOTSIZE."
        exit 1
    elif [[ $SWAP != 0 && $SWAP != 1 && $SWAP != 2 ]]; then
        Warn_Print "SPECIFY THE VARIABLE SWAP."
        exit 1
    elif [[ $SWAP_SIZE -lt 2 ]];  then
        Warn_Print "SPECIFY VARIABLE SWAPSIZE."
        exit 1
    elif [[ ! $KERNEL == linux* ]]; then
        Warn_Print "SPECIFY  VARIABLE  KERNEL."
        exit 1
    fi
    Done_Print "CHECKING NEEDED VARIABLES."
}

Info_Print "CHECKING NEEDED VARIABLES."
Variable_Checking
echo "" &>> $LOGFILE

# SYNC TIME AND DATE :
# ~~~~~~~~~~~~~~~~~~~~
Setting_DTime () {
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
Setting_DTime
echo "" &>> $LOGFILE

# INITIALISING KEYRING :
# ~~~~~~~~~~~~~~~~~~~~~~
Initialising_KRings () {
    Spin 8 INITIALISING &
    PID=$!
    if
        pacman-key --init &>> $LOGFILE
        pacman-key --populate &>> $LOGFILE
        pacman -Sy --noconfirm --disable-download-timeout archlinux-keyring &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "INITIALISING KEYRINGS."
    else
        kill $PID
        Warn_Print "INITIALISING KEYRINGS."
        exit 1
    fi
}

Info_Print "INITIALISING KEYRINGS."
Initialising_KRings
echo "" &>> $LOGFILE

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
echo "" &>> $LOGFILE


# PARTITION THE DISK :
# ~~~~~~~~~~~~~~~~~~~~
Creating_Partition () {
    Spin 10 CREATING &
    PID=$!
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
echo "" &>> $LOGFILE


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
echo "" &>> $LOGFILE

# MOUNT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~
Mounting_Partition () {
    Spin 10 MOUNTING &
    PID=$!
    if
        if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
                mount -v "$DISK"p3 /mnt
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount -v "$DISK"p1 /mnt/boot
                mkdir -vp /mnt/home &>> $LOGFILE
                mount -v "$DISK"p4 /mnt/home
                swapon -v "$DISK"p2 &>> $LOGFILE
            else
                mount -v "$DISK"p2 /mnt
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount -v "$DISK"p1 /mnt/boot
                mkdir -vp /mnt/home &>> $LOGFILE
                mount -v "$DISK"p3 /mnt/home
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                mount -v "$DISK"3 /mnt &>> $LOGFILE
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount -v "$DISK"1 /mnt/boot &>> $LOGFILE
                mkdir -vp /mnt/home &>> $LOGFILE
                mount -v "$DISK"4 /mnt/home &>> $LOGFILE
                swapon -v "$DISK"2 &>> $LOGFILE
            else
                mount -v "$DISK"2 /mnt &>> $LOGFILE
                mkdir -vp /mnt/boot &>> $LOGFILE
                mount -v "$DISK"1 /mnt/boot &>> $LOGFILE
                mkdir -vp /mnt/home &>> $LOGFILE
                mount -v "$DISK"3 /mnt/home &>> $LOGFILE
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
echo "" &>> $LOGFILE

# DETECT MICROCODE :
# ~~~~~~~~~~~~~~~~~~
Microcode_Detect () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        MICROCODE="amd-ucode"
    elif [[ "$CPU" == *"GenuineIntel"* ]]; then
        MICROCODE="intel-ucode"
    fi
}

Microcode_Detect

# INSTALLING BASE SYSTEM :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Installing_Base () {
    Spin 11 INSTALLING &
    PID=$!
    if
        pacstrap -K /mnt --noconfirm --disable-download-timeout base base-devel linux-firmware $KERNEL $KERNEL-headers $MICROCODE &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "INSTALLING BASE SYSTEM."
    else
        kill $PID
        Warn_Print "INSTALLING BASE SYSTEM."
        exit 1
    fi
}

Info_Print "INSTALLING BASE SYSTEM."
Installing_Base
echo "" &>> $LOGFILE

# GENERATE THE FSTAB FILE :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Generating_FTab () {
    Spin 10 GENERATING &
    PID=$!
    if
        genfstab -U /mnt >> /mnt/etc/fstab &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "GENERATING FSTAB FILE."
    else
        kill $PID
        Warn_Print "GENERATING FSTAB FILE."
        exit 1
    fi
}

Info_Print "GENERATING FSTAB FILE."
Generating_FTab
echo "" &>> $LOGFILE

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
        arch-chroot /mnt hwclock --systohc &>> $LOGFILE
    then
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
echo "" &>> $LOGFILE

# GENERATE LOCALE :
# ~~~~~~~~~~~~~~~~~
Generating_Locale () {
    Spin 6 GENERATING &
    PID=$!
    if
        arch-chroot /mnt sed -i "s/#$LOCALE/$LOCALE/g" /etc/locale.gen
        arch-chroot /mnt locale-gen &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "GENERATING LOCALE."
    else
        kill $PID
        Warn_Print "GENERATING LOCALE."
        exit 1
    fi
}

Info_Print "GENERATING LOCALE."
Generating_Locale
echo "" &>> $LOGFILE

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
        echo "LC_TIME=$LOCALE" >> /mnt/etc/locale.conf
    then
        sleep 1
        kill $PID
        Done_Print "SETTING LOCALE UNITS."
    else
        kill $PID
        Warn_Print "SETTING LOCALE UNITS."
        exit 1
    fi
}

Info_Print "SETTING LOCALE UNITS."
Setting_Locale
echo "" &>> $LOGFILE

# SET HOST-NAME :
# ~~~~~~~~~~~~~~~
Setting_Hostname () {
    Spin 9 SETTING &
    PID=$!
    if
        echo "$HOSTNAME" > /mnt/etc/hostname
    then
        sleep 1
        kill $PID
        Done_Print "SETTING HOST-NAME."
    else
        kill $PID
        Warn_Print "SETTING HOST-NAME."
        exit 1
    fi
}

Info_Print "SETTING HOST-NAME."
Setting_Hostname
echo "" &>> $LOGFILE

# SET HOSTS :
# ~~~~~~~~~~~
Setting_Hosts () {
    Spin 10 SETTING &
    PID=$!
    if
        echo "127.0.0.1      localhost" >> /mnt/etc/hosts
        echo "::1            localhost" >> /mnt/etc/hosts
        echo "127.0.1.1      $HOSTNAME.localdomain     $HOSTNAME" >> /mnt/etc/hosts
    then
        sleep 1
        kill $PID
        Done_Print "SETTING HOSTS FILE."
    else
        kill $PID
        Warn_Print "SETTING HOSTS FILE."
        exit 1
    fi
}

Info_Print "SETTING HOSTS FILE."
Setting_Hosts
echo "" &>> $LOGFILE

# SET CONSOLE KEYMAP :
# ~~~~~~~~~~~~~~~~~~~~
Setting_Console () {
    Spin 14 SETTING &
    PID=$!
    if
        echo "KEYMAP=$KEYBOARD" > /mnt/etc/vconsole.conf
        echo "XKBLAYOUT=$KEYBOARD" >> /mnt/etc/vconsole.conf
    then
        sleep 1
        kill $PID
        Done_Print "SETTING CONSOLE KEYMAP."
    else
        kill $PID
        Warn_Print "SETTING CONSOLE KEYMAP."
        exit 1
    fi
}

Info_Print "SETTING CONSOLE KEYMAP."
Setting_Console
echo "" &>> $LOGFILE

# EDIT PACMAN CONFIG:
# ~~~~~~~~~~~~~~~~~~~
Editing_Pacman () {
    Spin 13 EDITING &
    PID=$!
    if
        sed -i 's/#Color/Color\nILoveCandy/' /etc/pacman.conf
        sed -i '/\[multilib\]/,/Include/s/^#//' /mnt/etc/pacman.conf
        sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /mnt/etc/pacman.conf
        sed -i 's/^#ParallelDownloads/ParallelDownloads/' /mnt/etc/pacman.conf
        arch-chroot /mnt pacman -Sy --noconfirm &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "EDITING PACMAN CONFIG."
    else
        kill $PID
        Warn_Print "EDITING PACMAN CONFIG."
        exit 1
    fi
}

Info_Print "EDITING PACMAN CONFIG."
Editing_Pacman
echo "" &>> $LOGFILE

# SYNC FASTEST MIRRORS :
# ~~~~~~~~~~~~~~~~~~~~~~
Setting_Reflector () {
    Spin 15 SYNCING &
    PID=$!
    if
        arch-chroot /mnt pacman -S --noconfirm reflector &>> $LOGFILE
        arch-chroot /mnt reflector --save /etc/pacman.d/mirrorlist --download-timeout 60 --protocol https --country India --sort rate --verbose &>> $LOGFILE
        echo "--save /etc/pacman.d/mirrorlist" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--download-timeout 60" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--protocol https" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--country India" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--sort rate" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--verbose" > /mnt/etc/xdg/reflector/reflector.conf
    then
        sleep 1
        kill $PID
        Done_Print "SYNCING FASTEST MIRRORS."
    else
        kill $PID
        Warn_Print "SYNCING FASTEST MIRRORS."
        exit 1
    fi
}

Info_Print "SYNCING FASTEST MIRRORS."
Setting_Reflector
echo "" &>> $LOGFILE

# SET NETWORK MANAGER :
# ~~~~~~~~~~~~~~~~~~~~~
Setting_NManager () {
    Spin 15 SETTING &
    PID=$!
    if
        arch-chroot /mnt pacman -S --noconfirm networkmanager &>> $LOGFILE
        arch-chroot /mnt systemctl enable NetworkManager &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "SETTING NETWORK MANAGER."
    else
        kill $PID
        Warn_Print "SETTING NETWORK MANAGER."
        exit 1
    fi
}

Info_Print "SETTING NETWORK MANAGER."
Setting_NManager
echo "" &>> $LOGFILE

# NO WATCH-DOG :
# ~~~~~~~~~~~~~~
Disabling_WDog () {
    Spin 13 DISABLING &
    PID=$!
    if
        echo "blacklist iTCO_wdt" > /mnt/etc/modprobe.d/nowatchdog.conf
    then
        sleep 1
        kill $PID
        Done_Print "DISABLING WATCH-DOG LOG."
    else
        kill $PID
        Warn_Print "DISABLING WATCH-DOG LOG."
        exit 1
    fi
}

Info_Print "DISABLING WATCH-DOG LOG."
Disabling_WDog
echo "" &>> $LOGFILE

# REDUCE SHUTDOWN TIME :
# ~~~~~~~~~~~~~~~~~~~~~~
Reducing_STime () {
    Spin 13 REDUCING &
    PID=$!
    if
        sed -i "s/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=10s/" /mnt/etc/systemd/system.conf
    then
        sleep 1
        kill $PID
        Done_Print "REDUCING SHUTDOWN TIME."
    else
        kill $PID
        Warn_Print "REDUCING SHUTDOWN TIME."
        exit 1
    fi
}

Info_Print "REDUCING SHUTDOWN TIME."
Reducing_STime
echo "" &>> $LOGFILE

# RE-INITIALIZE INITRAMFS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Initialising_Kernel () {
    Spin 9 RE-INITIALISING &
    PID=$!
    if
        arch-chroot /mnt mkinitcpio -P &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "RE-INITIALISING INITRAMFS."
    else
        kill $PID
        Warn_Print "RE-INITIALISING INITRAMFS."
        exit 1
    fi
}

Info_Print "RE-INITIALISING INITRAMFS."
Initialising_Kernel
echo "" &>> $LOGFILE

# SET BOOT LOADER :
# ~~~~~~~~~~~~~~~~~
Setting_BLoader () {
    Spin 11 SETTING &
    PID=$!
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
                   echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}p3) rw" >> /mnt/boot/loader/entries/arch.conf
                else
                   echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}p2) rw" >> /mnt/boot/loader/entries/arch.conf
                fi
            else
                if [[ "$SWAP" == "1" ]]; then
                    echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}3) rw" >> /mnt/boot/loader/entries/arch.conf
                else
                    echo "options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISK}2) rw" >> /mnt/boot/loader/entries/arch.conf
                fi
            fi
        else
            arch-chroot /mnt pacman -S --noconfirm grub efibootmgr &>> $LOGFILE
            arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id="Boot Manager" --recheck &>> $LOGFILE
            arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "SETTING BOOT LOADER."
    else
        kill $PID
        Warn_Print "SETTING BOOT LOADER."
        exit 1
    fi
}

Info_Print "SETTING BOOT LOADER."
Setting_BLoader
echo "" &>> $LOGFILE

# INSTALL PACKAGES :
# ~~~~~~~~~~~~~~~~~~
Installing_Extra () {
    Spin 14 INSTALLING &
    PID=$!
    if
        arch-chroot /mnt pacman -S --noconfirm $EXTRA &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "INSTALLING EXTRA PACKAGES."
    else
        kill $PID
        Warn_Print "INSTALLING EXTRA PACKAGES."
        exit 1
    fi
}
Info_Print "INSTALLING EXTRA PACKAGES."
Installing_Extra
echo "" &>> $LOGFILE

# SET ROOT PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
Setting_RPassWd () {
    Spin 13 SETTING &
    PID=$!
    if
        printf "%s\n%s" "${ROOTPASSWORD}" "${ROOTPASSWORD}" | arch-chroot /mnt passwd &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "SETTING ROOT PASSWORD."
    else
        kill $PID
        Warn_Print "SETTING ROOT PASSWORD."
        exit 1
    fi
}

echo -en "${BCYAN}! NOTE !${BYELO} - ENTER ROOT PASSWORD :  ${RESET}"
read ROOTPASSWORD
Info_Print "SETTING ROOT PASSWORD."
Setting_RPassWd
echo "" &>> $LOGFILE

# CREATE USER ACCOUNT :
# ~~~~~~~~~~~~~~~~~~~~~
Creating_Account () {
    Spin 12 CREATING &
    PID=$!
    if
        groupadd libvirt
        arch-chroot /mnt useradd -m -G wheel,audio,video,storage,network,power,optical,libvirt -c "${NICKNAME}" -s /bin/bash "${USERNAME}"
        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers
    then
        sleep 1
        kill $PID
        Done_Print "CREATING USER ACCOUNT."
    else
        kill $PID
        Warn_Print "CREATING USER ACCOUNT."
        exit 1
    fi
}

Info_Print "CREATING USER ACCOUNT."
Creating_Account
echo "" &>> $LOGFILE

# SET USER PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
Setting_UPassWd () {
    Spin 13 SETTING &
    PID=$!
    if
        printf "%s\n%s" "${USERPASSWORD}" "${USERPASSWORD}" | arch-chroot /mnt passwd $USERNAME &>> $LOGFILE
    then
        sleep 1
        kill $PID
        Done_Print "SETTING USER PASSWORD."
    else
        kill $PID
        Warn_Print "SETTING USER PASSWORD."
        exit 1
    fi
}

echo -en "${BCYAN}! NOTE !${BYELO} - ENTER USER PASSWORD :  ${RESET}"
read USERPASSWORD
Info_Print "SETTING USER PASSWORD."
Setting_UPassWd
echo "" &>> $LOGFILE

# CREATING SWAP FILE :
# ~~~~~~~~~~~~~~~~~~~~
Creating_SFile () {
    Spin 9 CREATING &
    PID=$!
    if
        if [[ "$SWAP" == "2" ]]; then
            mkdir -vp /mnt/swap &>> $LOGFILE
            arch-chroot /mnt dd if=/dev/zero of=/swap/swapfile bs=1M count=$(("$SWAPSIZE" * 1024)) &>> $LOGFILE
            arch-chroot /mnt chmod 600 /swap/swapfile &>> $LOGFILE
            arch-chroot /mnt mkswap /swap/swapfile &>> $LOGFILE
            arch-chroot /mnt swapon /swap/swapfile &>> $LOGFILE
            echo '/swap/swapfile none swap sw 0 0' | tee -a /mnt/etc/fstab &>> $LOGFILE
        fi
    then
        sleep 1
        kill $PID
        Done_Print "CREATING SWAP FILE."
    else
        kill $PID
        Warn_Print "CREATING SWAP FILE."
        exit 1
    fi
}

Info_Print "CREATING SWAP FILE."
Creating_SFile
echo "" &>> $LOGFILE

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
        exit 1
    fi
}

Info_Print "COPING LOG FILE."
Coping_Logs
echo "" &>> $LOGFILE