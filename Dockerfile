FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli zip

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set up directory structure
RUN mkdir -p /var/www/html/public \
    && mkdir -p /var/www/html/api/application/logs \
    && mkdir -p /var/www/html/api/application/cache \
    && chown -R www-data:www-data /var/www/html

# Configure nginx - Remove default config
RUN rm -f /etc/nginx/conf.d/default.conf \
    && rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/sites-available/default

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Configure PHP
COPY docker/php.ini /usr/local/etc/php/php.ini

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Create a test file
RUN echo "<?php phpinfo(); ?>" > /var/www/html/public/info.php \
    && echo "Hello World" > /var/www/html/public/test.html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 80

# Copy and set up start script
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
