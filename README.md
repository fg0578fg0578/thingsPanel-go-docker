# 本地快速启动项目

## windows环境准备

- **windows电脑安装 [Docker Desktop](https://www.docker.com/products/docker-desktop)**
- **git**

## linux环境准备 (以下Ubuntu 22.04 LTS)

- **安装docker**

    ```bash
    #dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    #dnf install docker-ce docker-ce-cli containerd.io
    #systemctl start docker.service
    #systemctl enable docker.service
    sudo apt install docker.io
    ```

- **安装docker-compose**

    ```bash
    #curl -L "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    #chmod +x /usr/local/bin/docker-compose
    sudo apt  install docker-compose
    ```

- **如没有安装git**

    ```bash
    dnf install git -y
    ```

- **使用拉取项目**

    ```bash
    # 拉取docker配置
    git clone https://github.com/ThingsPanel/thingsPanel-go-docker.git
    cd thingsPanel-go-docker
    ```
- **当前用户加入docker，并设置不用sudo就可运行**

    ```bash
    # 创建docker组，若已存在则会报错，可跳过
    sudo groupadd docker
    # 将当前用户加入组docker
    sudo gpasswd -a ${USER} docker
    # 重启docker服务(生产环境请慎用)
    sudo systemctl restart docker
    # 添加访问和执行权限
    sudo chmod a+rw /var/run/docker.sock
    ```

- **运行项目**

    > 在`thingsPanel-go-docker`目录下(win需要打开`cmd` 窗口)

    ```bash
    # 以日志显示前台方式启动项目(默认账户和密码 super@super.cn 123456)(默认端口8080)
    docker-compose -f docker-compose.yml up
    # 或者以隐藏日志显示的方式启动项目
    docker-compose -f docker-compose.yml up -d
    # 停止服务
    docker-compose -f docker-compose.yml down
    ```

## 挂载说明

- **查看挂载的卷(后面./的目录为卷)**

    ```bash
    docker volume ls
    docker volume inspect xxx
    thingspanel-go #后端
    thingspanel-html #前端
    thingspanel-postgres #数据库
    ```

- **系统日志、图片等存放目录**

    ```bash
    ./thingspanel-go/files
    ```

- **插件**
    > 无需重启容器

    ```bash
    ./thingspanel-go/extensions
    ```

- **后端代码目录**
    > 可在此处更新和编译代码，编译后重启后端容器

    ```bash
    ./init_files/backend
    ```

- **前端代码目录**
    > 可将vue打包好的文件放在此处，重启前端容器

    ```bash
    ./init_files/html
    ```

## 查看容器运行日志

```bash
docker logs -f containerID
或
./init_files/files/log/
```

## 注意事项

- 端口：

    ```bash
    > 8080（前端服务端口）
    > 9998（tcp端口）
    > 9999（API端口）
    > 1883（mqtt端口）
    > 5432（postogresql端口）
    > 6379（redis端口）
    ```
- 登录

    ```
    输入网址:服务器ip:8080
    输入账户:super@super.cn
    输入密码:123456
    ```
- 设备接入
    http://thingspanel.io/docs/equipment-access/mqtt


## 联系我们

[wiki](http://wiki.thingspanel.cn/index.php?title=%E9%A6%96%E9%A1%B5)

[论坛](http://forum.thingspanel.cn/)

qq群：260150504
