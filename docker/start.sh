#!/bin/bash

echo "=== Environment Setup ==="
# Substituir variáveis de ambiente no .env
envsubst < .env > .env.tmp && mv .env.tmp .env

echo "=== Environment Check ==="
echo "Current .env file:"
cat .env

echo "=== Directory Structure ==="
ls -la /var/www/html
ls -la /var/www/html/public

echo "=== Creating/Checking Directories ==="
mkdir -p /var/www/html/api/application/logs
mkdir -p /var/www/html/api/application/cache
mkdir -p /var/www/html/public/upload

echo "=== Setting Permissions ==="
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
chmod -R 777 /var/www/html/api/application/logs
chmod -R 777 /var/www/html/api/application/cache
chmod -R 777 /var/www/html/public/upload

echo "=== Starting PHP-FPM ==="
php-fpm -D

echo "=== Nginx Configuration ==="
sed -i "s/\${PORT:-80}/$PORT/g" /etc/nginx/conf.d/default.conf
nginx -t
cat /etc/nginx/conf.d/default.conf

echo "=== Starting Nginx ==="
nginx -g 'daemon off;'
