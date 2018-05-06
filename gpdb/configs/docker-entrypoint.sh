#!/bin/bash

DIR=/docker-entrypoint.d

find / -name "run-parts"
if [[ -d "$DIR" ]]
then
  echo "Running $DIR"
  if [ -a /usr/bin/run-parts ]
  then
    /usr/bin/run-parts $DIR
  else
    if [ -a /bin/run-parts ]
    then
      /bin/run-parts $DIR
    else
      run-parts $DIR
      if [ $? -eq 0 ]; then
        echo OK
      else
          echo FAIL
          echo "Cannot find run-parts"
      fi

    fi
  fi
fi


if [ $? -eq 0 ]; then
  echo "Running $@"
  exec "$@"
fi
