#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'

SERVER_TYPE=${1:-"local"}
SSH_SERVER=$2
LOCAL_SERVER_SSH_KEY=${3:-"~/.ssh/id_rsa.pub"}
REMOTE_SERVER_SSH_KEY=${4:-"~/.ssh/id_rsa.pub"}

# Use the API keys
API_FILE=${5:-"Makefolder/api_keys.conf"}
GIT_ACCESS_TOKEN=$(grep '^GIT_ACCESS_TOKEN=' $API_FILE | cut -d= -f2-)

if [ $GIT_ACCESS_TOKEN == "" ] || [ $GIT_ACCESS_TOKEN == "GIT_ACCESS_TOKEN" ] ; then
    printf "$RED GIT TOKEN NOT SET";
    exit 1;
fi

DOMAIN=$(echo "$SSH_SERVER" | cut -d'@' -f 2)

if [ "$SERVER_TYPE" == "local" ]; then
    PUBLIC_SSH_KEY=$(cat $LOCAL_SERVER_SSH_KEY)
else
    PUBLIC_SSH_KEY=$(ssh $SSH_SERVER "cat $REMOTE_SERVER_SSH_KEY")
fi

# Check if we have access to GitHub using the API key
curl -s -H "Authorization: token $GIT_ACCESS_TOKEN" https://api.github.com/user | grep '"login":' > /dev/null

if [ $? -eq 0 ]; then
    printf "$GREEN GitHub access granted."
else
    printf "$RED GitHub access denied. Adding the public SSH key to GitHub."

    # Get the public SSH key content
    PUBLIC_KEY_CONTENT=$(cat "$PUBLIC_SSH_KEY")
    PUBLIC_KEY_TITLE="MyPublicKEY $DOMAIN"

    # Add the public SSH key to GitHub
    curl -s -H "Authorization: token $GIT_ACCESS_TOKEN" \
         -X POST \
         -d "{\"title\":\"$PUBLIC_KEY_TITLE\", \"key\":\"$PUBLIC_KEY_CONTENT\"}" \
         https://api.github.com/user/keys > /dev/null

    if [ $? -eq 0 ]; then
        printf "$GREEN Public SSH key added successfully."
    else
        printf "$RED Failed to add the public SSH key."
    fi
fi