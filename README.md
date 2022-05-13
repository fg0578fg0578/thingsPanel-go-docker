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

> 在`thingsPanel-go-docker`目录下(win需要打开`cmd` 窗口)

```

# 以日志显示前台方式启动项目
docker-compose -f docker-compose.yml up
# 或者以隐藏日志显示的方式启动项目
docker-compose -f docker-compose.yml up -d
# 停止服务
docker-compose -f docker-compose.yml down
```


## 插件加载

**插件存放目录**

- `./init_files/extensions`

**系统日志、图片等存放目录**

- `./init_files/files`

**更换插件无需重启容器**

**后端代码目录,可在此处更新和编译代码，编译后重启后端容器**

- `./init_files/backend`

**前端代码目录,可将vue打包好的文件放在此处，重启前端容器**

- `./init_files/html`

## 查看日志

```
docker logs -f containerID
或
./init_files/files/log/
```
