#!/bin/bash

echo "=== Starting initialization ==="

echo "Current directory structure:"
ls -la /var/www/html
echo "Public directory:"
ls -la /var/www/html/public

echo "=== Checking PHP-FPM ==="
php-fpm -v

echo "=== Starting PHP-FPM ==="
php-fpm -D

echo "=== Checking nginx configuration ==="
nginx -t

echo "=== Nginx configuration content ==="
cat /etc/nginx/conf.d/default.conf

echo "=== Starting nginx ==="
nginx -g 'daemon off;'
