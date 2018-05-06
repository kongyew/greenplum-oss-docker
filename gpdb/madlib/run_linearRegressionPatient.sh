#!/bin/bash

set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP TABLE IF EXISTS patients_logregr, patients_logregr_summary;"



# generates data for demo; should take at most 1--2 minutes
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "SELECT madlib.logregr_train( 'patients',                             -- Source table
                             'patients_logregr',                     -- Output table
                             'second_attack',                        -- Dependent variable
                             'ARRAY[1, treatment, trait_anxiety]',   -- Feature vector
                             NULL,                                   -- Grouping
                             20,                                     -- Max iterations
                             'irls'                                  -- Optimizer to use
                           );"


psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "SELECT * FROM patients_logregr_summary;"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "SELECT * from patients_logregr;"


cd $current
