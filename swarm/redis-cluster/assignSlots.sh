#!/bin/bash

STARTING_PORT=${1:-0}
NUM_MASTERS=${2:-0}
IMAGE=${3:-"jamespedwards42/alpine-redis:3.2"}

MAX_SLOT=$((16383))
SLOT_RANGE=$(((MAX_SLOT + NUM_MASTERS - 1) / NUM_MASTERS))

for ((port = STARTING_PORT, endPort = STARTING_PORT + NUM_MASTERS, slot = 0; port < endPort; port++)) do
  END_SLOT=$((slot + SLOT_RANGE))
  END_SLOT=$((END_SLOT > MAX_SLOT ? MAX_SLOT : END_SLOT))

  echo "CLUSTER ADDSLOTS $slot - $END_SLOT"
  docker run -it --rm --net host --name redis-cli \
    --entrypoint redis-cli \
      "$IMAGE" -h 127.0.0.1 -p "$port" \
        CLUSTER ADDSLOTS $(seq "$slot" "$END_SLOT")

  slot=$((END_SLOT + 1));
done

docker run -it --rm --net host --name redis-cli  \
  --entrypoint redis-cli \
    "$IMAGE" -h 127.0.0.1 -p "$STARTING_PORT" \
      CLUSTER NODES

docker run -it --rm --net host --name redis-cli  \
  --entrypoint redis-cli \
    "$IMAGE" -h 127.0.0.1 -p "$STARTING_PORT" \
      CLUSTER NODES

exit 0
