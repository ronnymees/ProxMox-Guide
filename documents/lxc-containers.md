# Create LXC containers for students

In this guide we will create a template for the LXC Containers that students can use for there lessons and projects. Then we use that template to create the actual LXC Containers for the students using a CSV file. 

For this scripts have been written. 

## Create the LXC Container template

❗At te start of the new academic year update the script `setup_debian_ct_template.sh` in this repository with the new installation information.

Then run the script from the ProxMox Terminal:

<!-- TODO: Test for private repo -->
<!-- 
use this commandline : 
bash <(wget -qO- --header 'Authorization: token PERSONAL_ACCESS_TOKEN_HERE' https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/setup_debian_ct_template.sh)
The token you can get from the GitHub Repo
-->

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/setup_debian_ct_template.sh)
```
💡 This script will pause for the installation of the OS, you should watch it in the console on ProxMox and wait for it to finish before hitting enter on the script to resume.

## Create the csv-file with student credentials

Create the csv-file `cts.csv` containing the student credentials ctid, name, user, password, ip 

* ctid = id of the LXC Container
* name = name of the LXC Container
* user = name of the student (no spaces)
* password = 8 char password
* ip = static ip adress for the LXC Container

```csv
ctid,name,user,password,ip
121,ctstudent1,student1,passw0rd1,192.168.1.121
122,ctstudent2,student2,passw0rd2,192.168.1.122
123,ctstudent3,student3,passw0rd3,192.168.1.123
```

💡It is best to create this file in Excel and save it as .csv. In ProxMox create the file via `nano /root/cts.csv` and copy the contents via **CRTL+C** / **CTRL+V**. Save and close with **CTRL+O** and **CTRL+X**.

💡In Excel you can auto generate the 8-character password with this formula:

```excel
=CHAR(RANDBETWEEN(65,90))&RANDBETWEEN(0,9)&CHAR(RANDBETWEEN(97,122))&CHAR(RANDBETWEEN(97,122))&CHAR(RANDBETWEEN(65,90))&RANDBETWEEN(0,9)&CHAR(RANDBETWEEN(65,90))&RANDBETWEEN(0,9)
```

## Clone the template for all student LXC Containers

```bash
bash <(wget -qO- https://raw.githubusercontent.com/ronnymees/ProxMox-student-vms/refs/heads/master/scripts/deploy_cts.sh)
```

Done. You should have all the LXC-Containers up and running for each student.