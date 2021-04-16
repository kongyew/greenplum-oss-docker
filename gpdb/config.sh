#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export BUILD_ENV="test"  # only 1 option for now.
# Greenplum
export CONTAINER_NAME="gpdbsne"

export DOCKER_OSS_LABEL="GPDB 6 OSS"
export DOCKER_OSS_TAG="kochanpivotal/gpdb6oss"
export DOCKER_LATEST_OSS_TAG="kochanpivotal/gpdb6oss:latest"

# CHANGEME to build different GPDB version
export GPDB_VERSION="6-6.15.0"
export GPDB_BINARY="greenplum-db-6"
