# Guide for the Educational ProxMox cluster

For educational purposes we have some servers in our serverroom that are setup as a ProxMox cluster.

We use this to:
* give our students a practical feeling with how things are done in production
* provide each student with a LXC Container for there lessons (programming, webdevelopment, AI, projects, ...)
* provide a MQTT broker for communication
* host finished student projects we want to keep active

## Hardware

For the ProxMox cluster we are using 3 HP ProLiant DL380 G10 8x SFF servers:
* 1x HP 8x bays 2,5" SFF SAS/SATA G9/G10 SFF
* 2x Intel Xeon Gold 6154 18x Core 3.0 GHz
* 12x HP 64GB DDR4 2400 MHz 19200P ECC gen.
* 1x HP Smart Array S100i software raid
* 1x HP Ethernet 1GB 4-port (intern) + IL04 Basic
* 1x Dell Intel XXV710-DA2 2x 10/25GBs SFP28 Converged Network Adapter Ref
* 1x HP ILO Advanced
* 4x HPE 1.6 TB SAS SSD 12G SFF P04174-003
* 2x Intel D3 S4510 480GB TLC SATA 6G M.2
* 8x HP Caddy Tray G8/G9/G10 2.5" SFF
* 1x HP Rack Rails Sliding ProLiant DL380 G9/G10
* 2x HP Proliant G9/G10 800W PSU - 723600-201, 754381-001

For the Backup we are using 1 HP Proliant DL380 G10 8x SFF server:
* 1x HP 8x bays 2,5" SFF SAS/SATA G9/G10 SFF
* 2x Intel Xeon Gold 5118 12x Core 2.3 GHz
* 4x HP 32GB DDR4 2400 MHz 19200P ECC gen.
* 1x HP Smart Array S100i software raid
* 1x HP Ethernet 1GB 4-port (intern) + IL04 Basic
* 1x Dell Intel X520-DA2 Dual Port 10GB SFP+ PCI-e 8x Adapter
* 1x HP ILO Advanced
* 6x HGST S3300 7.68TB SAS SSD 12Gbps SFF
* 2x Intel D3 S4510 480GB TLC SATA 6G M.2
* 8x HP Caddy Tray G8/G9/G10 2.5" SFF
* 1x HP Rack Rails Sliding ProLiant DL380 G9/G10
* 2x HP Proliant G9/G10 800W PSU - 723600-201, 754381-001

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


