FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurar e instalar extensiones PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql zip gd intl

# Habilitar mod_rewrite para CodeIgniter
RUN a2enmod rewrite

# Configurar el DocumentRoot para apuntar a /var/www/html/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copiar configuración personalizada de Apache
COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer puerto 80
EXPOSE 80

# Script de inicio personalizado
RUN echo '#!/bin/bash\n\
mkdir -p /var/www/html/writable/cache\n\
mkdir -p /var/www/html/writable/logs\n\
mkdir -p /var/www/html/writable/session\n\
mkdir -p /var/www/html/writable/uploads\n\
chown -R www-data:www-data /var/www/html/writable\n\
chmod -R 775 /var/www/html/writable\n\
apache2-foreground' > /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh

# Comando por defecto
CMD ["/usr/local/bin/start.sh"]