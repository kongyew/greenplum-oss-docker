#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

# Determine greenplum installation
if [ -d "/usr/local/gpdb" ]
then
  psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "\i /usr/local/gpdb/share/postgresql/contrib/dblink.sql"
else
  if [ -d "/usr/local/greenplum-db" ]
  then
    psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "\i /usr/local/greenplum-db/share/postgresql/contrib/dblink.sql"
  else
      echo "Error: Directory /usr/local/greenplum-db does not exists."
  fi
fi

cd $current
