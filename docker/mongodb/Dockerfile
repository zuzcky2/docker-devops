FROM mongo:6.0.2

MAINTAINER jinsoo.kim <jjambbongjoa@gmail.com>

# -----------------------------------------------------------------------------
### SERVER COMMON Configuration
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime \
 && sed -i -- 's/^# alias/alias/g' /root/.bashrc \
 && sed -i -- 's/^# export/export/g' /root/.bashrc
# -----------------------------------------------------------------------------
RUN mkdir /home/mongodb && chmod 777 /home/mongodb && chown mongodb:mongodb /home/mongodb
ADD mongod.conf /etc/mongod.conf
COPY replica.key /data/replica.key
RUN chown mongodb:mongodb /data/replica.key && chmod 400 /data/replica.key

CMD ["mongod", "-f", "/etc/mongod.conf"]