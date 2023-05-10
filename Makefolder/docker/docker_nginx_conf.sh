#!/bin/bash
RED='\033[0;31m'
DEFF_MAKER=${3:-"Makefolder/docker"}
#LINUX
# SED=$(which sed)
#MACOS, brew install gnu-sed
# SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;;
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac
APP_PORT=${2:-8000}
STATIC_FILES=${3:-'/home/myuser/web/static/'}
MEDIA_FILES=${4:-'/home/myuser/web/media/'}

if [[ "$1" != "" ]]; then
    DOCKER_HOST_NAME=$(echo $1)
    echo "Creating revers proxy for:" $DOCKER_HOST_NAME
else
    echo -e "${RED}invalid hostname"
     exit 1
fi

#Create file for checking messaging 
CONFIG="$PWD/$DEFF_MAKER/$DOCKER_HOST_NAME.conf"


#CHECK THE UPDOWN FILE EXIST
if [[ ! -f $CONFIG ]]; then
    touch $CONFIG
    sleep 3
fi

cp "$PWD/$DEFF_MAKER/nginx.stub" $CONFIG
$SED -i "s/{{DOCKER_HOST_NAME}}/$DOCKER_HOST_NAME/g" $CONFIG
$SED -i "s/{{APP_PORT}}/$APP_PORT/g" $CONFIG
###WE NEED TO CHANGE THE / to any other | because we have path in this example
$SED -i "s|{{STATIC_FILES}}|$STATIC_FILES|g" $CONFIG
$SED -i "s|{{MEDIA_FILES}}|$MEDIA_FILES|g" $CONFIG


