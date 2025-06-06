#!/bin/bash

echo "Starting initialization..."

# Garantir que os diretórios de logs existam
echo "Creating log directories..."
mkdir -p /var/www/html/api/application/logs
mkdir -p /var/www/html/api/application/cache
mkdir -p /var/log/nginx

# Definir permissões corretas
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/api/application/logs
chmod -R 755 /var/www/html/api/application/cache
chmod -R 755 /var/log/nginx

# Verificar configuração do nginx
echo "Testing nginx configuration..."
nginx -t

# Iniciar PHP-FPM em background
echo "Starting PHP-FPM..."
php-fpm -D

# Verificar se o PHP-FPM iniciou corretamente
if [ $? -ne 0 ]; then
    echo "Failed to start PHP-FPM"
    exit 1
fi

# Remover qualquer arquivo de pid antigo do nginx
echo "Cleaning up old nginx pid..."
rm -f /var/run/nginx.pid

# Mostrar a configuração atual do nginx
echo "Current nginx configuration:"
cat /etc/nginx/conf.d/default.conf

# Iniciar Nginx em foreground com debug
echo "Starting nginx..."
nginx -g "daemon off; error_log /dev/stderr debug;"
