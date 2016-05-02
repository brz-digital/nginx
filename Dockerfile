FROM brzdigital/ubuntu

MAINTAINER "Joao Paulo Barbosa" <jpaulobneto@gmail.com>

WORKDIR /tmp

RUN apt-get update -y

# Install nginx
RUN apt-get install nginx -y \
  && rm -rf /var/lib/apt/lists/*

# Apply Nginx configuration
ADD config/nginx.conf /opt/etc/nginx.conf
ADD config/laravel /etc/nginx/sites-available/laravel
RUN ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/laravel && \
    rm /etc/nginx/sites-enabled/default

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Nginx startup script
ADD config/nginx-start.sh /opt/bin/nginx-start.sh
RUN chmod u=rwx /opt/bin/nginx-start.sh

RUN mkdir -p /data
VOLUME ["/data"]

EXPOSE 80 443
WORKDIR /opt/bin
ENTRYPOINT ["/opt/bin/nginx-start.sh"]
