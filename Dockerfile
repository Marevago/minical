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

# Configure nginx
RUN rm -f /etc/nginx/conf.d/default.conf \
    && rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/sites-available/default

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Create .env from environment variables
RUN echo "DATABASE_HOST=\${DATABASE_HOST}" > .env \
    && echo "DATABASE_USER=\${DATABASE_USER}" >> .env \
    && echo "DATABASE_PASS=\${DATABASE_PASS}" >> .env \
    && echo "DATABASE_NAME=\${DATABASE_NAME}" >> .env \
    && echo "ENVIRONMENT=production" >> .env \
    && echo "PROJECT_URL=https://\${RAILWAY_PUBLIC_DOMAIN}/public" >> .env \
    && echo "API_URL=https://\${RAILWAY_PUBLIC_DOMAIN}/api" >> .env

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/api/application/logs \
    && chmod -R 777 /var/www/html/api/application/cache

# Expose port
EXPOSE 80

# Copy and set up start script
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
