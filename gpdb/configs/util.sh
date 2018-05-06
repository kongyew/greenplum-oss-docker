#!/bin/bash
set -e
[[ ${DEBUG} == true ]] && set -x
###############################################################################
function startInit(){  # This function is used by Centos platform

  # Get Version
  DISTRIBUTION=getDistribution
  echo "Distribution: $DISTRIBUTION"
  getOSVersion
  echo "major_version: $major_version"

  check_stat=$(ps -ef | grep 'init' | awk '{print $2}')

  if [ -n "$check_stat" ]
  then
     echo "init is running"
  else
     echo "init isn't running"
     if [ -f /usr/sbin/init ]; then
        /usr/sbin/init &
     fi
  fi
}
###############################################################################
function startSSH()
{
  getOSVersion
  check_stat=$(ps -ef | grep '[s]shd' | awk '{print $2}')
  if [ -n "$check_stat" ]
  then
     echo "SSHD is running"
  else
     echo "SSHD isn't running"
     if [ -f /etc/redhat-release ]; then
       if  [ "$major_version" -ge "7" ]; then # "$a" -ge "$b" ]
        #systemctl restart sshd.service
            /usr/bin/ssh-keygen -A
            /usr/sbin/sshd  &
       else
         service sshd start
       fi
     elif [ -f /etc/lsb-release ]; then
         /etc/init.d/ssh start
     elif [ -f /etc/os-release ]; then # SUSE
            /usr/sbin/sshd -D &
     fi
  fi
}
###############################################################################
function getDistribution()
{
  if [ -f /etc/SuSE-release ]; then
     DISTRIBUTION="suse"
   elif [ -f /etc/UnitedLinux-release ]; then
     DISTRIBUTION="united"
  elif [ -f /etc/debian_version ]; then
    DISTRIBUTION="debian"
  elif [ -f /etc/redhat-release ]; then
    a=$(grep -i 'red.*hat.*enterprise.*linux' /etc/redhat-release)
    if test "$?" == "0"; then
      DISTRIBUTION=rhel
    else
      a=$(grep -i 'red.*hat.*linux' /etc/redhat-release)
      if test "$?" == "0"; then
        DISTRIBUTION=rh
      else
        a=$(grep -i 'cern.*e.*linux' /etc/redhat-release)
        if test "$?" == "0"; then
          DISTRIBUTION=cel
        else
          a=$(grep -i 'scientific linux cern' /etc/redhat-release)
          if test "$?" == "0"; then
            DISTRIBUTION=slc
          else
            DISTRIBUTION="unknown"
          fi
        fi
      fi
    fi
  else
    DISTRIBUTION="unknown"
  fi
  getDistribution=$DISTRIBUTION
}
###############################################################################
function getPlatform()
{
   # Detect the platform (similar to $OSTYPE)
  OS=$(uname)
  case $OS in
    'Linux')
      OS='Linux'
      ;;
    'FreeBSD')
      OS='FreeBSD'
      alias ls='ls -G'
      ;;
    'WindowsNT')
      OS='Windows'
      ;;
    'Darwin')
      OS='Mac'
      ;;
    'SunOS')
      OS='Solaris'
      ;;
    'AIX') ;;
    *) ;;
  esac
}
###############################################################################
function getOSVersion()
{
  #OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
  if [ -f /etc/redhat-release ]; then  # Centos
    major_version=$(rpm -qa *-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)
    minor_version=$(sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/redhat-release)
  elif [ -f /etc/lsb-release ]; then # Ubuntu
    major_version=$(sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/lsb-release)
    minor_version=$(sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/lsb-release)
  elif [ -f /etc/SuSE-release ]; then # Ubuntu
    major_version=$(sed -rn 's/.*VERSION =.*/p' /etc/SuSE-release)
  fi
  # cat /etc/SuSE-release
  # SUSE Linux Enterprise Server 10 (x86_64)
  # VERSION = 10
  # PATCHLEVEL = 4
  # SERVER:~ #
}
###############################################################################
