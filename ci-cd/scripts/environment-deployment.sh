#!/bin/bash

#Expected format of tags
# QA         v#.#.#-qa
# DEMO       v#.#.#-demo
# Production v.#.#.#
echo "TRAVIS_TAG=${TRAVIS_TAG}"
export TARGET_ENVIRONMENT=""
echo "TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}"
echo "TRAVIS_BRANCH=${TRAVIS_BRANCH}"
echo "TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}"
echo "TRAVIS_TAG=${TRAVIS_TAG}"

IFS='-'     # space is set as delimiter
read -ra ADDR <<< "$TRAVIS_TAG"   # TRAVIS_TAG is read into an array as strings separated by IFS

#Get length of array
if [[ ${#ADDR[@]} == 2 ]];
then
   export TARGET_ENVIRONMENT=${ADDR[1]}
fi
if [[ ${#ADDR[@]} == 1 ]];
then
   export TARGET_ENVIRONMENT=production
fi

echo "Nuevo despliegue"
echo "commit 1"
echo "commit 2"
echo "commit after git tag"
echo "commit 2 after git tag"

case ${TARGET_ENVIRONMENT} in
  "qa")

    echo "Deployment to QA"
    #docker build -f ci-cd/docker/Dockerfile \
    #        --build-arg NODE_ENV=development \
    #        -t $DOCKER_IMAGE_NAME .

    #docker tag $DOCKER_IMAGE_NAME $DOCKER_IMAGE_URL_DEV:$TRAVIS_BUILD_ID

    #docker push $DOCKER_IMAGE_URL_DEV:$TRAVIS_BUILD_ID

  ;;
    "demo")

    echo "Deployment to DEMO"
    #docker build -f ci-cd/docker/Dockerfile \
    #        --build-arg NODE_ENV=development \
    #        -t $DOCKER_IMAGE_NAME .

    #docker tag $DOCKER_IMAGE_NAME $DOCKER_IMAGE_URL_DEV:$TRAVIS_BUILD_ID

    #docker push $DOCKER_IMAGE_URL_DEV:$TRAVIS_BUILD_ID

  ;;
    "production")

    echo "Deployment to Production"
    #docker build -f ci-cd/docker/Dockerfile \
    #        --build-arg NODE_ENV=production \
    #        -t $DOCKER_IMAGE_NAME .

    #docker tag $DOCKER_IMAGE_NAME $DOCKER_IMAGE_URL_PROD:$TRAVIS_BUILD_ID

    #docker push $DOCKER_IMAGE_URL_PROD:$TRAVIS_BUILD_ID

  ;;
esac