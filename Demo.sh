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
