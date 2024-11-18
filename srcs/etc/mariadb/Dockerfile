FROM 	debian:bullseye

# Expose the port
EXPOSE 	3306

# Install the necessary packages
RUN 	apt update -y &&				\
		apt install mariadb-server -y

# Copy the configuration file
COPY 	tools/50-server.cnf	/etc/mysql/mariadb.conf.d/

# Copy the init script
COPY 	tools/init.sh ./

# Give init script exec permissions
RUN 	chmod +x ./init.sh

# Start the init script
ENTRYPOINT [ "./init.sh" ]