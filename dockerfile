# Use the official PHP image with FPM
FROM php:5.6-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libxml2-dev \
    libsqlite3-dev \
    sqlite3 \
    nginx \
    git \
    curl \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_sqlite mbstring mcrypt dom session

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose ports
EXPOSE 8000

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm