#!/bin/bash
cd da
docker container rm da --force
docker build -t dctm-da:22.2 .
docker run -d --name da -h da --network documentum-network --ip 192.168.2.4 \
    -p 8080:8080 dctm-da:22.2 
cd ..