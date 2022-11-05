FROM mysql:8.0.30

MAINTAINER jinsoo.kim <jjambbongjoa@gmail.com>

COPY my.cnf     /etc/mysql/my.cnf

RUN mkdir -p /docker-volumes/log
RUN chmod 755 /docker-volumes/log

CMD ["mysqld"]