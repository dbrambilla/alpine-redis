#!/bin/bash

#./assignSlots.sh 7001 5 redis-cluster-m-

readonly STARTING_PORT=${1:-0}
readonly NUM_MASTERS=${2:-0}
readonly NAME_PREFIX=${3:-"redis-cluster-m-"}

readonly MAX_SLOT=$((16383))
readonly SLOT_RANGE=$(((MAX_SLOT + NUM_MASTERS - 1) / NUM_MASTERS))

readonly LOCAL_CONTAINER_ID=$(docker ps -f name="$NAME_PREFIX" -q | head -n 1)
readonly LOCAL_PORT=$(docker inspect --format='{{index .Config.Labels "com.docker.swarm.service.name"}}' "$LOCAL_CONTAINER_ID" | sed 's|.*-||')

for ((port = STARTING_PORT, endPort = STARTING_PORT + NUM_MASTERS, slot = 0; port < endPort; port++)) do
  end_slot=$((slot + SLOT_RANGE))
  end_slot=$((end_slot > MAX_SLOT ? MAX_SLOT : end_slot))

  host=$([ "$LOCAL_PORT" == $port ] && echo "127.0.0.1" || echo "$NAME_PREFIX$port")

  echo "CLUSTER ADDSLOTS $slot - $end_slot"
  # shellcheck disable=SC2046
  docker exec -it "$LOCAL_CONTAINER_ID" \
    redis-cli -h "$host" -p "$port" \
      CLUSTER ADDSLOTS $(seq "$slot" "$end_slot")

  slot=$((end_slot + 1));
done

exit 0
