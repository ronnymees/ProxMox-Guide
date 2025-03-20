# Settings
TEMPLATE_ID=9100
STORAGE="local-zfs"
BRIDGE="vmbr0"
CSV_FILE="/root/vms.csv"
GATEWAY="192.168.1.1"

# Step 1 - Import and process CSV
while IFS=, read -r ctid name user password ip
do
    # Skip the header
    if [[ "$ctid" == "ctid" ]]; then
        continue
    fi

    echo "Cloning container $TEMPLATE_ID to $ctid ($name)..."

    # Clone the LXC container from the template
    pct clone $TEMPLATE_ID $ctid --hostname $name --storage $STORAGE

    # Set container configurations
    pct set $ctid --net0 name=eth0,bridge=$BRIDGE,ip=$ip/24,gw=$GATEWAY
    pct set $ctid --unprivileged 1
    pct set $ctid --onboot 1
    pct set $ctid --start 1

    # Start the container
    pct start $ctid
    echo "Container $name ($ctid) has been created and started."

    # Configure the user inside the container
    pct exec $ctid -- bash -c "
        apt update && apt install -y openssh-server &&
        useradd -m -s /bin/bash $user &&
        echo '$user:$password' | chpasswd &&
        echo '$user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers &&
        sed -i 's/^#\?PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
        sed -i 's/^#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
        systemctl enable ssh &&
        systemctl restart ssh"

    echo "User $user has been created inside container $name ($ctid) with SSH access."

done < "$CSV_FILE"

# Step 2 - Delete the CSV file after use
rm -f "$CSV_FILE"

echo "All containers have been created and configured successfully!"

