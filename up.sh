#!/bin/bash

echo "Starting Statsd"
docker-compose -f deploy/statsd/docker-compose.yml up --build -d

echo "Starting ArangoDB"
docker-compose -f deploy/arangodb/docker-compose.yml up --build -d


echo "Starting Kafka & Kafka Connect"
docker-compose -f deploy/kafka/docker-compose.yml up --build -d


echo "Starting Q-Server"
docker-compose -f deploy/q-server/docker-compose.yml up --build -d


echo "Starting Node"
./deploy/ton-node/start_node.sh 

echo "Starting reverse proxy"
docker-compose -f deploy/proxy/docker-compose.yml up --build -d
