#!/bin/bash
#usage APP NAME POST default, can USE DELETE
RED='\033[0;31m'
YELLOW='\033[1;33m'

APP_NAME=$1
CURL_EXTION=${2:-"POST"}
# Use the API keys
API_FILE=${3:-"Makefolder/api_keys.conf"}
GIT_ACCESS_TOKEN=$(grep '^GIT_ACCESS_TOKEN=' $API_FILE | cut -d= -f2-)
OWNER=$(grep '^GIT_OWNER=' $API_FILE | cut -d= -f2-)

if [ -z $1 ] ; then
    printf "$RED APP NAME not given";
    exit 1;
fi

if [ $OWNER == "" ] || [ $OWNER == "OWNER" ] ; then
    printf "$RED GIT OWNER NOT SET";
    exit 1;
fi

if [ $GIT_ACCESS_TOKEN == "" ] || [ $GIT_ACCESS_TOKEN == "GIT_ACCESS_TOKEN" ] ; then
    printf "$RED GIT TOKEN NOT SET";
    exit 1;
fi

#USING DELETE CHECK TOKEN ACCESS!!!!!! 
URL=https://api.github.com/user/repos
if [ $CURL_EXTION == "DELETE" ]; then
    URL=https://api.github.com/repos/$OWNER/$APP_NAME
fi

if [ $CURL_EXTION == "POST" ] || [ $CURL_EXTION == "DELETE" ]; then 
    # Create REPO IN GITHUB
    curl -X $CURL_EXTION \
    -H 'Accept: application/vnd.github+json' \
    -H "Authorization: Bearer $GIT_ACCESS_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    $URL \
    -d "{\"name\":\"$APP_NAME\",\"homepage\":\"https://github.com\",\"private\":true,\"is_template\":false}" \
    | jq -r '.errors [].message'
    exit 0
elif [ $CURL_EXTION == "CHECK" ]; then
    CHECK_URL="https://api.github.com/repos/$OWNER/$APP_NAME"
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $GIT_ACCESS_TOKEN" $CHECK_URL)
    if [ $STATUS_CODE -eq 200 ]; then
        echo "yes"
    else
        echo "no"
    fi
    exit 0
else
    printf "$YELLOW YOU can use POST, DELETE, or CHECK in CURL query, default POST"
    exit 1;
fi