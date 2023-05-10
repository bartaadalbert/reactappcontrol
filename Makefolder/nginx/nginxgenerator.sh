#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

DEFF_MAKER=${3:-"Makefolder/nginx"}
case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;; 
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac
PROXYPASS=${2:-"http://127.0.0.1:8888"}
LISTEN=${3:-80}

# check the domain is valid!
PATTERN="^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"
if [[ "$1" =~ $PATTERN ]]; then
  SERVERNAME=$(echo $1 | tr '[A-Z]' '[a-z]')
  printf "$BLUE Creating hosting for:" $SERVERNAME
else
  printf "$RED invalid domain name"
  exit 1
fi


#Create file for checking messaging 
CONFIG="$PWD/$DEFF_MAKER/$SERVERNAME.conf"


# Check if the file exists
if [[ -f $CONFIG ]]; then
    # Prompt user if they want to proceed with creating the Nginx configuration
    read -p "Nginx configuration for $SERVERNAME already exists. Do you want to overwrite it? (y/n): " proceed
    if [ "$proceed" != "y" ] && [ "$proceed" != "Y" ]; then
      printf "$YELLOW Skipping Nginx configuration creation."
      exit 0
    fi
fi

#CHECK THE UPDOWN FILE EXIST
if [[ ! -f $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/$DEFF_MAKER/subdomain.stub" $CONFIG
$SED -i "s/{{SERVERNAME}}/$SERVERNAME/g" $CONFIG
$SED -i "s/{{PROXYPASS}}/$PROXYPASS/g" $CONFIG
$SED -i "s/{{LISTEN}}/$LISTEN/g" $CONFIG

printf "$BLUE The nginx conf $CONFIG was created successfully"


