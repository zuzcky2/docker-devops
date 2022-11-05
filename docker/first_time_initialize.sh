#!/usr/bin/env bash

# @author jinsoo.kim <jjambbongjoa@gmail.com>

MSG_COLOR="\033[1;32m"
MSG_RESET="\033[0m"
MSG_PREFIX="${MSG_COLOR}[Jinsoo.Kim@IAPI-WORK-STATUS]$ ${MSG_RESET}"

source ./copy-environment.sh

echo -e "${MSG_PREFIX}도커 인스턴스 빌드를 진행하시겠습니까? (번호 입력)"
select environment_build in "yes" "no"
do
  echo -e "${MSG_PREFIX}선택: $environment_build"
  break
done

if [ $environment_build == 'yes' ]
then

  source .env

	bash ./docker-run.sh

	if [ $environment_mode == 'production_active' ] || [ $environment_mode == 'production_standby' ]
  then

  	echo -e "${MSG_PREFIX}mysql-replication 작업을 진행하시겠습니까? 해당 작업을 진행할 경우 바라보는 상대 서버에서도 진행해야합니다. (번호 입력)"
    select environment_replication in "yes" "no"
    do
      echo -e "${MSG_PREFIX}선택: $environment_replication"
      break
    done
    if [ $environment_replication == 'yes' ]
    then
      sleep 2
      docker-compose exec mysql sh -c 'cd /var/workspace/docker && bash ./replication_build.sh'
      echo -e "${MSG_PREFIX}mysql replication 완료\n"
      echo -e "${MSG_PREFIX}mysql-replication 작업을 완료했습니다\n"

    fi

  fi

  if [ $environment_mode != 'production_standby' ]
  then

    echo -e "${MSG_PREFIX}mongodb-replicaset 작업을 진행하시겠습니까? 해당 작업은 production_standby 환경에서는 진행하지 않습니다. (번호 입력)"
    select environment_replicaset in "yes" "no"
    do
      echo -e "${MSG_PREFIX}선택: $environment_replicaset"
      break
    done

    if [ $environment_replicaset == 'yes' ]
    then

      echo -e "${MSG_PREFIX}mongodb 빌드 10초 대기..."
      sleep 10
      echo -e "${MSG_PREFIX}mongodb replication 완료\n"

      docker-compose exec mongodb sh -c 'cd /var/workspace/docker && bash ./mongodb_replicaset.sh'

      docker-compose exec mongodb sh -c 'cd /var/workspace/docker && bash ./user_db_add.sh'

      echo -e "${MSG_PREFIX}mongodb user 생성완료\n"
      echo -e "${MSG_PREFIX}mongodb-replicaset 작업을 완료했습니다\n"

    fi

  fi

fi

echo -e "${MSG_PREFIX}웹 빌드를 진행하시겠습니까? (번호 입력)"
select environment_web in "yes" "no"
do
  echo -e "${MSG_PREFIX}선택: $environment_web"
  break
done

if [ $environment_web == 'yes' ]
then

  bash ./web_build.sh

fi

echo -e "${MSG_PREFIX}mysql 빌드 10초 대기..."
sleep 10
docker-compose exec mysql sh -c 'cd /var/workspace/docker && bash ./user_add.sh'
echo -e "${MSG_PREFIX}mysql replication user 생성완료\n"
echo -e "${MSG_PREFIX}mysql replication 시작...\n"

echo -e "${MSG_PREFIX}완료되었습니다.\n"
exit 0

