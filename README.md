# Setup student VM's or CT's

## Virtual Machines

### Create the VM template

At the start of a new academic year you update the script `setup_debian_vm_template.sh` in this repository with the new installation information for Debian, Docker Compose and Tailscale.

Then run the script from the ProxMox Terminal:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/setup_debian_vm_template.sh)
```
💡 This script will pause for the installation of the OS, you should watch it in the console on ProxMox and wait for it to finish before hitting enter on the script to resume.

### Create the csv-file with student credentials

Create the csv-file `vms.csv` containing the student credentials vmid, name, user, password, ip 

```csv
vmid,name,user,password,ip
111,vmstudent1,student1,passw0rd1,192.168.1.111
112,vmstudent2,student2,passw0rd2,192.168.1.112
113,vmstudent3,student3,passw0rd3,192.168.1.113
```

💡It is best to create this file in Excel and save it as .csv. In ProxMox create the file via `nano /root/vms.csv` and copy the contents via **CRTL+C** / **CTRL+V**. Save and close with **CTRL+O** and **CTRL+X**.

### Clone the template for all student VM's

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/deploy_vms.sh)
```

## Containers

### Create the CT template

At te start of the new academic year update the script `setup_debian_ct_template.sh` in this repository with the new installation information.

Then run the script from the ProxMox Terminal:

```bash
bash <(wget -qO- ??)
```
💡 This script will pause for the installation of the OS, you should watch it in the console on ProxMox and wait for it to finish before hitting enter on the script to resume.

### Create the csv-file with student credentials

Create the csv-file `cts.csv` containing the student credentials ctid, name, user, password, ip 

```csv
ctid,name,user,password,ip
121,ctstudent1,student1,passw0rd1,192.168.1.121
122,ctstudent2,student2,passw0rd2,192.168.1.122
123,ctstudent3,student3,passw0rd3,192.168.1.123
```

💡It is best to create this file in Excel and save it as .csv. In ProxMox create the file via `nano /root/cts.csv` and copy the contents via **CRTL+C** / **CTRL+V**. Save and close with **CTRL+O** and **CTRL+X**.

### Clone the template for all student CT's

```bash
bash <(wget -qO- ??)
```
