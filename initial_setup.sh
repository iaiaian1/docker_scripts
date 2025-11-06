#!bin/bash

# Load local env
source .env

sudo apt-get update -y

# Docker
sudo apt install -y gnome-terminal
sudo apt install -y curl
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker Desktop
curl -L -o docker-desktop-amd64.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb" \
&& sudo apt-get install -y ./docker-desktop-amd64.deb \
&& rm docker-desktop-amd64.deb

# Nginx to proxy
sudo apt install -y nginx

# Mkcert for HTTPS
# sudo apt install -y mkcert
# sudo apt install libnss3-tools
# mkcert -install
# mkcert $SITE_NAME

# Move certificate files to a standard path
# sudo mkdir -p /etc/ssl/$PROJECT_NAME
# sudo mv $SITE_NAME.pem /etc/ssl/$PROJECT_NAME/
# sudo mv $SITE_NAME-key.pem /etc/ssl/$PROJECT_NAME/

# Create config file - HTTPS
# sudo tee /etc/nginx/sites-available/$PROJECT_NAME >/dev/null <<EOF
# server {
#     listen 443 ssl;
#     server_name $HOSTNAME.local;

#     ssl_certificate /etc/ssl/$PROJECT_NAME/$SITE_NAME.pem;
#     ssl_certificate_key /etc/ssl/$PROJECT_NAME/$SITE_NAME-key.pem;

#     location / {
#         proxy_pass http://127.0.0.1:8000;
#         proxy_set_header Host '$host';
#         proxy_set_header X-Real-IP '$remote_addr';
#         proxy_set_header X-Forwarded-For '$proxy_add_x_forwarded_for';
#         proxy_set_header X-Forwarded-Proto '$scheme';
#     }
# }
# EOF
# Create config file - HTTP
sudo tee /etc/nginx/sites-available/$PROJECT_NAME >/dev/null <<EOF
server {
   listen 80;
   server_name $HOSTNAME.local;

   location / {
       proxy_pass http://127.0.0.1:8000;
       proxy_set_header Host \$host;
       proxy_set_header X-Real-IP \$remote_addr;
       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto \$scheme;
   }
}
EOF
# Enable the config
sudo ln -sf /etc/nginx/sites-available/$PROJECT_NAME /etc/nginx/sites-enabled/

# Test and restart Nginx
sudo nginx -t && sudo systemctl restart nginx

# Avahi daemon for external access
sudo apt install avahi-daemon
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
