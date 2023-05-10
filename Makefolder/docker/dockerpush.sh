#!/usr/bin/env bash
SOCKET_NAME=docker-tunnel-socket
REMOTE_USER=root
REMOTE_HOST=jsonsmile.com
IMAGE=$1

if [ -z $1 ];then
  echo "Image name not valid"
  exit 1
fi
# open ssh tunnel to remote-host, with a socket name so that we can close it later
ssh -M -S $SOCKET_NAME -fnNT -L 5000:$REMOTE_HOST:5000 $REMOTE_USER@$REMOTE_HOST

if [ $? -eq 0 ]; then
  echo "SSH tunnel established, we can push image"
  # push the image to remote host via tunnel
  docker push localhost:5000/$IMAGE
fi
# close the ssh tunnel using the socket name
ssh -S $SOCKET_NAME -O exit $REMOTE_USER@$REMOTE_HOST