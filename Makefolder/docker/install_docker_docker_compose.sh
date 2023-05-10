#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'

DROPLET_IP="$1"


read -p "Do you want to install Docker, Docker Compose, and Certbot locally (L) or on a remote server (R)? (L/R): " location_choice

if [ "$location_choice" = "L" ] || [ "$location_choice" = "l" ]; then
    # Local installation
    echo "Installing Docker, Docker Compose locally..."
    read -p "Do you want to proceed with the installation? (y/n): " answer

    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        OS=$(uname)
        if [ "$OS" = "Linux" ]; then
            echo "Detected Linux OS"
            curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
            sudo systemctl enable docker && sudo systemctl start docker
            sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$OS-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
        elif [ "$OS" = "Darwin" ]; then
            echo "Detected macOS"
            brew install --cask docker
            brew install docker-compose
        else
            printf "$RED Unsupported OS. Please install Docker and Docker Compose manually."
            exit 1
        fi
        printf "$GREEN Docker and Docker Compose installation complete."
    else
        printf "$YELLOW Skipping Docker and Docker Compose installation."
    fi

elif [ "$location_choice" = "R" ] || [ "$location_choice" = "r" ]; then
    # Remote installation
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
        apt-get install -y jq
ENDSSH
    else
        printf "$YELLOW Skipping remote server installation. Install Docker and Docker Compose locally."
    fi
else
    printf "$RED Invalid choice. Please choose either L (local) or R (remote). Skipping docker docker-compose installation" 
fi