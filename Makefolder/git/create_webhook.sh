#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m' 

REPO_NAME=$1
WEBHOOK_URL=${2:-"URL"}
CURL_ACTION=${3:-"POST"}

# Use the API keys
API_FILE=${4:-"Makefolder/api_keys.conf"}
GIT_ACCESS_TOKEN=$(grep '^GIT_ACCESS_TOKEN=' $API_FILE | cut -d= -f2-)
OWNER=$(grep '^GIT_OWNER=' $API_FILE | cut -d= -f2-)

if [ -z $1 ] ; then
	printf "${RED}REPO_NAME APP NAME not given";
	exit 1;
fi

if [ $OWNER == "" ] || [ $OWNER == "OWNER" ] ; then
	printf "${RED}GIT OWNER NOT SET";
	exit 1;
fi

if [ $GIT_ACCESS_TOKEN == "" ] || [ $GIT_ACCESS_TOKEN == "GIT_ACCESS_TOKEN" ] ; then
	printf "${RED}GIT TOKEN NOT SET";
	exit 1;
fi

function is_valid_url() {
    URL=$1
    if [[ "$URL" =~ ^https?://.+ ]]; then
        return 0
    else
        return 1
    fi
}

WEBHOOK_URL=$(echo "$WEBHOOK_URL" | sed 's/\\//g')

if ! is_valid_url "$WEBHOOK_URL"; then
    printf "{$RED}Error: Invalid webhook URL $WEBHOOK_URL.\n"
    exit 1
fi


function create_webhook() {
    curl -X POST \
         -H "Authorization: token $GIT_ACCESS_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{\"name\": \"web\", \"config\": {\"url\": \"$WEBHOOK_URL\", \"content_type\": \"json\"}, \"events\": [\"push\"], \"active\": true}" \
         "https://api.github.com/repos/$OWNER/$REPO_NAME/hooks"
    printf "{$YELLOW}Webhook created."
}

function delete_webhook() {
    WEBHOOK_ID=$(curl -s -H "Authorization: token $GIT_ACCESS_TOKEN" \
        "https://api.github.com/repos/$OWNER/$REPO_NAME/hooks" \
        | jq -r ".[] | select(.config.url == \"$WEBHOOK_URL\") | .id")

    if [ -n "$WEBHOOK_ID" ]; then
        curl -X DELETE \
            -H "Authorization: token $GIT_ACCESS_TOKEN" \
            "https://api.github.com/repos/$OWNER/$REPO_NAME/hooks/$WEBHOOK_ID"
         printf "{$RED}Webhook deleted."
    else
         printf "{$YELLOW}No webhook found with the specified URL."
    fi
}

if [ "$CURL_ACTION" == "DELETE" ]; then
    delete_webhook
else
    create_webhook
fi