#!/bin/bash

#source ci-cd/scripts/functions.sh

echo "TRAVIS_PULL_REQUEST_BRANCH: ${TRAVIS_PULL_REQUEST_BRANCH}"
echo "TRAVIS_COMMIT: ${TRAVIS_COMMIT}" # it is available on merge 
echo "TRAVIS_COMMIT_MESSAGE: ${TRAVIS_COMMIT_MESSAGE}"
echo "TRAVIS_BRANCH: ${TRAVIS_BRANCH}"
echo "TRAVIS_COMMIT_RANGE: ${TRAVIS_COMMIT_RANGE}"
echo "TRAVIS_EVENT_TYPE: ${TRAVIS_EVENT_TYPE}"

docker-compose up -d