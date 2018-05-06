#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Greenplum
export GREENPLUM_HOST=gpdbsne
export GREENPLUM_USER=gpadmin
export GREENPLUM_DB=pljava_db
export GREENPLUM_DB_PWD=pivotal
export PGPASSWORD=${GREENPLUM_DB_PWD}
