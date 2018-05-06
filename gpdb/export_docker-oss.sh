#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Including configurations
. ${DIR}/config.sh

echo "Find docker image with tag:  ${DOCKER_OSS_TAG}"
  if docker images |grep "${DOCKER_OSS_TAG}"; then
    echo "docker save ${DOCKER_OSS_TAG} > ./gpdboss.tar "
    docker save ${DOCKER_OSS_TAG} > ./gpdboss.tar
    echo "If you want load this image, use this command $ docker load ./gpdboss.tar"
  else
    echo "Error : Cannot find this image :  ${DOCKER_OSS_TAG}"
    exit 1
  fi

 du -sh *.tar
