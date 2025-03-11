# Settings
TEMPLATE_ID=9000  # ID voor de Cloud-Init-template
TEMPLATE_NAME="debian-cloudinit"
STORAGE="local-zfs"
BRIDGE="vmbr0"
DEBIAN_IMAGE="debian-12-genericcloud-amd64.qcow2"
DEBIAN_URL="https://cloud.debian.org/images/cloud/bookworm/latest/$DEBIAN_IMAGE"
DISK_RESIZE="+13G"
RAM_SIZE="2048"
CPU_CORES="2"
TEMPLATE_IP="192.168.1.120"
GATEWAY="192.168.1.1"

# Step 1: Download the Debian Cloud-Init-image
echo "Downloading Debian Cloud-Init image..."
wget -q --show-progress -O $DEBIAN_IMAGE $DEBIAN_URL

# Step 2: Create a new VM
echo "Creating Proxmox VM template ($TEMPLATE_ID)..."
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory $RAM_SIZE --cores $CPU_CORES --net0 virtio,bridge=$BRIDGE --cpu cputype=x86-64-v2-AES

# Step 3: Import and configure the image
echo "Importing disk image..."
qm importdisk $TEMPLATE_ID $DEBIAN_IMAGE $STORAGE
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$TEMPLATE_ID-disk-0
qm resize $TEMPLATE_ID scsi0 $DISK_RESIZE
qm set $TEMPLATE_ID --ostype l26
qm set $TEMPLATE_ID --serial0 socket

# Step 4: Enable Cloud-Init
echo "Configuring Cloud-Init..."
qm set $TEMPLATE_ID --ide2 $STORAGE:cloudinit
qm set $TEMPLATE_ID --onboot 1
qm set $TEMPLATE_ID --boot c --bootdisk scsi0
qm set $TEMPLATE_ID --ciuser student --cipassword student --sshkey /root/.ssh/id_rsa.pub
qm set $TEMPLATE_ID --ipconfig0 ip=$TEMPLATE_IP/24,gw=$GATEWAY

# Step 5: Enable QEMU Guest Agent
qm set $TEMPLATE_ID --agent enabled=1

# Step 6: Start the VM to install the OS
echo "Starting VM for software installation..."
qm start $TEMPLATE_ID
echo "Press Enter when the OS installation is ready..."
read

# Step 7: Install Docker, Docker Compose and Tailscale via QEMU agent

#CLOUD_INIT_NAME="install-packages.yaml"
#CLOUD_INIT_URL="https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/cloud-init/$CLOUD_INIT_NAME"

#echo "Installing software inside the VM..."
#qm guest exec $TEMPLATE_ID -- bash -c "apt update && apt upgrade -y"
#qm guest exec $TEMPLATE_ID -- bash -c "apt install -y docker.io docker-compose"
#qm guest exec $TEMPLATE_ID -- bash -c "usermod -aG docker student"
#qm guest exec $TEMPLATE_ID -- bash -c "curl -fsSL https://tailscale.com/install.sh | sh"
#qm guest exec $TEMPLATE_ID -- bash -c "systemctl enable --now tailscaled"

# Step 7: Install Docker, Docker Compose and Tailscale via Cloud-init
#echo "Downloading Cloud-Init configuration..."
#wget -q -O /var/lib/vz/snippets/$CLOUD_INIT_NAME $CLOUD_INIT_URL
#qm set 9000 --cicustom "user=local:snippets/$CLOUD_INIT_NAME"
#qm cloudinit update $TEMPLATE_ID
#qm shutdown $TEMPLATE_ID
#while qm status $TEMPLATE_ID | grep -q "running"; do sleep 2; done
#qm start $TEMPLATE_ID
#while qm status $TEMPLATE_ID | grep -q "running"; done ; do sleep 2

# Step 7: Install Docker, Docker Compose and Tailscale via ssh
ssh-keygen -f "/root/.ssh/known_hosts" -R $TEMPLATE_IP
ssh student@$TEMPLATE_IP "sudo apt update && sudo apt install -y qemu-guest-agent && sudo systemctl enable --now qemu-guest-agent"
ssh student@$TEMPLATE_IP "sudo apt install -y docker.io docker-compose"
ssh student@$TEMPLATE_IP "sudo usermod -aG docker student"
ssh student@$TEMPLATE_IP "sudo curl -fsSL https://tailscale.com/install.sh | sh"
ssh student@$TEMPLATE_IP "sudo systemctl enable --now tailscaled"

# Step 8: Cleaning up
rm $DEBIAN_IMAGE

# Step 9: Shutdown the VM and convert it to a template
echo "Shutting down VM and converting to template..."
qm shutdown $TEMPLATE_ID --timeout 60
while qm status $TEMPLATE_ID | grep -q "running"; do sleep 2; done
qm template $TEMPLATE_ID

echo "Debian template ($TEMPLATE_NAME) is ready with QEMU Guest Agent, Docker, en Tailscale pre-installed!"




