#!/bin/bash

#./createMasters.sh 7001 5 redis-cluster-m- jamespedwards42/alpine-redis:4.0 [IP]

readonly STARTING_PORT=${1:-0}
readonly NUM_MASTERS=${2:-0}
readonly NAME_PREFIX=${3:-"redis-cluster-m-"}
readonly IMAGE=${4:-"jamespedwards42/alpine-redis:4.0"}
readonly ANNOUNCE_IP=${5}

if [ -z "$ANNOUNCE_IP"]; then
    for ((port = STARTING_PORT, endPort = port + NUM_MASTERS; port < endPort; port++)) do
      name="$NAME_PREFIX$port"
      docker service create \
        --name "$name" \
        --network backend \
        --publish "$port:$port"/tcp \
        --publish "1$port:1$port"/tcp \
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
            --logfile "$name".log \
            --port "$port" \
            --protected-mode no \
            --repl-diskless-sync yes \
            --save '''' \
            --cluster-announce-ip $ANNOUNCE_IP \
            --cluster-announce-port $port \
            --cluster-announce-bus-port 1$port
    done
else
     for ((port = STARTING_PORT, endPort = port + NUM_MASTERS; port < endPort; port++)) do
      name="$NAME_PREFIX$port"
      docker service create \
        --name "$name" \
        --network backend \
        --publish "$port:$port"/tcp \
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
            --logfile "$name".log \
            --port "$port" \
            --protected-mode no \
            --repl-diskless-sync yes \
            --save '''' \
    done   
end

exit 0

