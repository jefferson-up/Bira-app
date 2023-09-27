FROM php:8.2-fpm

# Instalar dependências
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    curl

# Configurar extensões do PHP
RUN docker-php-ext-install pdo_mysql zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Definir diretório de trabalho
WORKDIR /var/www

# Copiar aplicação para o container
COPY . /var/www

# Instalar dependências do projeto
RUN composer install --no-dev

# Ajustar permissões
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www

# Expor porta 9000
EXPOSE 9000
