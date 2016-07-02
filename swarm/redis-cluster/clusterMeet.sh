#!/bin/bash

STARTING_PORT=${1:-0}
NUM_MASTERS=${2:-0}
NAME_PREFIX=${3:-"redis-cluster-3_2-m-"}

GREETER_NODE="$NAME_PREFIX$STARTING_PORT"
LOCAL_CONTAINER_ID=$(docker ps -f name="$NAME_PREFIX" -q | head -n 1)
# From greeter node, meet all other nodes
for ((port = STARTING_PORT + 1, endPort = STARTING_PORT + NUM_MASTERS; port < endPort; port++)) do
  MEET_NODE="$NAME_PREFIX$port"
  MEET_IP=$(docker service inspect -f '{{(index .Endpoint.VirtualIPs 1).Addr}}' "$MEET_NODE" | sed 's|/.*||')
  echo "CLUSTER MEET $MEET_IP $port"
  docker exec -it "$LOCAL_CONTAINER_ID" redis-cli -h "$GREETER_NODE" -p "$STARTING_PORT" CLUSTER MEET "$MEET_IP" "$port"
done

docker exec -it "$LOCAL_CONTAINER_ID" redis-cli -h "$GREETER_NODE" -p "$STARTING_PORT" CLUSTER NODES
exit 0;
