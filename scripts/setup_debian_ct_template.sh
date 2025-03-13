# settings
TEMPLATE_ID=9100  
TEMPLATE_NAME="debian-ct-template"
DEBIAN_TEMPLATE="debian-12-standard_12.7-1_amd64.tar.zst"
RAM_SIZE="1024"
CPU_CORES="1"
BRIDGE="vmbr0"
STORAGE="local"
TEMPLATE_IP="192.168.1.120"
GATEWAY="192.168.1.1"

# download debian to local
pveam download local $DEBIAN_TEMPLATE

# Create a container
echo "Creating Proxmox CT template ($TEMPLATE_ID)..."
pct create $TEMPLATE_ID $STORAGE:$DEBIAN_TEMPLATE --hostname $TEMPLATE_NAME --memory $RAM_SIZE --net0 name=eth0,bridge=$BRIDGE,firewall=1,gw=$GATEWAY,ip=$TEMPLATE_IP/24,tag=10,type=veth --storage $STORAGE


# dit regeltje nog verder bekijken en dan alles uittesten
lock --rootfs localblock:8 --unprivileged 1 --pool Containers --ignore-unpack-errors --ssh-public-keys /root/.ssh/authorized_keys --ostype debian --password="student" --start 1