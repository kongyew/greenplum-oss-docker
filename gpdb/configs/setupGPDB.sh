#!/bin/bash
set -x
[[ ${DEBUG} == true ]] && set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Including files
. ${DIR}/util.sh

startInit
startSSH

rm -rf /tmp/.s*

# Default environment:
if [ -f /usr/local/greenplum-db/greenplum_path.sh ]; then
  export GPDB_HOME="/usr/local/greenplum-db"
fi

if [ -f /opt/gpdb/greenplum_path.sh ]; then
  export GPDB_HOME="/opt/gpdb"
fi
################################################################################
while getopts ":hg:" opt; do
  case $opt in
    g)
      echo "Greenplum home is : $OPTARG" >&2
      export GPDB_HOME=$OPTARG
      ;;
    h)

      echo "Help: Please specify greenplum home such as  " >&2

      exit 0;
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# if [ -z ${GPHOME} ]  # if user specify GPHOME in the env , we will use it.
# then
#    export GPDB_HOME=$GPHOME
#    echo "Variable GPDB_HOME:$GPDB_HOME"
# fi
su gpadmin -l -c "source $GPDB_HOME/greenplum_path.sh;gpssh-exkeys -f /tmp/gpdb-hosts"
su gpadmin -l -c "source $GPDB_HOME/greenplum_path.sh;gpinitsystem -a -c  /tmp/gpinitsystem_singlenode -h /tmp/gpdb-hosts; exit 0 "
su gpadmin -l -c "export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1;source $GPDB_HOME/greenplum_path.sh;psql -d template1 -c \"alter user gpadmin password 'pivotal'\"; createdb gpadmin;  exit 0"
su gpadmin -l -c "echo \"host all all 0.0.0.0/0 md5\" >> /gpdata/master/gpseg-1/pg_hba.conf"
