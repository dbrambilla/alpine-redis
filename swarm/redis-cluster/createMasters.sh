#!/bin/bash

#./createMasters.sh 7001 5 redis-cluster-m- jamespedwards42/alpine-redis:3.2

readonly STARTING_PORT=${1:-0}
readonly NUM_MASTERS=${2:-0}
readonly NAME_PREFIX=${3:-"redis-cluster-m-"}
readonly IMAGE=${4:-"jamespedwards42/alpine-redis:3.2"}

for ((port = STARTING_PORT, endPort = port + NUM_MASTERS; port < endPort; port++)) do
  docker service create \
    --name "$NAME_PREFIX$port" \
    --network backend \
    --publish "$port":"$port" \
    --reserve-cpu=1 \
    --reserve-memory 1000MB \
    --restart-condition any \
    --stop-grace-period 60s \
      "$IMAGE" \
        --appendfsync everysec \
        --appendonly yes \
        --auto-aof-rewrite-percentage 20 \
        --cluster-enabled yes \
        --cluster-node-timeout 60000 \
        --cluster-require-full-coverage no \
        --port "$port" \
        --protected-mode no \
        --repl-diskless-sync yes \
        --save \"\"
done

exit 0
