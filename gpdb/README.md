# How to build the Docker Image with Open Source repository in 10 minutes.

You can build Greenplum docker image with Ubuntu and Greenplum Open Source debian package.

The `build_docker.sh` is used to build Greenplum OSS. Internally, it uses DockerfileOpenSource that depends on Ubuntu.
1. Run `build_docker.sh` script.
```
$ ./build_docker.sh
Build Greenplum  
Building Open Source docker for GPDB OSS
Sending build context to Docker daemon  217.1MB
...
...
Commit docker image
sha256:ba58f8911e613018345133bdf54003b9fb051c27d71b843a31fa20e0532089a2
```

##  Running the OSS Docker Image
You can run Greenplum OSS docker image by following the command below.
1. Run `run_ossdocker.sh` script to start this GPDB instance.
```
$ ./run_ossdocker.sh
/bin/run-parts
Running /docker-entrypoint.d
Running bin/bash
root@gpdbsne:/#
```
2. By default, Greenplum instance is not started. You can use these scripts to start/stop Greenplum "startGPDB.sh" and stopGPDB.sh".

```
root@gpdbsne:/# startGPDB.sh
SSHD isn't running
 * Starting OpenBSD Secure Shell server sshd                                 [ OK ]
SSHD is running...
20180130:20:06:12:000068 gpstart:gpdbsne:gpadmin-[INFO]:-Starting gpstart with args: -a
20180130:20:06:12:000068 gpstart:gpdbsne:gpadmin-[INFO]:-Gathering information and validating the environment
...
20180130:20:06:12:000068 gpstart:gpdbsne:gpadmin-[INFO]:-Greenplum Binary Version: 'postgres (Greenplum Database) 5.4.1 build
...
20180130:20:06:19:000247 gpstart:gpdbsne:gpadmin-[ERROR]:-gpstart error: Master instance process running
root@gpdbsne:/#
```

## Verify GPDB is running
1. Execute this command `su - gpadmin`, so you can use gpadmin user.
2. Execute `psql` so you can start using psql client to access GPDB5.
```
$ psql
psql (8.3.23)
Type "help" for help.

```
3. Run this query to retrieve GPDB version.
```
$ psql
psql (8.3.23)
Type "help" for help.
gpadmin=# select version();
version         
---------------------------------------------------------------------------------------
 PostgreSQL 8.3.23 (Greenplum Database 5.13.0 build 30403eb-oss) on x86_64-pc-linux-gnu, compiled by GCC gcc (U
buntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609, 64-bit compiled on Nov  7 2018 03:25:11
(1 row)

gpadmin=#
```

## Reference:
* [Greenplum.org](https://www.greenplum.org/) - Greenplum open source website
* [Greenplum Youtube channel](https://www.youtube.com/channel/UCIC2TGO-4xNSAJFCJXlJNwA) - Greenplum related videos
* [PGConf US Youtube channel](https://www.youtube.com/pgconfus/) - Conference videos
