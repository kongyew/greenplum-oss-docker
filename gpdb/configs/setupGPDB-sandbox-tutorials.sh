#!/bin/bash
cd /home/gpadmin

# echo "Download gpdb-sandbox-tutorials"
# git clone git@github.com:greenplum-db/gpdb-sandbox-tutorials.git
# cd gpdb-sandbox-tutorials;git pull > /dev/null 2>&1;

wget https://github.com/greenplum-db/gpdb-sandbox-tutorials/raw/master/faa.tar.gz

echo "Untar faa"
tar xvfz faa.tar.gz
