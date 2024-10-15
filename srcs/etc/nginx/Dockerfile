FROM	debian:bullseye

EXPOSE	443

# Install nginx
RUN 	apt update -y &&				\
		apt install -y nginx &&			\
		apt install -y openssl

# Copy the config file
COPY 	tools/default.conf				\
		/etc/nginx/conf.d/

# Generate the SSL certificate
RUN 	openssl req													\
			-x509													\
			-nodes													\
			-days		365											\
			-newkey		rsa:2048									\
			-subj		"/CN=${DOMAIN}"								\
			-keyout		"/etc/ssl/private/nginx-selfsigned.key"		\
			-out		"/etc/ssl/certs/nginx-selfsigned.crt"

# Make nginx run in the foreground to keep the container running
ENTRYPOINT 	[ "nginx", "-g", "daemon off;" ]