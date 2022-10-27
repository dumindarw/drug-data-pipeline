SELECT product_name,
active_substance_1, 
active_substance_2,
active_substance_3,
active_substance_4,
active_substance_5,
route
FROM (
  SELECT product_name, 
  trim(split_part(active_substance, ',', 1)) AS active_substance_1, 
  trim(split_part(active_substance, ',', 2)) AS active_substance_2, 
  trim(split_part(active_substance, ',', 3)) AS active_substance_3, 
  trim(split_part(active_substance, ',', 4)) AS active_substance_4, 
  trim(split_part(active_substance, ',', 5)) AS active_substance_5,  
  trim(split_part(route_of_administration, ' ', 1)) AS route, 
  route_of_administration
  FROM "Drug Data"."ema_drugs.json" AS E
) nested_0



SELECT product_name, 
  split(route_of_administration, ' ') AS route, 
  route_of_administration
  FROM ema_drugs_stream 