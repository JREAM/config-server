# Nginx
Debian 7.x

## Install

    $ sudo apt-get install nginx

The main configuration file is located at

    /etc/nginx/nginx.conf


- The `http {..}` is the main configuration, but you should use separate Virtual Host files in `sites-enabled`.
- Default user nginx runs as is `www-data`
- Default worker processes is `4`
- Default process id located at `/var/run/nginx.pid`

To know how many *worker processes* to user see how many CPU cores you have:

    grep processor /proc/cpuinfo | wc -l
    > 1

To know the core limits:

    ulimit -n
    > 1024

So I could adjust my file to:

    # Total many cores to use
    worker_processes 1;

    # Total clients to serve at once
    worker_connections 1024;


## Configuration files

In the main `nginx.conf` you will see

    include /etc/nginx/sites-enabled/*;
    include /etc/nginx/conf.d/*.conf;

This will automatically include every configuration file and site-enabled (symlink).

There is also a `allow_deny.conf` file if you want to have some strict IP rules to the webserver.

## Nginx Usage

    sudo service nginx start
    sudo service nginx stop
    sudo service nginx reload
    sudo service nginx restart

## Virtual Hosts

Just like Apache we have virtual hosts

    cd /etc/nginx/sites-available
    touch codezeus
    vim codezues

###  A server block example for html or php

    server {
        # TCP Port and Server Name
        listen *:80;

        # Server Name
        server_name popcorn.com;
        server_name .popcorn.com; # Wildcard

        # Access Logs (For Individual Servers)
        access_log /var/www/popcorn/logs/access.log

        # Access Logs Off
        # access_log off;

        # Determines what happens with the request
        location / {
            # File Path
            root    /var/www/popcorn/htdocs;
            index   index.php index.html;
            error_page 404 404.html;
        }
    }

## Virtual Host Active

In Nginx you manually create a symbolic link, I would like to see something similar
to a2ensite a2dissite.

### Link from `sites-available` to `sites-enabled`

    sudo ln -s /etc/nginx/sites-available/popcorn /etc/nginx/sites-enabled/popcorn
    sudo service nginx reload

### Remove a host

    sudo rm /etc/nginx/sites-enabled/popcorn
    sudo service nginx reload

## Running a Django with uWSGI

This is one way to do this among many other configurations. You can even use an
INI file for configuration if you prefer.

### Install uWSGI
You should install all your items in a virtual environment using `pip install virtualenv`.
This way your application settings are dependant are nothing system-wide besides the nginx
configuration for media/static files.

    # Default
    pip install uwsgi

    # Long Term Support
    pip install http://projects.unbit.it/downloads/uwsgi-lts.tar.gz

#### Create a test file anywhere

    def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return ["Hello World"]

#### Run uwsgi

    uwsgi --http :8000 --wsgi-file test.py

#### Access your site

    http://youripaddress:8000

### Create a new Virtual Host

    upstream django {
        server 127.0.0.1:8001;
    }

    server {
        listen      8000;
        server_name .popcorn.com;

        location /media  {
            alias /var/www/popcorn/media;
        }

        location /static {
            alias /var/www/popcorn/static;
        }

        # All non-media
        location / {
            uwsgi_pass  django;

            # See Example Configuration,
            # It's also availalble in the nginx folder of the uWSGI installation.
            # https://github.com/nginx/nginx/blob/master/conf/uwsgi_params

            include     /var/www/popcorn/uwsgi_params;
        }
    }

You would obviously have to add that to sites-enabled in nginx.

#### Make uWSGI boot on system load

    vim /etc/rc.local

Append this line before the `exit 0`:

    /usr/local/bin/uwsgi --emperor /etc/uwsgi/vassals --uid www-data --gid www-data


