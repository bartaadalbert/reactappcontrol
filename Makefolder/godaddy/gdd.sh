#!/bin/bash
#usage domain/subdomain_name/ PUT default cen USE DELETE
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

DOMAIN=$1
SUB_DOMAIN=$2

# Get IP Address
# DEF_IP=`dig $DOMAIN +short @resolver1.opendns.com`

IP=${3:-`dig $DOMAIN +short @resolver1.opendns.com`}
CURL_EXTION=${4:-"PUT"}

# Use the API keys
API_FILE=${5:-"Makefolder/api_keys.conf"}
GODADDY_API_KEY=$(grep '^GODADDY_API_KEY=' $API_FILE | cut -d= -f2-)
GODADDY_API_SECRET=$(grep '^GODADDY_API_SECRET=' $API_FILE | cut -d= -f2-)

if [ -z $1 ] || [ -z $2 ]; then
	printf "${RED}Domain or subdomain not given";
	exit 1;
fi

if [ $GODADDY_API_KEY == "" ] || [ $GODADDY_API_KEY == "GODADDY_API_KEY" ] ; then
	printf "${RED}GDD API_KEY NOT SET";
	exit 1;
fi

if [ $GODADDY_API_SECRET == "" ] || [ $GODADDY_API_SECRET == "GODADDY_API_SECRET" ] ; then
	printf "${RED}GDD API_SECRET NOT SET";
	exit 1;
fi

if [ $CURL_EXTION == "PUT" ]; then
	read -p "Do you want to create a subdomain? (y/n): " create_subdomain
else
	read -p "Do you want to delete a subdomain? (y/n): " create_subdomain
fi

if [ "$create_subdomain" = "y" ] || [ "$create_subdomain" = "Y" ]; then
	if [ $CURL_EXTION == "PUT" ] || [ $CURL_EXTION == "DELETE" ]; then 
		
		# Create DNS A Record
		curl -X $CURL_EXTION \
		-H "Content-Type: application/json" \
		-H "Authorization: sso-key $GODADDY_API_KEY:$GODADDY_API_SECRET" \
		-H "Accept: application/json" \
		"https://api.godaddy.com/v1/domains/$DOMAIN/records/A/$SUB_DOMAIN" \
		-d "[{\"data\": \"$IP\", \"ttl\":600}]";
		
		if [ $CURL_EXTION == "PUT" ]; then
			printf "$BLUE subdomain was created $DOMAIN"
		else
			printf "$RED subdomain was deleted $DOMAIN"
		fi
	else
		printf "${YELLOW} YOU can use PUT or DELETE in CURL query, default PUT"
		exit 1;
	fi
else
	printf "$YELLOW Skipping subdomain creation."
fi