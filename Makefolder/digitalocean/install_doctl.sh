#!/bin/bash

# Get the latest doctl release version
DOCTL_VERSION=$(curl --silent "https://api.github.com/repos/digitalocean/doctl/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Download the doctl binary for Unix systems
# curl -sL "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz" -o doctl.tar.gz

# Download the doctl binary for macOS
# curl -sL "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-darwin-amd64.tar.gz" -o doctl.tar.gz

case "$OSTYPE" in
  darwin*)  curl -sL "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-darwin-amd64.tar.gz" -o doctl.tar.gz ;; 
  linux*)   curl -sL "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz" -o doctl.tar.gz ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac

# Extract the binary and make it executable
tar xzf doctl.tar.gz && chmod +x doctl

# Move the binary to /usr/local/bin
sudo mv doctl /usr/local/bin

# Clean up
rm -f doctl.tar.gz

echo "doctl version ${DOCTL_VERSION} installed."
