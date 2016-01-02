# Config Server
Common commands for Debian Flavors (Ubuntu)

## Brief
- If there is a `$` symbol, it means it's a terminal command, otherwise it's likely just a path.
- I am excluding the `$ sudo` command, because it's too repetitive, just `$ sudo su` to save time.


## Searching

Search for a filename from system path

    $ find / --name filename
    
Search the contents of a file

    $ cat filename | grep "text-to-find-here"

Search within files in the current directory 
    
    $ grep -Ril "text-to-find-here" .
    
    R (recursive)
    i (case insensitive)
    l (show the file name, not the result itself)

    
## Enable PPA Repositories

    $ apt-get install python-software-properties

## Config SSH Settings

    $ vim /etc/ssh/sshd_config
    $ service ssh restart

## Users

See Settings

    $ useradd

See the Defaults (Change in `/etc/default/useradd`)

    $ useradd -D

Add a user with the defaults

    $ useradd samson

Add user with defaults and home directory

    $ useradd -m samson

Add user with bash as shell if not set

    $ useradd -m -s /bin/bash jesse

Change user password

    $ passwd samson

Delete User

    $ userdel samson

See Users

    $ cat /etc/passwd

See Groups

    $ cat /etc/group

Add to sudo (Super User)
You have to re-login for sudo to take effect

    $ adduser samson sudo

Manually Add sudo (Super User)

    /etc/sudoers has: %sudo   ALL=(ALL:ALL) ALL
    $ visudo

You could also add per user, rather than include per group within `/etc/sudoers`

    samson ALL=(ALL) ALL

Change a users shell

    sudo chsh -s /bin/bash samson
    
Add Existing user to Existing Group

    usermod -a -G www-data samson

Make an SFTP user

    sudo groupadd sftp_users
    useradd -m -s /bin/bash samson
    passwd samson
    sudo usermod -G sftp_users samson
    
    # For a webserver, you should add the webserver group AS WELL
    sudo usermod -G www-data samson  
    
    sudo vim /etc/ssh/sshd_config
    
    # SFTP Permission (end of file)
    Match group filetransfer
        ChrootDirectory %h
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand internal-sftp
    
    sudo /etc/init.d/ssh restart

# User Keys

Use an existing SSH key. Paste your id_rsa.pub in one line in the file:

    mkdir ~/.ssh
    vim ~/.ssh/authorized_keys

Use the same key to authorize Git

    touch ~/.ssh/id_rsa.pub

Or, create a new SSH key

    ssh-keygen -t -rsa -C "email@gmail.com"

SSH Directory Permissions

    ~/.ssh              700
    ~/.ssh/id_rsa.pub   644
    ~/.ssh/id_rsa       600

One liner permissions

    chmod 700 ~/.ssh && chmod 644 ~/.ssh/id_rsa.pub

If you have a Private Key also

    chmod 700 ~/.ssh && chmod 644 ~/.ssh/id_rsa.pub && chmod 600 ~/.ssh/id_rsa

## IP Tables

`/etc/init.d/iptables` has been removed a while ago, so managing them is different for old schoolers.

Easy to manage persistent IP-Tables

    $ apt-get install iptables-persistent

Saving permanent tables:

    $ iptables-save > /etc/iptables.up.rules
    $ sudo vim /etc/network/if-pre-up.d/iptables
    
Add the following:

    #!/bin/sh
    /sbin/iptables-restore < /etc/iptables.up.rules

Make it executiable:
    
    chmod +x /etc/network/if-pre-up.d/iptables

This will save the rules for IPv4/v6 in: `/etc/iptables/`, Also refer to [IP Tables Wiki](https://wiki.debian.org/iptables) for startup.

List out IP Table Rules

    $ sudo iptables -L

List IP Tables with the Line Number

    $ sudo iptables -vnL –line-numbers

Add an INPUT rule (Change the port)

    $ sudo iptables -A INPUT -p tcp --dport 9898 -j ACCEPT

Delete a IP Table Rule (Get the list from above)

    $ iptables -D INPUT <list-number>

Permanently save IP Table Rules if satisfied with `$ sudo iptables -L`
From there, if you are not using iptables-persistent you would want a bash script to load in `/etc/init.d/` or the `/etc/network/ip-up.d`.

    $ touch /ectc/firewall.conf
    $ iptables-save > /etc/firewall.conf


## Manage Network Scripts

    /etc/network/if-down.d/
    /etc/network/if-pre-up.d/

Make sure to `chmod +x filename.sh`

## www folder user/group permissions

To best share with multiple users who should be able to write in `/var/www`, it should be assigned a common group. For example the default group for web content on Ubuntu and Debian is `www-data`. Make sure all the users who need write access to `/var/www` are in this group. [Source](http://superuser.com/questions/19318/how-can-i-give-write-access-of-a-folder-to-all-users-in-linux)

    $ usermod -a -G www-data <some_user>

Then set the correct permissions on `/var/www`.

    $ chown -R www-data:www-data /var/www 
    $ chmod -R g+w /var/www
    # Relogin for changes to apply

Additionally, you should make the directory and all directories below it "set GID", so that all new files and directories created under `/var/www` are owned by the `www-data` group.

    $ find /var/www -type d -exec chmod 2775 {} \;

Find all files in /var/www and add read and write permission for owner and group:

    $ find /var/www -type f -exec chmod ug+rw {} \;

## Using Networking
Beginner commands to [http://www.linux.com/learn/tutorials/290879-beginners-guide-to-nmap](nmap)

    $ apt-get install nmap

Check open ports

    $ sudo nmap -sT -O localhost

Other ways to check ports

    $ netstat -anp | grep 222
    $ lsof -i | grep 222
    $ telnet localhost 222
