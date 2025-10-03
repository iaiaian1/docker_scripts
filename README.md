# Frappe with ERPNext Docker Setup

This repository provides a customizable Docker-based setup for running Frappe with ERPNext. Follow the instructions below to configure and run the container.

## Prerequisites
- [Git](https://git-scm.com/downloads), [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.
- Basic knowledge of Docker and Frappe/ERPNext.

## Configuration
Customize the `.env` file to suit your needs. Below is an explanation of the environment variables:

- **CONTAINER_NAME**: Name of the Docker container (default: `Frappe with ERPNext`).
- **INSTALL_ERPNEXT**: Set to `1` to install ERPNext, `0` to skip (only for new containers).
- **FRAPPE_VERSION**: Frappe and ERPNext version (supported: `version-15` or `version-14`; `version-13` is no longer supported).
- **BENCH**: Name of the Frappe bench (default: `frappe_bench`).
- **BENCH_HTTP_PORT**: HTTP port for the bench (default: `8000`).
- **BENCH_WS_PORT**: WebSocket port for the bench (default: `9000`).
- **SITE_NAME**: Site name for the Frappe instance (default: `test.localhost`).
- **MYSQL_ROOT_PASSWORD**: MySQL root password (default: `frappe`).
- **MARIADB_PASSWORD**: MariaDB password (default: `frappe`).
- **ADMIN_PASSWORD**: Admin password for the Frappe/ERPNext site (default: `frappe`).

Example `.env` file:
```
CONTAINER_NAME='Frappe with ERPNext'
INSTALL_ERPNEXT=1
FRAPPE_VERSION='version-15'
BENCH='frappe_bench'
BENCH_HTTP_PORT=8000
BENCH_WS_PORT=9000
SITE_NAME='test.localhost'
MYSQL_ROOT_PASSWORD='frappe'
MARIADB_PASSWORD='frappe'
ADMIN_PASSWORD='frappe'
```

## Setup Instructions
1. Clone this repository:
   ```bash:disable-run
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Customize the `.env` file as needed (see above).

3. Start the container:
   ```bash
   docker compose up -d
   ```

4. Access the container to manage or pull the latest changes:
   ```bash
   docker compose exec -it frappe bash
   ```

5. (Optional) Install additional apps:
   - Modify `init.sh` or `init_dev.sh` to include additional apps using:
     ```bash
     bench get-app hrms
     ```
   - Run the modified script inside the container to install the app.

## Accessing the Application
- Once the container is running, access the Frappe/ERPNext site at `http://localhost:<BENCH_HTTP_PORT>` (e.g., `http://localhost:8000`).
- Log in with the admin credentials specified in the `.env` file (default: username `Administrator`, password `frappe`).

## Notes
- Ensure the ports specified in `BENCH_HTTP_PORT` and `BENCH_WS_PORT` are not in use on your host machine.
- To **STOP** the container, run:
  ```bash
  docker compose stop
  ```
- To **DELETE** the container, run:
```bash
docker compose down
```

## Troubleshooting
- If the container fails to start, check the logs:
  ```bash
  docker compose logs frappe
  ```
- Ensure the `.env` file is correctly formatted and all required variables are set.

## Contributing
Feel free to submit issues or pull requests to improve this setup.

## License
This project is licensed under the MIT License.

```