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

Done_Print () {
    echo -e "${BOLD}${BYELLOW}[ ${BGREEN}•${BYELLOW} ] $1${RESET}"
}

Issue_Print () {
    echo -e "${BOLD}${BRED}[ ${BBLUE}•${BRED} ] $1${RESET}"
}

# SYNC TIME AND DATE : 
# ~~~~~~~~~~~~~~~~~~~~
Info_Print "SYNCING TIME AND DATE..."
timedatectl set-ntp true
sleep 3
Done_Print "DONE - SYNCING TIME AND DATE..."
echo


# WIPE THE DISK :
# ~~~~~~~~~~~~~~~
Info_Print "WIPING DISK..."
# wipefs -af "$DISK" &>/dev/null
# sgdisk -Zo "$DISK" &>/dev/null
Done_Print "DONE - WIPING DISK..."
echo