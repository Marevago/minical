#!/bin/bash

echo "=== Environment Information ==="
echo "PORT: $PORT"
echo "PWD: $(pwd)"
echo "Directory contents:"
ls -la

# Substituir a porta no nginx
echo "=== Configuring Nginx ==="
sed -i "s/\${PORT:-80}/$PORT/g" /etc/nginx/conf.d/default.conf

echo "=== Starting PHP-FPM ==="
php-fpm -D

echo "=== Nginx Configuration ==="
nginx -t
cat /etc/nginx/conf.d/default.conf

echo "=== Starting Nginx ==="
nginx -g 'daemon off;'
