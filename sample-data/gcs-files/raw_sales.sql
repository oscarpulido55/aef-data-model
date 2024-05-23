CREATE OR REPLACE EXTERNAL TABLE
  `${PROJECT_ID}.${DATASET_ID}`.raw_sales ( location_id STRING,
    product_id STRING,
    sales_value INTEGER,
    sales_cost INTEGER)
WITH PARTITION COLUMNS (dt STRING)

WITH CONNECTION `${CONNECTION_NAME}`
    OPTIONS(hive_partition_uri_prefix = "gs://${DATA_BUCKET_NAME}/sales/",
            uris = ['gs://${DATA_BUCKET_NAME}/sales/dt=*'],
        max_staleness = INTERVAL 8 HOUR,
        metadata_cache_mode = 'AUTOMATIC',
        format = 'CSV')