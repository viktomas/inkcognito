#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

JOURNAL_FILE="${SCRIPT_DIR}/journal.age"
TEMP_FILE=$(mktemp)
LOCK_FILE="${SCRIPT_DIR}/journal.lock"
VIM_INIT_FILE="${SCRIPT_DIR}/init.lua"
# Generate this file with app-keygen -o key_file && app-keygen -y journal_recipient.txt key_file
RECIPIENTS_FILE="${SCRIPT_DIR}/public-key.txt"

generate_age_key() {
	# Run age-keygen and capture its output
	local output
	output=$(age-keygen 2>&1)

	# Extract the public key using grep and sed
	echo "$output" | grep "public key:" | sed 's/# public key: //' >public-key.txt

	# Extract and display the private key
	echo "Private key (store this somewhere safe):"
	echo "$output" | grep "AGE-SECRET-KEY-"
}

cleanup() {
	rm -f "$TEMP_FILE"
	rm -f "$LOCK_FILE"
}

trap cleanup EXIT

# Check if the script is already running
if [ -f "$LOCK_FILE" ]; then
	echo "Another instance of the journal script is running."
	exit 1
fi

# Create lock file
touch "$LOCK_FILE"

# Check if public key exists
if [ ! -f "$RECIPIENTS_FILE" ]; then
	echo "Public key file not found. I'll generate a keypair for you."
	generate_age_key
	echo "Now you can run the script again, enter the generated key, and start journaling."
	exit 1
fi

# Prompt for private key
# echo "Enter your private key (Ctrl+D when finished):"
# PRIVATE_KEY=$(cat)
# Prompt for password
read -s -p "Enter key: " PRIVATE_KEY

echo

# Decrypt the journal
if [ -f "$JOURNAL_FILE" ]; then
	echo "$PRIVATE_KEY" | age --decrypt --identity - "$JOURNAL_FILE" >"$TEMP_FILE"
else
	touch "$TEMP_FILE"
fi

# Open the decrypted file in Neovim
nvim -u "$VIM_INIT_FILE" "$TEMP_FILE"

# Encrypt the modified file
if age --encrypt -R "$RECIPIENTS_FILE" -o "$JOURNAL_FILE.new" "$TEMP_FILE"; then
	mv "$JOURNAL_FILE.new" "$JOURNAL_FILE"
else
	echo "Encryption failed. Journal content:" >&2
	cat "$TEMP_FILE" >&2
	exit 1
fi

# Securely delete the temporary file
shred -u "$TEMP_FILE"
