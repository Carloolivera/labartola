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
<<<<<<< HEAD
    && rm -rf /var/lib/apt/lists/*

# Configurar extensiones de PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Instalar extensiones de PHP
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    zip \
    gd \
    opcache \
    intl

# Configurar OPcache para desarrollo (con revalidación automática)
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=256'; \
    echo 'opcache.interned_strings_buffer=16'; \
    echo 'opcache.max_accelerated_files=20000'; \
    echo 'opcache.revalidate_freq=0'; \
    echo 'opcache.validate_timestamps=1'; \
    echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache.ini

# Configurar realpath cache para mejor performance
RUN { \
    echo 'realpath_cache_size=4096K'; \
    echo 'realpath_cache_ttl=600'; \
    echo 'max_execution_time=300'; \
    echo 'max_input_time=300'; \
    echo 'memory_limit=512M'; \
    echo 'upload_max_filesize=100M'; \
    echo 'post_max_size=100M'; \
} > /usr/local/etc/php/conf.d/custom.ini

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Configurar Apache para usar el directorio public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Agregar configuración de directorio
RUN echo '<Directory /var/www/html/public/>' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Options Indexes FollowSymLinks' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf && \
    echo '</Directory>' >> /etc/apache2/sites-available/000-default.conf

# Configurar ServerName para evitar warnings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Exponer puerto 80
EXPOSE 80
=======
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
>>>>>>> 51028a9be6c3ff3512e51dcc6885d422e227cd31
