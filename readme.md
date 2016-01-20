# Config Server
This is a guide to install a server for an **Ubuntu 14 LTS** server. You could likely use different versions.

---

# Table of Contents
- [Security](#security)
    - [Update](#update)
    - [Firewall UFW](#firewall-ufw)
    - [SSH and Users](#ssh-and-users)
    - [Fail2Ban](#fail2ban)
    - [Rootkits](#rootkits)
    - [Unattended Upgrades](#unattended-upgrades)
    - [Apache2 Mod-Evasive](#apache2-mod-evasive)
- [Packages](#packages)
    - [Common Items](#common-items)
    - [Enable PPA Repositories](#enable-ppa-repositories)
- [Commands](#commands)
    - [SSH Welcome Message](#ssh-welcome-message)  
    - [Searching](#searching)
    - [User Management](#user-management)
    - [SFTP User](#sftp-user)
- [Manage Network Scripts](#manage-network-scripts)
    - [Checking Ports](#checking-ports)

---
#Security
These are necessities to keep your server secure. Not everything will be covered but some of the most important.

###Update
With any new installation you want to update!

    sudo apt-get update
    sudo apt-get upgrade -y

###Firewall UFW
UFW is the uncomplicated firewall.

    sudo ufw enable
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw allow ssh
    sudo ufw allow 911 <or any number>

See your Firewall Rules:

    sudo ufw status verbose

###SSH and Users
You should first create a **non-root** user. Since default logins are root on port 22:

    sudo useradd -m -s /bin/bash user1
    passwd user1

We need **user1** him to be a **super-user (su)**. Add your in visudo:

    $ visudo
    --------
    # User privilege specification
    root    ALL=(ALL:ALL) ALL
    user1   ALL=(ALL:ALL) ALL

#####Change Default SSH Port
To change the default port of `22` to something else of your choice:

    $ sudo vim /etc/ssh/sshd_config
    -------------------------------
    Port 22              # Change to: 1234
    PermitRootLogin yes  # Change to: no

Reload SSH Configuration:

    sudo service ssh reload

#####Make Sure You can Login
Test your new user by keeping your current terminal connected and opening a second terminal:

    ssh user1@ip_address -p1234

Also make sure you can use sudo, so type `su -`

#####User SSH Login
---

As your new user (**user1**), if you want to login with an SSH key, make sure you have a key on your **local** machine.

    ssh-keygen -t rsa -b 4096 -C "your-email@domain.com"

Create your **remote** SSH folder and authorized_keys. Paste your `id_rsa.pub`to authorized_host:

    mkdir ~/.ssh
    vim /etc/authorized_keys

Your **local** `~/.ssh/id_rsa.pub` must match the **remote** `~/.ssh/authorized_keys`. Make sure it's on **one line!**

#####SSH File Permissions
Here are the permissions for your files (local and remote).

    chmod 700 ~/.ssh &&\
    chmod 600 ~/.ssh/authorized_keys &&\
    chmod 644 ~/.ssh/id_rsa.pub &&\
    chmod 600 ~/.ssh/id_rsa

Don't keep your `id_rsa` private key on the **remote** host, all you need to login is the `authorized_keys` file. _Only host your private key for a locked down user for deployments._

#####Quick SSH Login
On your local machine edit or create an ssh config for quick connection:

    $ vim ~/.ssh/config
    -------------------
    Host myhost
    Hostname 123.123.123.555
    Port 1234
    User user1

You should now be able to connect with:

    ssh myhost

###Fail2Ban
Bans IPs that attempt too many password failures, searching for exploits and the like. The default configuration is good.

    sudo apt-get install fail2ban

###Rootkits

    sudo apt-get install chkrootkit rkhunter

Edit the chkrootkit configuration:

    sudo vim /etc/chkrootkit.conf

We will run both weekly; However we need to change the configuration:

    RUN_DAILY="true"
    RUN_DAILY_OPTS=""
    DIFF_MODE="false"

For your reference, rkhunter's configuration file is located here: `/etc/default/rkhunter`

Rename the rkhunter's update job with a different name before moving the other items to the weekly CRON:

    sudo mv /etc/cron.weekly/rkhunter /etc/cron.weekly/rkhunter_update

Next move the daily CRON to the weekly:

    sudo mv /etc/cron.daily/chkrootkit /etc/cron.weekly
    sudo mv /etc/cron.daily/rkhunter /etc/cron.weekly


###Unattended Upgrades
Keep security updates on a cron.

    sudo apt-get install unattended-upgrades

Edit the periodic updated file:

    sudo vim /etc/apt/apt.conf.d/10periodic

Update your values to something like this:

    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "1";
    APT::Periodic::AutocleanInterval "7";
    APT::Periodic::Unattended-Upgrade "1";



###Apache2 Mod-Evasive
This is useful for DDOS attacks. First install the needed packages.

    sudo apt-get install apache2 apache2-utils libapache2-mod-evasive

Create the log directory.

    sudo mkdir /var/log/mod_evasive
    sudo chown www-data:www-data /var/log/mod_evasive

Edit the configuration file:

    sudo vim /etc/apache2/mods-available/mod_evasive.conf

Uncomment everything except `DOSSystemCommand` and add your email after `DOSEmailNotify`.

Reload Apache:

    sudo a2enmod evasive
    sudo service apache2 reload

#Packages
The location of the aptitute (`apt`) source list is at:

    /etc/apt/sources.list
    
However, you if you manually add sources you should put them in separate files in this folder, then you can delete it without editing a file if you like:

    /etc/apt/sources.list.d
    

###Common Items

    sudo apt-get install \
    git htop xclip \
    python-dev python-pip \
    php5 php5-dev \
    apache2 apache2-utils


###Enable PPA Repositories
This should exist by default, but if it doesn't install it:

    sudo apt-get install python-software-properties
    
#Commands
These are commands for reference.

###SSH Welcome Message
When you login to your SSH, you can add a custom welcome banner that looks cool:

    sudo vim /etc/ssh/sshd_config
    Banner /etc/banner

Then create the file and add anything you want:

    sudo vim /etc/banner
    
Here is an example:
```
   __ _____ _____ _____ _____ 
 __|  | __  |   __|  _  |     |
|  |  |    -|   __|     | | | |
|_____|__|__|_____|__|__|_|_|_|
-------------------------------
Server 01               Welcome
-------------------------------
```
    
I used a text to ASCII generator for that. Then restart and it will appear next time you login!

    sudo service ssh restart

##Searching

Search for a filename from system path

    $ find / --name filename

Search the contents of a file

    $ cat filename | grep "text-to-find-here"

Search within files in the current directory

    $ grep -Ril "text-to-find-here" .

    R (recursive)
    i (case insensitive)
    l (show the file name, not the result itself)

##User Management

See the user defaults, and add a user with the defaults:

    useradd -D
    useradd user2

    useradd -m user2                # Create Home, Default Shell
    useradd -m -s /bin/bash user2   # Set Shell, Create Home

    passwd user2                     # Change Passwd
    userdel user2                     # Delete User

    cat /etc/passwd # See Users
    cat /etc/group # See Groups

Manually Add sudo (Super User)

    $ visudo
    --------
    user2 ALL=(ALL) ALL

Change a users shell

    sudo chsh -s /bin/bash user2

Add Existing user to Existing Group

    usermod -a -G www-data user2

##SFTP User
For SFTP Access you should create a group an ddo the following:

    sudo groupadd sftp_users
    sudo usermod -G sftp_users user2

For a webserver, you should add the webserver group AS WELL

    sudo usermod -G www-data user2

Edit your SSHD config and append to the end of the file

    $ sudo vim /etc/ssh/sshd_config
    -------------------------------
    Match group filetransfer
        ChrootDirectory %h
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand internal-sftp

Restart SSH

    sudo service ssh restart

#Manage Network Scripts
You can add your own startup/shutdown scripts and the like in folders in this area:

    /etc/network/if-down.d/
    /etc/network/if-pre-up.d/

Just make sure to `chmod +x filename.sh`

##Checking Ports
Beginner commands to [http://www.linux.com/learn/tutorials/290879-beginners-guide-to-nmap](nmap)

    apt-get install nmap

There are many ways to check open ports:

    sudo ufw status
    sudo nmap -sT -O localhost

Other ways to check ports

    netstat -anp | grep 222
    lsof -i | grep 222
    telnet localhost 222

---

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that notice appear in all copies.

&copy;2016 MIT License | Jesse Boyer | JREAM.com
