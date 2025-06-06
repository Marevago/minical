#!/bin/bash

echo "Starting initialization..."

# Create test file
echo "Creating test file..."
echo "Server is running" > /var/www/html/public/test.html
chmod 644 /var/www/html/public/test.html

# Create and set permissions for directories
echo "Setting up directories..."
mkdir -p /var/www/html/public
mkdir -p /var/www/html/api/application/logs
mkdir -p /var/www/html/api/application/cache
mkdir -p /var/log/nginx

# Set permissions
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm -D

# Check PHP-FPM
echo "Checking PHP-FPM status..."
ps aux | grep php-fpm

# Remove old nginx pid if it exists
rm -f /var/run/nginx.pid

# Start nginx
echo "Starting nginx..."
exec nginx -g 'daemon off;'
