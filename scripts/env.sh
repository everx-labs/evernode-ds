#!/bin/bash -eE

DEBUG=${DEBUG:-no}

if [ "$DEBUG" = "yes" ]; then
    set -x
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
export SCRIPT_DIR
SRC_TOP_DIR=$(cd "${SCRIPT_DIR}/../" && pwd -P)
export SRC_TOP_DIR
export DOCKER_COMPOSE_DIR="${SRC_TOP_DIR}/docker-compose"

# Supported network types: net.ton.dev, main.ton.dev
export NETWORK_TYPE="${NETWORK_TYPE:-net.ton.dev}"
export CLEAN_HOST=${CLEAN_HOST:-yes}
export ADNL_PORT=${ADNL_PORT:-30303}
export EMAIL_FOR_NOTIFICATIONS="email@yourdomain.com"
export COMPOSE_HTTP_TIMEOUT=120 # in sec, 60 sec - default
HOSTNAME=$(hostname -f)
export TON_Q_SERVER_GITHUB_REPO="https://github.com/tonlabs/ton-q-server"
export TON_Q_SERVER_GITHUB_COMMIT_ID="0.54.4"
export TON_NODE_GITHUB_REPO="https://github.com/tonlabs/ever-node"
export TON_NODE_GITHUB_COMMIT_ID="8ccd0bf976c00f029d152a7f3ca7e86b02899e0f"
export TON_NODE_TOOLS_GITHUB_REPO="https://github.com/tonlabs/ever-node-tools.git"
export TON_NODE_TOOLS_GITHUB_COMMIT_ID="master"
