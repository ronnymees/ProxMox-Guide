# settings
TEMPLATE_ID=9100  
TEMPLATE_NAME="debian-lxc-template"
DEBIAN_TEMPLATE="debian-12-standard_12.7-1_amd64.tar.zst"
RAM_SIZE="1024"
CPU_CORES="1"
BRIDGE="vmbr0"
STORAGE="local"
TEMPLATE_IP="192.168.1.120"
GATEWAY="192.168.1.1"
HOSTNAME="debian-template"
PASSWORD="rootadmin"

# Step 1 - download debian
pveam download $STORAGE $DEBIAN_TEMPLATE

# Step 2 - Create a container
echo "Creating Proxmox LXC template ($TEMPLATE_ID)..."
pct create $TEMPLATE_ID $STORAGE:vztmpl/$DEBIAN_TEMPLATE \
    --hostname $HOSTNAME \
    --storage $STORAGE-zfs \
    --net0 name=eth0,bridge=$BRIDGE,ip=$TEMPLATE_IP/24,gw=$GATEWAY \
    --rootfs $STORAGE-zfs:8 \
    --memory $RAM_SIZE \
    --cores 2 \
    --password $PASSWORD \
    --unprivileged 1 \
    --onboot 1 \
    --start 1

# Step 3 - Customizing the container
pct exec $TEMPLATE_ID -- bash -c "
    apt update && apt upgrade -y &&
    apt install -y docker.io docker-compose curl &&
    curl -fsSL https://tailscale.com/install.sh | sh &&
    tailscale up --ssh &&
    rm /etc/ssh/ssh_host_* &&
    history -c"

# Step 5 - Enable SSH password authentication
pct exec $TEMPLATE_ID -- bash -c "
    sed -i 's/^#\?PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
    sed -i 's/^#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
    systemctl restart ssh"

# Step 6: Shutting down the container and convert it to a template
echo "Shutting down the container and converting it to a template..."
pct stop $TEMPLATE_ID --timeout 60
while ptc status $TEMPLATE_ID | grep -q "running"; do sleep 2; done
pct template $TEMPLATE_ID
echo "LXC container template created successfully with ID $TEMPLATE_ID and IP address $IP_ADDRESS."

