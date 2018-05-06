#!/bin/bash
set -e
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# reference : http://doc.mapr.com/display/MapR/MapR+Repositories+and+Package+Archives#MapRRepositoriesandPackageArchives-rpmanddebRepositoriesforMapRCoreSoftware
DOWNLOAD_DIR="./HADOOP"
VERSION="2.7.5"  # RHEL, SLES, UBUNTU

if [ -d $DOWNLOAD_DIR ]; then
  echo "Using $DOWNLOAD_DIR"
else
  mkdir "$DOWNLOAD_DIR"
fi
###############################################################################
# Default Hadoop Repository
HADOOP_SITE1_REPO=http://apache.claz.org/hadoop/common
HADOOP_SITE2_REPO=http://mirror.jax.hugeserver.com/apache/hadoop/common
HADOOP_SITE3_REPO=http://apache.cs.utah.edu/hadoop/common

# TODO verify signature
HADOOP_SIG_REPO=https://dist.apache.org/repos/dist/release/hadoop/common/

#
# 2.7.3 http://hadoop.apache.org/docs/r2.7.3/hadoop-project-dist/hadoop-common/releasenotes.html
# http://mirrors.koehn.com/apache/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz


if [ "$VERSION" == "2.7.5" ]; then
  wget ${HADOOP_SITE1_REPO}/hadoop-2.7.5/hadoop-2.7.5.tar.gz -P ${DOWNLOAD_DIR}
  #
elif [ "$VERSION"  == "2.8.3" ]; then
   wget ${HADOOP_SITE1_REPO}/hadoop-2.8.3/hadoop-2.8.3.tar.gz -P ${DOWNLOAD_DIR}
   #
elif [ "$VERSION"  == "2.9.0" ]; then
     wget ${HADOOP_SITE1_REPO}/hadoop-2.9.0/hadoop-2.9.0.tar.gz -P ${DOWNLOAD_DIR}
else
  echo "Error: Please specify the variable $VERSION"
fi
