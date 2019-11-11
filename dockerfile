FROM python:3.7

LABEL maintainer="Joe Bryan <joe@sinelabs.com>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    systemd \
    nginx \
    nano \
    apt-utils \
    default-mysql-client \
    default-libmysqlclient-dev \
    supervisor && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

RUN rm -rf /etc/nginx/sites-enabled/default
RUN rm -rf /etc/nginx/sites-available/default
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/sites-available/default.conf
COPY nginx/sosapp.live.conf /etc/nginx/sites-available/sosapp.conf
COPY nginx/qsapp.live.conf /etc/nginx/sites-available/qsapp.conf
COPY nginx/marut.live.conf /etc/nginx/sites-available/marut.conf
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
RUN ln -sf /etc/nginx/sites-available/sosapp.conf /etc/nginx/sites-enabled/sosapp.conf
RUN ln -sf /etc/nginx/sites-available/qsapp.conf /etc/nginx/sites-enabled/qsapp.conf
RUN ln -sf /etc/nginx/sites-available/marut.conf /etc/nginx/sites-enabled/marut.conf
RUN mkdir /var/www/certbot

RUN [ -f /etc/ssl/certs/dhparam.pem ] || openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 4096

# Disable nginx upstart/systemd
RUN update-rc.d -f nginx remove
RUN rm -rf /etc/init/nginx.conf && rm -rf /etc/init.d/nginx

# Add uwsgi.ini into /etc/uwsgi after creating directory
RUN mkdir /etc/uwsgi
RUN mkdir /var/log/uwsgi
RUN mkdir /var/log/uwsgi/app
RUN chmod a+w -R /var/log/uwsgi/app/
COPY wsgi/*.ini /etc/uwsgi/

COPY supervisord.conf /etc/supervisord.conf

WORKDIR /var/www/

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]