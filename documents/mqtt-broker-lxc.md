# Setup a MQTT Broker

<div align="center">
<img width=100px src="../media/mosquitto-logo.png">
</div>

<!-- TODO: This must still be tested completly, and make the IP adress static -->

## Create the LXC Container

To create a LXC Container with MQTT Broker Mosquitto, we will be using a script from the  [Proxmox VE Helper Community](https://community-scripts.github.io/ProxmoxVE/).

Just run the following command line in the ProxMox terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/mqtt.sh)"
```

Your Mosquitto broker should be up and running now.

## Configuration after installation

Go to the terminal of the MQTT Broker. To create a user and password we enter the following command line:

```bash
mosquitto_passwd -c /etc/mosquitto/passwd <username>
# change the username to the one you want
# you will be asked a password
```

To verify that Mosquitto has acces to the password file you just created you can enter this command line:

```bash
chown mosquitto:mosquitto /etc/mosquitto/passwd
```

If all is good, we just need to restart Mosquitto to implement the changes:

```bash
systemctl restart mosquitto
```

You can check if all is functioning properly with `mqtt explorer` using the ip adress of the broker and the user/password combination.

