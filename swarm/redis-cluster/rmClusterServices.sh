#!/bin/bash

FILTER=$1
docker service ls | grep "$FILTER" | awk '{print $1}' | xargs docker service rm

exit 0;
