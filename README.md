# 本地快速启动项目

## 情况说明

在项目根目录下面需要添加`Dockerfile`文件，目前是没有。到时候可以在git仓库更新新代码添加

后端 *ThingsPanel-Go/Dockerfile* 文件内容如下

```Dockerfile
# 拉取基础镜像环境
FROM golang:1.17-alpine

#  时区
RUN apk update && \
    apk add tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

ENV GO111MODULE on
ENV GOPROXY https://mirrors.aliyun.com/goproxy/
WORKDIR  /go/src
COPY  .  .



# 编译程序
RUN go build
# 暴露端口
EXPOSE 9999
# go run ThingsPanel-Go
CMD ["go", "run","ThingsPanel-Go"]
```
前端*ThingsPanel-Backend-Vue/Dockerfile* 文件内容如下

```Dockerfile

# 拉取基础镜像环境
FROM node:16.14-alpine3.14
# 该文件的拥有者
MAINTAINER XXX
#
RUN mkdir -p /opt/web
COPY . /opt/web
WORKDIR /opt/web
# 淘宝镜像
RUN npm i -g cnpm --registry=https://registry.npm.taobao.org
RUN cnpm install -g http-server
RUN cnpm install
RUN cnpm run build
EXPOSE 8080
CMD [ "http-server", "dist" ]
```

> 提醒: 前端在2G内存的linux环境编译可能会存在js v8 内存溢出的问题,环境资源大的话不会报错

## windows 环境

### 环境准备
windows 需要安装 `git` 、`Docker Desktop` 

### 准备项目

```
# 拉取前端项目
git clone https://github.com/ThingsPanel/ThingsPanel-Backend-Vue.git

# 拉取后端项目
git clone https://github.com/ThingsPanel/ThingsPanel-Go.git

# 拉取Gmqtt 项目
git clone https://gitee.com/mirrors/Gmqtt.git

# docker目录【新增】 用于存放docker-compose.yml文件及其他初始化文件
# 目录结构如下
- docker
  - docker-compose.yml
  - init_files  # postgresql 服务启动需要初始化数据库的一些文件脚本
    - init-user-db.sh
    - TP.sql

##############整个项目的结构应该是这样的##############
project
  - ThingsPanel-Backend-Vue
  - ThingsPanel-Go
  - Gmqtt
  - docker
      - docker-compose.yml
      - init_files
          - init-user-db.sh
          - TP.sql
```
 
docker-compose.yml 文件内容

```yml
version: "3.8"
services:
  backend:
    restart: always
    build:
      context: ../ThingsPanel-Go
      dockerfile: Dockerfile
    ports:
      - "9999:9999"
    hostname: backend
    links:
      - gmqtt
      - database

  frontend:
    build:
      context: ../ThingsPanel-Backend-Vue
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    depends_on:
      - backend
    hostname: frontend
    links:
      - backend

  database:
    image: timescale/timescaledb:latest-pg14
    user: postgres
    volumes:
      - ./init_files/init-user-db.sh:/docker-entrypoint-initdb.d/init-user-db.sh
      - ./init_files/TP.sql:/docker-entrypoint-initdb.d/TP.sql
    ports:
      - "5432:5432"
    environment:
      - "LC_ALL=C.UTF-8"
      - "POSTGRES_DB=ThingsPanel"
      - "POSTGRES_USER=postgres"
      - "POSTGRES_HOST=host.docker.internal"
      - "POSTGRES_PASSWORD=postgres"
    hostname: postgres

  gmqtt:
    build:
      context: ../Gmqtt
      dockerfile: Dockerfile
    ports:
      - "1883:1883"

```
init-user-db.sh 文件内容

```shell
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  set time zone 'Asia/Shanghai';
  \c "$POSTGRES_DB"
EOSQL
#CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
```



### 启动服务

```
cd project/docker
# 前台启动项目
docker-compose -f docker-compose-windows.yml up
# 后台启动项目
docker-compose -f docker-compose-windows.yml up -d
# 停止服务
docker-compose -f docker-compose-windows.yml down
```

### 特别说明
- Gmqtt官方默认端口是1883，后端中配置是10000 改了下项目本地的
- Postgresql使用了`timescaledb`扩展官方提供的`timescale/timescaledb:latest-pg14`镜像，所以需要注释`TP.sql`中的2行内容如下 该镜像环境已经有了

```sql
-- CREATE INDEX "ts_kv_ts_idx" ON "ts_kv" USING btree ("ts" DESC);
-- CREATE TRIGGER "ts_insert_blocker" BEFORE INSERT ON "ts_kv" FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
```
- 基于windows的docker-desktop网络配置会有所区别，请参考文档：https://docs.docker.com/desktop/windows/networking/  因此windows项目配置项目需要修改几个地址:

```
# ThingsPanel-Go/conf/app.conf
# 修改 psqladdr = 127.0.0.1
psqladdr = host.docker.internal

# ThingsPanel-Go\modules\dataService\config.yml
# 修改 broker: 127.0.0.1:1883   
broker: host.docker.internal:1883

# ThingsPanel-Backend-Vue\.env.dev || .env.production
# 修改 VUE_APP_BASE_URL = http://127.0.0.1:9999/
# 修改 VUE_APP_WEBSOCKET_URL = ws://127.0.0.1:9999/ws
VUE_APP_BASE_URL = http://host.docker.internal:9999/
VUE_APP_WEBSOCKET_URL = ws://host.docker.internal:9999/ws

```
> 提醒 `host.docker.internal` 这个主机名是在安装 `Docker Desktop` 之后写入到本地`hosts`文件中的


## linux环境

### 环境准备
linux 环境需要安装`git` 、 `docker` 和 `docker-compose` 

### 特别说明
- linux环境我这边没得足够资源环境进行测试，但跟windows环境大同小异，有条件的话可以专门测试下


