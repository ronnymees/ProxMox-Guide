#!/bin/bash

# Instellingen
TEMPLATE_ID=9000  # ID voor de Cloud-Init-template
TEMPLATE_NAME="debian-cloudinit"
STORAGE="local-lvm"
BRIDGE="vmbr0"
DEBIAN_IMAGE="debian-12-genericcloud-amd64.qcow2"
DEBIAN_URL="https://cloud.debian.org/images/cloud/bookworm/latest/$DEBIAN_IMAGE"
DISK_SIZE="16G"
RAM_SIZE="2048"
CPU_CORES="2"

# Stap 1: Download de Debian Cloud-Init-image
echo "Downloading Debian Cloud-Init image..."
wget -q --show-progress -O $DEBIAN_IMAGE $DEBIAN_URL

# Stap 2: Nieuwe VM aanmaken
echo "Creating Proxmox VM template ($TEMPLATE_ID)..."
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory $RAM_SIZE --core $CPU_CORES --net0 virtio,bridge=$BRIDGE

# Stap 3: Image importeren en instellen
echo "Importing disk image..."
qm importdisk $TEMPLATE_ID $DEBIAN_IMAGE $STORAGE
# qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$TEMPLATE_ID-disk-0
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:$DISK_SIZE

# Stap 4: Cloud-Init inschakelen
echo "Configuring Cloud-Init..."
qm set $TEMPLATE_ID --ide2 $STORAGE:cloudinit
qm set $TEMPLATE_ID --onboot 1
qm set $TEMPLATE_ID --boot c --bootdisk scsi0
qm set $TEMPLATE_ID --serial0 socket --vga serial0
qm set $TEMPLATE_ID --ciuser student --sshkey /root/.ssh/id_rsa.pub
qm set $TEMPLATE_ID --ipconfig0 ip=dhcp

# Stap 5: Schakel QEMU Guest Agent in
qm set $TEMPLATE_ID --agent enabled=1

# Stap 6: Start de VM om software te installeren
echo "Starting VM for software installation..."
qm start $TEMPLATE_ID
echo "Press Enter when the OS installation is ready..."
read

# Stap 7: Installeer Docker, Docker Compose en Tailscale via SSH
echo "Installing software inside the VM..."
# qm terminal $TEMPLATE_ID << 'EOF'
# sudo -i <<EOSU
# apt update && apt upgrade -y
# apt install -y docker.io docker-compose
# usermod -aG docker student
# curl -fsSL https://tailscale.com/install.sh | sh
# systemctl enable --now tailscaled
# EOSU
# EOF
qm exec $TEMPLATE_ID -- bash -c "apt update && apt upgrade -y"
qm exec $TEMPLATE_ID -- bash -c "apt install -y docker.io docker-compose"
qm exec $TEMPLATE_ID -- bash -c "usermod -aG docker student"
qm exec $TEMPLATE_ID -- bash -c "curl -fsSL https://tailscale.com/install.sh | sh"
qm exec $TEMPLATE_ID -- bash -c "systemctl enable --now tailscaled"


# Stap 8: Zet de VM uit en maak een template
echo "Shutting down VM and converting to template..."
qm shutdown $TEMPLATE_ID --timeout 60
sleep 5
qm template $TEMPLATE_ID

echo "Debian Cloud-Init template is klaar! 🚀"




