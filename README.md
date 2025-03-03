# Setup student VM's

## Create the VM template

At the start of a new academic year you update the script `setup_debian_vm_template.sh` in this repository with the new installation information for Debian, Docker Compose and Tailscale.

Then run the script from the ProxMox Terminal:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/setup_debian_vm_template.sh)
```

## Create the csv-file with student credentials

Create the csv-file `vms.csv` containing the student credentials vmid, name, user, password, ip 

```csv
vmid,naam,user,password,ip
101,vm-student1,student1,passw0rd1,192.168.1.101
102,vm-student2,student2,passw0rd2,192.168.1.102
103,vm-student3,student3,passw0rd3,192.168.1.103
```

💡Je kan dit bestand best aanmaken in Excel en dan opslaan als .csv. In ProxMox creër je het bestand via `nano /root/vms.csv` en kopier je de inhoud via **CRTL+X**, **Y**, en **ENTER**.

## Clone the template for all student VM's

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/deploy_vms.sh)
```
