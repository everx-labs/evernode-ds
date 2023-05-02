# Evernode DApp Server

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

This repository contains instructions on how to run your own free instance of Evernode Platform to connect your application to TVM blockchains.\
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

Evernode DApp Server is a set of services that provides a GraphQL API for TVM blockchains.

The client application can send messages to the blockchain and receive the results by performing the appropriate GraphQL operations:

-   Mutation - to send an external message to the blockchain.
-   Query - to query blockchain data.
-   Subscription - to subscribe for blockchain events.

 DApp Server consists of: 
-   [Everscale node](https://github.com/tonlabs/ton-labs-node), written in Rust and focused on performance and safety,
    is the core element of DApp Server.

-   [Everscale GraphQL Server](https://github.com/tonlabs/ton-q-server) (referred as Q-Server) provides GraphQL
    endpoint for sending messages and quering blockchain.

-   [ArangoDB](https://www.arangodb.com/documentation/). Multi-model database with the information about all
    blockchain entities (like accounts, blocks, transactions, etc.) stored over time.

-   [Kafka](https://kafka.apache.org/documentation/) stream-processing platform for communication between services.

-   [StatsD exporter](....) to collect and expose metrics to Prometheus.


**Note**: The DApp server is accessed via HTTPS, so your server must have an FQDN.\
A self-signed certificate will be received on start-up. This certificate will be subsequently renewed automatically.

## 2. Overview of technical architecture

Evernode DApp server provides the following endpoints:

-   https://your.domain/graphql
-   https://your.domain/arangodb (requires basic authorization)
-   https://your.domain/metrics

### 2.1 Service interaction diagram:

In this diagram, the bold arrows show how external messages are processed.

-   The client application sends a message (represented as a Graphql mutation operation) to the Q-Server.
-   Q-Server sends this message (via Kafka) to RNode for processing.
-   RNode continuously provides (via kafka) updated blockchain data as JSON documents (blocks, messages, transactions, account states) to ArangoDB.
-   Q-Server queries ArangoDB, thus knowing the result of the message execution.

![Services interaction](./docs/system_components.svg):

This scripts run all services as docker containers inside one docker bridge network.\
Recommended system configuration for this setup are shown below:

| CPU (cores) | RAM (GiB) | Storage (GiB)                          | Network (Gbit/s) |
| ----------- | :-------- | :------------------------------------- | :--------------- |
| 24          | 128       | 2000. (NVMe SSD disks are recommended) | 1                |

**Note**: For production use under high load, it makes sense to distribute services across different servers. Use this repository as a starting point.

## 3. Getting Started

### 3.1 Prerequisites

-   Host OS: Linux (all scripts tested on Ubuntu 20.04).
-   Host has a fully qualified domain name.
-   Installed Git, Docker Engine, Docker CLI, Docker Compose v2 or later.

### 3.2 Configuration

3.2.1 Set variables

Check `configure.sh` and set at least these enviroment variables:

-   NETWORK_TYPE
-   EVERNODE_FQDN
-   LETSENCRYPT_EMAIL
-   HTPASSWD. Set this variable if you need access to the ArangoDB web interface.\
     For example: HTPASSWD='admin:$apr1$zpnuu5ho$Swc8jhnhlHV.qqgoaLGdO1'. Single quoutes needed to escape "$" symbols.\
     You can generate HTPASSWD running `htpasswd -nb admin 12345`

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

To verify that the DApp server is really functional run the test bellow.\
This test deploys wallet and transfers 0.5 tokens from the wallet to another address.
```
$ docker build --tag evernode_test .
$ docker run --rm -e ENDPOINT=https://<your_domain>/graphql evernode_test
```
#### Example output

```
> npx ts-node src/wallet.ts
You can topup your wallet from dashboard at https://dashboard.evercloud.dev
Please send >= 1 tokens to 0:8a447eca3adde54414ab760d3633b96d5e7706a754450adfed587ac191c5b117
awaiting...
```

> Here the test will block until you send some tokens to that address.\
> In devnet you can do it using our dashboarsd at https://dashboard.evercloud.dev or telegram bot https://t.me/everdev_giver_bot

```
Account balance is: 100 tokens. Account type is 0
Deploying wallet contract to address: 0:8a447eca3adde54414ab760d3633b96d5e7706a754450adfed587ac191c5b117 and waiting for transaction...
Contract deployed. Transaction hash 318d2acfabd15a9e5ffd58c06c00074c67eca414f25e973c3332a8aeaa574bf1
Sending 0.5 token to -1:7777777777777777777777777777777777777777777777777777777777777777
Transfer completed. Transaction hash 54fdd8cce38c6078a25aae61c7deed2e5664c847c171048a814692440ee37610
Transaction hash: 1d3bf7ef8a50ad38012f304a38c94fe4bca5bc1b50c2d4dd45ce2a71dc7c0921
Transaction hash: 318d2acfabd15a9e5ffd58c06c00074c67eca414f25e973c3332a8aeaa574bf1
Transaction hash: 54fdd8cce38c6078a25aae61c7deed2e5664c847c171048a814692440ee37610
```

Congratulations! Your DApp server is set up.
