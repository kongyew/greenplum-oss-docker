#!/bin/bash
# Including configurations
. config.sh

export BUILD_ENV="test"
export VOLUME=`pwd`

docker run -it --hostname=gpdbsne \
    --add-host gpdbsne:127.0.0.1 \
    --add-host gpdbsne.localdomain:127.0.0.1 \
    --name gpdb6oss \
    --publish 5432:5432 \
    --publish 88:22 \
    --volume ${VOLUME}:/code \
    ${DOCKER_OSS_TAG} bin/bash
