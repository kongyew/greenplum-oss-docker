# Pivotal Greenplum
The Pivotal Greenplum Database (GPDB) is an advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes. Uniquely geared toward big data analytics, Greenplum Database is powered by the world’s most advanced cost-based query optimizer delivering high analytical query performance on large data volumes.
<https://pivotal.io/pivotal-greenplum>

# Streamsets
StreamSets software delivers performance management for data flows that feed the next generation of big data applications. Its mission is to bring operational excellence to the management of data in motion, so that data continually arrives on-time and with quality, empowering business-critical analysis and decision-making.
<https://streamsets.com/>

# Use Cases:
1. [Loading data from StreamSets data generator into Greenplum](#Loading-data-from-StreamSets-data-generator-into-Greenplum)
2. [Loading data from Kafka into Greenplum](#Loading-data-from-Kafka-into-Greenplum)
3. [Loading data from Hadoop into Greenplum](#Loading-data-from-Hadoop-into-Greenplum)

## Loading data from StreamSets data generator into Greenplum:
This example uses Streamsets data generator to generate random data and uses JDBC Producer that concurrently writes data into Greenplum.

The purpose of this use case is to demonstrate how to use StreamSets ETL solution to load large data sets into Greenplum database. For more details, see this [README.MD](usecase1/README.MD)


The example below shows records that are processed , number of records inserted per second while using Dev Data Generator to generate data that will be inserted into Greenplum via [JDBC Producer](https://streamsets.com/documentation/datacollector/latest/help/#datacollector/UserGuide/Destinations/JDBCProducer.html#concept_kvs_3hh_ht)
![alt text](usecase1/images/image18.png "Running pipeline")
## Loading data from Kafka into Greenplum

This example uses Streamsets data generator to generate random data, store data into Kafka. Later, this example loads data from Kafka into Greenplum

The purpose of this use case is to demonstrate how to use StreamSets ETL solution to load large data sets from Kafka into Greenplum database. For more details, see this [README.MD](usecase2/README.MD)

The example below shows records that are processed , number of records inserted per second while using Kafka consumer to read data and insert data into GPDB via JDBC
![alt text](usecase2/images/image50.png "Running pipeline")

## Loading data from Hadoop into Greenplum
To be added later


## Reference:
[Enhancement to Streamsets to use Greenplum native loaders](https://issues.streamsets.com/browse/SDC-7835)
