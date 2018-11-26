#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Including configurations
. "${DIR}"/config.sh


docker run --restart on-failure -p 18630:18630 -d --name streamsets-dc streamsets/datacollector
# The default username and password are "admin" and "admin".
