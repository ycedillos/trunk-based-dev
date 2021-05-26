#!/bin/bash

echo "Pull Request"
echo "TRAVIS_PULL_REQUEST_BRANCH=${TRAVIS_PULL_REQUEST_BRANCH}"
echo "TRAVIS_BRANCH=${TRAVIS_BRANCH}"

echo "TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}"
echo "TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}"
echo "TRAVIS_TAG=${TRAVIS_TAG}"

echo "TRAVIS_BUILD_DIR=${TRAVIS_BUILD_DIR}"
echo "TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}"
echo "TRAVIS_BUILD_NUMBER=${TRAVIS_BUILD_NUMBER}"
echo "TRAVIS_BUILD_WEB_URL=${TRAVIS_BUILD_WEB_URL}"
echo "TRAVIS_COMMIT=${TRAVIS_COMMIT}"
echo "TRAVIS_COMMIT_MESSAGE=${TRAVIS_COMMIT_MESSAGE}"
echo "TRAVIS_COMMIT_RANGE=${TRAVIS_COMMIT_RANGE}"
echo "TRAVIS_DIST=${TRAVIS_DIST}"
echo "TRAVIS_COMPILER=${TRAVIS_COMPILER}"
echo "TRAVIS_DEBUG_MODE=${TRAVIS_DEBUG_MODE}"
echo "TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}"

git fetch --tags
git fetch --unshallow
echo "show name"
#git rev-parse --abbrev-ref HEAD
export BRANCH_PRUEBAS=`git rev-parse --abbrev-ref HEAD`
echo "BRANCH_PRUEBAS=${BRANCH_PRUEBAS}"

# Return if we are not in a Pull Request
#[[ "$TRAVIS_PULL_REQUEST" = "false" ]] && return

GITHUB_PR_URL=https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST
GITHUB_PR_BODY=$(curl -s $GITHUB_PR_URL 2>/dev/null)

if [[ $GITHUB_PR_BODY =~ \"ref\":\ *\"([a-zA-Z0-9_-]*)\" ]]; then
  export TRAVIS_BRANCH=${BASH_REMATCH[1]}
fi

if [[ $GITHUB_PR_BODY =~ \"repo\":.*\"clone_url\":\ *\"https://github\.com/([a-zA-Z0-9_-]*/[a-zA-Z0-9_-]*)\.git.*\"base\" ]]; then
  export TRAVIS_REPO_SLUG=${BASH_REMATCH[1]}
fi