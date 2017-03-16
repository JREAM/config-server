#!/bin/bash
#
# @usage:
#   Run this from anywhere as the root user
#
echo "You logged in as arean: $USER"

if [[ $EUID -ne 0 ]]; then
    echo "You must run this as the root user."
    exit 1
fi

# Work from home path
cd $HOME

# /
# ------------------------------------------
#  User Prompts
# ------------------------------------------
# \
echo -n "Choose a hostname for this server[default: unchanged]: "
read hostname
echo -n "Choose a username for a new super user: "
read username
echo -n "Choose a username for a deploy user [deploy]: "
read username_deploy

# If no  username_deploy the default will be deploy
if [ -z "${username_deploy// }" ]; then
    $username_deploy = 'deploy'
fi

# Lowercase Username's
username=${username,,}
deploy=${username,,}

# Validate usernames
# @TODO: If this step gets screwed up or their password, there should
#        be a way to continue.
checkExistsUsername $username           # Exits on failure
checkValidUsername  $username           # Exits on Failure
checkExistsUsername $username_deploy    # Exits on failure
checkValidUsername  $username_deploy    # Exits on Failure

echo "Create a Password for $username (The deloy user $username_deploy has no password)"
useradd -m $username
passwd $username

# We will add them to www-data once the group exists below

echo "Welcome $username, we will automate setup now."

# Pause
sleep 2

# /
# ------------------------------------------
#  Installations
# ------------------------------------------
# \

if [ -z "${username_deploy// }" ]; then
    echo "Skipping hostname change, not set."
else
    echo "Adding hostname to /etc/hostname and /etc/hosts, you'll see changes after re-logging in"
    echo $hostname > /etc/hostname
    echo "127.0.0.1 $hostname" >> /etc/hosts
fi;

echo "Add PPA Repositories Prior to Updating"
apt-add-repository -y ppa:phalcon/stable

echo "Apt Update and Upgrade"
apt update
apt upgrade

echo "Firewall Rules"
ufw enable
ufw allow ssh
ufw allow http
ufw allow https

echo "Install Utils"
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

echo "Install Dependencies"
apt install -y\
    libssl-dev\
    libffi-dev\
    libpcre3-dev\
    libsqlite3-dev\
    libjpeg8-dev\
    libjpeg-dev

echo "Add Security Tools (fail2ban, clamav, rkhunter)"
pip install fail2ban
apt install clamav\
    rkhunter

echo "Install Server"
apt install nginx nginx-extras

echo "Copy server config over"
yes | cp nginx/default /etc/nginx/sites-available/default

echo "Install Redis"
apt install -y redis

echo "Install PHP"
apt install -y\
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

echo "Install Python and Python2/3"
apt install -y\
    python3\
    python3-dev\
    python3-pip\
    python-pip\
    python-dev

echo "Upgrading pip/pip3 to latest"
pip install --upgrade pip
pip3 install --upgrade pip

echo "Installing virtualenvwraper for Python2/3"
pip install bpython virtualenvwrapper --upgrade
pip3 install bpython virtualenvwrapper --upgrade

echo "Configure PHP"
phpenmod php7.0-phalcon
sed 's/#cgi.fix_pathinfo=0/cgi.fix_pathinfo=0' /etc/php/7.0/fpm/php.ini

echo "Turn PHP Short Tags On"
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.0/fpm/php.ini
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.0/cli/php.ini

# Must manually copy these
sudo cp /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/fpm/conf.d/20-phalcon.ini
sudo cp /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/cli/conf.d/20-phalcon.ini

sudo service php7.0-fpm restart

echo "Give the deploy user permissions"
useradd -m $username_deploy
usermod -aG www-data $username_deploy

echo "Give the sudo user permissions"
usermod -aG sudo $username
usermod -aG www-data $username

echo "Give the www-data members permissions in necessary areas"
chmod -R g+rws /usr/local
chmod -R g+rws /var/www

echo "Create SSH folder and authorized_keys for both users"
mkdir /home/$username/.ssh
touch /home/$username/.ssh/authorized_keys
chmod 700 /home/$username/.ssh
chmod 600 /home/$username/.ssh/authorized_keys

mkdir /home/$username_deploy/.ssh
touch /home/$username_deploy/.ssh/authorized_keys
chmod 700 /home/$username_deploy/.ssh
chmod 600 /home/$username_deploy/.ssh/authorized_keys

echo "Generate SSH Keys in a temporary folder to produce a tar.gz to download"
cd $HOME
mkdir -p $HOME/generated_ssh_keys
cd $HOME/generated_ssh_keys

echo "Generate a 4096 bit RSA key for $username"
ssh-keygen -t rsa -b 4096 -f "${username}_rsa"

echo "Generate a 4096 bit RSA key for $username_deploy"
ssh-keygen -t rsa -b 4096 -f "${username_deploy}_rsa"

echo "Correct Permissions for Public and Private keys"
chmod 600 "${username}_rsa"
chmod 644 "${username}_rsa.pub"

chmod 600 "${username_deploy}_rsa"
chmod 644 "${username_deploy}_rsa.pub"

echo "Create a downloadable tar.gz file SSH Keys"
download_file="generated_ssh_keys.tar.gz"
tar -cvzf $download_file $HOME/generated_ssh_keys/*
mv $download_file ..

echo "Move ssh keys to the user folders"
mv "${username}_rsa*" /home/$username/.ssh
mv "${username_deploy}_rsa*" /home/$username_deploy/.ssh

# Remove the no longer needed folder which shortens the tar.gz process
rmdir $HOME/generated_ssh_keys

echo "Adding SSH to authorized keys"
cat "${username}_rsa.pub" >> /home/$username/.ssh/authorized_keys
cat "${username_deploy}_rsa.pub" >> /home/$username_deploy/.ssh/authorized_keys

echo "Updating permissions for both user home folders"
chown -R $username:$username /home/$username/
chown -R $username_deploy:$username_deploy /home/$username_deploy/

server_ip=`curl http://myip.dnsomatic.com`

echo "Please download your generated SSH keys"
echo "Located at: $HOME/$download_file"
echo ""
echo "Using Secure Copy (SCP):"
echo "$ scp $USER@$server_ip:$HOME/$download_file /path/on/your/computer"
echo ""
echo "(!) Once downloaded, remove the tar.gz"
echo "(!) Check that your server is running at: http://$server_ip"

# /
# ------------------------------------------
#  Funcions
# ------------------------------------------
# \
# Verify they do not exist
checkExistsUsername() {
    if id "$1" >/dev/null 2>&1; then
        echo "Error: This user already exists."
        exit
    fi
}

checkValidUsername() {
    # Uses private function _isValidUsername
    if ! (_isValidUsername "$1"); then
        echo "Error: \"$1\" is not a valid username"
    fi
}

_isValidUsername() {
    local re='^[[:lower:]_][[:lower:][:digit:]_-]{2,15}$'
    (( ${#1} > 16 )) && return 1
    [[ $1 =~ $re ]] # The return value of this comparison is used for the function
}
