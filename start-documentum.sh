#!/bin/bash
cd server
docker container rm documentum --force
docker build -t dctm-cs:22.2 .
docker run -d --name documentum -h documentum --network documentum-network --ip 192.168.2.3 \
    -p 1489:1489 -p 1490:1490 -p 9080:9080 -p 50100:50100 -p 50101:50101 dctm-cs:22.2 
cd ..