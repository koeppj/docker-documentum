#!/bin/bash
#
# Start a test docker container of postgresql to test with
#
docker network create documentum-network --subnet 192.168.2.0/24
docker run --name postgres -e POSTGRES_PASSWORD=changeme -e POSTGRES_USER=sandbox \
    -p 5432:5432 -h postgres -d --network documentum-network --ip 192.168.2.2 postgres:12-alpine 