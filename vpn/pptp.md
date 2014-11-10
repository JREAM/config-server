# PPTP VPN Service
Start with installing OS updates

    apt-get update
    apt-get upgrade

## Install PPTPD

    apt-get install pptpd

### Allow IP Assignments

    nano /etc/pptpd.conf

## Uncomment one of the groups of:

    #localip
    #remote

### Create a VPN User
You'll use these to actually login.

    nano /etc/ppp/chap-secrets

It will look something in like this:

    # Secrets for authentication using CHAP
    # client server secret IP addresses
    yourname pptpd any_password *

## Enable IPv4 Forwarding

    nano /etc/sysctl.conf

Uncomment the following:

    #net.ipv4.ip_forward=1

to

    net.ipv4.ip_forward=1

## Add the following IP Rules

    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables -o eth0 -A FORWARD -p tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 800:1536 -j TCPMSS --clamp-mss-to-pmtu

## Permanently save IP Rules

    apt-get install iptables-persistent
    [YES] to both

## Reboot your server
This is to also make sure your IP Rules stick :)

    reboot

## Client: Windows
- Create a New VPN Client in Windows from Control Panel > Networking
- Connect to the IP
- Use your Username/Password you setup

## Client: Linux 
- Create a New VPN Connection
- Select PPTP
- Add your IP, Username/Password
- Check off `Use Point-to-Point encryption (MPPE)`
