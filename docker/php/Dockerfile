# Delivery App - PHP 8.4 Backend Dockerfile
# Purpose: Production-ready PHP environment with Apache, security extensions, and optimizations

FROM php:8.4-apache

LABEL maintainer="DeliveryApp Team"
LABEL version="1.0"

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for the delivery app
RUN docker-php-ext-install \
    pdo_mysql \
    mysqli \
    mbstring \
    exif \
    pcntl \
    bcmath \
    zip \
    intl \
    opcache

# Install Redis extension for caching
RUN pecl install redis && docker-php-ext-enable redis

# Install APCu for in-memory caching
RUN pecl install apcu && docker-php-ext-enable apcu

# Configure GD extension for image processing (restaurant/food photos)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install Composer (PHP dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy custom PHP configuration
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Enable Apache modules
RUN a2enmod rewrite headers ssl

# Copy Apache virtual host configuration
COPY docker/apache/delivery-app.conf /etc/apache2/sites-available/delivery-app.conf
RUN a2dissite 000-default.conf && a2ensite delivery-app.conf

# Set permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Security: Run as non-root user
USER www-data

# Expose port 80 (HTTP) and 443 (HTTPS)
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Default command
CMD ["apache2-foreground"]
