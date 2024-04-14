#!/bin/bash
#
# Start a test docker container of postgresql to test with
#
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --ip-range=192.168.1.224/28 \
  --gateway=192.168.1.1 \
  -o parent=enp2s0 documentum-network
docker run --name postgres -e POSTGRES_PASSWORD=changeme -e POSTGRES_USER=sandbox \
  -h postgres -d --network documentum-network --ip 192.168.1.225 postgres:12-alpine 