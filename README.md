# README

This HOWTO contains instructions on how to build and configure a full node in TON blockchain. The instructions and scripts below were verified on Ubuntu 20.04.
# Getting Started

## 1. System Requirements
| Configuration | CPU (cores) | RAM (GiB) | Storage (GiB) | Network (Gbit/s)|
|---|:---|:---|:---|:---|
| Recommended |24|192|2000|1| 

SSD disks are recommended for the storage.
## 2. Prerequisites
### 2.1 Set the Environment
Adjust (if needed) `TON-OS-DApp-Server/scripts/env.sh`
    
    $ cd TON-OS-DApp-Server/scripts/
    $ . ./env.sh 
### 2.2 Install Dependencies
Ubuntu 20.04:

    $ ./install_deps.sh
### 2.3 Deploy Full Node
Deploy a full node:

    $ ./deploy.sh
