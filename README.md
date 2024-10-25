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


