#!/bin/bash
set -e
[[ ${DEBUG} == true ]] && set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Including configurations
. "${DIR}"/config.sh



if [[ ! "$(whoami)" =~ ^(gpadmin|root)$ ]]
then
    echo "Please run the script as gpadmin or root" >&2
    exit 1
fi

check_stat=`ps -ef | grep '[s]shd' | awk '{print $2}'`
if [ -n "$check_stat" ]
then
   echo "SSHD is running"

else
   echo "SSHD isn't running"
   service sshd start
fi


###############################################################################
function InstallJDK()
{
  echo "Install Java on each Greenplum Database segment host"
  # Fix this issue "Rpmdb checksum is invalid: dCDPT(pkg checksums)"
  gpssh -e -v -f ${GPDB_HOSTS} -u root rpm --rebuilddb
  #;  yum clean all
  if rpm -qa | grep wget  2>&1 > /dev/null; then
    gpssh -e -v -f ${GPDB_HOSTS} -u root yum -y install wget
  fi

  if rpm -qa | grep wget  2>&1 > /dev/null; then
    gpssh -e -v -f ${GPDB_HOSTS} -u root yum -y install java-1.8.0-openjdk
  fi
  # sudo yum install java-1.8.0-openjdk
  # sudo yum install java-1.7.0-openjdk
  # sudo yum install java-1.6.0-openjdk

  echo "Update the gpadmin user’s .bash_profile file on each segment host to include this $JAVA_HOME setting"

  export JRE_HOME=$(pwd /usr/lib/jvm/java-1.8.0-openjdk-*/jre_)
  echo "JRE_HOME : ${JRE_HOME}"
  echo "Add Java home to gpadmin bashrc"
  gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "echo 'export JAVA_HOME=/usr/lib/jvm/jre-openjdk/' >> /home/gpadmin/.bash_profile"

}
###############################################################################
function isInstalled() {
    if rpm -q $1 &> /dev/null; then
        echo 'installed';
        return 1;
    else
        echo 'not installed';
        return 0;
    fi
}
################################################################################
function SetupMapR()
{
  echo "Setup MapR Client"

  echo "Query rpm for MapR "
  # https://maprdocs.mapr.com/home/AdvancedInstallation/AddingMapRreposonRHorCOS.html
  isInstalled mapr-client
  if [ $? == 0 ]; then

    echo "Copying maprtech.repo to /etc/yum.repos.d/"
    sudo cp ${DIR}/maprtech/maprtech5.2.2.repo /etc/yum.repos.d/
    echo "rpm --import http://package.mapr.com/releases/pub/maprgpg.key"
    sudo rpm --import http://package.mapr.com/releases/pub/maprgpg.key

    echo "yum install mapr-client.x86_64"
    sudo  yum install -y mapr-client.x86_64
  fi

  gpconfig -c gp_hadoop_target_version -v 'gpmr-1.2'
  gpstop -u

  # gpconfig -s gp_hadoop_target_version
  sudo /opt/mapr/server/configure.sh -N mapr-cluster -c -C mapr-control:7222 -HS mapr-clusterd1


  # container_name: mapr-control
  # environment:
  #   - CLUSTERNAME=mapr-cluster
  #   - MEMTOTAL=1024
  #   - DISKLIST=/dev/sda

  # Reference: https://gpdb.docs.pivotal.io/530/admin_guide/external/g-one-time-hdfs-protocol-installation.html
  # gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "gpconfig -c gp_hadoop_target_version -v 'hdb2'"
  # http://doc.mapr.com/display/MapR/Setting+Up+the+Client

  gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "gpconfig -c gp_hadoop_target_version -v 'gpmr-1.2'"

  # gpmr-1.2

  #cdh5
}
################################################################################
function SetupCDH5()
{
  echo "Remove docker image with tag:  ${DOCKER_TAG4}"
  # Reference: https://gpdb.docs.pivotal.io/530/admin_guide/external/g-one-time-hdfs-protocol-installation.html
  # gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "gpconfig -c gp_hadoop_target_version -v 'hdb2'"
  # http://doc.mapr.com/display/MapR/Setting+Up+the+Client

  gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "gpconfig -c gp_hadoop_target_version -v 'gpmr-1.2'"

  # gpmr-1.2

  #cdh5
}
################################################################################
function SetupHD2()
{
  echo "Setup Hortonworks"

  gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "gpconfig -c gp_hadoop_target_version -v 'gpmr-1.2'"

  # gpmr-1.2

  #cdh5
}
function usage(){
  me=$(basename "$0")
    echo "Usage: $me "
    echo "   " >&2
    echo "Options:   " >&2
    echo "-h \thelp  " >&2
    echo "  " >&2
    echo "To setup MapR, use -i to specify version such as mapr = " >&2
    echo "To setup Cloudera, use -i to specify version such as cdh5 " >&2
    echo "To setup Hortonworks, use -i to specify version such as hdp2 " >&2

}
################################################################################
while getopts ":hi:" opt; do
  case $opt in
    i)
      echo "Type for Parameter: $OPTARG" >&2
      export HADOOP_DISTRIBUTION=$OPTARG
      ;;

    h)
      usage
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

# http://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz
echo "export HADOOP_USER_NAME=gpadmin"
gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "echo 'export HADOOP_USER_NAME=gpadmin' >> /home/gpadmin/.bash_profile"

# echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin"
# gpssh -e -v -f ${GPDB_HOSTS} -u gpadmin "echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >> /home/gpadmin/.bash_profile"

InstallJDK
if [ -z "$HADOOP_DISTRIBUTION" ]                           # Is parameter #1 zero length?
  then
    echo "-Parameter #1 is zero length.-"  # Or no parameter passed.
  else
    if [ -n "$HADOOP_DISTRIBUTION" ]
    then
    if [ "$HADOOP_DISTRIBUTION" == "mapr" ]
    then
        echo "Variable $HADOOP_DISTRIBUTION exists!"
        SetupMapR
    elif [ "$HADOOP_DISTRIBUTION" == "cdh5" ]
      then
          echo "Variable $HADOOP_DISTRIBUTION exists!"
          SetupCDH5
    elif [ "$HADOOP_DISTRIBUTION" == "hdp2" ]
      then
          echo "Variable $HADOOP_DISTRIBUTION exists!"
            SetupHD2
    else # default option to build Centos if nothing is specified
        echo "Variable $HADOOP_DISTRIBUTION exists!"
        SetupMapR
    fi

    else
    echo 'Variable "${HADOOP_DISTRIBUTION}" does not exist!'
    fi


  fi
