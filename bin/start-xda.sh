#!/bin/bash
cur_dir="$(dirname "$0")"
. "$cur_dir/common.sh"
cd xda
docker container rm xda --force
docker build -t dctm-xda:22.2 .
if [[ $(is_debug $@) = "debug" ]]; then
    docker run -it --name xda -h xda --network documentum-network --ip 192.168.1.230 dctm-xda:22.2 sh
else 
    docker run -d --name xda -h xda --network documentum-network --ip 192.168.1.230 dctm-xda:22.2 
fi
cd ..