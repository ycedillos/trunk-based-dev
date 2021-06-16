#!/bin/bash

install_graphql_scheme_registry () {
  echo "Install schema registry"

  git clone https://github.com/${GRAPHQL_REPO_ORG}/${GRAPHQL_REPO_NAME}.git
  cd ${GRAPHQL_REPO_NAME}

  git checkout tags/${GRAPHQL_REPO_TAG} -b work

  #gcloud auth configure-docker

  docker build -f Dockerfile \
              --no-cache \
              --build-arg env=production \
              -t $DOCKER_IMAGE_NAME .

  docker tag $DOCKER_IMAGE_NAME $DOCKER_IMAGE_URL:$GRAPHQL_REPO_TAG

  docker push $DOCKER_IMAGE_URL:$GRAPHQL_REPO_TAG

}