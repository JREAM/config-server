# Apache

Debian 7.x

# Install

```
apt-get install apache2
```

# Troubleshooting Sites-Available

```
apachectl configtest
```

# Macros for better configs
  
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
