#!/bin/bash
# reference : https://discuss.pivotal.io/hc/en-us/articles/209311318-HowTo-Install-pljava-Package-
# http://gpdb.docs.pivotal.io/530/ref_guide/extensions/pl_java.html
set -e
export GPDB_HOSTS=/tmp/gpdb-hosts
current=`pwd`

cd `dirname $0`
################################################################################
function InstallPLJava()
{
  echo "Find greenplum-db GPDB_HOME: [$GPDB_HOME]"
  echo "Find pljava package ..."
  export in_file=`ls $INSTALLDIR/pljava*.gppkg`
  if [ -f $in_file ]; then
    echo "Found pljava package :[$in_file]"
  else
    exit -1;
  fi
  cd $INSTALLDIR
  export out_file="$(echo $in_file | sed 's=.*/==;s/\.[^.]*$/.gppkg/')"
  echo "gppkg --install $out_file"
  gppkg --install $out_file
}
################################################################################

function InstallJDK()
{
  echo "Install Java on each Greenplum Database segment host"
  # Fix this issue "Rpmdb checksum is invalid: dCDPT(pkg checksums)"
  gpssh -e -v -f ${GPDB_HOSTS} -u root rpm --rebuilddb
  #;  yum clean all
  gpssh -e -v -f ${GPDB_HOSTS} -u root yum -y install wget java-1.8.0-openjdk-1.8.0*

  echo "Update the gpadmin user’s .bash_profile file on each segment host to include this $JAVA_HOME setting"

  export JRE_HOME=`pwd /usr/lib/jvm/java-1.8.0-openjdk-*/jre`
  echo "JRE_HOME : ${JRE_HOME}"
  echo "Add Java home to gpadmin bashrc"
  gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "echo 'export JAVA_HOME=/usr/lib/jvm/jre-openjdk/' >> /home/gpadmin/.bash_profile"
}
################################################################################


check_stat=`ps -ef | grep '[s]shd' | awk '{print $2}'`
if [ -n "$check_stat" ]
then
   echo "SSHD is running"

else
   echo "SSHD isn't running"
   service sshd start
fi
export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1
export INSTALLDIR=/tmp

#

# Default environment:
if [ -f /usr/local/greenplum-db/greenplum_path.sh ]; then
  export GPDB_HOME="/usr/local/greenplum-db"
  source $GPDB_HOME/greenplum_path.sh
fi

if [ -f /opt/gpdb/greenplum_path.sh ]; then
  export GPDB_HOME="/opt/gpdb"
  source $GPDB_HOME/greenplum_path.sh
fi

InstallJDK
InstallPLJava
echo "Using scripts to setup database"

#echo "Copy your Java archives (JAR files) to the same directory on all Greenplum Database hosts"
#gpssh -e -v -f ${GPDB_HOSTS} -u root r$GPHOME/lib/postgresql/java/myclasses.JAR
gpconfig -c pljava_classpath -v 'examples.jar'

cd $current
