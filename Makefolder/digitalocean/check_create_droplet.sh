#!/bin/bash
DEFF_MAKER=${1:-"Makefolder/digitalocean/create_droplet.sh"}

read -p "Do you want to create a new droplet? (y/n): " answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    IP=$(./$DEFF_MAKER)
    # Check if the output is a valid IPv4 address using grep and a regex pattern
    if echo "$IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        echo "Droplet created with IP: $IP"
        echo "$IP" > ip.txt
    else
        echo "Invalid IP address"
    fi
else
    echo "Skipping droplet creation."
fi
