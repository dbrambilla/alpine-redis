#!/bin/bash

STARTING_PORT=${1:-0}
NUM_MASTERS=${2:-0}
NAME_PREFIX=${3:-"redis-cluster-3_2-m-"}

MAX_SLOT=$((16384))
SLOT_RANGE=$(((MAX_SLOT + NUM_MASTERS - 1) / NUM_MASTERS))

LOCAL_CONTAINER_ID=$(docker ps -f name="$NAME_PREFIX" -q | head -n 1)

for ((port = STARTING_PORT, endPort = STARTING_PORT + NUM_MASTERS, slot = 0; port < endPort; port++)) do
  END_SLOT=$((slot + SLOT_RANGE))
  END_SLOT=$((END_SLOT > MAX_SLOT ? MAX_SLOT : END_SLOT))
  SLOTS=$(seq -s ' ' "$slot" "$END_SLOT")

  echo "CLUSTER ADDSLOTS $slot - $END_SLOT"
  #docker exec -it "$LOCAL_CONTAINER_ID" redis-cli -h "$NAME_PREFIX$port" -p "$port" CLUSTER ADDSLOTS "$SLOTS"

  slot=$((END_SLOT + 1));
done
exit 0
