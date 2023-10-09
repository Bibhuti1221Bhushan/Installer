#!/bin/bash

# Check if the directory exists
if [ ! -d /sys/firmware/efi/efivars ]; then
  # Give an error
  echo "The directory /sys/firmwaress/efi/efivars does not exist."
  exit 1
fi

# The directory exists, so exit successfully
lsblk
ls -h



echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nModifying Pacman Configuration...\n"

# enable options "color", "ParallelDownloads", "multilib (32-bit) repository"
sed -i 's #Color Color ; s #ParallelDownloads ParallelDownloads ; s #\[multilib\] \[multilib\] ; /\[multilib\]/{n;s #Include Include }' /etc/pacman.conf

echo -e "\nDone.\n\n"



echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Initialization of Pacman Keyring...\n"

pacman-key --init

pacman-key --populate archlinux

echo -e "\nDone.\n\n"


echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nAdding Fastest Mirror in Pacman Mirrorlist...\n"

# save preferred configuration for the reflector systemd service
echo -e "--save /etc/pacman.d/mirrorlist\n--country Sweden,Denmark\n--protocol https\n--score 10\n" > /etc/xdg/reflector/reflector.conf

reflector --save /etc/pacman.d/mirrorlist --country Sweden,Denmark --protocol https --score 10 --verbose

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Pacstrap Operation...\n"

# edit and adjust the "pkgs" file for desired packages (don't worry about any extra white spaces or new lines or comments as they will be omitted using sed and tr)
pacstrap /mnt $(cat pkgs | sed 's #.*$  g' | tr '\n' ' ')

echo -e "\nDone.\n\n"


