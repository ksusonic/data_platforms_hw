# Задача с загрузкой данных и их партицированием в Hive

Для csv-файла примера возьмем датасет отсюда: https://www.kaggle.com/datasets/abdullah0a/comprehensive-weight-change-prediction

Загружаем на namenode-хост csv-файл и передаем его в файловую систему Hadoop:

```bash
```
curl -L -o ./archive.zip https://www.kaggle.com/api/v1/datasets/download/abdullah0a/comprehensive-weight-change-prediction
unzip archive.zip

$ hdfs dfs -mkdir -p /user/team
$ hdfs dfs -put ./weight_change_dataset.csv /user/team
$ hdfs dfs -ls /user/team
Found 1 items
-rw-r--r--   2 hadoop supergroup       7915 2024-10-29 20:54 /user/team/weight_change_dataset.csv
```

После того, как данные загружены в hdfs, можно приступать к переносу csv-таблицы в реляционную таблицу в hive. Для этого создадим структуру таблицы в hive через утилиту beeline:

`beeline -u 'jdbc:hive2://localhost:10000/'`

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS health_raw (
    participant_id INT,
    age INT,
    gender STRING,
    current_weight DOUBLE,
    bmr DOUBLE,
    daily_calories_consumed DOUBLE,
    daily_caloric_surplus_deficit DOUBLE,
    weight_change DOUBLE,
    duration_weeks INT,
    physical_activity_level STRING,
    sleep_quality STRING,
    stress_level INT,
    final_weight DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/team/health_raw'
TBLPROPERTIES ("skip.header.line.count"="1");
```

Разделим созданную таблицу на партиции по полям `gender`, `physical_activity_level`:

```sql
CREATE TABLE IF NOT EXISTS health_partitioned (
    participant_id INT,
    age INT,
    current_weight DOUBLE,
    bmr DOUBLE,
    daily_calories_consumed DOUBLE,
    daily_caloric_surplus_deficit DOUBLE,
    weight_change DOUBLE,
    duration_weeks INT,
    sleep_quality STRING,
    stress_level INT,
    final_weight DOUBLE
)
PARTITIONED BY (gender STRING, physical_activity_level STRING)
STORED AS TEXTFILE;
```

Выполним команду включения nonstrict mode, чтобы динамически партиционировать таблицу. Скопируем все данные в партицированную таблицу:

```sql
> SET hive.exec.dynamic.partition.mode=nonstrict;
> INSERT INTO TABLE health_partitioned PARTITION (gender, physical_activity_level)
  SELECT
      participant_id, age, current_weight, bmr, daily_calories_consumed,
      daily_caloric_surplus_deficit, weight_change, duration_weeks,
      sleep_quality, stress_level, final_weight, gender, physical_activity_level
  FROM health_raw;
```
