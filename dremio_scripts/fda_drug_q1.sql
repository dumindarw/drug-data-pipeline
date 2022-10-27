SELEC TITLE(drug_name) as drug_name, 
active_substance_1,
active_substance_2,
active_substance_3,
active_substance_4,
active_substance_5,
strength, route_1,route_2
FROM (
  SELECT DrugName as drug_name, 
  ActiveIngredient,
  trim(split_part(ActiveIngredient, ';', 1)) AS active_substance_1,
  trim(split_part(ActiveIngredient, ';', 2)) AS active_substance_2,
  trim(split_part(ActiveIngredient, ';', 3)) AS active_substance_3,
  trim(split_part(ActiveIngredient, ';', 4)) AS active_substance_4,
  trim(split_part(ActiveIngredient, ';', 5)) AS active_substance_5,
   Strength as strength, 
   Form as route,
   trim(split_part(Form, ';', 1)) AS route_1,
   trim(split_part(Form, ';', 2)) AS route_2
  FROM "Drug Data"."fda_drugs.json" AS F
) nested_0
