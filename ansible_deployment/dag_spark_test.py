from datetime import datetime, timedelta

from airflow.operators.python import PythonOperator
from onetl.connection import Hive, SparkHDFS
from onetl.db import DBWriter
from onetl.file import FileDFReader
from onetl.file.format import CSV
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import (
    DoubleType,
    IntegerType,
    StructField,
    StructType,
    StringType,
)
from pyspark.sql.window import Window

from airflow import DAG


def spark_test():
    spark = (
        SparkSession.builder.master("yarn")
        .appName("test")
        .config("spark.sql.warehouse.dir", "/user/hive/warehouse")
        .config("spark.hive.metastore.uris", "thrift://192.168.1.170:9083")
        .enableHiveSupport()
        .getOrCreate()
    )

    hdfs = SparkHDFS(host="192.168.1.171", port=9000, spark=spark, cluster="test")
    hive = Hive(spark=spark, cluster="test")

    schema = StructType([
        StructField("participant_id", IntegerType(), True),
        StructField("age", IntegerType(), True),
        StructField("gender", StringType(),     True),
        StructField("current_weight", DoubleType(), True),
        StructField("bmr", DoubleType(), True),
        StructField("daily_calories_consumed", DoubleType(), True),
        StructField("daily_caloric_surplus_deficit", DoubleType(), True),
        StructField("weight_change", DoubleType(), True),
        StructField("duration_weeks", IntegerType(), True),
        StructField("physical_activity_level", StringType(), True),
        StructField("sleep_quality", StringType(), True),
        StructField("stress_level", IntegerType(), True),
        StructField("final_weight", DoubleType(), True)
    ])

    reader = FileDFReader(
        connection=hdfs,
        format=CSV(delimiter=",", header=True),
        source_path="/user/team",
        df_schema=schema,
    )
    df = reader.run(["weight_change_dataset.csv"])

    filtered_df = df.filter((F.col("age") >= 20) & (F.col("age") <= 50))
    window_spec = Window.partitionBy("gender", "physical_activity_level").orderBy(F.desc("count"))
    sleep_quality_count = (
        filtered_df.groupBy("gender", "physical_activity_level", "sleep_quality")
        .count()
        .withColumn("rank", F.row_number().over(window_spec))
        .filter(F.col("rank") == 1)
        .select("gender", "physical_activity_level", "sleep_quality")
        .withColumnRenamed("sleep_quality", "most_frequent_sleep_quality")
    )
    aggregated_df = (
        filtered_df.groupBy("gender", "physical_activity_level")
        .agg(
            F.max("age").alias("max_age"),
            F.min("age").alias("min_age"),
            F.avg("weight_change").alias("avg_weight_change"),
            F.sum("daily_calories_consumed").alias("total_daily_calories_consumed"),
            F.count("age").alias("number_in_category"),
        )
    )
    aggregated_df = aggregated_df.join(
        sleep_quality_count, on=["gender", "physical_activity_level"], how="left"
    )

    result_df = aggregated_df.withColumn(
        "physical_activity_level_main_group",
        F.when(F.col("physical_activity_level") == "Sedentary", "Not active").otherwise("Active")
    )
    result_df = result_df.repartition("gender", "physical_activity_level_main_group")

    writer = DBWriter(
        connection=hive,
        table="default.spark_weight_change_dataset",
        options={"if_exists": "replace_entire_table", "partitionBy": ["gender", "physical_activity_level_main_group"]},
    )
    writer.run(result_df)

with DAG(
        "dag_spark_test",
        default_args={
            "owner": "airflow",
            "depends_on_past": False,
            "email_on_failure": False,
            "email_on_retry": False,
            "retries": 1,
            "retry_delay": timedelta(minutes=3),
        },
        description="DAG for Spark Test Job",
        schedule_interval=None,
        start_date=datetime(2024, 12, 10),
        catchup=False,
) as dag:
    PythonOperator(
        task_id="spark_test",
        python_callable=spark_test,
    )
