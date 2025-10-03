#!bin/bash

if [ -d "/home/frappe/$BENCH/apps/frappe" ]; then
    echo "Bench already exists, skipping init"
    cd $BENCH
    bench start
else
    echo "Creating new bench..."
fi

export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

bench init --skip-redis-config-generation $BENCH --frappe-branch $FRAPPE_VERSION

cd $BENCH

# Use containers instead of localhost
bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

# Remove redis, watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

# Create site
bench new-site $SITE_NAME \
--force \
--mariadb-root-password $MARIADB_PASSWORD \
--admin-password $ADMIN_PASSWORD \
--no-mariadb-socket

# Install ERPNext
if [ "$INSTALL_ERPNEXT" = 1  ]; then
    echo "Starting ERPNext installation..."
    bench get-app erpnext --branch $FRAPPE_VERSION
    bench --site $SITE_NAME install-app erpnext
else
    echo "Skipping ERPNext installation..."
fi

# Get additional app here
# bench get-app https://github.com/NextServ/custom_app

# bench --site $SITE_NAME install-app custom_app
bench --site $SITE_NAME set-config developer_mode 1
bench --site $SITE_NAME enable-scheduler
bench --site $SITE_NAME clear-cache
bench use $SITE_NAME

bench start
