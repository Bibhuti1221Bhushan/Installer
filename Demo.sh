#!/bin/bash

# -------------------------------------------------------- #
# Author : Bibhuti Bhushan                                 #
# Github : https://github.com/Bibhuti1221Bhushan/Installer #
# -------------------------------------------------------- #

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/sda                            # SET DISK FOR INSTALLATION

# SET SIZE OF DRIVE :
# ~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550MiB                         # SET BOOT PARTITION SIZE
SWAP_SIZE=8GiB                           # SET SWAP PARTITION SIZE
ROOT_SIZE=35GiB                          # SET ROOT PARTITION SIZE
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET PACKAGES :
# ~~~~~~~~~~~~~~
KERNEL="linux-lts"                       # SET KERNEL

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

# SHOW PROGRESS FUNCTION :
# ~~~~~~~~~~~~~~~~~~~~~~~~
Show_Progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -e "${BOLD}${GREEN} . ${RESET}"
        sleep 1
    done
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
Warn_Print "WORKING..."
Done_Print "WORKING..."
Info_Print "WORKING..."

echo -e "${BOLD}${GREEN} . . . . WARN${RESET}"


Center_Print() {
  # Calculate the number of spaces to print before the text.
  spaces=$((($(tput cols) - $1) / 2))
  # Print the spaces.
  printf "%${spaces}s"
  # Print the text.
  echo -e "${BOLD}${BBLUE}$1${RESET}"
  # Print the remaining spaces.
  printf "%${spaces}s"
}


Center_Print "Helloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"

echo
echo -ne "${BOLD}${BLUE}
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
if [ ! -d /sys/firmwareS/efi/efivars ]; then
  Warn_Print "YOU ARE NOT BOOTED IN UEFI."
  exit 1
fi