#!/bin/bash
cur_dir="$(dirname "$0")"
. "$cur_dir/common.sh"
cd da
docker container rm da --force
unzip -q adds/da.war -d adds/da
docker build -t dctm-da:22.2 .
rm -rf adds/da
if [[ $(is_debug $@) = "debug" ]]; then
    docker run -it --rm --name da -h da --network documentum-network --ip 192.168.1.227 dctm-da:22.2 sh
else
    docker run -d --name da -h da --network documentum-network --ip 192.168.1.227 dctm-da:22.2 
fi
cd ..