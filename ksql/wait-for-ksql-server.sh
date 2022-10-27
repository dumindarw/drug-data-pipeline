#!/bin/sh
# wait-for-ksql-server.sh

set -e

 
while [ $(curl -s -o response.txt -w "%{http_code}" http://ksql-server:8088/info) -ne  200 ];
do
  >&2 echo "KSQL Server is unavailable - retrying"
  sleep 1
done

>&2 echo "KSQL Server is up"

while [ $(curl -s -o response_2.txt -w "%{http_code}" http://data-extract-agent:8000) -ne  200 ];
do
  >&2 echo "Extractor Agent is not completed - retrying"
  sleep 1
done
  
>&2 echo "Extractor Agent is completed - executing command"

ksql --file /ksql/queries.sql -- http://ksql-server:8088
# Print and execute all other arguments starting with `$1`
# So `exec "$1" "$2" "$3" ...`
keepgoing=1
trap '{ echo "sigint"; keepgoing=0; }' SIGINT

while (( keepgoing )); do
    #echo "sleeping"
    sleep 10
done
