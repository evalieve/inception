#!/bin/bash

# Set the working directory
if [ ! -d /run/mysqld ]; then

	if [ ! -d /run/mysqld ]; then
		echo "Initializing MariaDB data directory..."

		# Create the run folder
		mkdir -p	/run/mysqld

		# Change owner and group
		chown -R	mysql:mysql		/run/mysqld
		chown -R	mysql:mysql		/var/lib/mysql
	else
		echo "MariaDB data directory already initialized."
	fi

	# Initialize the database
	if [ ! -d /var/lib/mysql/mysql ]; then
		mysql_install_db
	else
		echo "MariaDB database already initialized."
	fi

	# Set up the database and the user
	echo "Setting up the database and the user..."
	{
		echo "FLUSH PRIVILEGES;"
		echo "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
		echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
		echo "GRANT ALL ON \`$DB_NAME\`.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
		echo "FLUSH PRIVILEGES;"
	} | mysqld --bootstrap

else
	echo "MariaDB data directory already exists."
fi

# Run mariaDB in the foreground
echo "Starting MariaDB..."
echo "MariaDB is ready!"
exec mysqld