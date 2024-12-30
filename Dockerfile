# Use an official PHP image with Apache and necessary extensions
FROM php:8.1-apache

# Install system dependencies and MongoDB extension
RUN apt-get update && apt-get install -y \
    libssl-dev \
    git \
    unzip \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy composer and install dependencies
COPY composer.json composer.lock /var/www/html/
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

# Copy the application code
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose the port for the web server
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
