#!/bin/bash

set -e

DOCKER_IMAGE_NAME="dochroot-build"
DOCKER_CONTAINER_NAME="dochroot-build-container"

if [[ $(docker ps -a | grep $DOCKER_CONTAINER_NAME) != "" ]]; then
  docker rm -f $DOCKER_CONTAINER_NAME 2>/dev/null
fi

docker build -t $DOCKER_IMAGE_NAME .

docker run --volume "$GOPATH"/src/:/go/src/ --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME make "$@"

if [[ "$@" == *"clean"* ]] && [[ -d bin ]]; then
  rm -Rf bin
fi

docker cp $DOCKER_CONTAINER_NAME:/go/src/github.com/yuuki1/dochroot/dochroot .
