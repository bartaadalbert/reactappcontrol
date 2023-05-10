#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m' 
# DO_API_KEY="your_digitalocean_api_key"
# Use the API keys
API_FILE=${7:-"Makefolder/api_keys.conf"}
DO_API_KEY=$(grep '^DO_API_KEY=' $API_FILE | cut -d= -f2-)


if [ $DO_API_KEY == "" ] || [ $DO_API_KEY == "your_digitalocean_api_key" ] ; then
	printf "${RED}DigitalOcean API KEY NOT SET";
	exit 1;
fi

# # Authenticate with DigitalOcean API
# doctl auth init --access-token $DO_API_KEY

SSH_KEY_NAME=${1:-"DOCKER-REACT"}
SSH_KEY_FILE=${2:-"Makefolder/digitalocean/id_rsa"}
#CHECK THE SSH_KEY_FILE FILE EXIST
if [[ ! -f $SSH_KEY_FILE ]]; then
    ssh-keygen -t rsa -b 4096 -C $SSH_KEY_NAME -f $SSH_KEY_FILE
fi
SSH_KEY_ID=$(doctl compute ssh-key list --format ID --no-header | head -n1)



# Import SSH key
doctl compute ssh-key import $SSH_KEY_NAME --public-key-file $SSH_KEY_FILE.pub

# Customize your droplet configuration
DROPLET_NAME=${3:-"my-droplet"}
REGION=${4:-"ams3"}
IMAGE=${5:-"ubuntu-20-04-x64"}
SIZE=${6:-"s-1vcpu-1gb"}

# Get SSH key ID and fingerprint
SSH_KEY_INFO=$(doctl compute ssh-key list --output json | jq -r ".[] | select(.name==\"$SSH_KEY_NAME\")")
SSH_KEY_ID=$(echo "$SSH_KEY_INFO" | jq -r ".id")
SSH_KEY_FINGERPRINT=$(echo "$SSH_KEY_INFO" | jq -r ".fingerprint")

# # Create a new droplet and output the droplet ID
# DROPLET_ID=$(curl -X POST "https://api.digitalocean.com/v2/droplets" \
#      -H "Content-Type: application/json" \
#      -H "Authorization: Bearer $DO_API_KEY" \
#      -d "{\"name\":\"$DROPLET_NAME\",\"region\":\"$REGION\",\"size\":\"$SIZE\",\"image\":\"$IMAGE\", \"ssh_keys\": [\"$SSH_KEY_ID\"]}" \
#      | jq -r ".droplet.id")

# # echo $DROPLET_ID

# # Wait for a few seconds to ensure the droplet data is propagated in DigitalOcean's API
# sleep 60

# # Get the droplet's IP address
# DROPLET_IP=$(curl -X GET "https://api.digitalocean.com/v2/droplets/$DROPLET_ID" \
#      -H "Authorization: Bearer $DO_API_KEY" \
#      | jq -r ".droplet.networks.v4[0].ip_address")

# Create the droplet
DROPLET_ID=$(doctl compute droplet create $DROPLET_NAME --region $REGION --size $SIZE --image $IMAGE --ssh-keys $SSH_KEY_ID --wait --format ID --no-header)
# Wait for droplet ready with ssh connection
sleep 60
# Get droplet's IP address
DROPLET_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header)
# Add the SSH key to your local SSH agent
ssh-add $SSH_KEY_FILE

# Install Docker and Docker Compose on the droplet
# ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$DROPLET_IP 'bash -s' <<-'ENDSSH'
#     export DEBIAN_FRONTEND=noninteractive
# 	apt-get update
# 	apt-get install -y apt-transport-https ca-certificates curl software-properties-common
# 	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - >/dev/null 2>&1
# 	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# 	apt-get update
# 	apt-get install -y docker-ce

# 	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# 	chmod +x /usr/local/bin/docker-compose
# ENDSSH
# clear
echo $DROPLET_IP