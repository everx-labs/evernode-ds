#!/bin/bash

/work/create_topics.sh
/work/create_connectors.sh

exec tail -f /dev/null

