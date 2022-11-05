#!/usr/bin/env bash

# @author jinsoo.kim <jjambbongjoa@gmail.com>
MSG_COLOR="\033[1;32m"
MSG_RESET="\033[0m"
MSG_PREFIX="${MSG_COLOR}[Jinsoo.Kim@IAPI-WORK-STATUS]$ ${MSG_RESET}"

echo -e "${MSG_PREFIX}서비스 빌드 가능성 검사 시작..\n"
if [ ! -f .env ]; then
    echo "${MSG_PREFIX}#ERROR .env 파일이 존재하지않습니다."
    exit
fi
if [ ! -f docker-compose.yml ]; then
    echo "${MSG_PREFIX}#ERROR docker-compose.yml 파일이 존재하지않습니다."
    exit
fi
if [ ! -f haproxy/config.cfg ]; then
    echo "${MSG_PREFIX}#ERROR haproxy/config.cfg 파일이 존재하지않습니다."
    exit
fi
if [ ! -f mysql/my.cnf ]; then
    echo "${MSG_PREFIX}#ERROR mysql/my.cnf 파일이 존재하지않습니다."
    exit
fi
if [ ! -f mysql/replication_build.sh ]; then
    echo "${MSG_PREFIX}#ERROR mysql/replication_build.sh 파일이 존재하지않습니다."
    exit
fi
if [ ! -f php-fpm/options.ini ]; then
    echo "${MSG_PREFIX}#ERROR php-fpm/options.ini 파일이 존재하지않습니다."
    exit
fi
echo -e "${MSG_PREFIX}서비스 빌드 가능성 검사 통과\n"

source .env

echo -e "${MSG_PREFIX}docker network 세팅 시작...\n"
bash ./__docker-network-setup.sh
echo -e "${MSG_PREFIX}docker network 세팅 완료\n"

DIRECTORY="${__CONFIG_VOLUME__}/php-fpm"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}/session
    chmod 707 ${DIRECTORY}/session
    mkdir -p ${DIRECTORY}/laravel/sessions
    chmod 707 ${DIRECTORY}/laravel/sessions
    mkdir -p ${DIRECTORY}/laravel/views
    chmod 707 ${DIRECTORY}/laravel/views
    mkdir -p ${DIRECTORY}/laravel/cache/data
    chmod 707 ${DIRECTORY}/laravel/cache/data
fi

echo -e "${MSG_PREFIX}log, data 디렉토리 세팅 시작...\n"

DIRECTORY="${__DIST_VOLUME__}"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}
    chmod 707 ${DIRECTORY}
    chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__LOG_VOLUME__}/nginx"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}
    chmod 707 ${DIRECTORY}
    chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__LOG_VOLUME__}/anaconda"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}
    chmod 707 ${DIRECTORY}
    chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__DATA_VOLUME__}/php-fpm"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}
    chmod 707 ${DIRECTORY}
    chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__LOG_VOLUME__}/mongodb"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}
      chmod 777 ${DIRECTORY}
      chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__DATA_VOLUME__}/mongodb"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}/db
    chmod 707 ${DIRECTORY}/db
    chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__LOG_VOLUME__}/mysql"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}
      chmod 707 ${DIRECTORY}
      chown $USER:$USER ${DIRECTORY}
fi

DIRECTORY="${__DATA_VOLUME__}/mysql"
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ${DIRECTORY}/db
    chmod 707 ${DIRECTORY}/db
    chown $USER:$USER ${DIRECTORY}
fi

echo -e "${MSG_PREFIX}log, data 디렉토리 세팅 완료\n"

echo -e "${MSG_PREFIX}environment 결합작업 시작...\n"

export MONGO_INITDB_ROOT_USERNAME
export MONGO_INITDB_ROOT_PASSWORD
export MONGO_INITDB_DATABASE
export MONGO_INITDB_USERNAME
export MONGO_INITDB_PASSWORD
export MONGO_INITDB_HOST
export MONGO_INITDB_PORT

export SERVER_NAME
export WEB_SERVER_NAME
export API_SERVER_NAME
export STATIC_SERVER_NAME
export SOCKET_SERVER_NAME
export JUPYTER_SERVER_NAME
export SCIENCE_SERVER_NAME
export WEB_URL
export API_URL
export STATIC_URL
export SOCKET_URL
export JUPYTER_URL
export SCIENCE_URL
export __OPEN_WEB_PORT__
export NODEJS_ENV
export NODEOPEN_ENV
export FIXED_MASTER_TOKEN
export JUPYTER_NOTEBOOK_PASSWORD


export __HAPROXY_HTTP__
export __HAPROXY_HTTPS__
export __CONTAINER_ROOT__
export __CONFIG_VOLUME__
export STATS_USER
export STATS_PASS
export ACTIVE_IP
export STANDBY_IP
export MONGO_ARBITER_IP
export THIS_NAME
export OTHER_NAME

sh -c 'cat ${__CONFIG_VOLUME__}/certbot/lib/live/${SERVER_NAME}/fullchain.pem ${__CONFIG_VOLUME__}/certbot/lib/live/${SERVER_NAME}/privkey.pem \
 > ${__CONFIG_VOLUME__}/certbot/lib/live/${SERVER_NAME}/ssl.pem'

envsubst '${SERVER_NAME} ${WEB_SERVER_NAME} ${API_SERVER_NAME} ${STATIC_SERVER_NAME} ${SCIENCE_SERVER_NAME} \
${SOCKET_SERVER_NAME} \
${WEB_URL} ${API_URL} ${STATIC_URL} ${SOCKET_URL} ${SCIENCE_URL} \
${__OPEN_WEB_PORT__} ${NODEJS_ENV} ${FIXED_MASTER_TOKEN}' < ../nodejs/.env.example > ../nodejs/.env

envsubst '${SERVER_NAME} ${WEB_SERVER_NAME} ${API_SERVER_NAME} ${STATIC_SERVER_NAME} ${SCIENCE_SERVER_NAME} \
${SOCKET_SERVER_NAME} ${JUPYTER_SERVER_NAME} \
${WEB_URL} ${API_URL} ${STATIC_URL} ${SOCKET_URL} ${SCIENCE_URL} ${JUPYTER_URL} \
${__CONTAINER_ROOT__}' < nginx/sites-available/http.conf > nginx/sites-enabled/http.conf

if [ $__OPEN_WEB_PORT__ == ':443' ]
then
	__OPEN_WEB_PORT__=''
fi

envsubst '${__HAPROXY_HTTP__} ${__HAPROXY_HTTPS__} ${__OPEN_WEB_PORT__} \
${SERVER_NAME} ${WEB_SERVER_NAME} ${API_SERVER_NAME} ${STATIC_SERVER_NAME} ${SOCKET_SERVER_NAME} ${SCIENCE_SERVER_NAME} \
${JUPYTER_SERVER_NAME} \
${MONGO_INITDB_HOST} ${MONGO_INITDB_PORT} ${STATS_USER} ${STATS_PASS} \
${ACTIVE_IP} ${STANDBY_IP} ${THIS_NAME} ${OTHER_NAME}' < haproxy/config.cfg > haproxy/haproxy.cfg

envsubst '${MONGO_INITDB_ROOT_USERNAME} ${MONGO_INITDB_ROOT_PASSWORD} ${MONGO_INITDB_DATABASE} \
${MONGO_INITDB_USERNAME} ${MONGO_INITDB_PASSWORD}' < mongodb/user_db_add_default.sh > mongodb/user_db_add.sh

echo -e "${MSG_PREFIX}environment 결합작업 완료\n"

echo -e "${MSG_PREFIX}서비스 인스턴스 빌드 시작...\n"

docker-compose up --build -d

echo -e "${MSG_PREFIX}서비스 인스턴스 빌드 완료\n"
echo -e "${MSG_PREFIX}php-fpm log, storage, config 권한 작업 시작...\n"

docker-compose exec php-fpm sh -c 'chown $USER:$USER /var/workspace/log -R && chmod 777 /var/workspace/log -R'

docker-compose exec php-fpm sh -c 'chown $USER:$USER /var/workspace/config -R && chmod 777 /var/workspace/config -R'

docker-compose exec php-fpm sh -c 'chown $USER:$USER /var/workspace/php/storage -R && chmod 777 /var/workspace/php/storage -R'

echo -e "${MSG_PREFIX}php-fpm log, storage, config 권한 작업 완료\n"

