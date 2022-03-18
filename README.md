# 本地快速启动项目

## windows环境
**第一步 windows电脑安装 [Docker Desktop](https://www.docker.com/products/docker-desktop) 和 [git](https://git-scm.com/)**

傻瓜式安装这里不做赘述

**第二步 拉取项目**

```
# 拉取前端项目
git clone https://github.com/ThingsPanel/ThingsPanel-Backend-Vue.git

# 拉取后端项目
git clone https://github.com/ThingsPanel/ThingsPanel-Go.git

# 拉取Gmqtt 项目
git clone https://gitee.com/mirrors/Gmqtt.git

# 拉取docker配置
git clone git@github.com:ThingsPanel/thingsPanel-go-docker.git

```

**第三步 拷贝文件到项目目录下**

```
thingsPanel-go-docker\Dockerfile_backend   -----> ThingsPanel-Go\

thingsPanel-go-docker\Dockerfile_frontend  -----> ThingsPanel-Backend-Vue\

thingsPanel-go-docker\Dockerfile_gmqtt  -----> Gmqtt\ 

```

**第四步 更改项目配置**

```
# 1.修改 Gmqtt\cmd\gmqttd\default_config.yml
- address: ":1883"   # 修改前
- address: ":10000"  # 修改后


# 2.修改 ThingsPanel-Backend-Vue\.env.dev 跟 .env.production
# 修改后地址如下
VUE_APP_BASE_URL=http://localhost:9999/
VUE_APP_WEBSOCKET_URL=ws://localhost:9999/ws

# 3.修改 ThingsPanel-Go\conf\app.conf 文件配置如下
psqladdr = 172.19.0.4

# 4.修改 ThingsPanel-Go\modules\dataService\config.yml
broker: 172.19.0.5:10000
```

**第五步 运行项目**

> 在`thingsPanel-go-docker`目录下，打开`cmd` 窗口

```

# 前台启动项目
docker-compose -f docker-compose.yml up
# 后台启动项目
docker-compose -f docker-compose.yml up -d
# 停止服务
docker-compose -f docker-compose.yml down
```

