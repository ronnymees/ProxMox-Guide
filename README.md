# Guide for the Educational ProxMox cluster

For educational purposes we have some servers in our serverroom that are setup as a ProxMox cluster.

We use this to:
* give our students a practical feeling with how things are done in production
* provide each student with a LXC Container for there lessons (programming, webdevelopment, AI, projects, ...)
* provide a MQTT broker for communication
* host finished student projects we want to keep active

## Hardware

<!-- TODO: here we place the actual hardware we are using -->

## ProxMox Cluster

<!-- TODO: Guide for the setup of our ProxMox cluster -->

## Network agreements

* General Services: xxx.xxx.xxx.1-24
* Templates: xxx.xxx.xxx.25-49
* Long term projects: xxx.xxx.xxx.50-99
* Student VM's or LXC's: xxx.xxx.xxx.100-224
* Development services: xxx.xxx.xxx.225-255

## Setup the MQTT Broker

To create a MQTT Broker LXC container, you can follow this [guide](/documents/mqtt-broker-lxc.md)

## Create a Virtual Machine for each student

If you want each student to have a VM, you can follow this [guide](/documents/virtual-machines.md).

❗This is not recommended because it uses much more resources of our server.

## Create a LXC-Container for each student

If you want each student to have a LXC Container, you can follow this [guide](/documents/lxc-containers.md).

✔️ This is the recommended way to give each student there own virtual workplace.

## Setup a Home Assistant VM

If you want to setup a VM with Home Assistant, you can follow this [guide](/documents/home-assistant-vm.md).

## Setup the dashboards

If you want to setup a LXC Container with Grafana Dashboards, you can follow this [guide](/documents/dashboards.md).


