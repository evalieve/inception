# Inception - 42 Project

## Table of Contents

1. [Introduction](#introduction)
2. [Goal of the Project](#goal-of-the-project)
3. [Setup and Workflow](#setup-and-workflow)
4. [Directory Structure](#directory-structure)
5. [Components and Their Purpose](#components-and-their-purpose)
    - [MariaDB Service](#mariadb-service)
    - [WordPress Service](#wordpress-service)
    - [NGINX Service](#nginx-service)
    - [Volumes and Networks](#volumes-and-networks)
6. [How to Compile and Run the Project](#how-to-compile-and-run-the-project)
7. [Security and Best Practices](#security-and-best-practices)
8. [Key Concepts Applied](#key-concepts-applied)

<br>

---

# Introduction

The Inception project is designed to expand knowledge in **system administration** and **containerization using Docker**. By building a small, robust infrastructure from scratch, it demonstrates how to manage multiple services in a secure and efficient manner. The project emphasizes configuring, building, and running Docker images manually while adhering to best practices and specific constraints.

<br>

---

# Goal of the Project

- **The project aims to set up an infrastructure consisting of**:
    - A **MariaDB database** container for storing WordPress data.
    - A **WordPress container** with PHP-FPM for serving dynamic content.
    - An **NGINX container** for managing HTTPS traffic.
    - **Two persistent volumes** to store WordPress website files and MariaDB data.
    - A **Docker network** to ensure secure communication between containers.

<br>

- **The process involves**:
    - Creating custom Dockerfiles for each service.
    - Configuring a secure NGINX setup using TLSv1.2 or TLSv1.3.
    - Utilizing environment variables to enhance security and flexibility.
    - Managing all services with Docker Compose for simplicity and maintainability.

<br>

---

# Setup and Workflow

1. **Preparation**: 
    - All configuration files are placed in a [`srcs`](srcs) folder for better organization.
    - Environment variables are stored securely in a `.env` file.
    - A local domain is configured to point to the machine's IP address for easy access.

2. **Dockerfiles**: 
    - Each service (MariaDB, WordPress, NGINX) is implemented with its own Dockerfile, ensuring modularity and adherence to containerization principles.

3. **Docker Compose**:
    - The  [`docker-compose.yml`](srcs/docker-compose.yml) file defines services, dependencies, networks, and volumes to orchestrate the containers.

4. **Makefile Automation**:
    - Tasks such as building, starting, stopping, and cleaning containers are automated using a Makefile.

5. **TLS Security**:
    - A self-signed SSL certificate is generated to secure connections to the infrastructure.

6. **Volumes and Networks**:
    - Persistent volumes are used for MariaDB and WordPress data, ensuring durability.
    - A dedicated Docker network isolates and secures container communication.

<br>

---

# Directory Structure:
  ``` plaintext
      .
      ├── Makefile
      ├── .env
      ├── .gitignore
      ├── srcs
      │   ├── compose.yml
      │   ├── etc
      │   │   ├── mariadb
      │   │   │   ├── Dockerfile
      │   │   │   ├── tools
      │   │   │       ├── init.sh
      │   │   │       ├── 50-server.cnf
      │   │   ├── wordpress
      │   │   │   ├── Dockerfile
      │   │   │   ├── tools
      │   │   │       ├── wp-install.sh
      │   │   │       ├── www.conf
      │   │   ├── nginx
      │   │       ├── Dockerfile
      │   │       ├── tools
      │   │           ├── default.conf

  ```


<br>

---



# Components and Their Purpose


### Summary of Key Features

- Each Dockerfile installs only the necessary packages for its service, keeping the containers lightweight.
- Configuration files and scripts use environment variables to ensure flexibility and security.
- Services are designed to work together seamlessly through the Docker network.

<br>

---

### MariaDB Service:

- **Purpose**:
  Handles the database operations for WordPress.
    - The Dockerfile installs the MariaDB server and prepares the necessary configurations.
    - The `init.sh` script initializes the database, creates users, and sets permissions using environment variables.
    - The custom configuration file (`50-server.cnf`) fine-tunes database settings and binds the service to the internal Docker network.
 
- **Dockerfile**:
  - **Path**: [`srcs/etc/mariadb/Dockerfile`](srcs/etc/mariadb/Dockerfile)
  - **Description**: 
    - Defines the MariaDB container by installing the database server.
    - Copies the configuration and initialization scripts into the container.
    - Exposes port 3306 for database connections.

- **Configuration File**:
  - **Path**: [`srcs/etc/mariadb/tools/50-server.cnf`](srcs/etc/mariadb/tools/50-server.cnf)
  - **Description**: 
    - Customizes MariaDB settings, such as binding to the internal Docker network and ensuring case-insensitive table names.

- **Initialization Script**:
  - **Path**: [`srcs/etc/mariadb/tools/init.sh`](srcs/etc/mariadb/tools/init.sh)
  - **Description**: 
    - Sets up the database, creates necessary users, and initializes MariaDB on container startup.

<br>

---

### WordPress Service:

- **Purpose**:
  Hosts the WordPress application and processes dynamic content.
  - The Dockerfile installs PHP-FPM, WordPress CLI, and other necessary dependencies.
  - The wp-install.sh script automates the installation and configuration of WordPress, including user and admin setup.

- **Dockerfile**:
  - **Path**: [`srcs/etc/wordpress/Dockerfile`](srcs/etc/wordpress/Dockerfile)
  - **Description**: 
    - Sets up a PHP-FPM environment for running WordPress.
    - Includes WordPress CLI for automated installation and configuration.
    - Exposes port 9000 for PHP processing.

- **PHP-FPM Configuration**:
  - **Path**: [`srcs/etc/wordpress/tools/www.conf`](srcs/etc/wordpress/tools/www.conf)
  - **Description**: 
    - Configures PHP-FPM to handle incoming requests dynamically, optimizing performance.

- **WordPress Installation Script**:
  - **Path**: [`srcs/etc/wordpress/tools/wp-install.sh`](srcs/etc/wordpress/tools/wp-install.sh)
  - **Description**: 
    - Automates the setup of WordPress, including downloading the application, generating `wp-config.php`, and creating admin and user accounts.


<br>

---

### NGINX Service:

- **Purpose**:
  Manages incoming HTTPS traffic and routes it to the WordPress container.
    - The Dockerfile installs NGINX and OpenSSL for secure communication.
    - An SSL certificate is generated and applied for HTTPS.
    - The default.conf file configures NGINX to route requests to the WordPress service and ensures secure handling of files and scripts.

- **Dockerfile**:
  - **Path**: [`srcs/etc/nginx/Dockerfile`](srcs/etc/nginx/Dockerfile)
  - **Description**: 
    - Configures NGINX as a reverse proxy for HTTPS.
    - Generates a self-signed SSL certificate for secure communication.
    - Exposes port 443 for HTTPS traffic.

- **NGINX Configuration**:
  - **Path**: [`srcs/etc/nginx/tools/default.conf`](srcs/etc/nginx/tools/default.conf)
  - **Description**: 
    - Configures NGINX to route requests to the WordPress container on port 9000.
    - Implements HTTPS and blocks access to sensitive files.

<br>

---

### Volumes and Networks
- **Volumes**:
    - A volume stores MariaDB database files persistently to prevent data loss.
    - A second volume stores WordPress website files for persistent access and updates.
- **Network**:
    - A dedicated Docker network ensures secure and isolated communication between services without exposing internal connections.

<br>

---

# How to Compile and Run the Project
1. **Cloning the Repository**:
      ``` bash
      git clone https://github.com/example/inception.git
      cd inception
      ```

<br>

2. **Setting Up Environment Variables**:

   The `.env` file is a critical part of the setup as it stores sensitive information such as domain details, database credentials, and configuration variables. To maintain security, these values are excluded from version control using `.gitignore`.

   A template `.env` file with all the required keys but without values is provided to ensure consistency.

   - **Locate the Template**:
     A file named [`.env.template`](./.env.template) is included in the repository. This template contains all the necessary keys with placeholder values.

    - **Copy the Template**:
      Duplicate the .env.template file to create a new .env file in the same directory:

         ```bash
            cp .env.template .env
         ```

    - **Fill in the Values**:
      Open the newly created .env file, remove the comment and replace the placeholder values with the actual configuration values.

      For example:
        ```env
                DB_HOST=mariadb
                DB_NAME=wordpress
                DB_USER=wp-user
                DB_PASS=secure-password
                
                WP_TITLE=My WordPress Site
                WP_HTTPS_URL=https://example.com
                WP_ADMIN_USER=admin
                WP_ADMIN_PASS=strongpassword
                WP_ADMIN_MAIL=admin@example.com
                WP_USER=editor
                WP_MAIL=editor@example.com
                WP_PASS=editorpassword
                
                DOMAIN=example.com
        ```

<br>

3. **Using the Makefile**:

   The Makefile automates common tasks for managing the Docker environment. Below is a list of available commands and their purposes.
    - **Build and Start Containers**: 
      > This is the default target. It builds the Docker images and starts the containers in detached mode.
        ``` bash
        make
        ```

    - **Start the Containers**: 
      > Starts the containers defined in docker-compose.yml in detached mode. If the containers are not already built, it will build them first.
        ``` bash
        make up
        ```

    - **Build the Containers**:
      > Builds the Docker images defined in the docker-compose.yml file without starting the containers.
        ``` bash
        make build
        ```

    - **Stop and Remove the Containers**:
      > Stops and removes the running containers, including volumes and orphaned containers, to ensure a clean environment.
        ``` bash
        make down
        ```

    - **Show Container Status**:
      > Displays the status of all containers managed by the docker-compose.yml file.
        ``` bash
        make ps
        ```
        
    - **View Logs**:
      > Shows the logs for all services defined in the docker-compose.yml file. Useful for debugging and monitoring.
        ``` bash
        make logs
        ```
        
    - **Rebuild and Restart Containers**:
      > A shortcut to stop (make down), rebuild, and restart (make up) the containers. Useful for applying changes.
        ``` bash
        make re
        ```

    - **Access the NGINX Container**:
      > Executes an interactive bash session inside the running NGINX container. Use this for debugging or inspecting the NGINX setup.
        ``` bash
        make it
        ```

    - **Clean Up Docker Resourcest**:
      > Performs a system-wide cleanup of Docker resources, including unused images, containers, networks, and volumes.
        ``` bash
        make prune
        ```


<br>

4.  **Accessing the Application**:
The WordPress website is accessible through the configured domain over HTTPS.


<br>

---


# Security and Best Practices
- **Environment Variables**:
  - Sensitive data is stored in the .env file and excluded from version control via .gitignore.

- **TLS Encryption**:
  - HTTPS using TLSv1.2 or TLSv1.3 ensures secure communication between the client and the server.

- **Container Restart Policies**:
  - Containers are configured to restart automatically in case of failures.

- **Dedicated Networks**:
  - The Docker network isolates services to prevent unauthorized access.

<br>

---

# Key Concepts Applied
- **Dockerization**: Each service is encapsulated in its own Docker container for modularity and isolation.
- **Automation**: Routine tasks are automated using Makefile and Docker Compose.
- **Security**: Implementation of HTTPS, environment variables, and isolated networks enhances overall security.
- **Networking**: The Docker network enables secure communication between services without public exposure.



