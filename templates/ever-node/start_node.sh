#!/bin/bash
cd deploy/ever-node
rm -rf build/ever-node
cd build && git clone --recursive {{EVERNODE_GITHUB_REPO}} ever-node
cd ever-node && git checkout {{EVERNODE_GITHUB_COMMIT_ID}}
cd ..
rm -rf ever-node-tools
git clone --recursive {{EVERNODE_TOOLS_GITHUB_REPO}}
cd ever-node-tools && git checkout {{EVERNODE_TOOLS_GITHUB_COMMIT_ID}}
cd ../../

echo "==============================================================================="
echo "INFO: starting node on {{HOSTNAME}}..."

docker-compose up --build -d
docker exec --tty ever-node "/ever-node/scripts/generate_console_config.sh"

docker-compose down -t 300
sed -i 's/"client_enabled":.*/"client_enabled": true,/' configs/config.json
sed -i 's/"service_enabled":.*/"service_enabled": true/' configs/config.json
sed -i 's/command: \["bash"\]/command: ["normal"]/' docker-compose.yml
docker-compose up -d
echo "INFO: starting node on {{HOSTNAME}}... DONE"
echo "==============================================================================="

docker ps -a
