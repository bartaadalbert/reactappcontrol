#!/bin/bash

DO_API_KEY="your_digitalocean_api_key"
DROPLET_ID="$1"

if [ $DO_API_KEY == ""] || [ $DO_API_KEY == "your_digitalocean_api_key" ] ; then
	printf "${RED}DigitalOcean API KEY NOT SET";
	exit 1;
fi

# Get the droplet's IP address
IP_ADDRESS=$(curl -X GET "https://api.digitalocean.com/v2/droplets/$DROPLET_ID" \
     -H "Authorization: Bearer $API_KEY" \
     | jq -r ".droplet.networks.v4[0].ip_address")

echo $IP_ADDRESS
