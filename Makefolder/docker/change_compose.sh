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
APP_IMAGE_NAME=${1:-"app"}
COMPOSE_NAME=${2:-"app_docker_compose.stub"}
REDIS_IMAGE_NAME=${3:-'redis'}
COMPOSE_NAME_STG=${4:-''}
DEFF_MAKER=${5:-"Makefolder/docker"}

if [[ "$1" == "" ]] || [[ "$2" == "" ]] || [[ "$3" == "" ]]; then
    echo "Using default values"
fi


#Create file config 
CONFIG="$PWD/$DEFF_MAKER/$(if [ -z $COMPOSE_NAME_STG ]; then echo $APP_IMAGE_NAME; else echo "stg_$APP_IMAGE_NAME"; fi).compose"

# echo $CONFIG
# echo $DEFF_MAKER
# exit 1

#CHECK THE UPDOWN FILE EXIST
if [[ ! -f $CONFIG ]]; then
    touch $CONFIG
    sleep 1
fi

cp "$PWD/$DEFF_MAKER/$COMPOSE_NAME" $CONFIG
$SED -i "s/{{APP_IMAGE_NAME}}/$APP_IMAGE_NAME/g" $CONFIG
$SED -i "s/{{REDIS_IMAGE_NAME}}/$REDIS_IMAGE_NAME/g" $CONFIG



