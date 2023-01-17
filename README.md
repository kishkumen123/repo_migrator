# repo_migrator
Bitbucket to GitHub repository migration script

## Description
As I've become more frustrated with Bitbucket's bad interface and user experience, I've decided to migrate all of my repositories to GitHub.
This script allows you to migrate all of your repositories from one to the other.

With a bit of modification you can use this script to work on individual repostories or a set of repositories.

## Usage
This is a bash(.sh) script. If you want to run this on windows, you will have to use a unix based terminal.

You need to have jq installed in order for this script to work: https://github.com/stedolan/jq

You need to set thse 4 variables in the script:
- BITBUCKET_USERNAME=The username found in your account settings under Username
- BITBUCKET_PASSWORD=A token generated under App Password with the correct permissions
- GITHUB_USERNAME=Your GitHub username
- GITHUB_TOKEN=A token generated under Settings->Developer Settings->Personal access tokens->Tokens (classic)->Generate new token (classic) with the correct permissions

## Notes
If any repo is private, this script will fail once it gets to that specific repo. I will include a change to ignore private repos later, as it is annoying to have to change all your repos to public in order for this to work. But this isn't a feature at the moment.<br />

If the repo already exists, it will skip it and move on to the next one.<br />
