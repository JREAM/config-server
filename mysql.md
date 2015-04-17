# MySQL

Which config while is used?

    $ which mysqld
    $ /usr/sbin/mysqld --verbose --help | grep -A 1 "Default options"
    
New User with local access

    CREATE USER 'person'@'localhost' IDENTIFIED BY 'any_password';

New User with outside access

    CREATE USER 'person'@'%' IDENTIFIED BY 'any_password';

Grant All Priveleges to Every Database

    GRANT ALL PRIVILEGES ON *.* TO 'person'@'%'

Grant All Priveleges to Specific Database

    GRANT ALL PRIVILEGES ON database_name.* TO 'person'@'%'

Grant Some Priveleges to Specific Database

    GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON database_name.* TO 'person'@'%'
    
Reset Root Password (Easy to use two terminals)

    sudo /etc/init.d/mysqld stop
    sudo service mysql stop
    sudo mysqld_safe --skip-grant-tables &

If you have a `.my.cnf` file lingering around, you are better off just doing:

    sudo su && mysql

Otherwise, carry on this way:

    mysql -u root
    USE mysql;
    UPDATE user SET password=PASSWORD("") where User='root';
    FLUSH privileges;
    QUIT
    
kill all instances of MySQL now

    pkill -f mysql
    
    sudo /etc/init.d/mysql start
    sudo service mysql start
    mysql -u root

## Dump MySQL 
The brackets mean its optional, remove the [ ] if you need it.

    # Long Format
    mysqldump --user=username [--password=password] [--host=host] dbName | gzip > output.sql.gz
    
    # Short Format (The -p must have the password without a space)
    mysqldump -u username [-pPassword] -h localhost dbName | gzip > output.sql.gz

## Import MySQL 

    zcat output.sql.gz | mysql -u username -p dbName
    
## MySQL Script

    WIP

