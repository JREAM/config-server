# Apache

This is for Ubuntu and Debian. This is using Apache 2.2 and 2.4.

## Install
```
apt-get install apache2
cd /etc/apache2/
```

Some commands are:
```
a2ensite yoursitename
a2dissite yoursitename
service apache2 reload
service apache2 restart
```
    <Directory /var/www/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride None
        Order allow,deny
        allow from all
    </Directory>

## Troubleshooting Sites-Enabled

```
apachectl configtest
```

## Example Virtual Host

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

## Example Virtual Host SSL

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

## Example Subdomain
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


## Macros for better configs
  
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
