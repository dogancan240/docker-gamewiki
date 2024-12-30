# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary extensions for MongoDB
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev pkg-config libssl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Enable mod_rewrite for Apache (for clean URLs)
RUN a2enmod rewrite

# Copy your project files into the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Set permissions for web server
RUN chown -R www-data:www-data /var/www/html

# Expose the default HTTP port (80)
EXPOSE 80

# Set the default command to start Apache
CMD ["apache2-foreground"]
