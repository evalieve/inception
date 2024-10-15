#!/bin/bash

if [ ! -d /run/mysqld ]; then

	# Create the run folder
	mkdir -p	/run/mysqld

	# Change owner and group
	chown -R	mysql:mysql		/run/mysqld
	chown -R	mysql:mysql		/var/lib/mysql

	mysql_install_db

	# Set up the database and the user
	{
		echo "FLUSH PRIVILEGES;"
		echo "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
		echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
		echo "GRANT ALL ON \`$DB_NAME\`.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
		echo "FLUSH PRIVILEGES;"
	} | mysqld --bootstrap

fi

# Run mariaDB in the foreground
exec mysqld