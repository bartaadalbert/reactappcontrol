#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m' 
DROPLET_NAME=${1:-"my-droplet"}

# Get the droplet ID using the droplet name
DROPLET_ID=$(doctl compute droplet list --format "ID,Name" --no-header | grep -w "$DROPLET_NAME" | awk '{print $1}')

# Check if the droplet ID was found
if [ -n "$DROPLET_ID" ]; then
  # Delete the droplet using its ID
  doctl compute droplet delete --force "$DROPLET_ID"
  printf "$RED The Droplet $DROPLET_NAME deleted successfully."
else
  printf "$YELLOW The Droplet with name $DROPLET_NAME not found."
fi
