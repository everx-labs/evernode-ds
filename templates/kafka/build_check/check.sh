#!/usr/bin/env sh

ENDPOINT=$1

# List current connectors and status
curl -s $ENDPOINT | \
    jq '.[]'| sed  -e 's/"//g' | \
    xargs -I{connector_name} curl -s "$ENDPOINT/{connector_name}/status"| \
    jq -c -M '[.name,.connector.state,.tasks[].state]|join(":|:")'| column -s : -t| sed 's/\"//g'| sort | tee /work/result.txt

# Restart any connector tasks that are FAILED
curl -s $ENDPOINT | \
  jq '.[]' | sed  -e 's/"//g' | \
  xargs -I{connector_name} curl -s  "$ENDPOINT/{connector_name}/status" | \
  jq -c -M '[select(.tasks[].state=="FAILED") | .name,"§±§",.tasks[].id]' | \
  grep -v "\[\]"| \
  sed -e 's/^\[\"//g'| sed -e 's/\",\"§±§\",/\/tasks\//g'|sed -e 's/\]$//g'| \
  xargs -I{connector_and_task} curl -v -X POST "$ENDPOINT/{connector_and_task}/restart"

# put error status
grep "FAILED" -qs /work/result.txt && exit 1 || exit 0
