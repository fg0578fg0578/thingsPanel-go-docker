# 本地快速启动项目

## windows环境准备
- **windows电脑安装 [Docker Desktop](https://www.docker.com/products/docker-desktop)**
- **git**
## linux环境准备
- **安装docker**
- **安装docker-compose**
- **git**

**第二步 拉取项目**

```

# 拉取docker配置
git clone https://github.com/ThingsPanel/thingsPanel-go-docker.git
cd thingsPanel-go-docker
```


**第三步 运行项目**

> 在`thingsPanel-go-docker`目录下，打开`cmd` 窗口

```

# 前台启动项目
docker-compose -f docker-compose.yml up
# 后台启动项目
docker-compose -f docker-compose.yml up -d
# 停止服务
docker-compose -f docker-compose.yml down
```


## 插件加载

** 插件存放目录 **

> `./init_files/extensions`
> `./init_files/files`

** 防止好插件之后,重新启动项目即可 **
