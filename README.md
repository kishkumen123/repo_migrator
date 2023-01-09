# migrator
bitbucket to github repository migration script

## Description
As bitbucket continues its journey downhill from crap to worse, it makes no sense to use it anymore.
This script allows you to migrate all of your repositories from one to the other.<br />
With little modification you can use this script to work on individual repostories or a set of repositories.

## Usage
This is a bash(.sh) script. If you want to run this on windows, you will have to use a unix based terminal.<br />
You need to have jq installed in order for this script to work: https://github.com/stedolan/jq<br />
You need to set thse 4 variables in the script:<br />
- BITBUCKET_USERNAME=The username found in your account settings under Username<br />
- BITBUCKET_PASSWORD=A token generated under App Password with the correct permissions<br />
- GITHUB_USERNAME=Your github username<br />
- GITHUB_TOKEN=A token generated under Settings->Developer Settings->Personal access tokens->Tokens (classic)->Generate new token (classic) with the correct permissions<br />

And thats it. Run the script.

## Notes
If any repo is private, this script will fail once it gets to that specific repo. I will include a change to ignore private repos later, as it is annoying to have to change all your repos to public in order for this to work. But this isn't a feature at the moment.<br />

If the repo already exists, it will skip it and move on to the next one.<br />
