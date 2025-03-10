#!/bin/bash

# Instellingen
TEMPLATE_ID=9000  # ID voor de Cloud-Init-template
TEMPLATE_NAME="debian-cloudinit"
STORAGE="local-lvm"
BRIDGE="vmbr0"
DEBIAN_IMAGE="debian-12-genericcloud-amd64.qcow2"
DEBIAN_URL="https://cloud.debian.org/images/cloud/bookworm/latest/$DEBIAN_IMAGE"
DISK_RESIZE="+13G"
RAM_SIZE="2048"
CPU_CORES="2"
CLOUD_INIT_NAME="snippets/install-packages.yaml"
CLOUD_INIT_URL="https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/cloud-init/install-packages.yaml"

# Stap 1: Download de Debian Cloud-Init-image
echo "Downloading Debian Cloud-Init image..."
wget -q --show-progress -O $DEBIAN_IMAGE $DEBIAN_URL

# Stap 2: Nieuwe VM aanmaken
echo "Creating Proxmox VM template ($TEMPLATE_ID)..."
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory $RAM_SIZE --cores $CPU_CORES --net0 virtio,bridge=$BRIDGE

# Stap 3: Image importeren en instellen
echo "Importing disk image..."
qm importdisk $TEMPLATE_ID $DEBIAN_IMAGE $STORAGE
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$TEMPLATE_ID-disk-0
qm resize $TEMPLATE_ID scsi0 $DISK_RESIZE
qm set $TEMPLATE_ID --ostype l26

# Stap 4: Cloud-Init inschakelen
echo "Configuring Cloud-Init..."
qm set $TEMPLATE_ID --ide2 $STORAGE:cloudinit
qm set $TEMPLATE_ID --onboot 1
qm set $TEMPLATE_ID --boot c --bootdisk scsi0
qm set $TEMPLATE_ID --ciuser student --cipassword student --sshkey /root/.ssh/id_rsa.pub
qm set $TEMPLATE_ID --ipconfig0 ip=dhcp

# Stap 5: Schakel QEMU Guest Agent in
qm set $TEMPLATE_ID --agent enabled=1

# Stap 6: Start de VM om software te installeren
echo "Starting VM for software installation..."
qm start $TEMPLATE_ID
echo "Press Enter when the OS installation is ready..."
read

# Stap 7: Installeer Docker, Docker Compose en Tailscale via QEMU agent
#echo "Installing software inside the VM..."
#qm guest exec $TEMPLATE_ID -- bash -c "apt update && apt upgrade -y"
#qm guest exec $TEMPLATE_ID -- bash -c "apt install -y docker.io docker-compose"
#qm guest exec $TEMPLATE_ID -- bash -c "usermod -aG docker student"
#qm guest exec $TEMPLATE_ID -- bash -c "curl -fsSL https://tailscale.com/install.sh | sh"
#qm guest exec $TEMPLATE_ID -- bash -c "systemctl enable --now tailscaled"

# Stap 7: Installeer Docker, Docker Compose en Tailscale via Cloud-init
echo "Downloading Cloud-Init configuration..."
wget -qO- /var/lib/vz/$CLOUD_INIT_NAME $CLOUD_INIT_URL
qm set 100 --cicustom "user=local:$CLOUD_INIT_NAME"
qm cloudinit update $TEMPLATE_ID
qm shutdown $TEMPLATE_ID
while qm status $TEMPLATE_ID | grep -q "running"; do sleep 2; done
qm start $TEMPLATE_ID

# Stap 8: opschonen
rm $DEBIAN_IMAGE

# Stap 9: Zet de VM uit en maak een template
echo "Shutting down VM and converting to template..."
qm shutdown $TEMPLATE_ID --timeout 60
while qm status $TEMPLATE_ID | grep -q "running"; do sleep 2; done
qm template $TEMPLATE_ID

echo "Debian template ($TEMPLATE_NAME) is klaar met QEMU Guest Agent, Docker, en Tailscale!"




