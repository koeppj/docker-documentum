#!/bin/bash
cd rest
docker container rm rest --force
docker build -t dctm-rest:22.2 .
docker run -d --name rest -h rest --network documentum-network --ip 192.168.1.228 \
    -e DM_REST_PORT=8090 -p 8090:8090 dctm-rest:22.2 
cd ..