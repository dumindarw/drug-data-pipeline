#!/usr/bin/env python3

import json
import urllib.request
import pandas as pd 
from zipfile import ZipFile
from kafka import KafkaProducer
import http.server
import socketserver

urllib.request.urlretrieve("https://www.fda.gov/media/89850/download", "fda_drugs.zip");
urllib.request.urlretrieve('https://www.ema.europa.eu/documents/other/article-57-product-data_en.xlsx', 'ema_drugs.xlsx')

with ZipFile('fda_drugs.zip') as zipobj:
  zipobj.extractall('fda_drugs')

fda_drugs_df = pd.read_csv('fda_drugs/Products.txt', sep='\t', lineterminator='\r', on_bad_lines='skip')

headers = ['product_name', 'active_substance', 'route_of_administration', 'product_authorisation_country', 'marketing_authorisation_holder', 'pharmacovigilance_master_file_location', 'pharmacovigilance_enquiries_email', 'pharmacovigilance_enquiries_tp']
ema_drugs_df = pd.read_excel('ema_drugs.xlsx', sheet_name=None, header=None, skiprows=20, names=headers)

ema_drugs = ema_drugs_df['Art57 product data'].to_json(orient='records')


with open("files/ema_drugs.json", "w") as outfile2:
    outfile2.write(ema_drugs)

fda_drugs = fda_drugs_df.to_json(orient='records')

with open("files/fda_drugs.json", "w") as outfile:
    outfile.write(fda_drugs)
    

producer = KafkaProducer(bootstrap_servers='kafka:9092', value_serializer=lambda v: json.dumps(v).encode('utf-8'))

ema_drugs_json = json.loads(ema_drugs)

fda_drugs_json = json.loads(fda_drugs)

for jsonline in ema_drugs_json:
  producer.send('ema_drugs', jsonline)

for jsonline_fda in fda_drugs_json:
  producer.send('fda_drugs', jsonline_fda)

PORT = 8000

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()