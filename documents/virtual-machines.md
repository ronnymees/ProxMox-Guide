# Create Virtual Machines for students

In this guide we will create a template for the Virtual Machines that students can use for there lessons and projects. Then we use that template to create the actual Virtual Machines for the students using a CSV file. 

For this scripts have been written. 

## Create the Virtual Machine template

❗At the start of a new academic year you update the script `setup_debian_vm_template.sh` in this repository with the new installation information for Debian, Docker Compose and Tailscale.

Then run the script from the ProxMox Terminal:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/setup_debian_vm_template.sh)
```
💡 This script will pause for the installation of the OS, you should watch it in the console on ProxMox and wait for it to finish before hitting enter on the script to resume.

## Create the csv-file with student credentials

Create the csv-file `vms.csv` containing the student credentials vmid, name, user, password, ip 

* vmid = id of the Virtual Machine
* name = name of the Virtual Machine
* user = name of the student (no spaces)
* password = 8 char password
* ip = static ip adress for the Virtual Machine

```csv
vmid,name,user,password,ip
111,vmstudent1,student1,passw0rd1,192.168.1.111
112,vmstudent2,student2,passw0rd2,192.168.1.112
113,vmstudent3,student3,passw0rd3,192.168.1.113
```

💡It is best to create this file in Excel and save it as .csv. In ProxMox create the file via `nano /root/vms.csv` and copy the contents via **CRTL+C** / **CTRL+V**. Save and close with **CTRL+O** and **CTRL+X**.

💡In Excel you can auto generate the 8-character password with this formula:

```excel
=CHAR(RANDBETWEEN(65,90))&RANDBETWEEN(0,9)&CHAR(RANDBETWEEN(97,122))&CHAR(RANDBETWEEN(97,122))&CHAR(RANDBETWEEN(65,90))&RANDBETWEEN(0,9)&CHAR(RANDBETWEEN(65,90))&RANDBETWEEN(0,9)
```

## Clone the template for all student Virtual Machines

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/deploy_vms.sh)
```

Done. You should have all the Virtual Machines up and running for each student.