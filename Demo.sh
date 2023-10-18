#!/bin/bash

# ---------------------------------------------------------- #
# ------------------- SET SOME VARIABLES ------------------- #
# ---------------------------------------------------------- #

# SET GENERAL VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~~~~
USER_NAME="Bibhuti"				         # SET USER NAME
FULL_NAME="Bibhuti Bhushan"		         # SET FULL NAME
HOSTNAME="iTunes"			      	     # SET THE HOST NAME
TIMEZONE="Asia/Kolkata"	    	         # SET TIME-ZONE
LOCALE="en_US.UTF-8"			         # SET LOCALE
KEYBOARD="us" 				      	     # SET KEYBOARD

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/vda                            # SET DISK FOR INSTALLATION

# SET SIZE OF DRIVE :
# ~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550M                           # SET BOOT PARTITION SIZE
SWAP_SIZE=2G                             # SET SWAP PARTITION SIZE
ROOT_SIZE=15G                            # SET ROOT PARTITION SIZE
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

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
YELLOW='\e[93m'                          # YELLOW
GREEN='\e[92m'                           # GREEN
BLUE='\e[34m'                            # BLUE
RED='\e[91m'                             # RED
RESET='\e[0m'                            # RESET
BOLD='\e[1m'                             # BOLD

# PRETTY PRINT FUNCTIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print () {
    echo -e "${BOLD}${YELLOW}! ${GREEN}NOTE${YELLOW} ! - $1${RESET}"
}

Done_Print () {
    echo -e "${BOLD}${GREEN}! ${YELLOW}DONE${GREEN} ! - $1${RESET}"
}

Warn_Print () {
    echo -e "${BOLD}${RED}! ${BLUE}WARN${RED} ! - $1${RESET}"
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
echo -ne "${BOLD}${BLUE}
                                            ███████╗ █████╗ ███████╗██╗   ██╗      █████╗ ██████╗  ██████╗██╗  ██╗
                                            ██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
                                            █████╗  ███████║███████╗ ╚████╔╝      ███████║██████╔╝██║     ███████║
                                            ██╔══╝  ██╔══██║╚════██║  ╚██╔╝       ██╔══██║██╔══██╗██║     ██╔══██║
                                            ███████╗██║  ██║███████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
                                            ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                            ======================================================================
${RESET}"
echo
echo

# VERIFY BOOT MODE :
# ~~~~~~~~~~~~~~~~~~
if [ ! -d /sys/firmware/efi/efivars ]; then
  Warn_Print "YOU ARE NOT BOOTED IN UEFI."
  sleep 5
  echo
  exit 1
fi

# SYNC TIME AND DATE :
# ~~~~~~~~~~~~~~~~~~~~
Info_Print "SYNCING TIME AND DATE."
timedatectl set-ntp true
Done_Print "SYNCING TIME AND DATE."
echo

# UPDATE KEYRING :
# ~~~~~~~~~~~~~~~~
Info_Print "UPDATING KEYRINGS."
pacman -Sy --noconfirm --disable-download-timeout archlinux-keyring &>> $LOGFILE
Done_Print "UPDATING KEYRINGS."
echo

# WIPE THE DISK :
# ~~~~~~~~~~~~~~~
Info_Print "WIPING DISK."
wipefs -af "$DISK" &> $LOGFILE
sgdisk -Zo "$DISK" &>> $LOGFILE
Done_Print "WIPING DISK."
echo

# RELOAD PARTITION TABLE :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "RELOADING PARTITION TABLE."
partprobe "$DISK" &>> $LOGFILE
Done_Print "RELOADING PARTITION TABLE."
echo

# PARTITION THE DISK :
# ~~~~~~~~~~~~~~~~~~~~
Info_Print "CREATING PARTITIONS."
parted "$DISK" -s mklabel gpt &>> $LOGFILE
parted "$DISK" -s mkpart ESP fat32 1MiB $BOOT_SIZE &>> $LOGFILE
parted "$DISK" -s set 1 esp on &>> $LOGFILE
parted "$DISK" -s mkpart primary linux-swap $BOOT_SIZE $SWAP_SIZE &>> $LOGFILE
parted "$DISK" -s mkpart primary ext4 $SWAP_SIZE $ROOT_SIZE &>> $LOGFILE
parted "$DISK" -s mkpart primary ext4 $ROOT_SIZE 100% &>> $LOGFILE
Done_Print "CREATING PARTITIONS."
echo

# FORMAT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "FORMATTING PARTITIONS."
mkfs.fat -F 32 -n ESP "$DISK"1 &>> $LOGFILE
mkswap -L SWAP "$DISK"2 &>> $LOGFILE
mkfs.ext4 -L ROOT "$DISK"3 &>> $LOGFILE
mkfs.ext4 -L HOME "$DISK"4 &>> $LOGFILE
Done_Print "FORMATTING PARTITIONS."
echo

# MOUNT THE PARTITIONS :
# ~~~~~~~~~~~~~~~~~~~~~~
Info_Print "MOUNTING PARTITIONS."
mount "$DISK"3 /mnt
mkdir -vp /mnt/boot &>> $LOGFILE
mount "$DISK"1 /mnt/boot
mkdir -vp /mnt/home &>> $LOGFILE
mount "$DISK"4 /mnt/home
swapon "$DISK"2 &>> $LOGFILE
Done_Print "MOUNTING PARTITIONS."
echo

# MICROCODE DETECTIOR :
# ~~~~~~~~~~~~~~~~~~~~~
Microcode_Detector

# INSTALLING BASE SYSTEM :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "INSTALLING BASE SYSTEM PACKAGES."
pacstrap -K /mnt --noconfirm --disable-download-timeout base base-devel linux-firmware $KERNEL $KERNEL-headers $MICROCODE &>> $LOGFILE
Done_Print "INSTALLING BASE SYSTEM PACKAGES."
echo

# GENERATE THE FSTAB FILE :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "GENERATING FSTAB FILE."
genfstab -U /mnt >> /mnt/etc/fstab &>> $LOGFILE
Done_Print "GENERATING FSTAB FILE."
echo

# COPY LOG FILE :
# ~~~~~~~~~~~~~~~
Info_Print "COPING LOG FILE."
cp -r Installer.log /mnt/
Done_Print "COPING LOG FILE."
echo

# ---------------------------------------------------------- #
# ----------------- CHROOT START FROM HERE ----------------- #
# ---------------------------------------------------------- #

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
sleep 10
clear

# TITLE SHOW :
# ~~~~~~~~~~~~
echo
echo -ne "${BOLD}${BLUE}
                                   █████╗ ██████╗  █████╗ ██╗  ██╗       █████╗ ██╗  ██╗██████╗  █████╗  █████╗ ████████╗
                                  ██╔══██╗██╔══██╗██╔══██╗██║  ██║      ██╔══██╗██║  ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝
                                  ███████║██████╔╝██║  ╚═╝███████║      ██║  ╚═╝███████║██████╔╝██║  ██║██║  ██║   ██║   
                                  ██╔══██║██╔══██╗██║  ██╗██╔══██║      ██║  ██╗██╔══██║██╔══██╗██║  ██║██║  ██║   ██║   
                                  ██║  ██║██║  ██║╚█████╔╝██║  ██║      ╚█████╔╝██║  ██║██║  ██║╚█████╔╝╚█████╔╝   ██║   
                                  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝       ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝  ╚════╝    ╚═╝   
                                  =======================================================================================
${RESET}"
echo
echo
echo

# SET TIME-ZONE :
# ~~~~~~~~~~~~~~~
Info_Print "SETTING TIME-ZONE."
arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &>> $LOGFILE
arch-chroot /mnt hwclock --systohc &>> $LOGFILE
Done_Print "SETTING TIME-ZONE."
echo

# GENERATE LOCALE :
# ~~~~~~~~~~~~~~~~~
Info_Print "GENERATING LOCALE."
arch-chroot /mnt sed -i "s/#$LOCALE/$LOCALE/g" /etc/locale.gen
arch-chroot /mnt locale-gen &>> $LOGFILE
Done_Print "GENERATING LOCALE."
echo

# SET LOCALE UNITS :
# ~~~~~~~~~~~~~~~~~~
Info_Print "SETTING LOCALE UNITS."
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
Done_Print "SETTING LOCALE UNITS."
echo

# SET HOST-NAME :
# ~~~~~~~~~~~~~~~
Info_Print "SETTING HOST-NAME."
echo "$HOSTNAME" > /mnt/etc/hostname
Done_Print "SETTING HOST-NAME."
echo

# SET HOSTS :
# ~~~~~~~~~~~
Info_Print "SETTING HOSTS FILE."
cat > /mnt/etc/hosts <<HOSTS
127.0.0.1      localhost
::1            localhost
127.0.1.1      $HOSTNAME.localdomain     $HOSTNAME
HOSTS
Done_Print "SETTING HOSTS FILE."
echo

# SET CONSOLE KEYMAP :
# ~~~~~~~~~~~~~~~~~~~~
Info_Print "SETTING CONSOLE KEYMAP."
echo "KEYMAP=$KEYBOARD" > /mnt/etc/vconsole.conf
echo "XKBLAYOUT=$KEYBOARD" >> /mnt/etc/vconsole.conf
Done_Print "SETTING CONSOLE KEYMAP."
echo

# MODIFYING PACMAN :
# ~~~~~~~~~~~~~~~~~~
Info_Print "MODIFYING PACMAN CONFIG."
sed -i 's/^#Color/Color/' /mnt/etc/pacman.conf
sed -i '/NoProgressBar/iILoveCandy' /mnt/etc/pacman.conf
sed -i '/\[multilib\]/,/Include/s/^#//' /mnt/etc/pacman.conf
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /mnt/etc/pacman.conf
Done_Print "MODIFYING PACMAN CONFIG."
echo

# INITIALISING PACMAN KEYRINGS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "INITIALISING PACMAN KEYRINGS."
arch-chroot /mnt pacman-key --init &>> $LOGFILE
arch-chroot /mnt pacman-key --populate &>> $LOGFILE
Done_Print "INITIALISING PACMAN KEYRINGS."
echo

# SYNC FASTEST MIRRORS :
# ~~~~~~~~~~~~~~~~~~~~~~
Info_Print "SYNCING FASTEST MIRRORS."
arch-chroot /mnt pacman -Sy --needed --noconfirm reflector &>> $LOGFILE
cat > /mnt/etc/xdg/reflector/reflector.conf <<REFLECTOR
--verbose
--sort rate
--latest 20
--fastest 20
--protocol https
--save /etc/pacman.d/mirrorlist
REFLECTOR
arch-chroot /mnt reflector --save /etc/pacman.d/mirrorlist --protocol https --latest 20 --fastest 20 --sort rate --verbose &>> $LOGFILE
arch-chroot /mnt systemctl enable reflector.timer &>> $LOGFILE
Done_Print "SYNCING FASTEST MIRRORS."
echo

# SET NETWORK MANAGER :
# ~~~~~~~~~~~~~~~~~~~~~
Info_Print "SETTING NETWORK MANAGER."
arch-chroot /mnt pacman -S --needed --noconfirm networkmanager &>> $LOGFILE
arch-chroot /mnt systemctl enable NetworkManager &>> $LOGFILE
Done_Print "SETTING NETWORK MANAGER."
echo

# NO WATCH-DOG :
# ~~~~~~~~~~~~~~
Info_Print "DISABLING WATCH-DOG LOG."
echo "blacklist iTCO_wdt" > /mnt/etc/modprobe.d/nowatchdog.conf
Done_Print "DISABLING WATCH-DOG LOG."
echo

# REDUCE SHUTDOWN TIME-OUT :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "REDUCING SHUTDOWN TIME-OUT."
sed -i "s/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=10s/" /mnt/etc/systemd/system.conf
Done_Print "REDUCING SHUTDOWN TIME-OUT."
echo

# RE-INITIALIZE INITRAMFS :
# ~~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "RE-INITIALISING INITRAMFS."
arch-chroot /mnt mkinitcpio -P &>> $LOGFILE
Done_Print "RE-INITIALISING INITRAMFS."
echo

# SET BOOT LOADER :
# ~~~~~~~~~~~~~~~~~
Info_Print "SETTING BOOT LOADER."
arch-chroot /mnt bootctl install --esp-path=/boot/ &>> $LOGFILE
cat > /mnt/boot/loader/entries/Arch.conf <<ENTRIES
title   Boot Manager
linux   /vmlinuz-$KERNEL
initrd  /$MICROCODE.img
initrd  /initramfs-$KERNEL.img
options root=${DISK}3 rw
ENTRIES
cat > /mnt/boot/loader/loader.conf <<LOADER
default Arch.conf
console-mode max
timeout 0
editor yes
LOADER
Done_Print "SETTING BOOT LOADER."
echo

# INSTALL PACKAGES :
# ~~~~~~~~~~~~~~~~~~
arch-chroot /mnt pacman -S --needed --noconfirm $EXTRA &>> $LOGFILE

# SET ROOT PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
echo -en "${BOLD}${YELLOW}! ${GREEN}NOTE${YELLOW} ! - ENTER ROOT PASSWORD :  ${RESET}"
read ROOT_PASSWORD
Info_Print "SETTING ROOT PASSWORD."
printf "%s\n%s" "${ROOT_PASSWORD}" "${ROOT_PASSWORD}" | arch-chroot /mnt passwd &>> $LOGFILE
Done_Print "SETTING ROOT PASSWORD."
echo

# CREATE USER ACCOUNT :
# ~~~~~~~~~~~~~~~~~~~~~
Info_Print "CREATING USER ACCOUNT."
arch-chroot /mnt useradd -m -G wheel,audio,video,optical,storage,disk,network,power,input "${USER_NAME}" -c "${FULL_NAME}"
sed -i 's/# %wheel/%wheel/g' /mnt/etc/sudoers
Done_Print "CREATING USER ACCOUNT."
echo

# SET USER PASSWORD :
# ~~~~~~~~~~~~~~~~~~~
echo -en "${BOLD}${YELLOW}! ${GREEN}NOTE${YELLOW} ! - ENTER USER PASSWORD :  ${RESET}"
read USER_PASSWORD
Info_Print "SETTING USER PASSWORD."
printf "%s\n%s" "${USER_PASSWORD}" "${USER_PASSWORD}" | arch-chroot /mnt passwd $USER_NAME &>> $LOGFILE
Done_Print "SETTING USER PASSWORD."
echo

# ENABLE ESSENTIAL SERVICES :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Info_Print "ENABLING ESSENTIAL SERVICES."
# arch-chroot /mnt systemctl enable systemd-timesyncd.service &>> $LOGFILE
arch-chroot /mnt systemctl enable fstrim.timer &>> $LOGFILE
# arch-chroot /mnt systemctl enable systemd-boot-update.service &>> $LOGFILE
Done_Print "ENABLING ESSENTIAL SERVICES."
echo

# SET VM GUEST TOOLS :
# ~~~~~~~~~~~~~~~~~~~~
VM_Check

# TITLE SHOW :
# ~~~~~~~~~~~~
echo
echo -ne "${BOLD}${BLUE}
              ██╗███╗  ██╗ ██████╗████████╗ █████╗ ██╗     ██╗      █████╗ ████████╗██╗ █████╗ ███╗  ██╗      ██████╗  █████╗ ███╗  ██╗███████╗
              ██║████╗ ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔══██╗╚══██╔══╝██║██╔══██╗████╗ ██║      ██╔══██╗██╔══██╗████╗ ██║██╔════╝
              ██║██╔██╗██║╚█████╗    ██║   ███████║██║     ██║     ███████║   ██║   ██║██║  ██║██╔██╗██║      ██║  ██║██║  ██║██╔██╗██║█████╗  
              ██║██║╚████║ ╚═══██╗   ██║   ██╔══██║██║     ██║     ██╔══██║   ██║   ██║██║  ██║██║╚████║      ██║  ██║██║  ██║██║╚████║██╔══╝  
              ██║██║ ╚███║██████╔╝   ██║   ██║  ██║███████╗███████╗██║  ██║   ██║   ██║╚█████╔╝██║ ╚███║      ██████╔╝╚█████╔╝██║ ╚███║███████╗
              ╚═╝╚═╝  ╚══╝╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚════╝ ╚═╝  ╚══╝      ╚═════╝  ╚════╝ ╚═╝  ╚══╝╚══════╝
              =================================================================================================================================
${RESET}"

# EXIT INSTALLATION :
# ~~~~~~~~~~~~~~~~~~~
echo
echo
echo
echo -en "${BOLD}${RED}! ${BLUE}WARN${RED} ! - REBOOTING IN 10 SECONDS${RESET}"
echo -en "${BBLUE}${BOLD}REBOOTING IN 10 SEC... ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
sleep 1
echo -en "${BBLUE}${BOLD} . ${RESET}"
# reboot now





