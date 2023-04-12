#!/bin/bash

set -e

for connector in $(ls /work/connectors)
do
    java -jar /usr/bin/connect-cli create -e http://connect:8083/  $(awk -F "." '{print $1}' <<< ${connector}) < /work/connectors/${connector}
    sleep 10s
done
