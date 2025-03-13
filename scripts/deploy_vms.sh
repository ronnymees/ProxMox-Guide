# Settings
TEMPLATE_ID=9000
STORAGE="local-zfs"
BRIDGE="vmbr0"
CSV_FILE="/root/vms.csv"
GATEWAY="192.168.1.1"

# Step 1 - Import and process CSV
while IFS=, read -r vmid name user password ip
do
    # Skip the header
    if [[ "$vmid" == "vmid" ]]; then
        continue
    fi

    echo "Cloning VM $TEMPLATE_ID to $vmid ($name)..."

    # Clone the VM from the template
    qm clone $TEMPLATE_ID $vmid --name $name --full --storage $STORAGE

    # Apply Cloud-Init settings
    qm set $vmid --net0 virtio,bridge=$BRIDGE
    qm set $vmid --ipconfig0 ip=$ip/24,gw=$GATEWAY
    qm set $vmid --ciuser $user
    qm set $vmid --cipassword $password    

    # Start the VM
    qm start $vmid

    echo "VM $name ($vmid) has been created and started."

done < "$CSV_FILE"

# Step 2 - Delete the CSV file after use
rm -f $CSV_FILE

echo "All VMs have been created and started successfully!"
