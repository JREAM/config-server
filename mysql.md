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
