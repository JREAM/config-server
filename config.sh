#!/bin/bash
#
# This will configure settings for you.
# You can configure them yourself according to the readme.
#
# To run:
#   $ sudo ./config.sh
#
echo $USER
if [[ $USER != "root" ]]; then
    echo "You must run this as the root or sudo."
    exit 1
fi

echo "====================================================================="
echo ""
echo "                        JREAM - Config Server                      "
echo ""
echo " RECOMMENDED: Run 'ppa' first to get the latest goods!"
echo ""
echo " * To exit at anytime press CTRL+C"
echo " * Action runs after command is entered."
echo ""
echo "====================================================================="
echo ""


while true; do
cat <<- command_list
    CMD         PROCESS
    ----        --------------------------------
    ppa         Install PPAs (python-software-properties, git)
    useradd     Add a newuser with: home, bash, and empty ssh folder.
    userdel     Instructions Only
    q           Quit (or CTRL + C)
command_list

echo ""
echo "====================================================================="
echo ""

    read -p "Type a Command: " cmd

    case "$cmd" in
        ppa)
            apt-get install -y python-software-properties
            add-apt-repository ppa:git-core/ppa -y
            apt-get update
            apt-get install git
            echo ""
            echo "====================================================================="
            echo ""
            ;;
        useradd)
            read -p "Enter a username to create [ENTER]: " name

            # Lowercase Answer
            read -p "This will create user: $name with shell: /bin/bash, continue? [Y/n]: " choice
            case "$choice" in
                y|Y )
                echo "Creating User"
                ;;
                n|N )
                    echo "( ! ) Stopping useradd."
                    echo ""
                    continue;
                    ;;
                *)
                    continue;
                    ;;
            esac

            useradd -m -s /bin/bash $name
            passwd $name

            # SSH Folder Permissions
            mkdir /home/$name/.ssh
            chmod 700 /home/$name/.ssh

            # Empty Keys, with correct permissions so you can edit them.
            touch /home/$name/.ssh/id_rsa.pub
            chmod 644 /home/$name/.ssh/id_rsa.pub

            chmod 600 /home/$name/.ssh/id_rsa
            touch /home/$name/.ssh/id_rsa

            touch /home/$name/.ssh/authorized_keys

            echo ""
            echo " (+) The new user: $name, has been created. "
            echo " (+) The default set is shell: $shell "
            echo " (+) The /home/$name has an SSH folder with:"
            echo "     /home/$name/.ssh/id_rsa (empty)"
            echo "     /home/$name/.ssh/id_rsa.pub (empty)"
            echo "     /home/$name/.ssh/authorized_keys (empty)"
            echo "====================================================================="
            echo " Want this a Super User (sudo) ?"
            echo "====================================================================="
            echo " type: visudo, and find this line: "
            echo "       # User privilege specification"
            echo "       Add the following below it:"
            echo "       $name    ALL=(ALL:ALL) ALL"
            echo ""
            echo "====================================================================="
            echo " Want to disable ROOT login?"
            echo "====================================================================="
            echo " edit: /etc/ssh/sshd_config and find this line:"
            echo "       PermitRootLogin yes"
            echo "       PermitRootLogin no"
            echo " Then run: "
            echo "       /etc/init.d/sshd restart"
            echo ""
            echo " ( ! ) IMPORTANT"
            echo "---------------------------------------------------------------------"
            echo " 1) Keep your root terminal open"
            echo " 2) Login with your new user $name "
            echo " 3) Make sure you can run: 'sudo su' with $name"
            echo " 4) If it does not work, undo the above two steps, something is wrong."
            echo "====================================================================="
            ;;
        # usergroup)
        #     usermod -a -G www-data jesse
        #     echo ""
        #     echo "====================================================================="
        #     echo ""
        #     ;;

        userdel)
            echo "====================================================================="
            echo "This is too dangerous to put in a script, please see instructions below:"
            echo ""
            echo " A) Delete USER: $ sudo userdel NAME"
            echo " or "
            echo " B) Delete USER + HOME Folder: $ sudo userdel -r NAME"
            echo "====================================================================="
            ;;

        # hostname)
        #     read -p "Enter a hostname [ENTER]: " hostname
        #     read -p "You entered: $hostname, is this correct? [Y/n]: " choice

        #     case "$choice" in
        #         y|Y )
        #             echo "Editing Hostname to $hostname"
        #         ;;
        #         *)
        #             echo "( ! ) Stopping useradd."
        #             echo ""
        #             continue;
        #             ;;
        #     esac

        #     # Set hostname through command, and debian way for permanance
        #     hostname $hostname
        #     echo > $hostname /etc/hostname

        #     echo ""
        #     echo " ( + ) Your system hostname has been set to: $hostname"
        #     echo "       to see the changes, please logout of SSH and login again."
        #     echo "====================================================================="
        #     echo ""
        #     ;;
        # folderperm)
        #     find /var/www -type d -exec chmod 2775 {} \;
        #     find /var/www -type f -exec chmod ug+rw {} \;
        #     echo ""
        #     echo "====================================================================="
        #     echo ""
        #     ;;
        q)
            exit 1
            ;;
        *)
            echo ""
            echo "    (!) OOPS! You typed a command that's not available."
            echo ""
            echo "====================================================================="
            echo ""

    esac


done
