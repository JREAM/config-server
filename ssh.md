# SSH

Information regarding SSH.

## Locked out of server

First see if any errors appears here using `very-verybose`:

    ssh user@host.com -vv
  
Login through a *web terminal* if you are locked out. There is no other way around this.
Then shut down SSH:

    sudo service ssh stop
    sudo /usr/sbin/sshd -d
    
You may be getting blacklisted, so allow SSH connections:

    sudo vim /etc/hosts.allow

Append the following at the bottom of `/etc/hosts.allow`:

    sshd: ALL

Save and restart SSH

    sudo service ssh restart
    
Now try to login to your SSH outside of your web console.

# SSH Agent Not Found
This is annoying and there are permanent fixes, but I am not sure what the cause is. Here is how to reload it:

    eval `ssh-agent -s`
    
You may have to re-add your ssh keys with `ssh-add id_rsa`


