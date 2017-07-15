Christ the King File + Print Server
===================================


Installation
------------

Start with Ubuntu 16.04 amd64 ISO. Install basic config, leaving a 200GB windows partition on the drive. Setup user ctk-admin (see google doc for all passwords).

Add Users
---------

Add an `lteacher` and `lstudent` user, with their respective passwords. No need to make them admin/sudo users on here.

    sudo adduser tadmin 
    sudo adduser lteacher
    sudo adduser lstudent
    sudo addgroup admins
    sudo addgroup teachers
    sudo addgroup allusers
    sudo usermod -a -G admins ctk-admin
    sudo usermod -a -G admins tadmin
    sudo usermod -a -G teachers ctk-admin
    sudo usermod -a -G teachers tadmin
    sudo usermod -a -G teachers lteacher
    sudo usermod -a -G allusers ctk-admin
    sudo usermod -a -G allusers tadmin
    sudo usermod -a -G allusers lteacher
    sudo usermod -a -G allusers lstudent

Hard Drive
----------

Insert the 1TB Seagate HDD. Use the "Disks" utility to format it to EXT4. Give it the label "DATA".

In the terminal make a mount point for it by running `sudo mkdir /mnt/fs0`.

Modify the fstab file `sudo nano /etc/fstab`, and add the line

    LABEL=DATA    /mnt/fs0    ext4    defaults    0    0

so that it will reside in `/mnt/fs0` when booting. Try it without rebooting by running `sudo mount -a`.

Create Directory
----------------

Create a directory for the teachers to store data:

    sudo mkdir /mnt/fs0/TeacherData
    sudo chown lteacher:teachers /mnt/fs0/TeacherData
    sudo chmod 750 /mnt/fs0/TeacherData

Create a directory for the students to store data

    sudo mkdir /mnt/fs0/StudentData
    sudo chown lstudent:allusers /mnt/fs0/StudentData
    sudo chmod 750 /mnt/fs0/StudentData

Create a directory for administrators to store software

    sudo mkdir /mnt/fs0/AdminData
    sudo chown tadmin:admins /mnt/fs0/AdminData
    sudo chmod 750 /mnt/fs0/AdminData

Make a link so the teachers can see the student data within their directory

    cd /mnt/fs0/TeacherData
    sudo ln -s ../StudentData StudentData

Setup Samba File Shares
-----------------------

Install the samba service `sudo apt update` then `sudo apt install samba`.

Edit the config file `sudo nano /etc/samba/smb.conf`.

At the top of the file, under the `[global]` section, update the `workgroup = WORKGROUP` line. Immediately after that, add the following lines:

    security = user
    allow insecure wide links = yes

Add the following in the bottom section:

    [teacher]
       comment = Teachers Only
       browseable = yes
       path = /mnt/fs0/TeacherData
       guest ok = no
       read only = no
       create mask = 0770
       valid users = lteacher
       follow symlinks = yes
       wide links = yes

    [student]
       comment = Student Data
       browseable = yes
       path = /mnt/fs0/StudentData
       guest ok = yes
       read only = no
       create mask = 0770
       valid users = lteacher, lstudent
       
    [software]
       comment = Software for Admins to Install
       browseable = yes
       path = /mnt/fs0/AdminData
       guest ok = no
       read only = no
       create mask = 0770
       valid users = tadmin, ctk-admin

Save the `smb.conf` file.

Add samba specific passwords for the users and enable them

    sudo smbpasswd -a lteacher
    New SMB password:
    Retype new SMB password:
    sudo smbpasswd -a lstudent
    sudo smbpasswd -a ctk-admin
    sudo smbpasswd -a tadmin
    sudo smbpasswd -e lteacher
    sudo smbpasswd -e lstudent
    sudo smbpasswd -e ctk-admin
    sudo smbpasswd -e tadmin

Restart the samba server

    sudo systemctl restart smbd.service nmbd.service

Attempt to connect to the shares
