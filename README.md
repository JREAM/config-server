# Config Server
Common commands for Debian Flavors (Ubuntu)

## Brief
- If there is a `$` symbol, it means it's a terminal command, otherwise it's likely just a path.
- I am excluding the `$ sudo` command, because it's too repetitive, just `$ sudo su` to save time.

## Enable PPA Repositories

    $ apt-get install python-software-properties

## Config SSH Settings
    
    $ vim /etc/sshd_config
    $ service ssh restart

## Users

See Settings

    $ useradd
    
See the Defaults (Change in `/etc/adduser.conf`)

    $ useradd -D
    
Add a user with the defaults

    $ useradd samson
    
Add user with defaults and home directory

    $ useradd -m samson
    
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

## IP Tables
`/etc/init.d/iptables` has been removed a while ago, so managing them is different for old schoolers.

Easy to manage persistent IP-Tables

    $ apt-get install iptables-persistent
    
Using persistant iptables:

    $ /etc/init.d/iptables-persistent 
    
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

    $ chgrp -R www-data /var/www
    $ chmod -R g+w /var/www

Additionally, you should make the directory and all directories below it "set GID", so that all new files and directories created under `/var/www` are owned by the `www-data` group.

    $ find /var/www -type d -exec chmod 2775 {} \;    

Find all files in /var/www and add read and write permission for owner and group:

    $ find /var/www -type f -exec chmod ug+rw {} \;
    
