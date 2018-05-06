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

export DOCKER_LABEL4="GPDB 4"
export DOCKER_TAG4="kochanpivotal/gpdb4"
export DOCKER_LATEST_TAG4="kochanpivotal/gpdb4:latest"

export DOCKER_LABEL="GPDB 5"
export DOCKER_TAG="kochanpivotal/gpdb5"
export DOCKER_LATEST_TAG="kochanpivotal/gpdb5:latest"

export DOCKER_SUSE_LATEST_TAG="kochanpivotal/gpdb5suse:latest"

# CHANGEME to build different GPDB version
export GPDB_VERSION="5.7.0-rhel6-x86_64"
#export GPDB_VERSION="4.3.19.0-rhel5-x86_64"
# greenplum-db-4.3.19.0-rhel5-x86_64.zip
export GPDB_SUSE_VERSION="5.7.0-sles11-x86_64"

#export GPDB_DOWNLOAD="greenplum-downloader/DOWNLOAD_4.3.19.0"
export GPDB_DOWNLOAD="greenplum-downloader/DOWNLOAD_5.7.0"

export DOCKER_PXF_LABEL="GPDB 5-PXF"
export DOCKER_PXF_TAG="kochanpivotal/gpdb5-pxf"
export DOCKER_PXF_LATEST_TAG="kochanpivotal/gpdb5-pxf:latest"
# Alluxio
export DOCKER_ALLUXIO_LABEL="GPDB 5-alluxio"
export DOCKER_ALLUXIO_TAG="kochanpivotal/gpdb5-alluxio"

# Madlib
export DOCKER_MADLIB_LABEL="GPDB5-madlib"
export DOCKER_MADLIB_TAG="kochanpivotal/gpdb5-madlib:latest"
