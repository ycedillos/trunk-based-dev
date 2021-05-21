#!/bin/bash

echo "TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}"
echo "TRAVIS_BRANCH=${TRAVIS_BRANCH}"
echo "TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}"

case ${TRAVIS_BRANCH} in
    "main")

        docker build -f ci-cd/docker/Dockerfile \
               -t $DOCKER_IMAGE_NAME .


    ;;
esac