#!/bin/bash
#OAR -l nodes=1,walltime=1:0:0
#OAR -p larochette

COMPOSE_FILE=$1

# Install docker on the compute node
g5k-setup-docker -t

# Disable NUMA balancing
sudo sh -c 'echo 0 > /proc/sys/kernel/numa_balancing'

# Start the docker containers
docker compose ${COMPOSE_FILE:+-f "$COMPOSE_FILE"} up -d
docker compose logs -f
