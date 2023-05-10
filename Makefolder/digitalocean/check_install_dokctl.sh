#!/bin/bash
DEFF_MAKER=${1:-"Makefolder/digitalocean/install_doctl.sh"}

read -p "Do you want to install doctl? (y/n): " answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    # Replace this line with the actual installation command
    echo "Installing doctl...";
    source $DEFF_MAKER;
else
    echo "Skipping doctl installation."
fi
