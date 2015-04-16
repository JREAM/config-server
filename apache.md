# Apache

This is for Ubuntu and Debian. This is using Apache 2.2 and 2.4.

## Table of Contents
- [Install](#install)
- [Commands](#commands)
    - [Toggling Sites and Service](#toggling-sites-and-service)
    - [Enabling and Disable Modules](#enabling-and-disable-modules)
    - [Apache Control](#apache-control)
    - [Apache Utils](#apache-utils)
- [Troubleshooting Sites](#troubleshooting-sites)
- [Examples](#examples)
    - [htacccess](#htaccess)
    - [Virtual Host](#virtual-host)
    - [Virtual Host SSL](#virtual-host-ssl)
    - [Subdomain](#subdomain)
    - [Macros](#macros)

### Install
```
apt-get install apache2
cd /etc/apache2/
```

***

## Commands

### Toggling Sites and Service
```
a2ensite yoursitename
a2dissite yoursitename
service apache2 start|stop|reload|graceful
```

###  Enabling and Disable Modules
```
a2enmod rewrite
a2enmod evasive
a2dismod security
```

### Apache Control
```
# It appears both of these work
apache2ctl -h 
apachectl -h 
```

### Apache Utils
A cool little tool you can use with Apache if you want to dig in is the utils:

    sudo apt-get install apache2utils
    
It has the following features:

- `ab` (Apache benchmark tool)
- `logresolve` (Resolve IP addresses to hostname in logfiles)
- `htpasswd` (Manipulate basic authentication files)
- `htdigest` (Manipulate digest authentication files)
- `dbmmanage` (Manipulate basic authentication files in DBM format, using perl)
- `htdbm` (Manipulate basic authentication files in DBM format, using APR)
- `rotatelogs` (Periodically stop writing to a logfile and open a new one)
- `split-logfile` (Split a single log including multiple vhosts)
- `checkgid` (Checks whether the caller can setgid to the specified group)
- `check_forensic` (Extract mod_log_forensic output from apache log files)

***

## Troubleshooting Sites
This will tell you if there is an error.
```
apache2ctl configtest
```

If you cannot find the error, check the logs:

```
tail /var/log/apache2/error.log -n25
```

***

## Examples
Below are some examples for easy configuration made just for you.

### htaccess
First figure out your apache version with:

    apache2ctl -V
    
You should see something like:
    
    Server version: Apache/2.2.22 (Debian or Ubuntu)

For **2.2** your `<Directory>` typically has:

    Order allow,deny
    Allow from all
    
For **2.4** your `<Directory>` has:

    Require all granted
    
### Virtual Host

  ServerName yoursite.com
  <VirtualHost *:80>
      ServerAdmin server@yoursite.com
      ServerName  yoursite.com
      ServerAlias yoursite.com www.yoursite.com
  
      # Indexes + Directory Root.
      DirectoryIndex index.php
      DocumentRoot /var/www/yoursite.com/htdocs/public/
  
      # Logfiles
      ErrorLog  /var/www/yoursite.com/logs/error.log
      CustomLog /var/www/yoursite.com/logs/access.log combined
  </VirtualHost>

### Virtual Host SSL

You must replace your email, site name, path to your site, logs are optional, and the correct SSL keys with their respective locations. (*This would go nicely in the same Host that is serving port 80 above*).

    <VirtualHost *:443>
        ServerAdmin server@yoursite.com
        ServerName  yoursite.com
        ServerAlias yoursite.com www.yoursite.com

        # Indexes + Directory Root.
        DirectoryIndex index.php
        DocumentRoot /var/www/yoursite.com/htdocs/public/

        # Logfiles
        ErrorLog  /var/www/yoursite.com/logs/error.log
        CustomLog /var/www/yoursite.com/logs/access.log combined

        # SSL
        SSLEngine on
        SSLCertificateFile /etc/apache2/ssl/yoursite.com/yoursite_com.crt
        SSLCertificateKeyFile /etc/apache2/ssl/yoursite.com/server.key
    	SSLCACertificateFile /etc/apache2/ssl/yoursite.com/yoursite.com.cer
    </VirtualHost>
    
### Subdomain
If you wanted a blog subdomain you could do it like this. Keep in mind your DNS must point:

    # Your IP Address
    A Record: 99.99.99.99 

Here is the subdomain example, and without saying much you'd set your paths and sitename accordingly.

    <VirtualHost *:80>
        ServerAdmin server@yoursite.com
        ServerName  blog.yoursite.com
    
        # Indexes + Directory Root.
        DirectoryIndex index.php
        DocumentRoot /var/www/yoursite.com/subdomains/blog
    
        # Logfiles
        ErrorLog  /var/www/yoursite.com/subdomains/logs/error.log
        CustomLog /var/www/yoursite.com/subdomains/logs/access.log combined
    </VirtualHost>


### Macros
  
```
apt-get install libapache2-mod-macro
a2enmod macro
service apache2 restart
```

I am still figuring out how to use it, here's where I left off:

    <Macro $name $dir>
    <VirtualHost *:80>
        # Main Settings
        ServerName $name
        #ServerAlias $alias
    
        # Indexes + Directory Root.
        DocumentRoot $dir
    
        # Logfiles
        ErrorLog  $dir/error.log
        CustomLog $dir/access.log combined
    
        <Directory $dir>
            AllowOverride None
            Order allow,deny
            Allow from all
        </Directory>
    </VirtualHost>
    </Macro>
  
  Use vhost mysite.org /var/www/mysite.org/htdocs/public/        
