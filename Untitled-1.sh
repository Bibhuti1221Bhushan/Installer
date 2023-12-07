#!/bin/bash

# ---------------------------------------------------------- #
# ------------------- SET SOME VARIABLES ------------------- #
# ---------------------------------------------------------- #

# SET GENERAL VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~~~~
USERNAME="Bibhuti"                       # SET USER-NAME
NICKNAME="Bibhuti Bhushan"               # SET NICK-NAME
ROOTPASS="////"                          # SET ROOT-PASS
USERPASS="////"                          # SET USER-PASS
HOSTNAME="iTunes"                        # SET HOST-NAME
TIMEZONE="Asia/Kolkata"                  # SET TIME-ZONE
LOCALE="en_US.UTF-8"                     # SET AN LOCALE
KEYMAP="us"                              # SET AN KEYMAP

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
    echo -ne "\r${BCYAN}          ! NOTE !${BYELO} - $1${RESET}\n"
    echo -e "# $1" &>> $LOGFILE
}

Done_Print () {
    echo -ne "\r${BGREE}          ! DONE !${BBLUE} - $1${RESET}\n"
}

Warn_Print () {
    echo -ne "\r${BBLUE}          ! WARN !${BREDD} - $1${RESET}\n\n"
    sleep 5
    exit 1
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
    local pid=$1
    local spinstr='====+'
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}
        echo -ne "\r${BYELO}          ! WAIT ! - ${BBLUE}${3}${RESET}${BGREE} ${spinstr}${RESET}";
        # echo -ne "\r ! WAIT ! - $3 $spinstr";
        local spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# ---------------------------------------------------------- #
# ----------------- SCRIPT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
clear
printf '\e[?25l\e[?7l'

# TITLE SHOW :
# ~~~~~~~~~~~~
echo
Title_Print 17 "╔═══════════════╗"
Title_Print 17 "║  ARCH INSTALL ║"
Title_Print 17 "╚═══════════════╝"
echo

# VERIFY BOOT MODE :
# ~~~~~~~~~~~~~~~~~~
if [ ! -d /sys/firmware/efi/efivars ]; then
    Warn_Print "YOU ARE NOT BOOTED IN UEFI."
    echo
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
    elif [ -z "$KEYMAP" ]; then
        Warn_Print "SPECIFY VARIABLE KEYBOARD."
        exit 1
    elif [ -z "$LOCALE" ]; then
        Warn_Print "SPECIFY  VARIABLE  LOCALE."
        exit 1
    elif [[ ! $DISK =~ ^/dev/.* ]]; then
        Warn_Print "SPECIFY THE VARIABLE DISK."
        exit 1
    elif [[ $BOOTSIZE -lt 500 ]]; then
        Warn_Print "SPECIFY VARIABLE BOOTSIZE."
        exit 1
    elif [[ $ROOTSIZE -lt 5 ]]; then
        Warn_Print "SPECIFY VARIABLE ROOTSIZE."
        exit 1
    elif [[ $SWAP != 0 && $SWAP != 1 && $SWAP != 2 ]]; then
        Warn_Print "SPECIFY THE VARIABLE SWAP."
        exit 1
    elif [[ $SWAPSIZE -lt 2 ]];  then
        Warn_Print "SPECIFY VARIABLE SWAPSIZE."
        exit 1
    elif [[ $BOOTLOADER != 0 && $BOOTLOADER != 1 ]]; then
        Warn_Print "SPECIFY  VAR.  BOOTLOADER."
        exit 1
    elif [[ ! $KERNEL == linux* ]]; then
        Warn_Print "SPECIFY  VARIABLE  KERNEL."
        exit 1
    fi
    Done_Print "CHECKING NEEDED VARIABLES."
}

Info_Print "CHECKING NEEDED VARIABLES."
Variable_Checking
echo "CHECKING NEEDED VARIABLES." &>> $LOGFILE
echo

# SYNC TIME AND DATE :
# ~~~~~~~~~~~~~~~~~~~~
Setting_DTime () {
    if
        timedatectl set-ntp true &>> $LOGFILE
        sleep 1
    then
        Done_Print "SYNCING TIME AND DATE."
    else
        Warn_Print "SYNCING TIME AND DATE."
        exit 1
    fi
}

Info_Print "SYNCING TIME AND DATE."
Setting_DTime &
Spin $! "SYNCING"
echo; printf "\e[?25h\e[?7h" 

# CHECK PACMAN-INIT SERVICE
while true; do
    status=$(systemctl is-active pacman-init.service)
    
    if [ "$status" == "active" ]; then
        echo "pacman-init.service is running."
        break
    else
        echo -ne "\rWaiting for pacman-init.service to start..."
        systemctl restart pacman-init.service &>> $LOGFILE
        sleep 1  # Adjust the sleep duration as needed
    fi
done

# INITIALISING KEYRING :
# ~~~~~~~~~~~~~~~~~~~~~~
Initialising_KRings () {
    if
        # systemctl restart pacman-init &>> $LOGFILE
        # killall gpg-agent &>> $LOGFILE
        # rm -rf /etc/pacman.d/gnupg/ &>> $LOGFILE
        # pacman-key --init &>> $LOGFILE
        # pacman-key --populate archlinux &>> $LOGFILE
        pacman -Sy --noconfirm --disable-download-timeout archlinux-keyring &>> $LOGFILE
        sleep 1
    then
        Done_Print "INITIALISING KEYRINGS."
    else
        Warn_Print "INITIALISING KEYRINGS."
        exit 1
    fi
}

Info_Print "INITIALISING KEYRINGS."
Initialising_KRings &
Spin $! "INITIALISING"
echo

# WIPE THE DISK :
# ~~~~~~~~~~~~~~~
Wiping_Drive () {
    if
        wipefs -af "$DISK" &> $LOGFILE
        sleep 0.5
        sgdisk -Zo "$DISK" &>> $LOGFILE
        sleep 0.5
    then
        Done_Print "WIPING DISK."
    else
        Warn_Print "WIPING DISK."
        exit 1
    fi
}

Info_Print "WIPING DISK."
Wiping_Drive &
Spin $! "WIPING"
echo "WIPING DISK." &>> $LOGFILE
echo


# PARTITION THE DISK :
# ~~~~~~~~~~~~~~~~~~~~
Creating_Partition () {
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
        sleep 1
    then
        Done_Print "CREATING PARTITIONS."
    else
        Warn_Print "CREATING PARTITIONS."
        exit 1
    fi
}

Info_Print "CREATING PARTITIONS."
Creating_Partition &
Spin $! "CREATING"
echo "CREATING PARTITIONS." &>> $LOGFILE
echo

partprobe "$DISK" &>> $LOGFILE

# FORMAT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~
Formatting_Partition () {
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
        sleep 1
    then
        Done_Print "FORMATTING PARTITIONS."
    else
        Warn_Print "FORMATTING PARTITIONS."
        exit 1
    fi
}

Info_Print "FORMATTING PARTITIONS."
Formatting_Partition &
Spin $! "FORMATTING"
echo "FORMATTING PARTITIONS." &>> $LOGFILE
echo

# MOUNT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~
Mounting_Partition () {
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
        sleep 1
    then
        Done_Print "MOUNTING PARTITIONS."
    else
        Warn_Print "MOUNTING PARTITIONS."
        exit 1
    fi
}

Info_Print "MOUNTING PARTITIONS."
Mounting_Partition &
Spin $! "MOUNTING"
echo "MOUNTING PARTITIONS." &>> $LOGFILE
echo

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
echo "CHECKING MICROCODE." &>> $LOGFILE

# INSTALLING BASE SYSTEM :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Installing_Base () {
    if
        pacstrap -K /mnt --noconfirm --disable-download-timeout base base-devel linux-firmware $KERNEL $KERNEL-headers $MICROCODE &>> $LOGFILE
        sleep 1
    then
        Done_Print "INSTALLING BASE SYSTEM."
    else
        Warn_Print "INSTALLING BASE SYSTEM."
        exit 1
    fi
}

Info_Print "INSTALLING BASE SYSTEM."
Installing_Base &
Spin $! "INSTALLING"
echo "INSTALLING BASE SYSTEM." &>> $LOGFILE
echo

# GENERATE THE FSTAB FILE :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Generating_FTab () {
    if
        genfstab -U /mnt >> /mnt/etc/fstab &>> $LOGFILE
        sleep 1
    then
        Done_Print "GENERATING FSTAB FILE."
    else
        Warn_Print "GENERATING FSTAB FILE."
        exit 1
    fi
}

Info_Print "GENERATING FSTAB FILE."
Generating_FTab &
Spin $! "GENERATING"
echo "GENERATING FSTAB FILE." &>> $LOGFILE
echo

# ---------------------------------------------------------- #
# ----------------- CHROOT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
sleep 5
clear

# TITLE SHOW :
# ~~~~~~~~~~~~
echo
Title_Print 17 "╔═══════════════╗"
Title_Print 17 "║  CHROOT ARCH  ║"
Title_Print 17 "╚═══════════════╝"
echo

# SET TIME-ZONE :
# ~~~~~~~~~~~~~~~
Setting_Timezone () {
    if
        arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &>> $LOGFILE
        arch-chroot /mnt hwclock --systohc &>> $LOGFILE
        sleep 1
    then
        Done_Print "SETTING TIME-ZONE."
    else
        Warn_Print "SETTING TIME-ZONE."
        exit 1
    fi
}

Info_Print "SETTING TIME-ZONE."
Setting_Timezone &
Spin $! "SETTING"
echo "SETTING TIME-ZONE." &>> $LOGFILE
echo

# GENERATE LOCALE :
# ~~~~~~~~~~~~~~~~~
Generating_Locale () {
    if
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
        sleep 1
    then
        Done_Print "GENERATING LOCALE."
    else
        Warn_Print "GENERATING LOCALE."
        exit 1
    fi
}

Info_Print "GENERATING LOCALE."
Generating_Locale &
Spin $! "GENERATING"
echo "GENERATING LOCALE." &>> $LOGFILE
echo

# SET HOST-NAME :
# ~~~~~~~~~~~~~~~
Setting_Hostname () {
    Spin 9 SETTING &
    PID=$!
    if
        echo "$HOSTNAME" > /mnt/etc/hostname
        sleep 1
    then
        Done_Print "SETTING HOST-NAME."
    else
        Warn_Print "SETTING HOST-NAME."
        exit 1
    fi
}

Info_Print "SETTING HOST-NAME."
Setting_Hostname &
Spin $! "SETTING"
echo "SETTING HOST-NAME." &>> $LOGFILE
echo

# SET HOSTS :
# ~~~~~~~~~~~
Setting_Hosts () {
    if
        echo "127.0.0.1      localhost" >> /mnt/etc/hosts
        echo "::1            localhost" >> /mnt/etc/hosts
        echo "127.0.1.1      $HOSTNAME.localdomain     $HOSTNAME" >> /mnt/etc/hosts
        sleep 1
    then
        Done_Print "SETTING HOSTS FILE."
    else
        Warn_Print "SETTING HOSTS FILE."
        exit 1
    fi
}

Info_Print "SETTING HOSTS FILE."
Setting_Hosts &
Spin $! "SETTING"
echo "SETTING HOSTS FILE." &>> $LOGFILE
echo

# SET CONSOLE KEYMAP :
# ~~~~~~~~~~~~~~~~~~~~
Setting_Console () {
    if
        echo "KEYMAP=$KEYBOARD" > /mnt/etc/vconsole.conf
        echo "XKBLAYOUT=$KEYBOARD" >> /mnt/etc/vconsole.conf
        sleep 1
    then
        Done_Print "SETTING CONSOLE KEYMAP."
    else
        Warn_Print "SETTING CONSOLE KEYMAP."
        exit 1
    fi
}

Info_Print "SETTING CONSOLE KEYMAP."
Setting_Console &
Spin $! "SETTING"
echo "SETTING CONSOLE KEYMAP." &>> $LOGFILE
echo

# EDIT PACMAN CONFIG:
# ~~~~~~~~~~~~~~~~~~~
Editing_Pacman () {
    if
        sed -i 's/#Color/Color\nILoveCandy/' /etc/pacman.conf
        sed -i '/\[multilib\]/,/Include/s/^#//' /mnt/etc/pacman.conf
        sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /mnt/etc/pacman.conf
        sed -i 's/^#ParallelDownloads/ParallelDownloads/' /mnt/etc/pacman.conf
        arch-chroot /mnt pacman -Sy --noconfirm &>> $LOGFILE
    then
        Done_Print "EDITING PACMAN CONFIG."
    else
        Warn_Print "EDITING PACMAN CONFIG."
        exit 1
    fi
}

Info_Print "EDITING PACMAN CONFIG."
Editing_Pacman &
Spin $! "EDITING"
echo "EDITING PACMAN CONFIG." &>> $LOGFILE
echo

# SYNC FASTEST MIRRORS :
# ~~~~~~~~~~~~~~~~~~~~~~
Setting_Reflector () {
    if
        arch-chroot /mnt pacman -S --noconfirm reflector &>> $LOGFILE
        arch-chroot /mnt reflector --save /etc/pacman.d/mirrorlist --download-timeout 60 --country India --sort rate --verbose &>> $LOGFILE
        echo "--save /etc/pacman.d/mirrorlist" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--download-timeout 60" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--protocol https" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--country India" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--sort rate" >> /mnt/etc/xdg/reflector/reflector.conf
        echo "--verbose" > /mnt/etc/xdg/reflector/reflector.conf
    then
        Done_Print "SYNCING FASTEST MIRRORS."
    else
        Warn_Print "SYNCING FASTEST MIRRORS."
        exit 1
    fi
}

Info_Print "SYNCING FASTEST MIRRORS."
Setting_Reflector &
Spin $! "SYNCING"
echo "SYNCING FASTEST MIRRORS." &>> $LOGFILE
echo

# SET NETWORK MANAGER :
# ~~~~~~~~~~~~~~~~~~~~~
Setting_NManager () {
    if
        arch-chroot /mnt pacman -S --noconfirm networkmanager &>> $LOGFILE
        arch-chroot /mnt systemctl enable NetworkManager &>> $LOGFILE
    then
        Done_Print "SETTING NETWORK MANAGER."
    else
        Warn_Print "SETTING NETWORK MANAGER."
        exit 1
    fi
}

Info_Print "SETTING NETWORK MANAGER."
Setting_NManager &
Spin $! "SETTING"
echo "SETTING NETWORK MANAGER." &>> $LOGFILE
echo

# NO WATCH-DOG :
# ~~~~~~~~~~~~~~
Disabling_WDog () {
    if
        echo "blacklist iTCO_wdt" > /mnt/etc/modprobe.d/nowatchdog.conf
        sleep 1
    then
        Done_Print "DISABLING WATCH-DOG LOG."
    else
        Warn_Print "DISABLING WATCH-DOG LOG."
        exit 1
    fi
}

Info_Print "DISABLING WATCH-DOG LOG."
Disabling_WDog &
Spin $! "DISABLING"
echo "DISABLING WATCH-DOG LOG." &>> $LOGFILE
echo

# REDUCE SHUTDOWN TIME :
# ~~~~~~~~~~~~~~~~~~~~~~
Reducing_STime () {
    if
        sed -i "s/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=10s/" /mnt/etc/systemd/system.conf
        sleep 1
    then
        Done_Print "REDUCING SHUTDOWN TIME."
    else
        Warn_Print "REDUCING SHUTDOWN TIME."
        exit 1
    fi
}

Info_Print "REDUCING SHUTDOWN TIME."
Reducing_STime &
Spin $! "REDUCING"
echo "REDUCING SHUTDOWN TIME." &>> $LOGFILE
echo

# RE-INITIALIZE INITRAMFS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Initialising_Kernel () {
    if
        arch-chroot /mnt mkinitcpio -P &>> $LOGFILE
        sleep 1
    then
        Done_Print "RE-INITIALISING INITRAMFS."
    else
        Warn_Print "RE-INITIALISING INITRAMFS."
        exit 1
    fi
}

Info_Print "RE-INITIALISING INITRAMFS."
Initialising_Kernel &
Spin $! "RE-INITIALISING"
echo "RE-INITIALISING INITRAMFS." &>> $LOGFILE
echo

# SET BOOT LOADER :
# ~~~~~~~~~~~~~~~~~
Setting_BLoader () {
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
        sleep 1
    then
        Done_Print "SETTING BOOT LOADER."
    else
        Warn_Print "SETTING BOOT LOADER."
        exit 1
    fi
}

Info_Print "SETTING BOOT LOADER."
Setting_BLoader &
Spin $! "SETTING"
echo "SETTING BOOT LOADER." &>> $LOGFILE
echo

# INSTALL PACKAGES :
# ~~~~~~~~~~~~~~~~~~
Installing_Extra () {
    if
        arch-chroot /mnt pacman -S --noconfirm $EXTRA &>> $LOGFILE
    then
        Done_Print "INSTALLING EXTRA PACKAGES."
    else
        Warn_Print "INSTALLING EXTRA PACKAGES."
        exit 1
    fi
}
Info_Print "INSTALLING EXTRA PACKAGES."
Installing_Extra &
Spin $! "INSTALLING"
echo "INSTALLING EXTRA PACKAGES." &>> $LOGFILE
echo

# SET ROOT PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
Setting_RPassWd () {
    if
        printf "%s\n%s" "${ROOTPASSWORD}" "${ROOTPASSWORD}" | arch-chroot /mnt passwd &>> $LOGFILE
        sleep 1
    then
        Done_Print "SETTING ROOT PASSWORD."
    else
        Warn_Print "SETTING ROOT PASSWORD."
        exit 1
    fi
}

# echo -en "${BCYAN}          ! NOTE !${BYELO} - ENTER ROOT PASSWORD :  ${RESET}"
# read ROOTPASSWORD
# echo
Info_Print "SETTING ROOT PASSWORD."
Setting_RPassWd &
Spin $! "SETTING"
echo "SETTING ROOT PASSWORD." &>> $LOGFILE
echo

# CREATE USER ACCOUNT :
# ~~~~~~~~~~~~~~~~~~~~~
Creating_Account () {
    if
        arch-chroot /mnt useradd -mG wheel,audio,video,storage,network,power,optical -c "${NICKNAME}" -s /bin/bash "${USERNAME}"
        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers
        sleep 1
    then
        Done_Print "CREATING USER ACCOUNT."
    else
        Warn_Print "CREATING USER ACCOUNT."
        exit 1
    fi
}

Info_Print "CREATING USER ACCOUNT."
Creating_Account &
Spin $! "CREATING"
echo "CREATING USER ACCOUNT." &>> $LOGFILE
echo

# SET USER PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
Setting_UPassWd () {
    if
        printf "%s\n%s" "${USERPASSWORD}" "${USERPASSWORD}" | arch-chroot /mnt passwd $USERNAME &>> $LOGFILE
        sleep 1
    then
        Done_Print "SETTING USER PASSWORD."
    else
        Warn_Print "SETTING USER PASSWORD."
        exit 1
    fi
}

# echo -en "${BCYAN}          ! NOTE !${BYELO} - ENTER USER PASSWORD :  ${RESET}"
# read USERPASSWORD
# echo
Info_Print "SETTING USER PASSWORD."
Setting_UPassWd &
Spin $! "SETTING"
echo "SETTING USER PASSWORD." &>> $LOGFILE
echo

# CREATING SWAP FILE :
# ~~~~~~~~~~~~~~~~~~~~
Creating_SFile () {
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
        Done_Print "CREATING SWAP FILE."
    else
        Warn_Print "CREATING SWAP FILE."
        exit 1
    fi
}

Info_Print "CREATING SWAP FILE."
Creating_SFile &
Spin $! "CREATING"
echo "CREATING SWAP FILE." &>> $LOGFILE
echo

# COPY LOG FILE :
# ~~~~~~~~~~~~~~~
Coping_Logs () {
    if
        cp Installer.log /mnt/
        sleep 1
    then
        Done_Print "COPING LOG FILE."
    else
        Warn_Print "COPING LOG FILE."
        exit 1
    fi
}

Info_Print "COPING LOG FILE."
Coping_Logs &
Spin $! "COPING"
echo
