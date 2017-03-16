#!/bin/bash
#
# $ sudo ./config.sh
#
echo "You logged in as arean: $USER"
if [[ $EUID -ne 0 ]]; then
    echo "You must run this as the root user."
    exit 1
fi

echo ""
echo "====================================================================="
echo ""

# PPA Repo's
sudo apt-add-repository ppa:phalcon/stable

# Updates
apt update
apt upgrade

# Firewall
ufw enable
ufw allow ssh
ufw allow http
ufw allow https

# Security
# fail2ban
# ClamAV
# rkhunter

# Utils
apt install -y\
    at\
    ack-grep\
    bzip2\
    curl\
    git\
    git-extras\
    htop\
    tree\
    unzip\
    vim\
    whois\
    xclip


# Dependencies
sudo apt-get install -y\
    libssl-dev\
    libffi-dev\
    libjpeg8-dev\
    libjpeg-dev


# Server
apt install nginx nginx-extras
yes | cp nginx/default /etc/nginx/sites-available/default

# PHP
sudo apt-get install -y\
    php7.0\
    php7.0-bz2\
    php7.0-dev\
    php7.0-cli\
    php7.0-common\
    php7.0-curl\
    php7.0-fpm\
    php7.0-gd\
    php7.0-imap\
    php7.0-intl\
    php7.0-json\
    php7.0-mbstring\
    php7.0-mcrypt\
    php7.0-mysql\
    php7.0-odbc\
    php7.0-opcache\
    php7.0-phalcon\
    php7.0-readline\
    php7.0-soap\
    php7.0-sqlite3\
    php7.0-tidy\
    php7.0-xml\
    php7.0-xmlrpc\
    php7.0-zip\
    php-redis

# Python
apt install -y\
    python3\
    python3-dev\
    python3-pip\
    python-pip\
    python-dev

pip install --upgrade pip
pip3 install --upgrade pip

pip install bpython virtualenvwrapper --upgrade
pip3 install bpython virtualenvwrapper --upgrade

# Configure PHP

phpenmod php7.0-phalcon
sed 's/#cgi.fix_pathinfo=0/cgi.fix_pathinfo=0' /etc/php/7.0/fpm/php.ini


sudo cp /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/fpm/conf.d/20-phalcon.ini
sudo cp /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/cli/conf.d/20-phalcon.ini

sudo service php7.0-fpm restart


# Create User
useradd -m deploy
usermod -aG www-data deploy

# Give them permissions
chmod -R g+rws /usr/local
chmod -R g+rws /var/www

# Dotfiles
