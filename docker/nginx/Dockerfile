FROM nginx:1.23.1

MAINTAINER jinsoo.kim <jjambbongjoa@gmail.com>

# -----------------------------------------------------------------------------
### SERVER COMMON Configuration
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime \
 && sed -i -- 's/^# alias/alias/g' /root/.bashrc \
 && sed -i -- 's/^# export/export/g' /root/.bashrc
# -----------------------------------------------------------------------------
### NGINX Configuration
# -----------------------------------------------------------------------------
ADD certbot-cron       /etc/cron.d/certbot-cron
ADD cronjob.sh /

RUN rm -f /etc/nginx/conf.d/*
RUN mkdir /etc/nginx/sites-enabled/
RUN rm -f /etc/nginx/sites-enabled/default

COPY nginx.conf        /etc/nginx/
COPY common            /etc/nginx/common
COPY sites-available   /etc/nginx/sites-available
COPY sites-enabled/http.conf   /etc/nginx/sites-enabled/http.conf
COPY upstream.conf /etc/nginx/conf.d/

WORKDIR /etc/nginx

#CMD ['nginx']
