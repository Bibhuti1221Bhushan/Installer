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
    elif [[ "$CPU" == *"GenuineIntel"* ]]; then
        MICROCODE="intel-ucode"
    fi
}

# GRAPHICS DRIVERS CHECK FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Graphics_Detect () {
    GPU=$(lspci)
    if grep -E "NVIDIA|GeForce" <<< ${GPU}; then
        arch-chroot /mnt pacman -S --noconfirm --needed nvidia nvidia-utils
    elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
        pacman -S --noconfirm --needed xf86-video-amdgpu
    elif grep -E "Integrated Graphics Controller" <<< ${GPU}; then
        pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
    elif grep -E "Intel Corporation UHD" <<< ${GPU}; then
        pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
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

# UPDATE KEYRING :
# ~~~~~~~~~~~~~~~~
Info_Print "UPDATING KEYRINGS."
pacman -S --noconfirm --disable-download-timeout lsd 2>&1 | tee -a "$LOGFILE"
Done_Print "UPDATING KEYRINGS."
echo



# UPDATE KEYRING :
# ~~~~~~~~~~~~~~~~
Info_Print "UPDATING KEYRINGS."
pacman -S --noconfirm --disable-download-timeout meld &>> $LOGFILE
Done_Print "UPDATING KEYRINGS."
echo
