GRANT INSERT ON PROTOCOL gphdfs TO gpadmin;
GRANT SELECT ON PROTOCOL gphdfs TO gpadmin;

CREATE EXTERNAL TABLE pxf_hdfs_textsimple(location text, month text, num_orders int, total_sales float8)
LOCATION ('gphdfs://sandbox.hortonworks.com:8020/data/pxf_examples/pxf_hdfs_simple.txt')
   FORMAT 'TEXT' (DELIMITER ',');
