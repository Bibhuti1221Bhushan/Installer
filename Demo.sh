#!/bin/bash


# COLOR VARIABLES :
# ~~~~~~~~~~~~~~~~~ 
BYELLOW='\e[93m'                         # BOLD YELLOW    
BGREEN='\e[92m'                          # BOLD GREEN    
BBLUE='\e[34m'                           # BOLD BLUE      
BRED='\e[91m'                            # BOLD RED   
RESET='\e[0m'                            # RESET       
BOLD='\e[1m'                             # BOLD
       
# TITLE SHOW :
# ~~~~~~~~~~~~
echo -e "${BBLUE}${BOLD}                                                           ~~~~~~~~~~~~~~~~~~~~~~~    ${RESET}"
echo -e "${BBLUE}${BOLD}                                                           ~~ INSTALLATION DONE ~~    ${RESET}"
echo -e "${BBLUE}${BOLD}                                                           ~~~~~~~~~~~~~~~~~~~~~~~    ${RESET}" 
echo
echo
echo -en "${BBLUE}${BOLD}REBOOTING IN 10 SEC... ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}1  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}2  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}3  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}4  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}5  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}6  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}7  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}8  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}9  ${RESET}" 
sleep 1
echo -en "${BBLUE}${BOLD}10  ${RESET}" 
reboot


