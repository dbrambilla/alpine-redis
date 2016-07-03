#!/bin/bash

#./forEach.sh 7001 5 redis-cluster-m- CLUSTER INFO

readonly STARTING_PORT=$1
readonly NUM_MASTERS=$2
readonly NAME_PREFIX=$3
readonly REDIS_CMD=("${@:4}")

readonly LOCAL_CONTAINER_ID=$(docker ps -f name="$NAME_PREFIX" -q | head -n 1)
readonly LOCAL_PORT=$(docker inspect --format='{{index .Config.Labels "com.docker.swarm.service.name"}}' "$LOCAL_CONTAINER_ID" | sed 's|.*-||')

for ((port = STARTING_PORT, endPort = port + NUM_MASTERS; port < endPort; port++)) do
  host=$([ "$LOCAL_PORT" == $port ] && echo "127.0.0.1" || echo "$NAME_PREFIX$port")
  printf "\n%s\n" "$NAME_PREFIX$port:~\$ ${REDIS_CMD[*]}"
  docker exec -it "$LOCAL_CONTAINER_ID" \
    redis-cli -h "$host" -p "$port" \
      "${REDIS_CMD[@]}"
done
exit 0
