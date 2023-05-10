#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'


# Convert arguments to arrays
# SECRETS=($1)
# EXPECTED_VALUES=($2)

# Convert arguments to arrays
IFS=',' read -ra SECRETS <<< "$1"
IFS=',' read -ra EXPECTED_VALUES <<< "$2"
# Print arrays for testing 
# echo "SECRETS: ${SECRETS[@]}"
# echo "EXPECTED_VALUES: ${EXPECTED_VALUES[@]}"
# Get the deploy key file path from the expected values array
SSH_KEY_FILE=${EXPECTED_VALUES[2]}

REPO_NAME=${3:-"REPO_NAME"}
# Use the API keys
API_FILE=${4:-"Makefolder/api_keys.conf"}
GIT_ACCESS_TOKEN=$(grep '^GIT_ACCESS_TOKEN=' $API_FILE | cut -d= -f2-)
OWNER=$(grep '^GIT_OWNER=' $API_FILE | cut -d= -f2-)

$PY_GEN=${5:-"Makefolder/git/encrypt_secret.py"}
# Print the array
# echo "${EXPECTED_VALUES[2]}"
# exit 1

# Check if the SSH key file exists and is not empty

if [[ -s "$SSH_KEY_FILE" ]]; then
    SSH_PRIVATE_KEY=$(cat "$SSH_KEY_FILE")
else
    printf "$YELLOW SSH key file not found or empty:${NC} $SSH_KEY_FILE "
    read -p "Do you want to create a new SSH key? (y/n): " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "$BLUE Creating new SSH key..."
        read -p "Enter file name (default: id_rsa): " -r
        SSH_KEY_NAME=${REPLY:-id_rsa}
        read -p "Enter passphrase (empty for no passphrase): " -r
        SSH_PASSPHRASE=$REPLY

        ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_FILE" -N "$SSH_PASSPHRASE"
        SSH_PRIVATE_KEY=$(cat "$SSH_KEY_FILE")
        printf "$GREEN SSH key created."
    else
        printf "$RED SSH key not created. Exiting."
        exit 1
    fi
fi

EXPECTED_VALUES[2]="$SSH_PRIVATE_KEY"
# Add the public key to the remote host
REMOTE_USER=${EXPECTED_VALUES[0]}
REMOTE_HOST=${EXPECTED_VALUES[1]}
ssh-copy-id -i "$SSH_KEY_FILE.pub" "${REMOTE_USER}@${REMOTE_HOST}"

# Check the exit status of the ssh-copy-id command
if [ $? -eq 0 ]; then
    printf "$GREEN SSH key successfully added to the remote host.(GITHUB WILL BE USE)"
else
    printf "$RED Error: Failed to add SSH key to the remote host."
    exit 1
fi


# Check if GitHub PAT is set
if [ $GIT_ACCESS_TOKEN == "" ] || [ $GIT_ACCESS_TOKEN == "GIT_ACCESS_TOKEN" ] ; then
    printf "$RED GIT TOKEN NOT SET";
    exit 1;
fi

if [ $REPO_NAME == "REPO_NAME" ] ; then
    printf "$RED APP NAME not given";
    exit 1;
fi

if [ $OWNER == "" ] || [ $OWNER == "OWNER" ] ; then
    printf "$RED GIT OWNER NOT SET";
    exit 1;
fi

# Get the public key for the repository
response=$(curl -s -H "Authorization: token $GIT_ACCESS_TOKEN" "https://api.github.com/repos/$OWNER/$REPO_NAME/actions/secrets/public-key")
public_key=$(echo "$response" | jq -r '.key')
key_id=$(echo "$response" | jq -r '.key_id')

printf "$GREEN API response for public key: $response"
printf "$GREEN Public key: $public_key"
printf "$GREEN Key ID: $key_id"
# exit 1
# Loop through the secrets
for i in "${!SECRETS[@]}"; do
  SECRET_NAME="${SECRETS[$i]}"
  EXPECTED_VALUE="${EXPECTED_VALUES[$i]}"

  # Encrypt the value
  # encrypted_value=$(echo -n "$SECRET_VALUE" | sodium seal --pk <(echo "$PUBLIC_KEY" | base64 -D) | base64)
  encrypted_value=$(Makefolder/git/encrypt_secret.py "$public_key" "$EXPECTED_VALUE")
#   printf "$encrypted_value"
#   exit 1
  printf "$GREEN Encrypted value for $SECRET_NAME: $encrypted_value"
  # Create or update the secret
  response=$(curl -s -X PUT -H "Authorization: token $GIT_ACCESS_TOKEN" -H "Content-Type: application/json" -d "{\"encrypted_value\":\"$encrypted_value\", \"key_id\":\"$key_id\"}" "https://api.github.com/repos/$OWNER/$REPO_NAME/actions/secrets/$SECRET_NAME")
  printf "$YELLOW API response: $response"
  printf "$GREEN Updated secret $SECRET_NAME with value $EXPECTED_VALUE.\n"
done

encrypt_and_set_secret() {
  secret_name="$1"
  secret_value="$2"
  encrypted_secret=$(echo -n "$secret_value" | openssl rsautl -encrypt -pubin -inkey <(echo "-----BEGIN PUBLIC KEY----- $public_key -----END PUBLIC KEY-----") | base64 | tr -d '\n')
  echo "Updated secret $secret_name with value $encrypted_secret"
}

encrypt_secret() {
  secret_value="$1"
  encrypted_secret=$(echo -n "$secret_value" | openssl rsautl -encrypt -pubin -inkey <(echo "-----BEGIN PUBLIC KEY-----
$public_key
-----END PUBLIC KEY-----") | base64 | tr -d '\n')
  echo "$encrypted_secret"
}
