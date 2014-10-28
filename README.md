# config-server
For Ubuntu/Debian Flavor

## Enable PPA Repositories

    apt-get install python-software-properties

## Config SSH Settings
    
    vim /etc/sshd_config
    sudo service ssh restart

## Users

    # See Settings
    useradd
    
    # See the Defaults (Change in /etc/adduser.conf)
    useradd -D
    
    # Add a user with the defaults
    useradd samson
    
    # Add user with defaults and home directory
    useradd -m samson
    
    # Change user password
    passwd samson
    
    # Delete User
    userdel samson
    
    # See Users
    cat /etc/passwd
    
    # See Groups
    cat /etc/group
    
    # Add to sudo (Super User)
    # You have to re-login for sudo to take effect
    adduser samson sudo
    
    # Manually Add sudo (Super User)
    # /etc/sudoers has: %sudo   ALL=(ALL:ALL) ALL
    visudo
    
    # You could also do this
    samson ALL=(ALL) ALL

## Easy to manage persistent IP-Tables

    sudo apt-get install iptables-persistent
    
This will save the rules for IPv4/v6 in: `/etc/iptables/`, Also refer to [IP Tables Wiki](https://wiki.debian.org/iptables) for startup.

## Manage Network Scripts

    /etc/network/if-down.d/
    /etc/network/if-pre-up.d/

Make sure to `chmod +x filename.sh`

