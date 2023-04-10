#!/bin/bash

kafka-topics --create --bootstrap-server kafka:29092 --topic accounts  --replication-factor 1 --partitions 20 --if-not-exists
sleep 2
kafka-topics --create --bootstrap-server kafka:29092 --topic transactions  --replication-factor 1 --partitions 40 --if-not-exists
sleep 2
kafka-topics --create --bootstrap-server kafka:29092 --topic blocks  --replication-factor 1 --partitions 5 --if-not-exists
sleep 2
kafka-topics --create --bootstrap-server kafka:29092 --topic messages  --replication-factor 1 --partitions 60 --if-not-exists
sleep 2
kafka-topics --create --bootstrap-server kafka:29092 --topic requests  --replication-factor 1 --partitions 30 --if-not-exists
sleep 2
kafka-topics --create --bootstrap-server kafka:29092 --topic blocks_signatures  --replication-factor 1 --partitions 5 --if-not-exists
sleep 2
kafka-topics --alter --bootstrap-server kafka:29092 --topic accounts --partitions 20 --if-exists
sleep 2
kafka-topics --alter --bootstrap-server kafka:29092 --topic transactions --partitions 40 --if-exists
sleep 2
kafka-topics --alter --bootstrap-server kafka:29092 --topic blocks --partitions 5 --if-exists
sleep 2
kafka-topics --alter --bootstrap-server kafka:29092 --topic messages --partitions 60 --if-exists
sleep 2
kafka-topics --alter --bootstrap-server kafka:29092 --topic requests --partitions 30 --if-exists
sleep 2
kafka-topics --alter --bootstrap-server kafka:29092 --topic blocks_signatures --partitions 5 --if-exists


for connector in $(ls /work/connectors/*.json)
do
    curl --max-time 5 -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" connect:8083/connectors/ -d @/${connector}
    sleep 5s
done

exec tail -f /dev/null

