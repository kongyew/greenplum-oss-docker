#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export BUILD_ENV="test"  # only 1 option for now.
# Greenplum
export CONTAINER_NAME="gpdbsne"

export DOCKER_OSS_LABEL="GPDB 5 OSS"
export DOCKER_OSS_TAG="kochanpivotal/gpdb5oss"
export DOCKER_LATEST_OSS_TAG="kochanpivotal/gpdb5oss:latest"

# CHANGEME to build different GPDB version
export GPDB_VERSION="GPDB OSS"
