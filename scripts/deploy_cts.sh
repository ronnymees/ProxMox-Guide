# Settings
TEMPLATE_ID=9100
STORAGE="local"
BRIDGE="vmbr0"
CSV_FILE="/root/cts.csv"
GATEWAY="192.168.1.1"

# Step 1 - Import and process CSV
while IFS=, read -r ctid name user password ip
do
    # Skip the header
    if [[ "$ctid" == "ctid" ]]; then
        continue
    fi

    echo "Cloning CT $TEMPLATE_ID to $ctid ($name)..."

    # Clone the CT from the template
    ptc clone $TEMPLATE_ID $ctid --hostname $name --full --storage $STORAGE

    # Apply settings
    ptc set --net0 name=eth0,bridge=$BRIDGE,firewall=1,gw=$GATEWAY,ip=$ip/24,tag=10,type=veth
    
    # Start the CT    
    ptc start $ctid
    while ptc status $ctid | grep -q "running"; done ; do sleep 2
    ssh root@$ip "useradd -m -p $(openssl passwd -1 ${PASSWORD}) -s /bin/bash -G sudo ${USERNAME}"
    echo "CT $name ($ctid) has been created and started."

done < "$CSV_FILE"

# Step 2 - Delete the CSV file after use
rm -f $CSV_FILE

echo "All CTs have been created and started successfully!"
