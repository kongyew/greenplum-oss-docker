#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Including configurations

. "${DIR}"/config.sh


################################################################################

################################################################################
function BuildOpenSourceGreenplum()
{
  # echo "Remove docker image with tag:  ${DOCKER_OSS_TAG}"
  # if docker images |grep ${DOCKER_OSS_TAG}; then
  #      docker rmi -f ${DOCKER_OSS_TAG}
  # fi

  echo "Building Open Source docker for ${GPDB_VERSION}"

  # https://docs.docker.com/engine/reference/commandline/build/#specifying-target-build-stage-target
  # Squash to reduce file size
#  docker build --build-arg GPDB_VERSION=${GPDB_VERSION} --force-rm --squash -t ${DOCKER_OSS_TAG} -f DockerfileOpenSource .
  docker build --build-arg GPDB_VERSION="${GPDB_VERSION}",GPDB_HOST="gpdbsne"  -t "${DOCKER_OSS_TAG}" -f DockerfileOpenSource .

  # Build docker image
  echo "Build docker image"
  docker run --interactive --tty -h "${CONTAINER_NAME}" \
       "${DOCKER_OSS_TAG}" /bin/bash -c "/usr/local/bin/setupGPDB.sh -g /opt/gpdb;/usr/local/bin/stopGPDB.sh  -g /opt/gpdb"

  echo "Commit docker image"
  export CONTAINER_ID=`docker ps -a -n=1 -q`
  docker commit -m "${DOCKER_OSS_LABEL}" -a "author" "${CONTAINER_ID}" "${DOCKER_LATEST_OSS_TAG}"
}
################################################################################
#
# Main function
#
################################################################################

while getopts ":hi:" opt; do
  case $opt in
    i)
      echo "Type for Parameter: $OPTARG" >&2
      export GPDB_VERSION=$OPTARG
      ;;

    h) # GPDB_VERSION="5.2.0-rhel6-x86_64"

    me=$(basename "$0")
      echo "Usage: $me "
      echo "   " >&2
      echo "Options:   " >&2
      echo "-h \thelp  " >&2
      echo "  " >&2
      echo "To install Open source Greenplum version, use -i to specify version such as opensource  " >&2
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

if [ -n "$GPDB_VERSION" ]
then
  if [ "$GPDB_VERSION" == "opensource" ]
  then
      echo "Variable opensource exists!"
      BuildOpenSourceGreenplum
  elif [ "$GPDB_VERSION" == "TBD" ]
    then
        echo "Variable using ${GPDB_VERSION} "
        exit 1
  else # default option to build if nothing is specified
      echo 'Build Greenplum  '
      BuildOpenSourceGreenplum
  fi

else
  echo 'Variable "${GPDB_VERSION}" does not exist!'
fi
