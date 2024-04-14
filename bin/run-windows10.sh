docker run -it --name windows --device=/dev/kvm -e VERSION="tiny10" -e DISK_SIZE="12G" \
--cap-add NET_ADMIN --network windows-vlan --ip 192.168.1.225 --stop-timeout 120 dockurr/windows
