#!/bin/bash

files=$(find data/*)

echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time for file in $files; do
    unzip -p "$file" | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:15456/postgres -c "COPY tweets_jsonb (data) FROM STDIN CSV QUOTE E'\x01' DELIMITER E'\x02';" 
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time for file in $files; do  
    python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:15457/postgres --inputs $file
done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time for file in $files; do
    python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:15458/postgres --inputs $file
done
