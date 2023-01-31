SET 'auto.offset.reset' = 'earliest';


CREATE STREAM ema_drugs_stream(product_name VARCHAR, active_substance VARCHAR, route_of_administration VARCHAR, product_authorisation_country VARCHAR) WITH (kafka_topic = 'ema_drugs', value_format = 'JSON');

CREATE STREAM formatted_ema_drugs_stream AS SELECT UCASE(product_name) as product_name, ARRAY_REMOVE(ARRAY[UCASE(split(route_of_administration, ' ')[1]), IFNULL(UCASE(split(route_of_administration, ' ')[3]), 'N/A')], 'N/A') AS routes, ARRAY_REMOVE(ARRAY[UCASE(split(active_substance, ',')[1]), IFNULL(UCASE(split(active_substance, ',')[2]),'N/A'),IFNULL(UCASE(split(active_substance, ',')[3]), 'N/A'),IFNULL(UCASE(split(active_substance, ',')[4]), 'N/A'), IFNULL(UCASE(split(active_substance, ',')[5]), 'N/A')] , 'N/A') AS active_substances FROM ema_drugs_stream;

CREATE STREAM formatted_ema_drugs_json_stream WITH ( VALUE_FORMAT = 'AVRO') AS SELECT * FROM formatted_ema_drugs_stream;



CREATE STREAM fda_drugs_stream(DrugName VARCHAR, ActiveIngredient VARCHAR, Form VARCHAR, Strength VARCHAR) WITH (kafka_topic = 'fda_drugs', value_format = 'JSON');

CREATE STREAM formatted_fda_drugs_stream AS SELECT DrugName as product_name, ARRAY_REMOVE(ARRAY[split(Form, ';')[1], IFNULL(split(Form, ';')[2], 'N/A')], 'N/A') AS routes, ARRAY_REMOVE(ARRAY[split(ActiveIngredient, ';')[1], IFNULL(split(ActiveIngredient, ';')[2],'N/A'),IFNULL(split(ActiveIngredient, ';')[3], 'N/A'),IFNULL(split(ActiveIngredient, ';')[4], 'N/A'),IFNULL(split(ActiveIngredient, ';')[5], 'N/A')], 'N/A') AS active_substances, Strength as strength FROM fda_drugs_stream;

CREATE STREAM formatted_fda_drugs_json_stream WITH ( VALUE_FORMAT = 'AVRO') AS SELECT * FROM formatted_fda_drugs_stream;


-- CREATE STREAM y2 AS SELECT a.product_name, a.active_substances, a.routes, b.strength  from formatted_ema_drugs_stream a FULL OUTER JOIN formatted_fda_drugs_stream b WITHIN 1 HOURS ON a.product_name = b.product_name ;