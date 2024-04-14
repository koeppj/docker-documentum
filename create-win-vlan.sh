#!/bin/bash
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --ip-range=192.168.1.224/28 \
  --gateway=192.168.1.1 \
  -o parent=enp2s0 windows-vlan

