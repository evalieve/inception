FROM 	debian:bullseye

EXPOSE 	9000

RUN 	apt update -y

# Install the required packages
RUN 	apt install -y					\
					wget				\
					php7.4-fpm			\
					php7.4-mysql		\
					mariadb-client

# Install WordPress Command Line Interface
RUN 	wget "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

# Copy the php-fpm configuration file
COPY 	tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Make the file executable and move it to the bin directory to use it globally
RUN 	chmod +x wp-cli.phar
RUN 	mv		wp-cli.phar				\
				/usr/local/bin/wp

# Make run dir
RUN 	mkdir -p /run/php

# Copy the script to install WordPress
COPY 	tools/wp-install.sh .
RUN 	chmod +x wp-install.sh

ENTRYPOINT [ "./wp-install.sh" ]