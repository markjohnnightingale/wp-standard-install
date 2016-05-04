#!/bin/bash
# read the options
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
utility=0
# set mn_utility plugin
gitUrl="https://github.com/markjohnnightingale/mn-utility-plugin.git"


# set plugins to install
pluginsToInstall="\
all-in-one-wp-security-and-firewall \
contact-form-7 \
email-address-encoder \
flamingo \
really-simple-captcha \
regenerate-thumbnails \
show-current-template \
wordpress-seo \
wp-better-attachments \
wp-super-cache"

pluginsToActivate="\
contact-form-7 \
email-address-encoder \
flamingo \
really-simple-captcha \
regenerate-thumbnails \
show-current-template \
wordpress-seo \
wp-better-attachments"

while getopts "u" opt; do
    case "$opt" in
    
    u)  utility=1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


# Download Wordpress
# Run script


if hash wp 2>/dev/null; then

    WP-cli installed
    echo "Downloading Wordpress"
    wp core download

    echo "Enter database name"
    read DBNAME
    echo "Enter database user"
    read DBUSER
    echo "Enter database password"
    read -s -p Password: DBPW
    echo "Configuring Wordpress Database"
	wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPW

	# Set URL (if in Sites folder use default)	
	if [[ "$PWD" =~ Sites ]]
	then
		URL="http://$(echo $PWD | sed 's|.*Sites/||').dev:8080"
		echo $URL
	fi
	echo "Enter Site title"
    read STITLE
	echo "Enter admin username name"
    read ANAME
    echo "Enter admin password name"
    read -s -p Password: APWD
    echo "Enter admin email"
    read AEMAIL
    echo "Installing Wordpress"
    wp core install --url=$URL --title="$STITLE" --admin_user="$ANAME" --admin_password="$APWD" --admin_email=$AEMAIL
 #    exit 0;

    echo "Installing plugins"
    wp plugin install $pluginsToInstall

    echo "Activating plugins"
    wp plugin activate $pluginsToActivate

    if [[ $utility == 1 ]]
    	then
    	echo "Cloning mn-utility-plugin from $gitUrl"
    	git clone $gitUrl wp-content/plugins/mn-utility-plugin
    fi

    echo "Finished successfully."
else
	# WP-cli not found
	echo "WP-CLI not found"
    exit 1;
fi


# End of file