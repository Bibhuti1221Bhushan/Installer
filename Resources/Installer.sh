#!/usr/bin/env bash

# Author : Bibhuti Bhushan                                   
# Github : https://github.com/Bibhuti1221Bhushan/Installer   

# COLOR CODES :
# ~~~~~~~~~~~~~
BR="\e[1;31m"
BG="\e[1;32m"
BY="\e[1;33m"
BB="\e[1;34m"
BP="\e[1;35m"
BC="\e[1;36m"
NC="\e[0m"

# VARIABLES :
# ~~~~~~~~~~~
DIR="$HOME/Installer"
LOG_FILE="$DIR/Setup.log"

# SOURCE CONFIG FILE :
# ~~~~~~~~~~~~~~~~~~~~
if [ -f "$DIR/Resources/Installer.conf" ]; then
    source "$DIR/Resources/Installer.conf"
else
    echo -ne "\r${BY}   [ Note ]${BR} - Config File Not Found...${NC}\n"
    exit 1
fi

# PRINT FUNCTION :
# ~~~~~~~~~~~~~~~~
_Info_Print () {
    echo -ne "\r${BP}   [ Note ]${BC} - ${1}${NC}\n"
    echo -ne "[ Note ] - ${1}" &>> $LOG_FILE
}

_Done_Print () {
    echo -ne "\r${BG}   [ Done ]${BC} - ${1}${NC}\n"
    echo -ne "[ Done ] - ${1}" &>> $LOG_FILE
}

_Warn_Print () {
    echo -ne "\r${BR}   [ Warn ]${BC} - ${1}${NC}\n"
    echo -ne "[ Warn ] - ${1}" &>> $LOG_FILE
    sleep 3
    exit 1
}

# SPIN FUNCTION :
# ~~~~~~~~~~~~~~~
_Spin_Print () {
    SPIN=("+===" "=+==" "==+=" "===+" "==+=" "=+==")
    while true; do
        for SPINNER in "${SPIN[@]}"; do
            echo -ne "\r${BY}   [ ${SPINNER} ]${BC} ${1}${NC}"
            sleep 0.1
        done
    done
}

# IN 3 SEC FUNCTION :
# ~~~~~~~~~~~~~~~~~~~
_InSec_Print () {
    for SEC in {3..0}; do
        echo -ne "\r${BY}   [ Info ]${BR} - ${1} In ${SEC} Seconds...${NC} "
        sleep 1.5
    done
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~~~ SCRIPT START FROM HERE ~~~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# HEADER FUNCTION :
# ~~~~~~~~~~~~~~~~~
_Show_Header () {
    clear
    echo -e "\e[?25l\e[?7l"
    echo -e ""
    echo -e "          ${BC}┌─${BR}──${BY}──${BB}──${BP}──${BG}──${BG}──${BR}──${BY}──${BB}─┐${NC}"
    echo -e "          ${BP}│ ${BG}iTunes Installer${BC} │${NC}"
    echo -e "          ${BR}└─${BP}──${BY}──${BB}──${BC}──${BG}──${BP}──${BR}──${BY}──${BB}─┘${NC}"
    echo
}

# DETECT MICROCODE :
# ~~~~~~~~~~~~~~~~~~
_Detecting_Microcode () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        MICROCODE="amd-ucode"
    elif [[ "$CPU" == *"GenuineIntel"* ]]; then
        MICROCODE="intel-ucode"
    fi
}

_Pacman_Config () {
    cat << PACMAN > /mnt/etc/pacman.conf
[options]
ILoveCandy
ParallelDownloads = 5
PACMAN
}

_Sudoers_Config () {
    cat << SUDO > /mnt/etc/sudoers.d/Installer
# Sudoers Setup :
# ~~~~~~~~~~~~~~~

# Defaults Specification :
Defaults    pwfeedback
Defaults    passprompt="Enter Your Code: "
Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/bin"
Defaults    editor=/usr/bin/$EDITOR, !env_editor
Defaults    insults

Defaults    env_reset

# Defaults!/usr/bin/visudo env_keep += "SUDO_EDITOR EDITOR VISUAL"

# Defaults env_keep += "HOME"
# Defaults env_keep += "XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH"
# Defaults env_keep += "QTDIR KDEDIR"
# Defaults env_keep += "XDG_SESSION_COOKIE"
# Defaults env_keep += "XMODIFIERS GTK_IM_MODULE QT_IM_MODULE QT_IM_SWITCHER"
# Defaults>root !use_pty
# Defaults exec_background
# Defaults mail_badpass
# Defaults log_output
# Defaults!/usr/bin/sudoreplay !log_output
# Defaults!/usr/local/bin/sudoreplay !log_output
# Defaults!REBOOT !log_output
# Defaults maxseq = 1000
# Defaults!DEBUGGERS !intercept, !log_subcmds
# Defaults!PKGMAN !intercept, !log_subcmds
# Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"


# Super Power Specification :
root ALL=(ALL:ALL) ALL
%wheel ALL=(ALL:ALL) ALL

# %wheel ALL=(ALL:ALL) NOPASSWD: ALL

# Included Files :
@includedir /etc/sudoers.d
SUDO
}


# REQUIREMENTS :
# ~~~~~~~~~~~~~~
_Checking_Requirements () {
    if ! grep --quiet "Arch Linux" /etc/os-release; then
        Warn_Print "Please Run This On Aarch Linux."
    elif [[ "$EUID" -ne 0 ]]; then
        Warn_Print "Please Run This Script As Root."
    elif [ ! -d /sys/firmware/efi/efivars ]; then
        Warn_Print "Please Boot Into The UEFI Mode."
    elif ! ping -c 1 archlinux.org &>/dev/null; then
        Warn_Print "No Internet Connection Detected."
    elif ! timedatectl set-ntp true &>/dev/null; then
        Warn_Print "Time Date Initialisation Failed."
    fi
}

_Initialising_Pacman () {
    _Info_Print "Initialising Pacman." &>> $LOG_FILE
    _Spin_Print "Initialising Pacman." &
    PID=$!
    if
        if ! systemctl is-active --quiet pacman-init.service; then
            systemctl start pacman-init.service &>> $LOG_FILE
            while ! systemctl is-active --quiet pacman-init.service; do
                sleep 1
            done
        fi
        sed -i "s/^#ParallelDownloads/ParallelDownloads/" /etc/pacman.conf
        pacman -S --refresh --noconfirm --needed --disable-download-timeout archlinux-keyring &>> $LOG_FILE
    then
        sleep 0.5
        kill $PID
        _Done_Print "Initialising Pacman."
    else
        kill $PID
        _Warn_Print "Initialising Pacman."
    fi
}

_Creating_Partition () {
    _Info_Print "Creating Partition." &>> $LOG_FILE
    _Spin_Print "Creating Partition." &
    PID=$!
    if
        wipefs -af "$DISK" &>> $LOG_FILE
        sleep 0.5
        sgdisk -Zo "$DISK" &>> $LOG_FILE
        sleep 0.5
        partprobe "$DISK" &>> $LOG_FILE
        if [[ "$SWAP" == "2" ]]; then
            parted "$DISK" --script mklabel gpt &>> $LOG_FILE
            parted "$DISK" --script mkpart Boot fat32 1MiB "$BOOT_SIZE"Mib &>> $LOG_FILE
            parted "$DISK" --script set 1 esp on &>> $LOG_FILE
            parted "$DISK" --script mkpart Swap linux-swap "$BOOT_SIZE"Mib "$SWAP_SIZE"Gib &>> $LOG_FILE
            parted "$DISK" --script set 2 swap on &>> $LOG_FILE
            if [[ "$HOME" == "1" ]]; then
                parted "$DISK" --script mkpart Root ext4 "$SWAP_SIZE"Gib "$ROOT_SIZE"Gib &>> $LOG_FILE
                parted "$DISK" --script set 3 root on &>> $LOG_FILE
                parted "$DISK" --script mkpart Home ext4 "$ROOT_SIZE"Gib 100% &>> $LOG_FILE
                parted "$DISK" --script set 4 linux-home on &>> $LOG_FILE
            else
                parted "$DISK" --script mkpart Root ext4 "$SWAP_SIZE"Gib 100% &>> $LOG_FILE
                parted "$DISK" --script set 3 root on &>> $LOG_FILE
            fi
        else
            parted "$DISK" --script mklabel gpt &>> $LOG_FILE
            parted "$DISK" --script mkpart Boot fat32 1MiB "$BOOT_SIZE"Mib &>> $LOG_FILE
            parted "$DISK" --script set 1 esp on &>> $LOG_FILE
            if [[ "$HOME" == "1" ]]; then
                parted "$DISK" --script mkpart Root ext4 "$BOOT_SIZE"Mib "$ROOT_SIZE"Gib &>> $LOG_FILE
                parted "$DISK" --script set 3 root on &>> $LOG_FILE
                parted "$DISK" --script mkpart Home ext4 "$ROOT_SIZE"Gib 100% &>> $LOG_FILE
                parted "$DISK" --script set 4 linux-home on &>> $LOG_FILE
            else
                parted "$DISK" --script mkpart Root ext4 "$BOOT_SIZE"Mib 100% &>> $LOG_FILE
                parted "$DISK" --script set 3 root on &>> $LOG_FILE
            fi
        fi
        partprobe "$DISK" &>> $LOG_FILE
    then
        sleep 0.5
        kill $PID
        _Done_Print "Creating Partition."
    else
        kill $PID
        _Warn_Print "Creating Partition."
    fi
}

_Formating_Partition () {
    _Info_Print "Formating Partition." &>> $LOG_FILE
    _Spin_Print "Formating Partition." &
    PID=$!
    if
        if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
                mkfs.fat -F 32 -n ESP "$DISK"p1 &>> $LOG_FILE
                mkswap -L SWAP "$DISK"p2 &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mkfs.ext4 -L ROOT "$DISK"p3 &>> $LOG_FILE
                    mkfs.ext4 -L HOME "$DISK"p4 &>> $LOG_FILE
                else
                    mkfs.ext4 -L ROOT "$DISK"p3 &>> $LOG_FILE
                fi
            else
                mkfs.fat -F 32 -n ESP "$DISK"p1 &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mkfs.ext4 -L ROOT "$DISK"p2 &>> $LOG_FILE
                    mkfs.ext4 -L HOME "$DISK"p3 &>> $LOG_FILE
                else
                    mkfs.ext4 -L ROOT "$DISK"p2 &>> $LOG_FILE
                fi
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                mkfs.fat -F 32 -n ESP "$DISK"1 &>> $LOG_FILE
                mkswap -L SWAP "$DISK"2 &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mkfs.ext4 -L ROOT "$DISK"3 &>> $LOG_FILE
                    mkfs.ext4 -L HOME "$DISK"4 &>> $LOG_FILE
                else
                    mkfs.ext4 -L ROOT "$DISK"3 &>> $LOG_FILE
                fi
            else
                mkfs.fat -F 32 -n ESP "$DISK"1 &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mkfs.ext4 -L ROOT "$DISK"2 &>> $LOG_FILE
                    mkfs.ext4 -L HOME "$DISK"3 &>> $LOG_FILE
                else
                    mkfs.ext4 -L ROOT "$DISK"2 &>> $LOG_FILE
                fi
            fi
        fi
    then
        sleep 0.5
        kill $PID
        _Done_Print "Formating Partition."
    else
        kill $PID
        _Warn_Print "Formating Partition."
    fi
}

_Mounting_Partition () {
    _Info_Print "Mounting Partition." &>> $LOG_FILE
    _Spin_Print "Mounting Partition." &
    PID=$!
    if
       if [[ $DISK =~ ^/dev/nvme.* ]]; then
            if [[ "$SWAP" == "1" ]]; then
                mount "$DISK"p3 /mnt
                swapon "$DISK"p2 &>> $LOG_FILE
                mount --mkdir "$DISK"p1 /mnt/boot &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mount --mkdir "$DISK"p4 /mnt/home &>> $LOG_FILE
                fi
            else
                mount "$DISK"p2 /mnt
                mount --mkdir "$DISK"p1 /mnt/boot &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mount --mkdir "$DISK"p3 /mnt/home &>> $LOG_FILE
                fi
            fi
        else
            if [[ "$SWAP" == "1" ]]; then
                mount "$DISK"3 /mnt &>> $LOG_FILE
                swapon "$DISK"2 &>> $LOG_FILE
                mount --mkdir "$DISK"1 /mnt/boot &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mount --mkdir "$DISK"4 /mnt/home &>> $LOG_FILE
                if
            else
                mount "$DISK"2 /mnt &>> $LOG_FILE
                mount --mkdir "$DISK"1 /mnt/boot &>> $LOG_FILE
                if [[ "$HOME" == "1" ]]; then
                    mount --mkdir "$DISK"3 /mnt/home &>> $LOG_FILE
                fi
            fi
        fi
    then
        sleep 0.5
        kill $PID
        _Done_Print "Mounting Partition."
    else
        kill $PID
        _Warn_Print "Mounting Partition."
    fi
}

_Installing_Base () {
    _Info_Print "Installing Base." &>> $LOG_FILE
    _Spin_Print "Installing Base." &
    PID=$!
    if
        pacstrap -K /mnt --noconfirm --disable-download-timeout base base-devel linux-firmware $KERNEL $KERNEL-headers $MICROCODE &>> $LOG_FILE
        genfstab -U /mnt >> /mnt/etc/fstab &>> $LOG_FILE
    then
        sleep 0.5
        kill $PID
        _Done_Print "Installing Base."
    else
        kill $PID
        _Warn_Print "Installing Base."
    fi
}

_Configuring_Setup () {
    _Info_Print "Configuring Setup." &>> $LOG_FILE
    _Spin_Print "Configuring Setup." &
    PID=$!
    if
        _Info_Print "Time-Zone Setup :\n" &>> $LOG_FILE
        arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime &>> $LOG_FILE
        arch-chroot /mnt hwclock --systohc &>> $LOG_FILE

        _Info_Print "Locale Setup :\n" &>> $LOG_FILE
        echo "# Locale Setup :\n" > /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LANG=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_NAME=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_TIME=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_CTYPE=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_PAPER=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_COLLATE=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_NUMERIC=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_ADDRESS=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_MONETARY=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_MESSAGES=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_TELEPHONE=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_MEASUREMENT=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE
        echo "LC_IDENTIFICATION=$LOCALE" >> /mnt/etc/locale.conf &>> $LOG_FILE

        echo "# Locale Setup :\n" > /mnt/etc/locale.gen &>> $LOG_FILE
        echo "$LOCALE" >> /mnt/etc/locale.gen &>> $LOG_FILE
        arch-chroot /mnt locale-gen &>> $LOG_FILE

        _Info_Print "Console Setup :\n" &>> $LOG_FILE
        echo "# Console Setup :\n" > /mnt/etc/vconsole.conf &>> $LOG_FILE
        echo "KEYMAP=$INPUT_MAP" >> /mnt/etc/vconsole.conf &>> $LOG_FILE

        _Info_Print "Host-Name Setup :\n" &>> $LOG_FILE
        echo "# Host-Name Setup :\n" > /mnt/etc/hostname &>> $LOG_FILE
        echo "$HOST_NAME" >> /mnt/etc/hostname &>> $LOG_FILE

        _Info_Print "Hosts Setup :\n" &>> $LOG_FILE
        echo "# Hosts Setup :\n" > /mnt/etc/hosts &>> $LOG_FILE
        echo "127.0.0.1   localhost" >> /mnt/etc/hosts &>> $LOG_FILE
        echo "::1         localhost" >> /mnt/etc/hosts &>> $LOG_FILE
        echo "127.0.1.1   $HOST_NAME.localdomain    $HOST_NAME" >> /mnt/etc/hosts &>> $LOG_FILE

        _Info_Print "Pacman Setup :\n" &>> $LOG_FILE
        sed -i 's/#Color/Color\nILoveCandy/' /mnt/etc/pacman.conf &>> $LOG_FILE
        sed -i '/\[multilib\]/,/Include/s/^#//' /mnt/etc/pacman.conf &>> $LOG_FILE
        sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /mnt/etc/pacman.conf &>> $LOG_FILE
        sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /mnt/etc/pacman.conf &>> $LOG_FILE
    then
        sleep 0.5
        kill $PID
        _Done_Print "Configuring Setup."
    else
        kill $PID
        _Warn_Print "Configuring Setup."
    fi
}

_Configuring_Packages () {
    _Info_Print "Installing Packages." &>> $LOG_FILE
    _Spin_Print "Installing Packages." &
    PID=$!
    if
        arch-chroot /mnt pacman -S --refresh --needed --noconfirm networkmanager reflector $EDITOR &>> $LOG_FILE
        arch-chroot /mnt systemctl enable NetworkManager &>> $LOG_FILE

        _Info_Print "Reflector Setup :\n" &>> $LOG_FILE
        arch-chroot /mnt reflector --latest 30 --number 30 --sort rate --protocol http,https --save /etc/pacman.d/mirrorlist --verbose &>> $LOG_FILE
        echo "# Reflector Setup :\n" > /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
        echo "--save /etc/pacman.d/mirrorlist" >> /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
        echo "--protocol http,https" >> /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
        echo "--latest 30" >> /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
        echo "--number 30" >> /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
        echo "--sort rate" >> /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
        echo "--verbose" > /mnt/etc/xdg/reflector/reflector.conf &>> $LOG_FILE
    then
        sleep 0.5
        kill $PID
        _Done_Print "Installing Packages."
    else
        kill $PID
        _Warn_Print "Installing Packages."
    fi
}

_Configuring_BLoader () {
    _Info_Print "Installing Boot Loader." &>> $LOG_FILE
    _Spin_Print "Installing Boot Loader." &
    PID=$!
    if  
        arch-chroot /mnt mkinitcpio -P &>> $LOG_FILE

        if [[ "$BOOTLOADER" == "1" ]]; then
            arch-chroot /mnt pacman -S --noconfirm grub efibootmgr &>> $LOG_FILE
            arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id="Grub Boot Manager" --recheck &>> $LOG_FILE
            arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg &>> $LOG_FILE
        else
            arch-chroot /mnt bootctl install --esp-path=/boot/ &>> $LOG_FILE
            echo "# Boot Loader Setup :\n" > /mnt/boot/loader/loader.conf &>> $LOG_FILE
            echo "default @saved" >> /mnt/boot/loader/loader.conf &>> $LOG_FILE
            echo "timeout 3" >> /mnt/boot/loader/loader.conf &>> $LOG_FILE
            echo "editor on" >> /mnt/boot/loader/loader.conf &>> $LOG_FILE
            echo "beep false" >> /mnt/boot/loader/loader.conf &>> $LOG_FILE
            echo "console-mode auto" >> /mnt/boot/loader/loader.conf &>> $LOG_FILE

            echo "# Boot Entries Setup :\n" > /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
            echo "title   Aarch Linux" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
            echo "linux   /vmlinuz-$KERNEL" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
            if [[  -n "$MICROCODE" ]]; then
                echo "initrd  /$MICROCODE.img" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
            fi
            echo "initrd  /initramfs-$KERNEL.img" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
            if [[ $DISK =~ ^/dev/nvme.* ]]; then
                if [[ "$SWAP" == "1" ]]; then
                   echo "options root=UUID=$(blkid -s UUID -o value ${DISK}p3) quiet splash rw" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
                else
                   echo "options root=UUID=$(blkid -s UUID -o value ${DISK}p2) quiet splash rw" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
                fi
            else
                if [[ "$SWAP" == "1" ]]; then
                    echo "options root=UUID=$(blkid -s UUID -o value ${DISK}3) quiet splash rw" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
                else
                    echo "options root=UUID=$(blkid -s UUID -o value ${DISK}2) quiet splash rw" >> /mnt/boot/loader/entries/default.conf &>> $LOG_FILE
                fi
            fi
        fi
    then
        sleep 0.5
        kill $PID
        _Done_Print "Installing Boot Loader."
    else

        kill $PID
        _Warn_Print "Installing Boot Loader."
}

_Creating_SFile () {
    if [[ "$SWAP" == "3" ]]; then
        _Info_Print "Creating Swap File." &>> $LOG_FILE
        _Spin_Print "Creating Swap File." &>> $LOG_FILE
        PID=$!
        if
            mkdir --verbose --parents /mnt/swap &>> $LOG_FILE
            arch-chroot /mnt dd if=/dev/zero of=/swap/swapfile bs=1M count=$(("$SWAP_SIZE" * 1024)) &>> $LOG_FILE
            arch-chroot /mnt chmod 600 /swap/swapfile &>> $LOG_FILE
            arch-chroot /mnt mkswap /swap/swapfile &>> $LOG_FILE
            arch-chroot /mnt swapon /swap/swapfile &>> $LOG_FILE
            echo "/swap/swapfile                             none          swap    sw 0 0" | tee -a /mnt/etc/fstab &>> $LOG_FILE
        then
            sleep 0.5
            kill $PID
            _Done_Print "Creating Swap File."
        else
            kill $PID
            _Warn_Print "Creating Swap File."
        fi
    if
}

_Finishing_Setup () {
    _Info_Print "Finishing Setup." &>> $LOG_FILE
    _Spin_Print "Finishing Setup." &
    PID=$!
    if
        printf "%s\n%s" "${ROOT_PASS}" "${ROOT_PASS}" | arch-chroot /mnt passwd &>> $LOG_FILE
        arch-chroot /mnt useradd -mG wheel,audio,video,storage,disk,network,input,power,optical -c "${FULL_NAME}" -s $(which bash) "${USER_NAME}"
        printf "%s\n%s" "${USER_PASS}" "${USER_PASS}" | arch-chroot /mnt passwd $USER_NAME &>> $LOG_FILE

        echo "# Sudo Setup :\n" > /mnt/etc/sudoers.d/Installer &>> $LOG_FILE
        echo "%wheel    ALL=(ALL:ALL) ALL" >> /mnt/etc/sudoers.d/Installer &>> $LOG_FILE
        echo "Defaults  pwfeedback" >> /mnt/etc/sudoers.d/Installer &>> $LOG_FILE
        # echo "Defaults  editor=$EDITOR" >> /mnt/etc/sudoers.d/Installer &>> $LOG_FILE
        echo "Defaults  passprompt=\"Enter Your Code: \"" >> /mnt/etc/sudoers.d/Installer &>> $LOG_FILE

        _Info_Print "Coping Log File." &>> $LOG_FILE
        cp --recursive --force $DIR /mnt/home/$USER_NAME &>> $LOG_FILE
        
        # _InSec_Print "Rebooting"

        printf "\e[?25h\e[?7h"
    then
        sleep 0.5
        kill $PID
        _Done_Print "Finishing Setup."
    else
        kill $PID
        _Warn_Print "Finishing Setup."
    fi
}

_Calling_Functions () {
    _Checking_Requirements
    _Initialising_Pacman
    _Creating_Partition
    _Formating_Partition
    _Mounting_Partition
    _Detecting_Microcode
    _Installing_Base
    _Configuring_Setup
    _Configuring_Packages
    _Configuring_BLoader
    _Creating_SFile
    _Finishing_Setup
}

_Calling_Functions

