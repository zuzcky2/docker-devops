# devOps Docker 환경

#### 이 프로젝트는 Multi language 및 Database 구성을 docker-compose로 묶어 통합 개발환경을 제공합니다.
구성
* Haproxy: SSL 연결 및 HTTP/HTTPS/TCP Proxy, 이중화, Auto-failover
* Anaconda(Python): Jupyter-notebook, FastAPI 기반 개발환경/API
* Nginx: 웹서버 (upstream: php-fpm, anaconda, nodejs)
* MySQL: dual master replication
* MongoDB: replica-set
* php-fpm: Laravel
* Node.js(Vue.js): Vuetify
* Logrotate: 특정용량 기준 특정 스택으로 로그파일 관리

#### jjambbongjoa@gmail.com (김진수)

### clone
```shell
git clone https://github.com/zuzcky2/infra.git {path}
cd {path}/docker
```

### 환경변수 관련파일 생성
이 프로젝트는 3가지 환경이 있습니다.
1. local: 로컬 개발환경
   1. docker/.env.local
2. production_active: 상용 이중화서버 주 환경
   1. docker/.env.production_active
3. production_standby: 사용 이중화서버 보조 환경
   1. docker/.env.production_standby
```shell
bash ./copy-environment.sh
# 실행 후 원하는 환경을 선택 후 진행


[Jinsoo.Kim@IAPI-WORK-STATUS]$ 환경을 선택하세요. (번호 입력)
1) local
2) production_active
3) production_standby

```

### env 세팅
각 환경별로 .env 파일과 설정 파일들을 수정합니다.
* docker/.env
* docker/haproxy/config.cfg
* docker/mongodb/replicaset.js
* docker/mysql/my.cnf
* docker/replication_build.sh
* docker/php/options.ini
* php/.env

### 세팅한 도메인의 호스트 변조
```shell
127.0.0.1       api.example.com
127.0.0.1       manager.example.com
127.0.0.1       static.example.com
127.0.0.1       socket.example.com
127.0.0.1       jupyter.example.com
127.0.0.1       science.example.com
```
* api.*: php(laravel api)
* manager.*: vue.js build 후 dist
* static.*: 이미지 등 캐싱이 필요한 자료 web url 연결
* socket.*: vue serve 개발 hot reload 연결
* jupyter.*: Anaconda 의 jupyter-notebook 연결
* science.*: python의 fastapi 연결

### docker-network
docekr container 내부의 사설망
```shell
cd docker
bash ./__docker-network-setup.sh
```

### certbot letsencrypt SSL
SSL은 AWS의 Route53 기능을 활용하여 자동으로 와일드카드 SSL을 갱신할 수 있습니다.
IAM에서 <code>aws.route53.letsencrypt</code>사용자의 정책 중 아래 두가지의 정책이 허용되어 있어야합니다.
* route53:ListHostedZones
* route53:GetChange


```shell
touch ${__CONFIG_VOLUME__}/aws/credentials
# aws access key, secret 설정

docker-compose up -d --no-deps --build certbot
docker-compose exec certbot sh -c 'sh /var/workspace/docker/certbot-certonly.sh'
```

### install
```shell
bash ./first_time_initialize.sh
# 실행 후 아래 안내들을 진행하세요.

[Jinsoo.Kim@IAPI-WORK-STATUS]$ 환경을 선택하세요. (번호 입력)
1) local
2) production_active
3) production_standby

[Jinsoo.Kim@IAPI-WORK-STATUS]$ 선택한 환경: local
[Jinsoo.Kim@IAPI-WORK-STATUS]$ 도커 인스턴스 빌드를 진행하시겠습니까? (번호 입력)
1) yes
2) no

[Jinsoo.Kim@IAPI-WORK-STATUS]$ mongodb-replicaset 작업을 진행하시겠습니까? 해당 작업은 production_standby 환경에서는 진행하지 않습니다. (번호 입력)
1) yes
2) no

[Jinsoo.Kim@IAPI-WORK-STATUS]$ 웹 빌드를 진행하시겠습니까? (번호 입력)
1) yes
2) no

```

## 실행확인

### haproxy	
[http://example.com:1936/stats](http://example.com:1936/stats)

### vue build page
[https://manager.example.com](https://manager.example.com)

### vue serve(hot reload 개발모드)
```shell
docker-compose exec nodejs sh -c 'yarn serve'
```
[https://socket.example.com](https://socket.example.com)

### PHP Laravel api
[https://api.example.com](https://api.example.com)

### Jupyter Notebook
```shell
docker-compose exec anaconda sh -c 'jupyter notebook list'
# token 확인
```
[https://jupyter.example.com](https://jupyter.example.com)

### Python fastAPI
[https://science.example.com](https://science.example.com)
#### Python fastAPI DOCUMENT
[https://science.example.com/redoc](https://science.example.com/redoc)
