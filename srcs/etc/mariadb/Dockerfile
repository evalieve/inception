FROM 	debian:bullseye

EXPOSE 	3306

RUN 	apt update -y &&				\
		apt install mariadb-server -y

# Copy the config file
COPY 	tools/50-server.cnf				\
		/etc/mysql/mariadb.conf.d/

# Copy the init script
COPY 	tools/init.sh					\
		./

# Give init script exec permissions
RUN 	chmod +x ./init.sh

ENTRYPOINT [ "./init.sh" ]