#!/bin/bash
# Including configurations
. config.sh

#
docker stop $(docker ps -aq)

#check
# docker ps -a
