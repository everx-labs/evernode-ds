#!/bin/bash
cd deploy/ton-node
rm -rf build/ton-node
cd build && git clone --recursive {{TON_NODE_GITHUB_REPO}} ton-node
cd ton-node && git checkout {{TON_NODE_GITHUB_COMMIT_ID}}
cd ..
rm -rf ever-node-tools
git clone --recursive {{TON_NODE_TOOLS_GITHUB_REPO}}
cd ever-node-tools && git checkout {{TON_NODE_TOOLS_GITHUB_COMMIT_ID}}
cd ../../

echo "==============================================================================="
echo "INFO: starting node on {{HOSTNAME}}..."

docker-compose up --build -d
docker exec --tty rnode "/ton-node/scripts/generate_console_config.sh"

docker-compose down -t 300
sed -i 's/"client_enabled":.*/"client_enabled": true,/' configs/config.json
sed -i 's/"service_enabled":.*/"service_enabled": true/' configs/config.json
sed -i 's/command: \["bash"\]/command: ["normal"]/' docker-compose.yml
docker-compose up -d
echo "INFO: starting node on {{HOSTNAME}}... DONE"
echo "==============================================================================="

docker ps -a
