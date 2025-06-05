FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli zip

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure nginx
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Configure PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Create directory structure
WORKDIR /var/www/html
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/api/application/logs \
    && chmod -R 755 /var/www/html/api/application/cache

# Start script
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
