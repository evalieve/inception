#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h $DB_HOST --silent;
do
	sleep 1
	echo "Checking..."
done

# Set the working directory
cd /var/www/html

# Install WordPress
if [ -f wp-login.php ]
then
	echo "WordPress is already Downloaded."
else
	echo "Downloading WordPress..."
	wp core download							\
			--path="/var/www/html"				\
			--allow-root
fi

# Create wp-config.php
if [ -f wp-config.php ]
then
	echo "Wordpress is already configured."
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
if wp core is-installed --path="/var/www/html" --allow-root; then
    echo "WordPress is already installed."
else
	echo "Installing WordPress..."
	wp core install 							\
			--path="/var/www/html"				\
			--url=$WP_HTTPS_URL					\
			--title="$WP_TITLE"					\
			--admin_user=$WP_ADMIN_USER			\
			--admin_password=$WP_ADMIN_PASS		\
			--admin_email=$WP_ADMIN_MAIL		\
			--skip-email						\
			--allow-root
fi

# Set up the user
if wp user get $WP_USER --path="/var/www/html" --allow-root > /dev/null 2>&1; then
    echo "User '$WP_USER' already exists."
else
	echo "Setting up the user '$WP_USER'..."
	wp user create $WP_USER $WP_MAIL			\
			--path="/var/www/html"				\
			--user_pass=$WP_PASS				\
			--role=editor						\
			--allow-root
fi

# Activate the theme
ACTIVE_THEME=$(wp theme list --status=active --field=name --path="/var/www/html" --allow-root | tr '[:upper:]' '[:lower:]')

if [ "$ACTIVE_THEME" = "twentytwentythree" ]; then
    echo "The theme 'Twenty Twenty-Three' is already active."
else
	echo "Activating the theme..."
	wp theme activate twentytwentythree			\
			--path="/var/www/html"				\
			--allow-root
fi

# Start PHP-FPM
echo "Executing php-fpm7.4..."
echo "WordPress is ready!"
exec php-fpm7.4 -F -R