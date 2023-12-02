FROM php:8.2.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libgif-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions with GD and Intl support
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql exif pcntl bcmath gd zip intl

# Get the latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a system user to run Composer and Artisan Commands
ARG user
ARG uid
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set the working directory
WORKDIR /var/www/html

USER $user
