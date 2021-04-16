#!/bin/bash
set -e
[[ ${DEBUG} == true ]] && set -x

if [ -f /etc/redhat-release ]; then  # Centos
  major_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)
elif [ -f /etc/lsb-release ]; then # Ubuntu
  major_version=$(OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/lsb-release`)
fi

check_stat=$(pgrep 'init' | awk '{print $2}')
if [ -n "$check_stat" ]
then
   echo "init is running"

else
  echo "init isn't running"
  if [ -f /etc/redhat-release ]; then
    if  [ "$major_version" -ge "7" ]; then # "$a" -ge "$b" ]
      if [ -f /usr/sbin/init ]; then
         /usr/sbin/init
         status=$?
         if [ $status -ne 0 ]; then
           echo "Failed to start init process: $status"
           exit $status
         fi
         
      fi
    fi
  else
    echo ""
  fi
fi


# # Start the second process
# ./my_second_process -D
# status=$?
# if [ $status -ne 0 ]; then
#   echo "Failed to start my_second_process: $status"
#   exit $status
# fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds
#
# while /bin/true; do
#   ps aux |grep '[s]shd' |grep -q -v grep
#   PROCESS_1_STATUS=$?
#   # ps aux |grep my_second_process |grep -q -v grep
#   # PROCESS_2_STATUS=$?
#   # If the greps above find anything, they will exit with 0 status
#   # If they are not both 0, then something is wrong
#   # if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
#   #   echo "One of the processes has already exited."
#   #   exit -1
#   # fi
#   if [ $PROCESS_1_STATUS -ne 0 ]; then
#     echo "One of the processes has already exited."
#     exit -1
#   fi
#   sleep 60
# done
