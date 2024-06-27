FROM nginx:latest

# Copier les certificats et la configuration Nginx
COPY certs/selfsigned.crt /etc/nginx/certs/selfsigned.crt
COPY certs/selfsigned.key /etc/nginx/certs/selfsigned.key
COPY nginx/nginx.conf /etc/nginx/nginx.conf
