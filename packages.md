# Packages


## Enable PPA sources with the following:

    install -y python-software-properties

## PPA Items
  
    sudo apt-add-repository ppa:ondrej/php5
    sudo apt-add-repository ppa:phalcon/stable
    
Always update after adding PPA

    apt-get update

## Utilities

    sudo apt-get install -y\
    git\
    htop\
    curl\

## Databases

    sudo apt-get install -y\
    redis-server\
    mysql-server

## NodeJS

    curl -sL https://deb.nodesource.com/setup | bash -
    sudo apt-get install -y nodejs
    
### NPM Packages

    sudo npm install -g\
    gulp\
    bower\
    grunt-cli

## PHP Packages
    
    sudo apt-get install -y\
    php5\
    php5-dev\
    apache2\
    libapache2-mod-php5\
    php5-mysql\
    php5-curl\
    php5-mcrypt\
    php5-phalcon\
    php5-intl\
    libpcre3-dev\
    phpunit
    
### PHP Quick Options

    sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/apache2/php.ini
    sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/apache2/php.ini
    sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini 
    # Append session save location to /tmp to prevent errors in an odd situation..
    sudo sed -i '/\[Session\]/a session.save_path = "/tmp"' /etc/php5/apache2/php.ini
    
### PHP Composer, use Globally
    
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

    sudo apt-get install -y\
    python-pip
    
## Python PIP Packages

    sudo pip install\
    virtualenv\
    virtualenvwrapper

## Default Apache 

    cd ~
    echo '<VirtualHost *:80>
            DocumentRoot /var/www
    </VirtualHost>
    <Directory "/var/www">
            Options Indexes Followsymlinks
            AllowOverride All
            Require all granted
    </Directory>' > default.conf
    
    sudo mv default.conf /etc/apache2/sites-available
    
### Enable Modules

    sudo php5enmod phalcon
    sudo php5enmod curl
    sudo php5enmod mcrypt
    sudo php5enmod intl

    sudo a2dissite 000-default
    sudo a2ensite default
    sudo a2enmod rewrite
