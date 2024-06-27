#!/bin/bash

# Mettre à jour les paquets
apt-get update -y
apt-get -y full-upgrade
apt-get install -y docker.io openssl

# Assurer que Docker démarre au démarrage
systemctl enable docker
systemctl start docker

# Créer les dossiers nécessaires
mkdir -p /home/vagrant/certs
mkdir -p /home/vagrant/nginx

# Générer le certificat auto-signé
openssl req -newkey rsa:2048 -nodes -keyout /home/vagrant/certs/selfsigned.key -x509 -days 365 -out /home/vagrant/certs/selfsigned.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=92.174.88.93"

# Créer la configuration Nginx
cat <<EOF > /home/vagrant/nginx/nginx.conf
events {
  worker_connections 1024;
}

http {
  server {
    listen 80;
    server_name 92.174.88.93;

    location / {
      return 301 https://\$host\$request_uri;
    }
  }

  server {
    listen 443 ssl;
    server_name 92.174.88.93;

    ssl_certificate /etc/nginx/certs/selfsigned.crt;
    ssl_certificate_key /etc/nginx/certs/selfsigned.key;

    location / {
      root /usr/share/nginx/html;
      index index.html;
    }
  }
}
EOF

# Construire et lancer le conteneur Nginx avec la configuration et les certificats
docker build -t custom-nginx /home/vagrant
docker run --name nginx --restart=always -d -p 443:443 -p 80:80 custom-nginx
