#!/bin/bash

function usage() {
	me=$(basename "$0")
	echo "Usage: $me "

	echo -e "USAGE:  $me\n"
	echo -e "./$me <gp_hadoop_target_version> <gp_hadoop_home> <format> <path to file> [optional -v for kreberos debugging]\n"
 echo -e "\n./$me gpmr-1.2 /opt/mapr/hadoop/hadoop-2.7.0 TEXT gphdfs://mapr-clusterd1:8020/tmp/t1"

	echo -e "Example:\n./$me gphd-2.0 /usr/lib/phd/current TEXT gphdfs://HOST:PORT/path/to/file"

	exit 1
}

if [ -z $GPHOME ] || [ -z $JAVA_HOME ]
then
	echo "GPHOME and JAVA_HOME must be set"
	exit 1
fi

declare -A connVersionMap
connVersionMap["gphd-1.0"]="hdp-gnet-1.2.0.0"
connVersionMap["gphd-1.1"]="hdp-gnet-1.2.0.0"
connVersionMap["gphd-1.2"]="hadoop-gnet-1.2.0.0"
connVersionMap["gphd-2.0"]="hadoop-gnet-1.2.0.0"
connVersionMap["gpmr-1.0"]="mpr-gnet-1.2.0.0"
connVersionMap["gpmr-1.2"]="mpr-gnet-1.2.0.0"
connVersionMap["cdh3u2"]="cdh-gnet-1.2.0.0"
connVersionMap["hdp2"]="hdp-gnet-1.2.0.0"
connVersionMap["hadoop2"]="hadoop-gnet-1.2.0.0"
connVersionMap["cdh5"]="cdh-gnet-1.2.0.0"
connVersionMap["gphd-3.0"]="hadoop-gnet-1.2.0.0"

export GP_HADOOP_CONN_JARDIR=lib/hadoop
export GP_HADOOP_CONN_VERSION=${connVersionMap[$1]}
export HADOOP_HOME=$2
FORMAT=$3
FILE=$4
KRBDEBUG=$5

if [ -z $GP_HADOOP_CONN_VERSION ] || [ -z $HADOOP_HOME ] || [ -z $FILE ]
then
	usage
fi

if [ "$FORMAT" != "PARQUET" ] && [ "$FORMAT" != "AVRO" ] && [ "$FORMAT" != "TEXT" ] && [ "$FORMAT" != "GPDBWritable" ]
then
        echo -e "\nThe format $FORMAT does not match any available format type"
        echo -e "Available types are \"PARQUET, AVRO, GPDBWritable, and TEXT\""
        usage
fi

source ${GPHOME}/${GP_HADOOP_CONN_JARDIR}/hadoop_env.sh
if [ "$KRBDEBUG" == "-v" ]
then
	$JAVA_HOME/bin/java -Dsun.security.krb5.debug=true com.emc.greenplum.gpdb.hdfsconnector.HDFSReader 0 32 $FORMAT gphd-2.0.2 $FILE
else
	$JAVA_HOME/bin/java com.emc.greenplum.gpdb.hdfsconnector.HDFSReader 0 32 $FORMAT gphd-2.0.2 $FILE
fi

#./GphdfsTest.sh gpmr-1.2 /opt/mapr/hadoop/hadoop-2.7.0 TEXT gphdfs://mapr-clusterd1:8020/tmp/t1
