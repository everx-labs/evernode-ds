#!/bin/bash -eEx

echo "INFO: ever-node startup..."

echo "INFO: NETWORK_TYPE = ${NETWORK_TYPE}"
echo "INFO: CONFIGS_PATH = ${CONFIGS_PATH}"
echo "INFO: \$1 = $1"

curl -sS "https://raw.githubusercontent.com/tonlabs/${NETWORK_TYPE}/master/configs/ton-global.config.json" \
    -o "${CONFIGS_PATH}/ton-global.config.json"

if [ "$1" = "bash" ]; then
    tail -f /dev/null
else
    cd /ever-node
    exec /ever-node/ton_node --configs "${CONFIGS_PATH}"
fi

echo "INFO: ever-node startup... DONE"
