#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export DOCKER_POSTGRES8.3_LABEL="latest"
export DOCKER_POSTGRES8.3_TAG="dequis/postgresql-8.3"

export DOCKER_POSTGRES9.6_LABEL="latest"
export DOCKER_POSTGRES9.6_TAG="sameersbn/postgresql:9.6-2"
