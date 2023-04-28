# Evernode DApp Server (DS)

[Evernode Dapp Server](https://docs.evercloud.dev/products/dapp-server-ds) is a community (open source) version of [Evernode Platform](https://docs.evercloud.dev/) (client supernode with GraphQL API) for TVM blockchains (Everscale, Venom, TON, Gosh) that exposes [GraphQL API](https://docs.evercloud.dev/reference/graphql-api).

Evernode Dapp Server is compatible with [ever-sdk](https://github.com/tonlabs/ever-sdk), [everdev](https://github.com/tonlabs/everdev), [everscale-inpage-provider](https://github.com/broxus/everscale-inpage-provider), [evescale-standalone-client](https://github.com/broxus/everscale-inpage-provider) and other libraries and tools for TVM blockchains.

<p align="center">
  <a href="https://docs.everscale.network/">
    <img src="https://4031793516-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FCmimRVYKp3FChIIdVQ51%2Fuploads%2Fg8DCzYhXFbskTt0odAR4%2FEverscale%20Logo.png?alt=media&token=9484b624-6456-47b4-9757-c0fa43f4caa7" alt="Logo"   height="100">
  </a>
  <a href="https://github.com/venom-blockchain/developer-program">
    <img src="https://raw.githubusercontent.com/venom-blockchain/developer-program/main/vf-dev-program.png" alt="Logo" height="100">
  </a>
</p>

This repository contains instructions on how to run your own free instance of Evernode Platform to connect your application to TVM blockchains.
The instructions and scripts were verified on Ubuntu 20.04.

## Table of Contents

-   [1. What is Evernode DApp Server?](#1-what-is-evernode-dapp-server)
-   [2. Overview of technical architecture](#2-overview-of-technical-architecture)
    -   [2.1 Service interaction diagram](#21-service-interaction-diagram)
-   [3. Getting Started](#3-getting-started)
    -   [3.1 Prerequisites](#31-prerequisites)
    -   [3.2 Configuration](#32-configuration)
    -   [3.3 Deployment](#33-deployment)
    -   [3.4 Tests](#34-tests)

## 1. What is Evernode DApp Server?

 Evernode DS is a set of services that allow your applications to interact with the TVM blockchains:

-   [Everscale node](https://github.com/tonlabs/ton-labs-node), written in Rust and focused on performance and safety,
    is the core element of Evernode DS.

-   [Everscale GraphQL Server](https://github.com/tonlabs/ton-q-server) (referred as Q-Server) provides EVER SDK GraphQL
    endpoint for sending messages and quering blockchain.

-   [ArangoDB](https://www.arangodb.com/documentation/). Multi-model database with the information about all
    blockchain entities (like accounts, blocks, transactions, etc.) stored over time.

-   [Kafka](https://kafka.apache.org/documentation/) stream-processing platform for communication between services.

-   [StatsD exporter](....) to collect and expose metrics to Prometheus.

The client/application interacts with the blockchain by performing the appropriate GraphQL operations:

-   Mutation - to send an external message to the blockchain.
-   Query - to query blockchain data.
-   Subscription - to subscribe for blockchain events.

**Note**: The DApp server is accessed via HTTPS, so your server must have an FQDN.\
A self-signed certificate will be received on start-up. This certificate will be subsequently renewed automatically.

## 2. Overview of technical architecture

The DApp server provides the following endpoints:

-   https://your.domain/graphql
-   https://your.domain/arangodb
-   https://your.domain/metrics

All endpoints require basic authorization.

### 2.1 Service interaction diagram:

![Services interaction](./docs/system_components.svg):

This scripts run all services as docker containers inside one docker bridge network.\
Recommended system configuration for this setup are shown below:

| CPU (cores) | RAM (GiB) | Storage (GiB)                       | Network (Gbit/s) |
| ----------- | :-------- | :---------------------------------- | :--------------- |
| 24          | 128       | 2000                                | 1                |
|             |           | NVMe SSD disks are recommended      |                  |

**Note**: For production use under high load, it makes sense to distribute services across different servers. Use this repository as a starting point.

## 3. Getting Started

### 3.1 Prerequisites
- Host OS: Linux (all scripts tested on Ubuntu 20.04). 
- Host has a fully qualified domain name.
- Installed Git, Docker Engine, Docker CLI, Docker Compose v2 or later.

### 3.2 Configuration

3.2.1 Set variables

Check `configure.sh` and set at least these enviroment variables:

- NETWORK_TYPE
- EVERNODE_FQDN
- LETSENCRYPT_EMAIL
- HTPASSWD, for example: HTPASSWD='admin:$apr1$dZ.erPEP$hwe0sqiw8ars.NUaFumnb0'.\
  Note single quoutes. It is needed to escape "$" symbols.\
  You can generate HTPASSWD running  `htpasswd -nb admin weakPas$w0rd`.

3.2.2 Run configuration script

```
$ ./configure.sh
```

This script creates `./deployment` directory

### 3.3 Deployment

Run `./up.sh`.

After the script completes normally (it takes 30 min apox.), the node starts synchronizing its state, which can take several hours.\
Use the following command to check the progress:

```
    docker exec rnode /ton-node/tools/console -C /ton-node/configs/console.json --cmd getstats
```

Script output example:

```
tonlabs console 0.1.286
COMMIT_ID: 5efe6bb8f2a974ba0e6b1ea3e58233632236e182
BUILD_DATE: 2022-10-17 02:32:44 +0300
COMMIT_DATE: 2022-08-12 00:22:07 +0300
GIT_BRANCH: master
{
	"sync_status":	"synchronization_finished",
	"masterchainblocktime":	1665988670,
	"masterchainblocknumber":	9194424,
	"node_version":	"0.51.1",
	"public_overlay_key_id":	"S4TaVdGitzTApe7GFCj8DbuRIkVEbg+ODzBxhQGIUG0=",
	"timediff":	6,
	"shards_timediff":	6,
     ----%<---------------------
}
```

If the `timediff` parameter is less than 10 seconds, synchronization with masterchain is complete.\
`"sync_status": "synchronization finished"` means synchronization with workchains is complete.

### 3.4 Tests

TODO: Add tests to verify that the DApp is really functional

Congratulations! Your DApp server is set up.
