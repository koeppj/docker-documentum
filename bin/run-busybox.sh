docker run -it --rm --name busybox --device=/dev/kvm -e VERSION="win10" \
--cap-add NET_ADMIN --network windows-vlan --ip 192.168.1.225 --stop-timeout 120 busybox
