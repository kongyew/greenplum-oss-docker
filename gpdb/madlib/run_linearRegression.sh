#!/bin/bash

set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP TABLE IF EXISTS regr_example_model;"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP TABLE IF EXISTS regr_example_model_summary;"


# generates data for demo; should take at most 1--2 minutes
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "SELECT madlib.linregr_train (
   'regr_example',         -- source table
   'regr_example_model',   -- output model table
   'y',                    -- dependent variable
   'ARRAY[1, x1, x2]'      -- independent variables
);"


psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "SELECT * from regr_example_model"
cd $current
