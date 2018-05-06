#!/bin/bash
if [[ ! "$(whoami)" =~ ^(gpadmin|root)$ ]]
then
    echo "Please run the script as gpadmin or root" >&2
    exit 1
fi

set -e
[[ ${DEBUG} == true ]] && set -x

if [[ ! "$(whoami)" =~ ^(gpadmin|root)$ ]]
then
    echo "Please run the script as gpadmin or root" >&2
    exit 1
fi

if [ -f /etc/redhat-release ]; then  # Centos
  major_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)
elif [ -f /etc/lsb-release ]; then # Ubuntu
  major_version=$(rOS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/lsb-release`)
fi

check_stat=$(ps -ef | grep '[s]shd' | awk '{print $2}')
if [ -n "$check_stat" ]
then
   echo "SSHD is running"

else
   echo "SSHD isn't running"
   if [ -f /etc/redhat-release ]; then
     if  [ "$major_version" -ge "7" ]; then # "$a" -ge "$b" ]
         /usr/bin/ssh-keygen -A
         systemctl restart sshd.service  # Centos 7 or latest
     else
       service sshd start
     fi
   elif [ -f /etc/lsb-release ]; then
       /etc/init.d/ssh start
   elif [ -f /etc/os-release ]; then # SUSE
          /usr/sbin/sshd -D &
   fi
fi
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sshd process: $status"
  exit $status
fi

check_stat=$(ps -ef | grep '[s]shd' | awk '{print $2}')
if [ -n "$check_stat" ]
then
   echo "SSHD is running..."
fi

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

if [[ -z "$GPHOME" ]]  # if user specify GPHOME in the env , we will use it.
then
  if [ "$GPHOME" != "" ]
  then
      export GPDB_HOME=$GPHOME
  fi
fi


if [ -f $GPDB_HOME/greenplum_path.sh ]
then
  su gpadmin -l -c "echo \"host all all 0.0.0.0/0 md5\" >> /gpdata/master/gpseg-1/pg_hba.conf"
  su gpadmin -l -c "export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1;source $GPDB_HOME/greenplum_path.sh;gpstop -a;  exit 0"
else
  echo "Cannot find file: $GPDB_HOME/greenplum_path.sh"
fi
