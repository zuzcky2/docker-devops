#!/usr/bin/env bash

# @author jinsoo.kim <jjambbongjoa@gmail.com>

MSG_COLOR="\033[1;32m"
MSG_RESET="\033[0m"
MSG_PREFIX="${MSG_COLOR}[Jinsoo.Kim@IAPI-WORK-STATUS]$ ${MSG_RESET}"

source .env

echo -e "${MSG_PREFIX}mongodb backup을 진행합니다. 진행하시겠습니까?"
select mongo_try in "yes" "no"
do
  echo -e "${MSG_PREFIX}선택: $mongo_try"
  break
done

if [ $mongo_try == 'yes' ]
then
  docker-compose stop mongodb
  docker-compose exec mongodb sh -c 'rm -rf /var/workspace/docker/mongo_backup'
  docker-compose exec mongodb sh -c 'mongodump --out /var/workspace/docker/mongo_backup --host 127.0.0.1 --port 27017 -u "root" -p "database12!@" --authenticationDatabase "admin" --db cloud'
  docker-compose exec mongodb sh -c 'mongodump --out /var/workspace/docker/mongo_backup --host 127.0.0.1 --port 27017 -u "root" -p "database12!@" --authenticationDatabase "admin" --db eload'

  sudo rm -rf ../storage/data/mongodb

  docker-compose up -d --build mongodb

  if [ ${THIS_NAME} == 'active' ]
  then
    echo -e "${MSG_PREFIX}mongodb 빌드 10초 대기..."
    sleep 10
    echo -e "${MSG_PREFIX}mongodb replication 완료\n"

    docker-compose exec mongodb sh -c 'cd /var/workspace/docker && bash ./mongodb_replicaset.sh'

    docker-compose exec mongodb sh -c 'cd /var/workspace/docker && bash ./user_db_add.sh'

    echo -e "${MSG_PREFIX}mongodb user 생성완료\n"
    echo -e "${MSG_PREFIX}mongodb-replicaset 작업을 완료했습니다\n"

    echo -e "${MSG_PREFIX}mongodb 데이터 import 진행...\n"
    docker-compose exec mongodb sh -c 'mongorestore --host 127.0.0.1 --port 27017 -u "root" -p "database12!@" --authenticationDatabase "admin" --db cloud /var/workspace/docker/mongo_backup/cloud'
    docker-compose exec mongodb sh -c 'mongorestore --host 127.0.0.1 --port 27017 -u "root" -p "database12!@" --authenticationDatabase "admin" --db eload /var/workspace/docker/mongo_backup/eload'
    echo -e "${MSG_PREFIX}mongodb 데이터 import 완료\n"
  fi

fi

