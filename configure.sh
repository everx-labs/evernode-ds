#!/bin/bash -eE

#----- To configure your Dapp server set at least these environment variables: -----
export NETWORK_TYPE=net.ton.dev
export EVERNODE_FQDN=empty4.deploy.tonlabs.io
export LETSENCRYPT_EMAIL=artem.a.zhdanov@gmail.com
export HTPASSWD='admin:$apr1$tn69YEhu$ob9tNcnBCOYQm0oz.iWsY0'
export VALIDATOR_NAME=ex_my_validator

#----- Next variables can be used as reasonable defaults: -----

export ADNL_PORT=30303
#
# Container memory limits
#
export NODE_MEMORY=64G 
export QSERVER_MEMORY=5G
export ARANGO_MEMORY=32G
export KAFKA_MEMORY=10G
export CONNECT_MEMORY=5G


export TON_NODE_GITHUB_REPO="https://github.com/tonlabs/ever-node"
export TON_NODE_GITHUB_COMMIT_ID="8ccd0bf976c00f029d152a7f3ca7e86b02899e0f"
export TON_NODE_TOOLS_GITHUB_REPO="https://github.com/tonlabs/ever-node-tools.git"
export TON_NODE_TOOLS_GITHUB_COMMIT_ID="master"

Q_SERVER_GITHUB_REPO="https://github.com/tonlabs/ton-q-server"
Q_SERVER_GITHUB_COMMIT="0.54.0"

# This is a name of the internal (docker bridge) network. Set it arbitrarily. 
export NETWORK=evernode_ds  

# export COMPOSE_HTTP_TIMEOUT=120 

# 
# Create internal network if not exists
#
docker network inspect $NETWORK >/dev/null 2>&1 ||  docker network create $NETWORK -d bridge


##
# Create `deploy` directory as a copy of `templates` 
# and replace all {{VAR}} with enviroment variables
#
rm -rf deploy ; cp -R templates deploy
find deploy \
    -type f \( -name '*.yml' -o -name *.html \) \
    -not -path '*/ton-node/configs/*' \
    -exec ./templates/templater.sh {} \;

mv deploy/proxy/vhost.d/{host.yourdomain.com,$EVERNODE_FQDN}


# Run q-server
### rm -rf ./deploy/q-server/build/ton-q-server
### cd ./deploy/q-server/build  && git clone ${Q_SERVER_GITHUB_REPO} --branch ${Q_SERVER_GITHUB_COMMIT}



./templates/templater.sh deploy/ton-node/start_node.sh  

# echo "admin:\$apr1\$d0ifqbt3\$iayulpIOP2.IS4Sy1I2zJ0" >"${DOCKER_COMPOSE_DIR}/proxy/htpasswd/arango.${HOSTNAME}"

