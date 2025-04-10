# Home Assistant OS on a VM

<div align="center">
<img width=100px src="../media/home-assistant-logo.svg">
</div>

In this guide we will setup Home Assistant OS on a Virtual Machine on ProxMox.

## Download and unpack Home Assistant OS

* Navigate to the [installation page on the HA website](https://www.home-assistant.io/installation/alternative)

* Simply right-click the `KVM/Proxmox` link and copy the address

* Open a SSH remote connection to your ProxMox server with Visual Code.

* Enter the following command line to download:

    ```bash
    wget <copied address>
    ```
* Enter the following command line to unpack:

    ```bash
    unxz </path/to/file.qcow2.xz> # for example haos_ova-15.1.qcow2.xz
    ```

## Create the VM

General:
* Select your VM name and ID
* Select 'start at boot'

OS:
* Select 'Do not use any media'

System:
* Change 'machine' to 'q35'
* Change BIOS to OVMF (UEFI)
* Select the EFI storage (typically local-lvm)
* Uncheck 'Pre-Enroll keys'

Disks:
* Delete the SCSI drive and any other disks

CPU:
* Set minimum 2 cores

Memory:
* Set minimum 4096 MB

Network:
* Leave default unless you have special requirements (static, VLAN, etc)

Confirm and finish. **Do not start the VM yet.**

## Add the OS image to the VM

* Enter the following command line to import the OS image from the host to the VM

    ```bash
    qm importdisk <VM ID> </path/to/file.qcow2> <EFI location>
    # for example qm importdisk 107 haos_ova-15.1.qcow2 local-zfs
    ```

* In your ProxMox dashboard select the HA VM

* Go to the 'Hardware' tab

* Select the 'Unused Disk' and click the 'Edit' button

* Check the 'Discard' box if you're using an SSD then click 'Add'

* Select the 'Options' tab

* Select 'Boot Order' and hit 'Edit'

* Check the newly created drive (likely scsi0) and uncheck everything else

## Set a static ip-adress

<!-- TODO: Test this static ip stuff out -->

* Go to the 'Cloud-Init' tab and under 'IP Config' change the default DHCP setting (ip=dhcp) to something like:

    ```ini
    ip=192.168.1.105/24,gw=192.168.1.1
    ```

* click 'Regenerate Image' <!-- what is this ?? -->

## Finish Up

* Start the VM

* Check the shell of the VM. If it booted up correctly, you should be greeted with the link to access the Web UI.

* Navigate to <VM IP>:8123

Done. Home Assistant should be up and running now.