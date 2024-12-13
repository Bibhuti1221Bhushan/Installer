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

# CREATING FOLDERS :
# ~~~~~~~~~~~~~~~~~~
DIR="$HOME/Installer"
if [ ! -d "$DIR/Resources" ]; then
    mkdir -p "$DIR/Resources"
fi

# CREATING LOG FILE :
# ~~~~~~~~~~~~~~~~~~~
LOG_FILE="$DIR/Setup.log"
if [ -f "$LOG_FILE" ]; then
    rm -f "$LOG_FILE"
fi

# DOWNLOADING FILES :
# ~~~~~~~~~~~~~~~~~~~
# curl https://raw.githubusercontent.com/Bibhuti1221Bhushan/Installer/Global/Demo.sh --output $HOME/Installer/Resources/Demo.sh # Temporary
# source "$HOME/Documents/Working/Github/Installer/Resources/Installer.conf"    # Temporary

cd "$DIR"
curl https://raw.githubusercontent.com/Bibhuti1221Bhushan/Installer/Global/Setup --output $DIR/Setup.sh &>> $LOG_FILE
curl https://raw.githubusercontent.com/Bibhuti1221Bhushan/Installer/Global/Resources/Installer.sh --output $DIR/Resources/Installer.sh &>> $LOG_FILE
curl https://raw.githubusercontent.com/Bibhuti1221Bhushan/Installer/Global/Resources/Installer.conf --output $DIR/Resources/Installer.conf &>> $LOG_FILE
source "$DIR/Resources/Installer.conf"

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

# IN 3 SEC FUNCTION :
# ~~~~~~~~~~~~~~~~~~~
_InSec_Print () {
    clear
    echo -e "\e[?25l\e[?7l"
    echo -e ""
    for START in {1..3}; do
        echo -ne "\r${BG}    - $1"
        for ((i=1; i<=START; i++)); do
            echo -n "."
            sleep 0.3
        done
        sleep 0.3
    done
    echo -e "${NC}"
}
_InSec_Print "Starting"

# CHECK KERNEL AND EDITOR AVAILABILITY :
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if pacman -Si "$KERNEL" &> /dev/null; then
    KERNEL_AVAILABLE=True
else
    KERNEL_AVAILABLE=False
fi

if pacman -Si "$EDITOR" &> /dev/null; then
    EDITOR_AVAILABLE=True
else
    EDITOR_AVAILABLE=False
fi

# INSTALL CONFIGURATION :
# ~~~~~~~~~~~~~~~~~~~~~~~
_Show_Config () {
    _Show_Header
    echo -e "   ┌─${BR}─────${BG}─────${BY}─────${BB}─────${BP}─────${BC}─────${BR}─────${NC}" 
    echo -e "   │  ${BB}Current Configuration Settings${NC}"
    echo -e "   ├─${BR}─────${BG}─────${BY}─────${BB}─────${BP}─────${BC}─────${BR}─────${NC}"

    # USER INFORMATION
    if [ -n "$FULL_NAME"  ]; then
        echo -e "   ├─ ${BC}Full Name : ${BG}$FULL_NAME${NC}"
    else
        echo -e "   ├─ ${BC}Full Name : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$USER_NAME"  ]; then
        echo -e "   ├─ ${BC}User Name : ${BG}$USER_NAME${NC}"
    else
        echo -e "   ├─ ${BC}User Name : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$USER_PASS"  ]; then
        echo -e "   ├─ ${BC}User Pass : ${BG}$USER_PASS${NC}"
    else
        echo -e "   ├─ ${BC}User Pass : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$ROOT_PASS"  ]; then
        echo -e "   ├─ ${BC}Root Pass : ${BG}$ROOT_PASS${NC}"
    else
        echo -e "   ├─ ${BC}Root Pass : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$HOST_NAME"  ]; then
        echo -e "   ├─ ${BC}Host Name : ${BG}$HOST_NAME${NC}"
    else
        echo -e "   ├─ ${BC}Host Name : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$TIME_ZONE"  ]; then
        echo -e "   ├─ ${BC}Time Zone : ${BG}$TIME_ZONE${NC}"
    else
        echo -e "   ├─ ${BC}Time Zone : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$INPUT_MAP"  ]; then
        echo -e "   ├─ ${BC}Input Map : ${BG}$INPUT_MAP${NC}"
    else
        echo -e "   ├─ ${BC}Input Map : ${BR}InCorrect Input${NC}"
    fi
    if [ -n "$LOCALE"  ]; then
        echo -e "   ├─ ${BC}Locale ID : ${BG}$LOCALE${NC}"
    else
        echo -e "   ├─ ${BC}Locale ID : ${BR}InCorrect Input${NC}"
    fi
    echo -e "   ├─${BR}─────${BG}─────${BY}─────${BB}─────${BP}─────${BC}─────${BR}─────${NC}" 

    # DISK INFORMATION
    if lsblk -ndo NAME | grep -q "${DISK#/dev/}" && [[ $DISK =~ ^/dev/.* ]]; then
        DISK_SIZE=$(lsblk -bdno SIZE $DISK | awk '{printf "%.2f GB\n", $1/1024/1024/1024}')
        echo -e "   ├─ ${BC}Disk Name : ${BG}${DISK#/dev/} [ ${DISK_SIZE} ]${NC}"
    else
        echo -e "   ├─ ${BC}Disk Name : ${BR}InCorrect Input${NC}"
    fi
    if [[ "$BOOT_SIZE" =~ ^[0-9]+$ ]] && [[ $BOOT_SIZE -ge 500 ]]; then
        echo -e "   ├─ ${BC}Boot Size : ${BG}${BOOT_SIZE} MB${NC}"
    else
        echo -e "   ├─ ${BC}Boot Size : ${BR}Min. 500 MB Required${NC}"
    fi
    if [[ "$ROOT_SIZE" =~ ^[0-9]+$ ]] && [[ $ROOT_SIZE -ge 20 ]]; then
        echo -e "   ├─ ${BC}Root Size : ${BG}${ROOT_SIZE} GB${NC}"
    else
        echo -e "   ├─ ${BC}Root Size : ${BR}Min. 20 GB Required${NC}"
    fi

    # HOME INFORMATION
    if [[ "$HOME" =~ ^[0-2]$ ]]; then
        if [ "$HOME" -eq 0 ]; then
            echo -e "   ├─ ${BC}Home Info : ${BG}Disabled${NC}"
        else
            echo -e "   ├─ ${BC}Home Info : ${BG}Enabled${NC}"
        fi
    else
        echo -e "   ├─ ${BC}Home Info : ${BR}InCorrect Input${NC}"
    fi
    
    # CHECK CUSTOM HOME PARTITION
    if [[ "$HOME" =~ ^[0-2]$ ]] && [[ "$HOME" -eq 2 ]]; then
        if awk '/part$/ {print $1}' <<< "$(lsblk -o NAME,TYPE)" | grep -qw "${CUSTOM_HOME#/dev/}" && [[ "$CUSTOM_HOME" =~ ^/dev/[a-z]+[0-9]+$ ]]; then
            CUSTOM_HOME_SIZE=$(lsblk -bno SIZE $CUSTOM_HOME | awk '{printf "%.2f GB\n", $1/1024/1024/1024}')
            echo -e "   ├─ ${BC}Home Disk : ${BG}${CUSTOM_HOME#/dev/} [ ${CUSTOM_HOME_SIZE} ]${NC}"
        else
            echo -e "   ├─ ${BC}Home Disk : ${BR}InCorrect Input${NC}"
        fi
    fi

    # HOME PARTITION SIZE
    if [[ "$HOME" =~ ^[0-2]$ ]] && [[ "$HOME" -eq 1 ]]; then
        DISK_SIZE=$(lsblk -bdno SIZE $DISK | awk '{printf "%.2f\n", $1/1024/1024/1024}')
        case $SWAP in
            1)
                HOME_SIZE=$(awk -v disk="$DISK_SIZE" -v boot="$BOOT_SIZE" -v root="$ROOT_SIZE" -v zram="$ZRAM_SIZE" 'BEGIN {printf "%.0f", disk - boot/1024 - root - zram}')
                ;;
            2|3)
                HOME_SIZE=$(awk -v disk="$DISK_SIZE" -v boot="$BOOT_SIZE" -v root="$ROOT_SIZE" -v swap="$SWAP_SIZE" 'BEGIN {printf "%.0f", disk - boot/1024 - root - swap}')
                ;;
            0|*)
                HOME_SIZE=$(awk -v disk="$DISK_SIZE" -v boot="$BOOT_SIZE" -v root="$ROOT_SIZE" 'BEGIN {printf "%.0f", disk - boot/1024 - root}')
                ;;
        esac
        echo -e "   ├─ ${BC}Home Size : ${BG}$HOME_SIZE GB${NC}"
    fi

    # SWAP INFO
    if [[ "$SWAP" =~ ^[0-3]$ ]]; then
        if [ "$SWAP" -eq 0 ]; then
            echo -e "   ├─ ${BC}Swap Info : ${BG}Disabled${NC}"
        else
            echo -e "   ├─ ${BC}Swap Info : ${BG}Enabled${NC}"
        fi
    else
        echo -e "   ├─ ${BC}Swap Info : ${BR}InCorrect Input${NC}"
    fi

    # ZRAM SIZE
    if [[ "$SWAP" =~ ^[0-3]$ ]] && [[ "$SWAP" -eq 1 ]]; then
        if [[ "$ZRAM_SIZE" =~ ^[0-9]+$ ]] && [[ "$ZRAM_SIZE" -ge 2 ]]; then
            echo -e "   ├─ ${BC}ZRam Size : ${BG}$ZRAM_SIZE GB${NC}"
        else
            echo -e "   ├─ ${BC}ZRam Size : ${BR}Min. 2 GB${NC}"
        fi
    fi

    # SWAP SIZE
    if [[ "$SWAP" =~ ^[2-3]$ ]]; then
        if [[ "$SWAP_SIZE" =~ ^[0-9]+$ ]] && [[ "$SWAP_SIZE" -ge 2 ]]; then
            echo -e "   ├─ ${BC}Swap Size : ${BG}$SWAP_SIZE GB${NC}"
        else
            echo -e "   ├─ ${BC}Swap Size : ${BR}Min. 2 GB${NC}"
        fi
    fi

    echo -e "   ├─${BR}─────${BG}─────${BY}─────${BB}─────${BP}─────${BC}─────${BR}─────${NC}" 

    # BOOTLOADER
    if [[ "$BOOT_LOADER" =~ ^[1-2]$ ]]; then
        if [ "$BOOT_LOADER" -eq 1 ]; then
            echo -e "   ├─ ${BC}Boot Info : ${BG}Default${NC}"
        else
            echo -e "   ├─ ${BC}Boot Info : ${BG}Grub${NC}"
        fi
    else
        echo -e "   ├─ ${BC}Boot Info : ${BR}InCorrect Input${NC}"
    fi

    # KERNEL 
    if [[ $KERNEL_AVAILABLE == True ]] && [[ "$KERNEL" == *"linux"* ]]; then
        echo -e "   ├─ ${BC}Kernel ID : ${BG}$KERNEL${NC}"
    else
        echo -e "   ├─ ${BC}Kernel ID : ${BR}InCorrect Input${NC}"
    fi

    # EXTRA PACKAGES
    if [[ "$EDITOR_AVAILABLE" == True ]] && [[ -n "$EDITOR" ]]; then
        echo -e "   ├─ ${BC}Editor ID : ${BG}$EDITOR${NC}"
    else
        echo -e "   ├─ ${BC}Editor ID : ${BR}InCorrect Input${NC}"
    fi
    
    # DOTFILES REPOSITORY
    if [[ -n "$DOT_FILES" && "$DOT_FILES" =~ ^https?:// ]]; then
        echo -e "   ├─ ${BC}Dots Repo : ${BG}$DOT_FILES${NC}"
    else
        echo -e "   ├─ ${BC}Dots Repo : ${BR}InCorrect Input${NC}"
    fi

    echo -e "   └─${BR}─────${BG}─────${BY}─────${BB}─────${BP}─────${BC}─────${BR}─────${NC}"
}

while true; do
    _Show_Config
    echo ""
    echo -ne "   ${BP}Press ${BY}C${BP}ontinue, C${BY}o${BP}nfigure or C${BY}l${BP}ose : ${NC}"
    read -r Choice
    case "$Choice" in
        c|C)
            _InSec_Print "Continuing"
            bash "$DIR/Resources/Installer.sh"
            break
            ;;
        o|O)
            nano --modernbindings --linenumbers --nohelp --zero --saveonexit "$DIR/Resources/Installer.conf"
            ;;
        l|L)
            echo -e "\e[?25h"
            exit 0
            ;;
        *)
            ;;
    esac
done
