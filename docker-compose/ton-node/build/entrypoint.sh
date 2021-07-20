#!/bin/bash -eEx

echo "INFO: R-Node startup..."

echo "INFO: NETWORK_TYPE = ${NETWORK_TYPE}"
echo "INFO: CONFIGS_PATH = ${CONFIGS_PATH}"
echo "INFO: \$1 = $1"

case "${NETWORK_TYPE}" in
"net.ton.dev" | "main.ton.dev")
    curl -sS "https://raw.githubusercontent.com/tonlabs/${NETWORK_TYPE}/master/configs/${NETWORK_TYPE}/ton-global.config.json" \
        -o "${CONFIGS_PATH}/ton-global.config.json"
    ;;
"rustnet.ton.dev")
    curl -sS "https://raw.githubusercontent.com/tonlabs/${NETWORK_TYPE}/main/configs/ton-global.config.json" \
        -o "${CONFIGS_PATH}/ton-global.config.json"
    ;;
esac

if [ "$1" = "bash" ]; then
    tail -f /dev/null
else
    cd /ton-node
    exec /ton-node/ton_node --configs "${CONFIGS_PATH}"
fi

echo "INFO: R-Node startup... DONE"
