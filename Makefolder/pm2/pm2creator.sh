#!/bin/bash
RED='\033[0;31m'
#LINUX
# SED=$(which sed)
#MACOS, brew install gnu-sed
# SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;; 
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac
APP_NAME=${1:-"my_app"}
FINAL_PORT=${2:-3000}
DEFF_MAKER=${3:-"Makefolder/pm2"}


#CHECK THE UPDOWN FILE EXIST
if [[ ! -d $APP_NAME ]]; then
    echo -e "${RED}Your app was not configured"
    exit 1
fi

#Create file for checking messaging 
CONFIG="$PWD/$DEFF_MAKER/$APP_NAME.config.js"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/$DEFF_MAKER/pm2.stub" $CONFIG
$SED -i "s/{{APP_NAME}}/$APP_NAME/g" $CONFIG
sleep 1
$SED -i "s/{{FINAL_PORT}}/$FINAL_PORT/g" $CONFIG