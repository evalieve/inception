#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h $DB_HOST --silent;
do
	sleep 1
	echo Checking...
done

# Set the working directory
cd /var/www/html

# Install WordPress
if [ -f wp-login.php ]
then
	echo "WordPress is already installed"
else
	echo "Downloading WordPress..."
	wp core download							\
			--path="/var/www/html"				\
			--allow-root
fi

# Create wp-config.php
if [ -f wp-config.php ]
then
	echo "Wordpress is already configured"
else
	echo "Configuring WordPress..."
	wp config create 							\
			--path="/var/www/html"				\
			--dbname=$DB_NAME					\
			--dbuser=$DB_USER					\
			--dbpass=$DB_PASS					\
			--dbhost=$DB_HOST					\
			--allow-root
fi

# Install WordPress
echo "Installing WordPress..."
wp core install 							\
		--path="/var/www/html"				\
		--url=$WP_HTTPS_URL					\
		--title=$WP_TITLE					\
		--admin_user=$WP_ADMIN_USER			\
		--admin_password=$WP_ADMIN_PASS		\
		--admin_email=$WP_ADMIN_MAIL		\
		--skip-email						\
		--allow-root

# Set up the user
wp user create $WP_USER $WP_MAIL			\
		--path="/var/www/html"				\
		--user_pass=$WP_PASS				\
		--role=editor						\
		--allow-root

# Activate the theme
echo "Activating the theme..."
wp theme activate twentytwentythree			\
		--path="/var/www/html"				\
		--allow-root

echo "executing php-fpm7.4..."

# Start PHP-FPM
exec php-fpm7.4 -F -R