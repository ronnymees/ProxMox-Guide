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
ROOTPASS="rootadmin"

# Step 1 - download debian to local
pveam download local $DEBIAN_TEMPLATE

# Step 2 - Create a container
echo "Creating Proxmox CT template ($TEMPLATE_ID)..."
pct create $TEMPLATE_ID $STORAGE:$DEBIAN_TEMPLATE  --storage $STORAGE --password="$ROOTPASS" --start 1
pct set --rootfs localblock:8 --unprivileged 1
ptc set --ostype debian --memory $RAM_SIZE --hostname $TEMPLATE_NAME
ptc set --net0 name=eth0,bridge=$BRIDGE,firewall=1,gw=$GATEWAY,ip=$TEMPLATE_IP/24,tag=10,type=veth

# Step 3: Start the CT to install the OS
echo "Starting CT for software installation..."
ptc start $TEMPLATE_ID
echo "In the ProxMox dashboard go to the console of the newly made CT "$TEMPLATE_ID
echo "Press Enter when the OS installation is ready and you see the login prompt..."
read

# Step 4: Install Docker, Docker Compose and Tailscale via ssh
ssh-keygen -f "/root/.ssh/known_hosts" -R $TEMPLATE_IP
yes | ssh student@$TEMPLATE_IP "sudo apt update && sudo apt install -y qemu-guest-agent && sudo systemctl enable --now qemu-guest-agent"
yes | ssh student@$TEMPLATE_IP "sudo apt install -y docker.io docker-compose"
yes | ssh student@$TEMPLATE_IP "sudo usermod -aG docker student"
yes | ssh student@$TEMPLATE_IP "sudo curl -fsSL https://tailscale.com/install.sh | sh"
yes | ssh student@$TEMPLATE_IP "sudo systemctl enable --now tailscaled"

# Step 5 - Change file for username/password identification
ssh student@$TEMPLATE_IP 'sudo bash -c "echo 'PasswordAuthentication yes' >> /etc/ssh/ssh_config"'


# Step 6: Shutdown the CT and convert it to a template
echo "Shutting down CT and converting to template..."
ptc shutdown $TEMPLATE_ID --timeout 60
while ptc status $TEMPLATE_ID | grep -q "running"; do sleep 2; done
ptc template $TEMPLATE_ID
echo "Debian CT template ($TEMPLATE_NAME) is ready with QEMU Guest Agent, Docker, en Tailscale pre-installed!"