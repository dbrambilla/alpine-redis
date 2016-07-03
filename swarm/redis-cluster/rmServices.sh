#!/bin/bash
#./rmServices.sh redis-cluster-m-
readonly FILTER=${1:-"redis-cluster-m-"}
docker service ls | grep "$FILTER" | awk '{print $1}' | xargs docker service rm
exit 0
