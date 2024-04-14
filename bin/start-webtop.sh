#!/bin/bash
cd webtop
docker container rm webtop --force
docker build -t dctm-webtop:22.2 .
docker run -d --name webtop -h webtop --network documentum-network --ip 192.168.1.229 dctm-webtop:22.2 
cd ..