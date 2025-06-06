#!/bin/bash

echo "=== Environment Setup ==="
# Criar novo arquivo .env com as variáveis do ambiente, usando as variáveis MYSQL_*
cat > /var/www/html/.env << EOF
DATABASE_HOST=${MYSQLHOST}
DATABASE_USER=${MYSQLUSER}
DATABASE_PASS=${MYSQLPASSWORD}
DATABASE_NAME=${MYSQL_DATABASE}

ENVIRONMENT=production

PROJECT_URL=https://${APP_URL}
API_URL=https://${API_URL}

# AWS info (opcional, pode deixar vazio por enquanto)
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_S3_BUCKET=

# SMTP info (opcional, pode deixar vazio por enquanto)
SMTP_USER=
SMTP_PASS=
SMTP_HOST=
SMTP_PORT=
SMTP_CRYPTO=

# Captcha info (opcional, pode deixar vazio por enquanto)
RECAPTCHA_SITE_KEY=
RECAPTCHA_SECRET_KEY=
EOF

echo "=== Environment Check ==="
echo "Current .env file:"
cat /var/www/html/.env

echo "=== Database Connection Test ==="
php -r "
\$host='${MYSQLHOST}';
\$user='${MYSQLUSER}';
\$pass='${MYSQLPASSWORD}';
\$db='${MYSQL_DATABASE}';
echo \"Testing connection to MySQL (\$host)...\n\";
\$conn = new mysqli(\$host, \$user, \$pass, \$db);
if (\$conn->connect_error) {
    die(\"Connection failed: \" . \$conn->connect_error);
} 
echo \"Database connection successful!\n\";
\$conn->close();
"

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

echo "=== PHP Info ==="
php -v
php -m

echo "=== Starting PHP-FPM ==="
php-fpm -D

echo "=== Nginx Configuration ==="
sed -i "s/\${PORT:-80}/$PORT/g" /etc/nginx/conf.d/default.conf
nginx -t
cat /etc/nginx/conf.d/default.conf

echo "=== Starting Nginx ==="
exec nginx -g 'daemon off;'
