# Packages
These are system packages that I find handy.

## Enable PPA if on Ubuntu 12 or lower:
PPA means Personal Package Archive that users or organizations create so that you do not have to manually compile softwrae.

    apt-get install -y python-software-properties

## PPA Items

For the latest **git** version you can also add the following PPA

    sudo add-apt-repository ppa:git-core/ppa -y

If you wanted the latest **PHP**, this guy does quite a bit:

    sudo apt-add-repository ppa:ondrej/php

If you want the fast **PHP Phalcon** framework you could add:

    sudo apt-add-repository ppa:phalcon/stable
    
**Important** Always update after adding PPA

    apt-get update

Now you can look at what you added:

    sudo apt-get install php7<TAB-key>
    sudo apt-get install php5<TAB-key>

## Utilities
Here are what these utilities do
- `vim` is a text editor and it has a ton of cool addons [VimAwesome](http://vimawesome.com)
    - I would install [Vundle](https://github.com/VundleVim/Vundle.vim) for VIM 
- `htop` is a better version of TOP
- `lsof` is List of Open Files
- `vmstat` provides details about your environment
- `rsync` is a tool that allows you to transfer files from servers or locally.
- `bzip2` is handles bz2 files like zip
- `gzip` is another good compression tool like zip
- `mlocate` helps you find things using `updatedb`

Command to install all:
```
    sudo apt-get install -y \
    vim \
    git \
    htop \
    curl \
    lsof \ 
    vmstat \
    rsync \
    bzip2 \
    gzip \
    mlocate
```

####Configure Git
Configure your git details (without the `< placeholders >`):

    git config --global push.default simple
    git config --global user.name <your name>
    git config --global user.email <your@email.com>


## Databases

    sudo apt-get install -y \
    redis-server \
    mysql-server

## PHP Packages
    
    sudo apt-get install -y \
    php5 \
    php5-dev \
    apache2 \
    libapache2-mod-php5 \
    php5-mysql \
    php5-curl \
    php5-mcrypt \
    php5-phalcon \
    php5-intl \
    libpcre3-dev \
    php5-gd \
    libssh2-php \
    phpunit
    
### PHP Quick Options
This is to make your development environment easier to work with. Do **not** do this in production.

    sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/apache2/php.ini
    sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/apache2/php.ini
    sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini 
    # Append session save location to /tmp to prevent errors in an odd situation..
    sudo sed -i '/\[Session\]/a session.save_path = "/tmp"' /etc/php5/apache2/php.ini

You may also want to run some of the same things on `/etc/php5/cli/php.ini` if you use the CLI a lot.
    
### PHP Composer
Composer is the PHP Package Manager. You should use composer globally it makes life easier.

    sudo curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    
### Phalcon Dev Tools

    cd ~
    echo '{"require": {"phalcon/devtools": "dev-master"}}' > composer.json
    composer install
    rm composer.json
    
    sudo mkdir /opt/phalcon-tools
    sudo mv ~/vendor/phalcon/devtools/* /opt/phalcon-tools
    sudo ln -s /opt/phalcon-tools/phalcon.php /usr/bin/phalcon
    sudo rm -rf ~/vendor
    
## Python Packages

    sudo apt-get install -y \
    python-pip \
    python-dev \
    python-imaging
    
## Python PIP Packages

    sudo pip install \
    virtualenv \
    virtualenvwrapper \
    fabric

## Basic Apache Templates 
For Apache **2.4**

    sudo echo '<VirtualHost *:80>
            DocumentRoot /var/www
    </VirtualHost>
    <Directory "/var/www">
            Options Indexes Followsymlinks
            AllowOverride All
            Require all granted
    </Directory>' > local.conf
    
    sudo mv local.conf /etc/apache2/sites-available
    sudo a2ensite local
    sudo service apache2 reload
    
#### For Apache **2.2**

Change These lines:

    AllowOverride All
    Require all granted

To This:

    Order allow,deny
    Allow from all
    
Your default access and error logs are in `/var/log/apache2/`.
    
### Enable Modules

PHP Modules

    sudo php5enmod phalcon
    sudo php5enmod curl
    sudo php5enmod mcrypt
    sudo php5enmod intl

Apache Modules

    sudo a2ensite default
    sudo a2enmod rewrite
