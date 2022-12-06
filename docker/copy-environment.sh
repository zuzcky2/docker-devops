#!/usr/bin/env bash

# @author jinsoo.kim <jjambbongjoa@gmail.com>

MSG_COLOR="\033[1;32m"
MSG_RESET="\033[0m"
MSG_PREFIX="${MSG_COLOR}[Jinsoo.Kim@IAPI-WORK-STATUS]$ ${MSG_RESET}"

echo -e "${MSG_PREFIX}환경을 선택하세요. (번호 입력)"
select environment_mode in "local" "production_active" "production_standby"
do
  echo -e "${MSG_PREFIX}선택한 환경: $environment_mode"
  break
done

if [ ! -f .env ]; then
    cp ".env.example.$environment_mode" .env
    echo -e "${MSG_PREFIX}.env 생성 완료\n"
fi

if [ ! -f docker-compose.yml ]; then
    cp "docker-compose-$environment_mode.yml" docker-compose.yml
    echo -e "${MSG_PREFIX}docker-compose.yml 생성 완료\n"
fi

if [ ! -f haproxy/config.cfg ]; then
    cp "haproxy/config_$environment_mode.cfg" haproxy/config.cfg
    echo -e "${MSG_PREFIX}haproxy/config.cfg 생성 완료\n"
fi

if [ $environment_mode != 'production_standby' ]
then
	if [ ! -f mongodb/replicaset.js ]; then
      cp "mongodb/replicaset_$environment_mode.js" mongodb/replicaset.js
      echo -e "${MSG_PREFIX}mongodb/replicaset.js 생성 완료\n"
  fi
fi

if [ ! -f mysql/my.cnf ]; then
    cp "mysql/my_$environment_mode.cnf" mysql/my.cnf
    echo -e "${MSG_PREFIX}mysql/my.cnf 생성 완료\n"
fi

if [ ! -f mysql/replication_build.sh ]; then
    cp "mysql/replication_build_$environment_mode.sh" mysql/replication_build.sh
    echo -e "${MSG_PREFIX}mysql/replication_build.sh 생성 완료\n"
fi

if [ ! -f php-fpm/options.ini ]; then
    cp "php-fpm/options_$environment_mode.ini" php-fpm/options.ini
    echo -e "${MSG_PREFIX}php-fpm/options.ini 생성 완료\n"
fi

if [ ! -f ../php/.env ]; then
    cp "../php/.env.example" ../php/.env
    echo -e "${MSG_PREFIX}../php/.env 생성 완료\n"
fi
