#!/bin/bash
# Including configurations
. config.sh

docker run  -it --hostname=postgres8.3 \
    --name postgres8.3 \
    --privileged \
    --publish 5432:5432 \
    --publish 88:22 \
    --volume ${VOLUME}:/code \
    ${DOCKER_POSTGRES8.3_TAG} bin/bash

docker run  -it --hostname=postgres9.6 \
        --name postgres9.6 \
        --privileged \
        --publish 5432:5432 \
        --publish 88:22 \
        --volume ${VOLUME}:/code \
        ${DOCKER_POSTGRES9.6_TAG} bin/bash
