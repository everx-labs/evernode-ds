#!/bin/bash -eEx

if [ "$DEBUG" = "yes" ]; then
    set -x
fi

EVER_NODE_ROOT_DIR="/ever-node"
EVER_NODE_CONFIGS_DIR="${EVER_NODE_ROOT_DIR}/configs"
EVER_NODE_TOOLS_DIR="${EVER_NODE_ROOT_DIR}/tools"
EVER_NODE_CONSOLE_SERVER_PORT="3031"

HOSTNAME=$(hostname -f)
TMP_DIR="/tmp/$(basename "$0" .sh)_$$"
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"

"${EVER_NODE_TOOLS_DIR}/keygen" >"${EVER_NODE_CONFIGS_DIR}/${HOSTNAME}_console_client_keys.json"
cat "${EVER_NODE_CONFIGS_DIR}/${HOSTNAME}_console_client_keys.json"
jq -c .public "${EVER_NODE_CONFIGS_DIR}/${HOSTNAME}_console_client_keys.json" >"${EVER_NODE_CONFIGS_DIR}/console_client_public.json"

jq ".control_server_port = ${EVER_NODE_CONSOLE_SERVER_PORT}" "${EVER_NODE_CONFIGS_DIR}/default_config.json" >"${TMP_DIR}/default_config.json.tmp"
cp "${TMP_DIR}/default_config.json.tmp" "${EVER_NODE_CONFIGS_DIR}/default_config.json"

# Generate initial config.json
cd "${EVER_NODE_ROOT_DIR}" && "${EVER_NODE_ROOT_DIR}/ton_node" --configs "${EVER_NODE_CONFIGS_DIR}" --ckey "$(cat "${EVER_NODE_CONFIGS_DIR}/console_client_public.json")" &

# TODO: Why it's needed?
sleep 60

if [ ! -f "${EVER_NODE_CONFIGS_DIR}/config.json" ]; then
    echo "ERROR: ${EVER_NODE_CONFIGS_DIR}/config.json does not exist"
    exit 1
fi

cat "${EVER_NODE_CONFIGS_DIR}/config.json"

if [ ! -f "${EVER_NODE_CONFIGS_DIR}/console_config.json" ]; then
    echo "ERROR: ${EVER_NODE_CONFIGS_DIR}/console_config.json does not exist"
    exit 1
fi

cat "${EVER_NODE_CONFIGS_DIR}/console_config.json"

jq ".client_key = $(jq .private "${EVER_NODE_CONFIGS_DIR}/${HOSTNAME}_console_client_keys.json")" "${EVER_NODE_CONFIGS_DIR}/console_config.json" >"${TMP_DIR}/console_config.json.tmp"
jq ".config = $(cat "${TMP_DIR}/console_config.json.tmp")" "${EVER_NODE_CONFIGS_DIR}/console_template.json" >"${EVER_NODE_CONFIGS_DIR}/console.json"
rm -f "${EVER_NODE_CONFIGS_DIR}/console_config.json"

rm -rf "${TMP_DIR}"
