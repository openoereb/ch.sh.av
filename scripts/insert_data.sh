#!/bin/bash

ili2pg_executable=$(find /ili2pg -iname 'ili2pg*.jar')
av_model="DM01AVCH24LV95D"
schema="live"
topics="DM01AVCH24LV95D.Liegenschaften;DM01AVCH24LV95D.Gemeindegrenzen;DM01AVCH24LV95D.Gebaeudeadressen"

git clone https://github.com/openoereb/ch.sh.av.git /data

for f in /data/*.itf; do
  java -jar "$ili2pg_executable" \
    --import \
    --dbdatabase "$POSTGRES_DB" \
    --dbusr postgres \
    --dbpwd "$POSTGRES_PASSWORD" \
    --dbschema "$schema" \
    --models "$av_model" \
    --topics "$topics" \
    --disableValidation "$f"
done