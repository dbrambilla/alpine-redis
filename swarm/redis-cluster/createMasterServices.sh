#!/bin/bash

#./createMasterServices.sh 7000 5 redis-cluster-unstable-m- jamespedwards42/alpine-redis:unstable

STARTING_PORT=${1:-0}
NUM_MASTERS=${2:-0}
NAME_PREFIX=${3:-"redis-cluster-3_2-m-"}
IMAGE=${4:-"jamespedwards42/alpine-redis:3.2"}

for ((port = STARTING_PORT, endPort = port + NUM_MASTERS; port < endPort; port++)) do
  docker service create \
    --name "$NAME_PREFIX$port" \
    --network backend \
    --reserve-cpu=2 \
    --reserve-memory 1000MB \
    --publish "$port":"$port" \
    --restart-condition any \
    --stop-grace-period 60s \
      "$IMAGE" \
        --protected-mode no \
        --port "$port" \
        --cluster-enabled yes \
        --cluster-node-timeout 60000 \
        --cluster-require-full-coverage no \
        --save \"\" \
        --repl-diskless-sync yes \
        --appendonly yes \
        --appendfsync everysec \
        --auto-aof-rewrite-percentage 20
done

exit 0
