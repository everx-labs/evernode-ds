#!/bin/bash

kafka-topics --create --zookeeper zookeeper:2181 --topic accounts  --replication-factor 1 --partitions 20 --if-not-exists
sleep 2
kafka-topics --create --zookeeper zookeeper:2181 --topic transactions  --replication-factor 1 --partitions 40 --if-not-exists
sleep 2
kafka-topics --create --zookeeper zookeeper:2181 --topic blocks  --replication-factor 1 --partitions 5 --if-not-exists
sleep 2
kafka-topics --create --zookeeper zookeeper:2181 --topic messages  --replication-factor 1 --partitions 60 --if-not-exists
sleep 2
kafka-topics --create --zookeeper zookeeper:2181 --topic requests  --replication-factor 1 --partitions 30 --if-not-exists
sleep 2
kafka-topics --create --zookeeper zookeeper:2181 --topic blocks_signatures  --replication-factor 1 --partitions 5 --if-not-exists
sleep 2
kafka-topics --alter --zookeeper zookeeper:2181 --topic accounts --partitions 20 --if-exists
sleep 2
kafka-topics --alter --zookeeper zookeeper:2181 --topic transactions --partitions 40 --if-exists
sleep 2
kafka-topics --alter --zookeeper zookeeper:2181 --topic blocks --partitions 5 --if-exists
sleep 2
kafka-topics --alter --zookeeper zookeeper:2181 --topic messages --partitions 60 --if-exists
sleep 2
kafka-topics --alter --zookeeper zookeeper:2181 --topic requests --partitions 30 --if-exists
sleep 2
kafka-topics --alter --zookeeper zookeeper:2181 --topic blocks_signatures --partitions 5 --if-exists
