# Gunakan image PHP + Apache
FROM php:8.2-apache

# Install dependency dasar
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy semua file Laravel
COPY . .

# Install dependency Laravel
RUN composer install --no-dev --optimize-autoloader

# Generate cache config
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Expose port
EXPOSE 8080

# Jalankan Laravel pakai artisan serve
CMD php artisan serve --host=0.0.0.0 --port=8080
