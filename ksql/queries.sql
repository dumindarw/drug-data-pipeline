SET 'auto.offset.reset' = 'earliest';


CREATE STREAM ema_drugs_stream(product_name VARCHAR, active_substance VARCHAR, route_of_administration VARCHAR, product_authorisation_country VARCHAR) WITH (kafka_topic = 'ema_drugs', value_format = 'JSON');

CREATE STREAM formatted_ema_drugs_stream AS SELECT product_name, split(route_of_administration, ' ')[1] AS route, split(active_substance, ',')[1] AS active_substance_1, split(active_substance, ',')[2] AS active_substance_2, split(active_substance, ',')[3] AS active_substance_3, split(active_substance, ',')[4] AS active_substance_4,split(active_substance, ',')[5] AS active_substance_5 FROM ema_drugs_stream;

CREATE STREAM formatted_ema_drugs_json_stream WITH ( value_format = 'JSON') AS SELECT * FROM formatted_ema_drugs_stream;



CREATE STREAM fda_drugs_stream(DrugName VARCHAR, ActiveIngredient VARCHAR, Form VARCHAR, Strength VARCHAR) WITH (kafka_topic = 'fda_drugs', value_format = 'JSON');

CREATE STREAM formatted_fda_drugs_stream AS SELECT DrugName as product_name, split(Form, ';')[1] AS route, split(ActiveIngredient, ';')[1] AS active_substance_1, split(ActiveIngredient, ';')[2] AS active_substance_2, split(ActiveIngredient, ';')[3] AS active_substance_3, split(ActiveIngredient, ';')[4] AS active_substance_4,split(ActiveIngredient, ';')[5] AS active_substance_5 , Strength as strength FROM fda_drugs_stream;

CREATE STREAM formatted_fda_drugs_json_stream WITH ( value_format = 'JSON') AS SELECT * FROM formatted_fda_drugs_stream;
