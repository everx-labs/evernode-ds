FROM jwilder/nginx-proxy:0.8.0
#FROM jwilder/nginx-proxy:latest

RUN sed -i 's/worker_connections  .*;/worker_connections  10240;/' /etc/nginx/nginx.conf
RUN apt update && \
    apt install -y net-tools iproute2 watch vim && \
    rm -rf /var/lib/apt/lists/*
