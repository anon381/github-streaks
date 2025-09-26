# Use the official PHP image with Apache
FROM php:8.2-apache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Install system dependencies for PHP extensions and tools
RUN apt-get update -y && \
	apt-get install -y libicu-dev libzip-dev unzip git && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP intl extension
RUN docker-php-ext-install intl
# Install PHP zip extension
RUN docker-php-ext-install zip

# Set working directory
WORKDIR /var/www/html
# Copy the entire project into the container
COPY . .
# Install dependencies
RUN composer install --no-dev --no-interaction --optimize-autoloader

# Copy all project files to the Apache document root
COPY src/ /var/www/html/

# Enable Apache mod_rewrite (optional, for pretty URLs)
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
