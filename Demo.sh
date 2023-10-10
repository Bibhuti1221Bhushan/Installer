#!/bin/bash


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
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
}

Other_Print () {
    echo -e "${BOLD}${BYELLOW}[ ${BGREEN}•${BYELLOW} ] $1${RESET}"
}

Error_Print () {
    echo -e "${BOLD}${BRED}[ ${BBLUE}•${BRED} ] $1${RESET}"
}

# -------------------------- #
# --- SET SOME VARIABLES --- #
# -------------------------- #

# SET NORMAL VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~~~
USERNAME="Bibhuti"				         # SET USER NAME
FULLNAME="Bibhuti Bhushan"		         # SET FULL NAME
USERPASSWORD="\\"			      	     # SET USER PASSWORD
ROOTPASSWORD="\\"			      	     # SET ROOT PASSWORD
HOSTNAME="iTunes"			      	     # SET THE HOST NAME
TIMEZONE="Asia/Kolkata"	    	         # SET TIME-ZONE
LOCALE="en_US.UTF-8"			         # SET LOCALE
LANGUAGE="en_US.UTF-8"                   # SET LOCALE.CONF
KEYBOARD="us" 				      	     # SET KEYBOARD 

# SET DISK VARIABLES :
# ~~~~~~~~~~~~~~~~~~~~
DISK=/dev/sda                            # SET DISK FOR INSTALL
FILESYSTEM=ext4                          # SET FILESYSTEM

# SET SIZE OF DRIVE :
# ~~~~~~~~~~~~~~~~~~~
BOOT_SIZE=550MiB                         # SET BOOT PARTITION SIZE
SWAP_SIZE=8GiB                           # SET SWAP PARTITION SIZE
ROOT_SIZE=35GiB                          # SET ROOT PARTITION SIZE
HOME_SIZE=                               # REMAINING SPACE FOR HOME PARTITION

# SET PACKAGES :
# ~~~~~~~~~~~~~~
KERNEL="linux-lts linux-lts-headers"     # SET KERNEL
MICROCODE="intel-ucode"                  # SET MICROCODE
EXTRA="git neovim"                       # EXTRA PACKAGES LIKE EDITOR...


# ------------------------------- #
# --- SCRIPT START FROM HERE ---  #
# ------------------------------- #

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
clear

# VERIFY BOOT MODE :
# ~~~~~~~~~~~~~~~~~~
if [ ! -d /sys/firmwares/efi/efivars ]; then
  echo
  Error_Print "YOU ARE NOT BOOTED IN UEFI"
  echo
  Error_Print "EXITING..."
  echo
  sleep 3
  exit 1
fi