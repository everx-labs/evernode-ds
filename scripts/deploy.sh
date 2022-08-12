#!/bin/bash -eE

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
# shellcheck source=env.sh
. "${SCRIPT_DIR}/env.sh"

TMP_DIR=/tmp/$(basename "$0" .sh)_$$
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"

set +eE

for BUNDLE_COMPONENT in proxy web.root arangodb q-server kafka statsd ton-node kafka-streams redis; do
    echo "Stopping $BUNDLE_COMPONENT"
    if [ "${CLEAN_HOST}" = "yes" ]; then
        cd "${DOCKER_COMPOSE_DIR}/${BUNDLE_COMPONENT}/" && docker-compose down --volumes --remove-orphans 2>/dev/null
    else
        cd "${DOCKER_COMPOSE_DIR}/${BUNDLE_COMPONENT}/" && docker-compose stop 2>/dev/null
    fi
done

if [ "${CLEAN_HOST}" = "yes" ]; then
    docker system prune --all --force --volumes
    docker network create proxy_nw
fi

set -eE

sed -i "s|yourdomain.com|${HOSTNAME}|g" "${DOCKER_COMPOSE_DIR}/arangodb/docker-compose.yml"
sed -i "s|email for notification|${EMAIL_FOR_NOTIFICATIONS}|g" "${DOCKER_COMPOSE_DIR}/arangodb/docker-compose.yml"
sed -i "s|NETWORK_TYPE.*|NETWORK_TYPE=${NETWORK_TYPE}|g" "${DOCKER_COMPOSE_DIR}/arangodb/.env"

sed -i "s|host.yourdomain.com|${HOSTNAME}|g" "${DOCKER_COMPOSE_DIR}/web.root/.env"
sed -i "s|for notification|${EMAIL_FOR_NOTIFICATIONS}|g" "${DOCKER_COMPOSE_DIR}/web.root/docker-compose.yml"

rm -f "${DOCKER_COMPOSE_DIR}/proxy/htpasswd/arango.yourdomain.com"
echo "admin:\$apr1\$d0ifqbt3\$iayulpIOP2.IS4Sy1I2zJ0" >"${DOCKER_COMPOSE_DIR}/proxy/htpasswd/arango.${HOSTNAME}"
echo "#iJJ9fWxb9Z6CS1aPagoW" >>"${DOCKER_COMPOSE_DIR}/proxy/htpasswd/arango.${HOSTNAME}"
mv "${DOCKER_COMPOSE_DIR}/proxy/vhost.d/host.yourdomain.com" "${DOCKER_COMPOSE_DIR}/proxy/vhost.d/${HOSTNAME}"

for BUNDLE_COMPONENT in proxy web.root arangodb redis; do
    cd "${DOCKER_COMPOSE_DIR}/${BUNDLE_COMPONENT}/" && docker-compose up -d
done

rm -rf "${DOCKER_COMPOSE_DIR}/q-server/build/ton-q-server"
cd "${DOCKER_COMPOSE_DIR}/q-server/build" && git clone --recursive "${TON_Q_SERVER_GITHUB_REPO}"
cd "${DOCKER_COMPOSE_DIR}/q-server/build/ton-q-server" && git checkout "${TON_Q_SERVER_GITHUB_COMMIT_ID}"

ENVFILE=${DOCKER_COMPOSE_DIR}/q-server/.env
if [ "${REMP_ENABLED}" = "yes" ]; then
    echo "Q_REMP_ENABLED=true" >> ${ENVFILE}
    echo "Q_REMP_REDIS_CLIENT_URL=redis://redis:6379" >> ${ENVFILE}
else
    echo "Q_REMP_ENABLED=false" >> ${ENVFILE}
fi
cd "${DOCKER_COMPOSE_DIR}/q-server" && docker-compose up -d

echo "INFO: Waiting for Kafka start..."
cd "${DOCKER_COMPOSE_DIR}/kafka" || exit 1
OK=0
while [ $OK -ne 100 ]; do
    docker-compose up -d >"${TMP_DIR}/kafka.log" 2>&1
    OK=$(awk '
        BEGIN { fail = 0 }
        {
            if ($1 == "ERROR:") {
                fail = fail + 1
            }
        }
        END {
            if (fail != 0) {
                print 0
            } else {
                print 100
            }
        }
    ' "${TMP_DIR}/kafka.log")
done
rm -f "${TMP_DIR}/kafka.log"

OK=0
while [ $OK -ne 100 ]; do
    OK=$(docker ps --format 'table {{.Image}} \t {{.Names}} \t {{.Status}}' | awk '
        BEGIN { OK = 0 }
        {
            if (($2 == "check-connect") && ($3 == "Up")) {
                i = NF;
                if ($i == "(healthy)") {
                    OK = OK + 1
                }
            }
        }
        END {
            if (OK != 1) {
                print OK
            } else {
                print 100
            }
        }
    ')
    sleep 1s
done

until [ "$(echo "${IntIP}" | grep "\." -o | wc -l)" -eq 3 ]; do
    set +e
    IntIP="$(curl -sS --ipv4 https://ip.me/)":${ADNL_PORT}
    set -e
    echo "INFO: IntIP = $IntIP"
    sleep 1s 
done
sed -i "s|IntIP.*|IntIP=${IntIP}|g" "${DOCKER_COMPOSE_DIR}/statsd/.env"
cd "${DOCKER_COMPOSE_DIR}/statsd/" && docker-compose up -d

if [ "${REMP_ENABLED}" = "yes" ]; then
    rm -rf "${DOCKER_COMPOSE_DIR}/kafka-streams/dapp-remp-subscriptions"
    cd "${DOCKER_COMPOSE_DIR}/kafka-streams" && git clone --recursive "${REMP_SUBSCRIPTIONS_GITHUB_REPO}"
    cd "${DOCKER_COMPOSE_DIR}/kafka-streams/dapp-remp-subscriptions" && git checkout "${REMP_SUBSCRIPTIONS_GITHUB_COMMIT_ID}"
    cd "${DOCKER_COMPOSE_DIR}/kafka-streams" && docker-compose up -d
fi

sed -i "s|ADNL_PORT.*|ADNL_PORT=${ADNL_PORT}|" "${DOCKER_COMPOSE_DIR}/ton-node/.env"
sed -i "s|NETWORK_TYPE.*|NETWORK_TYPE=${NETWORK_TYPE}|" "${DOCKER_COMPOSE_DIR}/ton-node/.env"

rm -rf "${DOCKER_COMPOSE_DIR}/ton-node/build/ton-node"
cd "${DOCKER_COMPOSE_DIR}/ton-node/build" && git clone --recursive "${TON_NODE_GITHUB_REPO}" ton-node
cd "${DOCKER_COMPOSE_DIR}/ton-node/build/ton-node" && git checkout "${TON_NODE_GITHUB_COMMIT_ID}"

echo "==============================================================================="
echo "INFO: starting node on ${HOSTNAME}..."

cd "${DOCKER_COMPOSE_DIR}/ton-node/configs"

tmp=$(mktemp)
jq --arg enabled $REMP_ENABLED '
    .external_db_config.remp_statuses_producer = {
            "enabled": $enabled | test("yes"),
            "brokers": "kafka",
            "message_timeout_ms": 1000,
            "topic": "remp-receipts",
            "attempt_timeout_ms": 100,
            "message_max_size": 2000000
    } |
    .remp.RempClient = { "enabled": true }
' default_config.json  > "$tmp" && mv "$tmp" default_config.json

cd "${DOCKER_COMPOSE_DIR}/ton-node/" && docker-compose up -d
echo "INFO: starting node on ${HOSTNAME}... DONE"
echo "==============================================================================="

docker ps -a
rm -rf "${TMP_DIR}"
