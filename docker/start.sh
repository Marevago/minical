#!/bin/bash

# Garantir que os diretórios de logs existam
mkdir -p /var/www/html/api/application/logs
mkdir -p /var/www/html/api/application/cache

# Definir permissões corretas
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/api/application/logs
chmod -R 755 /var/www/html/api/application/cache

# Iniciar PHP-FPM em background
php-fpm -D

# Verificar se o PHP-FPM iniciou corretamente
if [ $? -ne 0 ]; then
    echo "Failed to start PHP-FPM"
    exit 1
fi

# Remover qualquer arquivo de pid antigo do nginx
rm -f /var/run/nginx.pid

# Iniciar Nginx em foreground
nginx -g "daemon off;"
