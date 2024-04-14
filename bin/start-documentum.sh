#!/bin/bash
cur_dir="$(dirname "$0")"
. "$cur_dir/common.sh"
cd server
docker container rm documentum --force
docker build -t dctm-cs:22.2 .
if [[ $(is_debug $@) = "debug" ]]; then
    docker run -it --name documentum -h documentum --network documentum-network --ip 192.168.1.226 dctm-cs:22.2 /bin/bash
else 
    docker run -d --name documentum -h documentum --network documentum-network --ip 192.168.1.226 dctm-cs:22.2 
fi
cd ..