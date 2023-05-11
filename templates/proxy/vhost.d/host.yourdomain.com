## Start of configuration add by letsencrypt container
location ^~ /.well-known/acme-challenge/ {
    auth_basic off;
    auth_request off;
    allow all;
    root /usr/share/nginx/html;
    try_files $uri =404;
    break;
}
## End of configuration add by letsencrypt container

location /graphql {
      proxy_http_version 1.1;
      proxy_pass http://q-server/graphql;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host $host;
      proxy_read_timeout 7200;
      proxy_buffering off;
      add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
}

location /arangodb {
      auth_basic "Restricted Content";
      auth_basic_user_file /etc/nginx/.htpasswd;
      proxy_pass http://arangodb:8529/;
      proxy_set_header X-Script-Name /arangodb;
}

location /_db {
      auth_basic "Restricted Content";
      auth_basic_user_file /etc/nginx/.htpasswd;
      proxy_pass http://arangodb:8529/_db;
      proxy_set_header X-Script-Name /arangodb;
}

location /metrics {
      proxy_http_version 1.1;
      proxy_pass http://statsd:9102/metrics;
      proxy_set_header Host $host;
      proxy_read_timeout 7200;
      proxy_buffering off;
}
