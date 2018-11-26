#  Greenplum
The  Greenplum Database (GPDB) is an advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes. Uniquely geared toward big data analytics, Greenplum Database is powered by the world’s most advanced cost-based query optimizer delivering high analytical query performance on large data volumes.
<https://www.greenplum.org>

# Table of Contents
1. [Pre-requisites](#Pre-requisites)
2. [Starting Docker-compose](#Starting-Dockercompose)
3. [Configure Greenplum](#Configure-Greenplum)
4. [Use psql](#Use-psql)

## Pre-requisites:
- [docker-compose](http://docs.docker.com/compose)
- [GPDB 5.x OSS docker image](https://hub.docker.com/r/kochanpivotal/gpdb5oss/)

## Starting Docker-compose
Once you have cloned this repository, you can run the command  `./runDocker.sh -t usecase1 -c up`, in order to start both Greenplum docker instance.

The assumption: docker and docker-compose are already installed on your machine.

### Run command to start Greenplum instance
```
kochan$ ./runDocker.sh -t usecase1 -c up
Creating network "usecase1_mynetwork" with driver "bridge"
Creating gpdbsne ... done
gpdbsne     | /bin/run-parts
gpdbsne     | Running /docker-entrypoint.d
gpdbsne     | Running bin/bash
```

### How to access Greenplum docker instance:
You can use this command `docker exec -it gpdbsne bin/bash` to access Greenplum docker instance.
For example:
```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED              STATUS              PORTS                                                                                                                                NAMES
6aa6f4020531        kochanpivotal/gpdb5oss   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:5005->5005/tcp, 0.0.0.0:5010->5010/tcp, 0.0.0.0:5432->5432/tcp, 0.0.0.0:40000-40002->40000-40002/tcp, 0.0.0.0:9022->22/tcp   gpdbsne
Kongs-MacBook-Pro:greenplum-oss-docker kochan$
```

## Configure Greenplum
Once you have access to Greenplum docker instance, you can create database, table with some sample data.

1. Start GPDB instance:
Use the command 'startGPDB.sh'
```
root@gpdbsne# startGPDB.sh
SSHD isn't running
 * Starting OpenBSD Secure Shell server sshd                             [ OK ]
SSHD is running...
20180419:21:15:09:000094 gpstart:gpdbsne:gpadmin-[INFO]:-Starting gpstart with args: -a
20180419:21:15:09:000094 gpstart:gpdbsne:gpadmin-[INFO]:-Gathering information and validating the environment...
...
20180419:21:15:18:000247 gpstart:gpdbsne:gpadmin-[INFO]:-Have lock file /tmp/.s.PGSQL.5432 and a process running on port 5432
20180419:21:15:18:000247 gpstart:gpdbsne:gpadmin-[ERROR]:-gpstart error: Master instance process running
```
2. Change to use gpadmin user by executing `su - gpadmin`
3. Create database and table with sample database
The scripts to create database and sample data is found at `/code/usercase1/data`.

Next, run the command '/code/usecase1/data/setupDB.sh'
```
gpadmin@gpdbsne:/# cd /code/usecase1/data
gpadmin@gpdbsne:/code/usecase1/data# ./setupDB.sh
psql:./gpdb_sample.sql:2: NOTICE:  table "usertable" does not exist, skipping
DROP TABLE
CREATE TABLE
root@gpdbsne:/code/usecase1/data#
```
3. Verify database and table is created.
Use `psql -U gpadmin -d sample_db -c "select count(*) from usertable;"`.  The result shows no records are yet created.

Example:
```
$ psql -U gpadmin -d sample_db -c "select count(*) from usertable;"
 count
-------
     0
(1 row)
```

## Use psql
1. Verify database and table is created.
Use `psql -U gpadmin -d sample_db -c "select count(*) from usertable;"`.  The result shows no records are yet created.

Example:
```
$ psql -U gpadmin -d sample_db -c "select count(*) from usertable;"
 count
-------
     0
(1 row)
```

## Screencast
* [![Clone this repo](https://asciinema.org/a/LIFWP2uK8jcyLHoPJkbO8zsos.svg)](https://asciinema.org/a/LIFWP2uK8jcyLHoPJkbO8zsos)
* [![Build Greenplum OSS docker](https://asciinema.org/a/LIFWP2uK8jcyLHoPJkbO8zsos.svg)](https://asciinema.org/a/LIFWP2uK8jcyLHoPJkbO8zsos)
