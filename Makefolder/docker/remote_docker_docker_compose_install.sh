#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'

DROPLET_IP="$1"

read -p "Do you want to install Docker and Docker Compose on a remote server? (y/n): " remote_answer

if [ "$remote_answer" = "y" ] || [ "$remote_answer" = "Y" ]; then

    if [[ ! $DROPLET_IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        printf "$RED $DROPLET_IP is not a valid IPv4 address."
        exit 1
    else
        printf "$GREEN $DROPLET_IP is a valid IPv4 address."
    fi

    ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$DROPLET_IP 'bash -s' <<-'ENDSSH'
    export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - >/dev/null 2>&1
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt-get update
	apt-get install -y docker-ce

	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	# Install Certbot
    apt-get install -y certbot
ENDSSH
else
    printf "$YELLOW Skipping remote server installation. Install Docker and Docker Compose locally."
fi