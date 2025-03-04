#!/bin/bash

# Instellingen
TEMPLATE_ID=9000  # ID van de Debian Cloud-Init-template
STORAGE="local-lvm"
BRIDGE="vmbr0"
CSV_FILE="/root/vms.csv"

# CSV inlezen en verwerken
while IFS=, read -r vmid naam user password ip
do
    # Sla de header over
    if [[ "$vmid" == "vmid" ]]; then
        continue
    fi

    echo "Cloning VM $TEMPLATE_ID to $vmid ($name)..."

    # Clone de VM vanuit de template
    qm clone $TEMPLATE_ID $vmid --name $name --full --storage $STORAGE

    # Cloud-Init instellingen toepassen
    qm set $vmid --net0 virtio,bridge=$BRIDGE
    qm set $vmid --ipconfig0 ip=$ip/24,gw=192.168.1.1
    qm set $vmid --ciuser $user
    qm set $vmid --cipassword $password
    qm set $vmid --sshkey /root/.ssh/id_rsa.pub

    # Start de VM
    qm start $vmid

    echo "VM $name ($vmid) is aangemaakt en gestart."

done < "$CSV_FILE"

# Verwijder het CSV-bestand na gebruik
rm -f $CSV_FILE

echo "Alle VM's zijn succesvol aangemaakt! 🚀"
