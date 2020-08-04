FROM jwilder/nginx-proxy:latest

RUN sed -i 's/worker_connections  .*;/worker_connections  10240;/' /etc/nginx/nginx.conf