# InkCognito

`inkcognito` gives you encrypted document for all your thoughts. The encryption uses `age`. Journal also provides NeoVim configuration for absolute privacy - no backup files or undo history that could be read after you close your journal.

## Prerequisites

1. Install `nvim`, `git`, and `age`

## First use

1. Create your journal folder (e.g. `mkdir journal`)
1. Enter it and make it a git repository `cd journal && git init`
1. Add InkCognito as a submodule `git submodule add git@github.com:viktomas/inkcognito.git`
1. Run `./inkcognito/journal.sh` and store your private key.

## Usage

1. Run `./inkcognito/journal.sh` to start journaling.
1. You'll be prompted for the private key every time you try to open your journal

<details><summary> Claude's ideas for improvements </summary>


The code looks generally secure in its handling of age encryption, but there are a few potential improvements and considerations:

1. The private key is stored in a shell variable (`PRIVATE_KEY`), which could be visible in process listings or system logs. Consider using a file descriptor instead.
2. You might want to clear the private key from memory after use:

bash

`PRIVATE_KEY=""  # Clear the variable after use`

3. The `shred` command is good, but you might want to ensure it exists and falls back to alternatives:

bash

`if command -v shred >/dev/null 2>&1; then     shred -u "$TEMP_FILE" else     rm -P "$TEMP_FILE"  # On macOS fi`

4. You might want to set stricter permissions on the temporary file:

bash

`TEMP_FILE=$(mktemp) chmod 600 "$TEMP_FILE"`

5. Consider adding umask setting:

bash

`umask 077  # At the beginning of the script`

6. You might want to validate the private key format before using it:

bash

`if ! echo "$PRIVATE_KEY" | grep -q "^AGE-SECRET-KEY-"; then     echo "Invalid key format" >&2    exit 1 fi`

Here's how you could handle the private key more securely using a file descriptor:

bash

`# Instead of storing in a variable exec 3<<< "$PRIVATE_KEY" age --decrypt --identity /dev/fd/3 "$JOURNAL_FILE" >"$TEMP_FILE" exec 3<&-`

These changes would make the script more secure and robust.

</details>
