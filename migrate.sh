#!/bin/bash
set -e

# Set your Bitbucket and GitHub credentials
BITBUCKET_USERNAME=
BITBUCKET_TOKEN=
GITHUB_USERNAME=
GITHUB_TOKEN=


REPOSITORIES=()

echo " "
echo "-- Get a list of all repositories on Bitbucket, handling pagination"
URL="https://api.bitbucket.org/2.0/repositories/$BITBUCKET_USERNAME"
while [ "$URL" != "null" ]; do
    # "Get the current page of repositories"
    RESULT=$(curl -s -u $BITBUCKET_USERNAME:$BITBUCKET_TOKEN $URL)

    # "Extract the list of repositories from the current page"
    PAGE_REPOSITORIES=$(echo $RESULT | jq -r '.values[].slug')

    # "Add the repositories from the current page to the list"
    REPOSITORIES+="$PAGE_REPOSITORIES"
    REPOSITORIES+=$'\n'

    # "Get the URL of the next page (if any)"
    URL=$(echo $RESULT | jq -r '.next')
done

# Echo out the repo collected
echo " -- Repositories = [$REPOSITORIES]"
echo " "
echo "----------------------------------------------"
echo "Migrating each repository"
echo "----------------------------------------------"

# Loop over all repositories and migrate each repo
IFS=$'\n'
for REPOSITORY in $REPOSITORIES; do
    # remove newlines from the end of each repo string
    REPOSITORY=$(echo "$REPOSITORY" | sed 's/\n//g')
    echo "  Repository:" 
    echo "    - Name: $REPOSITORY"

    DESCRIPTION=$(curl -s -u $BITBUCKET_USERNAME:$BITBUCKET_TOKEN "https://api.bitbucket.org/2.0/repositories/$BITBUCKET_USERNAME/$REPOSITORY" | jq -r '.description')
    echo "    - Description: $DESCRIPTION"
    echo " " 

    echo "  Create the repository on GitHub"
    RESULT=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/user/repos -H "Content-Type: application/json" -d "{\"name\":\"$REPOSITORY\", \"description\":\"$DESCRIPTION\"}")
    if [[ $RESULT == *'"name already exists on this account"'* ]]; then
      echo "  *** Error: name $REPOSITORY already exists on this account"
      echo "  *** Skipping to next repository"
      echo "----------------------------------------------"
      continue
    elif [[ $RESULT == *'"errors"'* ]]; then
      echo "  *** Unexpected error occured when creating new repo: (RESULT: $RESULT)"
      exit 1
    fi

    echo "  Get the repository's clone URL on Bitbucket"
    BITBUCKET_URL=$(curl -s -u $BITBUCKET_USERNAME:$BITBUCKET_TOKEN https://api.bitbucket.org/2.0/repositories/$BITBUCKET_USERNAME/$REPOSITORY | jq -r '.links.clone[0].href')
    echo "    - BITBUCKET_URL: $BITBUCKET_URL"

    echo "  Get the repository's clone URL on GitHub"
    GITHUB_URL=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/repos/$GITHUB_USERNAME/$REPOSITORY | jq -r '.clone_url')
    echo "    - GITHUB_URL: $GITHUB_URL"
    echo " "

    echo "  Mirror the repository from Bitbucket to GitHub"
    if [ -d "$REPOSITORY.git" ]; then
    rm -rf "$REPOSITORY.git"
    fi
    git clone --mirror $BITBUCKET_URL
    echo "  - Cloning: $BITBUCKET_URL"
    cd $REPOSITORY.git
    git push --mirror $GITHUB_URL
    echo "  - Pushing: $GITHUB_URL"
    cd ..
    rm -rf $REPOSITORY.git
    echo "----------------------------------------------"
done
echo "Done."
