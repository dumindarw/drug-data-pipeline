## Dremio

```
sudo useradd --base-dir /var/lib/dremio --system --gid dremio dremio

sudo chown dremio:dremio dremio-data/
```

## Kafka pipeline

```
docker run -it --name kafka-producer -p 19092:9092  quay.io/strimzi/kafka:0.30.0-kafka-3.2.0  bin/kafka-console-producer.sh --bootstrap-server 192.168.1.7:9092 --topic my-topic

docker run -it --name kafka-consumer -p 29092:9092  quay.io/strimzi/kafka:0.30.0-kafka-3.2.0  bin/kafka-console-consumer.sh --bootstrap-server 192.168.1.7:9092 --topic my-topic --from-beginning

docker run -it confluentinc/ksqldb-cli:0.28.2 ksql http://127.0.0.1:8088

docker run -it --name kafka-consumer -p 29092:9092  quay.io/strimzi/kafka:0.30.0-kafka-3.2.0  bin/kafka-console-consumer.sh --bootstrap-server 192.168.1.7:9092 --topic ema_drugs --from-beginning

docker run -it --name kafka-topics -p 29092:9092  quay.io/strimzi/kafka:0.30.0-kafka-3.2.0  bin/kafka-topics.sh --list --bootstrap-server 192.168.1.7:9092
```

## KSQL

```
ksql -- http://ksqldb-server:8088

SHOW TOPICS;

SET 'auto.offset.reset' = 'earliest';

CREATE STREAM ema_drugs_stream(product_name VARCHAR, active_substance VARCHAR, route_of_administration VARCHAR, product_authorisation_country VARCHAR) WITH (kafka_topic = 'ema_drugs', value_format = 'JSON');

CREATE TABLE ema_drugs_table(id BIGINT PRIMARY KEY, product_name VARCHAR, active_substance VARCHAR, route_of_administration VARCHAR, product_authorisation_country VARCHAR) WITH (kafka_topic = 'ema_drugs', value_format = 'JSON');

CREATE TABLE QUERYABLE_EMA_DRUGS_TABLE AS SELECT * FROM EMA_DRUGS_TABLE;

CREATE STREAM ema_drugs_avro_stream WITH ( value_format = 'AVRO') AS SELECT * FROM ema_drugs_stream;

{"product_name": "4,4\u2018-Dihydroxybiphenyl Smartpractice Europe", 
"active_substance": "4,4'-Dihydroxybiphenyl", 
"route_of_administration": "Cutaneous Use", 
"product_authorisation_country": "Germany", 
"marketing_authorisation_holder": "Smartpractice Europe Gmbh", "pharmacovigilance_master_file_location": "Germany", "pharmacovigilance_enquiries_email": "pv.smartpracticeeurope@ebeling-assoc.com", "pharmacovigilance_enquiries_tp": "0049405480070"}

CREATE TABLE ema_drug_products AS SELECT product_name, count(*) FROM ema_drugs_stream GROUP BY product_name;

SELECT product_name, split(route_of_administration, ' ')[1] AS route, split(active_substance, ',')[1] AS active_substance_1, split(active_substance, ',')[2] AS active_substance_2, split(active_substance, ',')[3] AS active_substance_3, split(active_substance, ',')[4] AS active_substance_4,split(active_substance, ',')[5] AS active_substance_5 FROM ema_drugs_stream

CREATE STREAM ema_drugs_avro_stream_2 WITH ( value_format = 'AVRO') AS SELECT product_name, split(route_of_administration, ' ')[1] AS route, split(active_substance, ',')[1] AS active_substance_1, split(active_substance, ',')[2] AS active_substance_2, split(active_substance, ',')[3] AS active_substance_3, split(active_substance, ',')[4] AS active_substance_4,split(active_substance, ',')[5] AS active_substance_5 FROM ema_drugs_stream;


CREATE STREAM ema_drugs_stream_2 AS  SELECT product_name, split(route_of_administration, ' ')[1] AS route, split(active_substance, ',')[1] AS active_substance_1, split(active_substance, ',')[2] AS active_substance_2, split(active_substance, ',')[3] AS active_substance_3, split(active_substance, ',')[4] AS active_substance_4,split(active_substance, ',')[5] AS active_substance_5 FROM ema_drugs_stream;

CREATE STREAM ema_drugs_avro_stream_2 WITH ( value_format = 'AVRO') AS SELECT * FROM ema_drugs_stream_2;

select * from ema_drugs_avro_stream_2;
```

## Columnstore
```
docker run -d -p 3306:3306 --name mcs_container mariadb/columnstore

mariadb --protocol tcp --host localhost -u coluser --password=col789


```

## Kylin


https://github.com/weibin0516/kylin_docker/blob/master/entrypoint.sh


## Druid instead Kylin ?

https://druid.apache.org/docs/latest/querying/sql-api.html#submit-a-query