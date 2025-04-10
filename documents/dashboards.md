# Grafana dashboards on a LXC Container

<div align="center">
<img width=100px src="../media/grafana-logo.png">
<img width=100px src="../media/influxdb-logo.svg">
<img width=100px src="../media/docker-logo.png">
</div>

<!-- TODO: This guide needs to be tested and debugged -->

In this guide we will setup Grafana dashboards for the ProxMox cluster and Unify network.

## Creating a LXC Container

To create the LXC Container we use the template we use the same script as for creating the LXC Containers for students.
Just follow the guide to create the student LXC Containers, for the csv-file, you can enter one line for the container:

```csv
ctid,name,user,password,ip
24,dashboard,root,passw0rd1,192.168.1.24
```

## Deploy the services in a docker container

Now we will deploy Grafana, InfluxDB and Unpoller in a docker container on the LXC Container we just created.

In Visual Code setup a remote connection to the LXC Container, open the folder and Create a folder `dashboard` then add these files:
* [docker compose file](/docker/docker-compose.yml)
* [.env](/docker/.env)

Now start the services with this command line:

```bash
sudo docker-compose up -d
```

❗The Unpoller service will not be running correctly at the moment, we still have some configuration to do for this.

## Setup InfluxDB

* Now go to the InfluxDB dashboard `ip-adress:8086` and create a user `root` with password `rootadmin` and organisation `Vives`.
* Next create a bucket `proxmox` to store the proxmox data.
* Next create a bucket `unifi` to store the unifi data.
* Next create a API token with superuser privileges, store it in case you need it.
* Next create a API token with read acces to all buckets, store it for future use.
* Next create a API token with write privileges on the bucket `unifi` and store it for future use.

## Grafana Setup

* Now go to the Grafana dashboard `ip-adress:3000` and login with the default user `admin` and password `admin`.
* Next change the password to `VivesAdmin`.
* Under Data Sources add InfluxDB, give it the name `InfluxDB2` with the query language `Flux`. Enter the URL `http://ip-adress:8086` of InfluxDB use `Basic auth` add the name of your organisation `Vives` and paste the API token you last made in InfluxBD.

## ProxMox Setup

* First go back to your InfluxBD dashboard and create a new API token with write privileges on the bucket `proxmox` and save it for future use.
* Next login to the proxmox dashboard, go to Datacenter => Metric Server and add `InfluxDB` with the name `InfluxDB2`, the ip adress of your InfluxDB with port 8086, organisation `Vives` and bucket `proxmox`, fill in the previously created API token.
* To test if data is added to the bucket, go to the InfluxDB dasboard, under Data Explorer start creating a new script for bucket `proxmox`, if you are able to select measurements then all is good.

## Unifi Setup

In the Unifi OS create a new user `unpoller25` with password `VivesPoller-25` by using the email `elektronicaictbrugge@gmail.com`.

## Unpoller Setup

Now add the missing info in the `.env file` and restart the docker containers with the following command line:

```dash
sudo docker-compose up -d
```

## Dashboard Setup

We have 3 dashboards:
* Main dashboard
* LXC Container dashboard
* Unifi Dashboard

### The main dashboard

* Under dashboards click on New and choose Import and select the [Proxmox Main Dashboard.json](/dashboards/Proxmox%20Main%20Dashboard-1743495280055.json) file. 
* Under the Settings => Variables you can change the names of the cluster and servers.

### The LXC Container dashboard

* Under dashboards click on New and choose Import and select the [Proxmox Container Dashboard.json](/dashboards/Proxmox%20Container%20Dashboard-1743688482998.json) file.
* Under the Settings => Variables you can change the names of the cluster and servers.

### The Unifi dashboard

<!-- TODO: this still needs to be created -->