<img src="https://github.com/mclitao/openshift/blob/master/docker/docker.jpg?raw=true" alt="" width="600"/>

[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://travis-ci.org/edp963/wormhole.svg?branch=master)](https://travis-ci.org/edp963/wormhole)
[![Build Status](https://travis-ci.org/containers/skopeo.svg?branch=master)](https://travis-ci.org/containers/skopeo)
[![Coverage Status](https://coveralls.io/repos/github/edp963/wormhole/badge.svg)](https://coveralls.io/github/edp963/wormhole)




## Docker学习笔记
> 来自[mclitao](https://www.xxx.cn/)[学习笔记](http://xxxxx.cn/)的学习内容

### 笔记目录

- **Docker配置文件表**
  - 
    |ID | 文件列表                              |     描述内容      |
    |:--|:--------------------------------------|:----------------- |
    | 0 |/usr/lib/systemd/system/docker.service | 服务文件位置      |
    | 1 |/lib/systemd/system/docker.socket      |                   |
    | 3 |/etc/sysconfig/docker                  | options选项在这里 |
    | 4 |/etc/sysconfig/docker-storage          | 存储配置               |
    | 5 |/etc/sysconfig/docker-storage-setup    | 存储设置               |
    | 6 |/etc/docker/daemon.json                | 守护配置文件           |
    | 7 |rpm -qc docker                         | docker的全部配置文件   |
   
- **Docker参数表**
   - 
    |ID | 参数 |     描述内容      |
    |:--|:-----|:----------------- |
    |0|-i|交互|
    |1|-t|分配一个ttyz终端|terminal|
    |2|-d|后台执行模式|
    |3|-P|大P自动开放一个容器端口映射到宿主机|会自动映射本地49000~49900范文内的端口随机端口到容器的端口|
    |4|-p|指定一个容器端口到主机端口|-p|8080:8080|
    |5|-h|给容器指定一个内部hostname|
    |6|--name|给容器一个外部名字|
    |7|-rm|容器运行退出时删除自己|
    |8|--privileged=true|<font color='red'>**__```特权模式```__**</font>|
    |9|--pid=host|让容器共享主机pid命名空间,在容器内部使用ps\|-ef命令能看到宿主机的程序pid|
    |10|--ipc=host|让容器共享主机ipc命名空间|
    |11|--restart=always|容器退出时总是重启并运行容器,无限次数的尝试|
    |12|--restart=no|退出后不在启动容器，默认的状态。|
    |13|--restart=on-failure|非正常退出非0，才会重新启动容器|
    |14|--restart=on-failure:3|非正常退出，只重试重启动三次。|
    |15|--restart=unless-stopped|在容器退出时重启容器，docker守护启时已经停止的除外。就是不自启动。|
    |16|--volumes-from|让运行的容器引用一个持久卷使用|
    |17|--net=host|使用宿主机全部网路接口|
    |18|--net=none|不使用网络|
    |19|--net=container|多容器公用ip地址|
    |20|--net=bridge|docker默认模式，网桥模式|
    |21|--link|链接2个容器之间网络|
    |22|--expose|开放一个或一组端口|
    |23|--dns|给容器制定一个dns服务器,默认和宿主一致|
    |24|--env-file|以文件方式引入一度ENV变量给容器|
    |25|--entrypoint bash|进入容器手动调试，组织默认的命令执行|
    |  |下面是资源显示memory和cpu的限制方式|
    |26|-m,--memory|指定可以使用的最大内存，格式是数字加单位，单位可以为 b,k,m,g。最小为 4M|
    |27|--memory-swap|内存+交换分区大小总限制。格式同上。必须必-m设置的大|
    |28|--memory-reservation|内存的软性限制。格式同上|
    |29|--oom-kill-disable|是否阻止 OOM killer 禁止内核在没有内存时杀死该容器 该项需要和--memory、还有--memory-swap、一起使用不然很危险会出现内存超限问题|
    |30|--oom-score-adj|容器被 OOM killer 杀死的优先级，范围是[-1000, 1000]，默认为 0|
    |31|--memory-swappiness|用于设置容器的虚拟内存控制行为。值为 0~100 之间的整数|
    |32|--kernel-memory|核心内存限制。格式同上，最小为 4M|
    |  |如果容器使用了大于 200M 但小于 500M 内存时，下次系统的内存回收会尝试将容器的内存锁紧到 200M 以下<br>docker run -it -m 500M --memory-reservation 200M
     ubuntu:16.04 /bin/bash <br>正确的使用容器的方法：限制容器的内存为 100M 并禁止了 OOM killer： <br>docker run -it -m 100M --oom-kill-disable ubuntu:16.04 /bin/bash||
    |29|--cpu-period=100000||
    |30|--cpu-quota=200000||
    |31|--cpuset-cpus="1,3"|指定1和3核心给这个容器，值可以为 0-3,0,1|
    |32|-c,--cpu-shares=0|CPU 共享权值（相对权重）|
    |33|cpu-period=0|限制 CPU CFS 的周期，范围从 100ms~1s，即[1000, 1000000]|
    |34|--cpu-quota=0|限制 CPU CFS 配额，必须不小于1ms，即 >= 1000|
    |35|--cpuset-mems=|允许在上执行的内存节点（MEMs），只对 NUMA 系统有效|
    |  |<br>第一个容器使用1号cpu的全部时钟，使用改CPU的100%能力<br>$ docker run --rm --name test01 --cpu-cpus 1 --cpu-quota=50000 
    --cpu-period=50000 deadloop:busybox-1. <br>第二个容器 在意一样的参数拉起，这样实际上是2个容器各自用了1号cpu的50%计算力因为时钟轮训间隔周期频率一致<br>$ docker run --rm --name test01 --cpu-cpus 2 --cpu-quota=50000 --cpu-period=50000 deadloop:busybox-1.<br>第三次，我们删了第二个容器再次启动它增加一个-c 2048参数，这样第二个容器就会使用除了自身的计算时间外的其他人的资源共享了他们的2048，导致第一个容器只是用了33%第二个容器使用了65%<br>docker run --rm --name test02 --cpu-cpus 1 --cpu-quota=50000 --cpu-period=50000 -c 2048 deadloop:busybox-1.25.1-glibc<br><br>观察到第一个容器的 CPU 使用率在 33% 左右，第二个容器的 CPU 使用率在 66% 左右。因为第二个容器的共享值是 2048，第一个容器的默认共享值是 1024，所以第二个容器在每个周期内能使用的 CPU 时间是第一个容器的两倍。<br>|

- **基础命令**
  - 
    ```
      查看最后一个启动的容器
    # docker ps -l
     
      停止、启动、重启、杀死、日志
    # docker stop | start | restart | kill | logs <容器>
     
      实时输出类似tail -f    
    # docker logs -ft  <容器>  
    
      显示镜像的历史构造信息
    # docker history  <镜像名>
     
      查看容器内的全部变量ENV内容
    # docker exec 35bd92c228fb env  
    
      查询容器中A增加 、D删除、C改变的文件
    # docker diff <容器>
     
      在容器内运行后台任务 -d 表示是后台任务
    # docker exec -it   <容器名或id>  /bin/bash
    # docker exec 容器名或id touch /etc/new_config_file
    
      查看该容器开放的端口
    # docker port 容器ID
    
      查看容器内部top命令
    # docker top 容器名id 
    
      提取容器ip
    # docker inspect 8cc51037c0dd |grep IPAddress |cut -f4 -d '"'
    
      容器网络地址
    # docker inspect --format='{{.NetworkSettings.IPAddress}}' $CONTAINER_ID
    
      容器持久卷内容
    # docker inspect --format {{.Volums}} Name/id
    
       提取容器名
    # docker inspect -f "{{ .Name }}" 目标容器id
    
       将目标容器的ip和容器id组成 dns解析信息放到dnsmasq文件中做dns解析用
    # docker ps | grep 8cc51037c0dd | awk '{print $1}' | xargs -I{} docker inspect -f '{{.NetworkSettings.IPAddress}} {{.Config.Hostname}}' {} > dnsmasq.hosts
       
       查看容器各种使用状态cpu\mem\net\io
    # docker stats -a ID
      
      查询容器的系统运行的PID
    # PID=$(docker inspect --format {{.State.Pid}} 62d473045406)
    # echo $PID
    
       查看容器内进程
    # ps -aux | grep $PID
    
      清除镜像垃圾，保留一运行的容器镜像 需要docker版本到1.13.1以上
    # docker system prune -a            
      
      查询悬挂类镜像<none> 
    # docker images --filter "dangling=true" 
    # docker images -q --filter "dangling=true"    
    
      删除<none>的悬挂类Images镜像
    # docker rmi $(docker images -q -f dangling=true)
    # docker rmi $(docker images | awk '/^<none>/ { print $3 }')
    # docker rmi $(docker images -q --filter "dangling=true") 
    # docker rmi $(docker images --filter "danling=true" | awk '/^<none>/ { print $3 }')
     
      登录仓库登出
    # docker logout
    # docker login 172.16.5.188 -u admin -p admin
     
      从容器考出
    # docker cp <容器>:/内部目录文件 <本地路径>
    # docker cp 4052fa46c9a9:/spice-html5 /root/spice-html5.tar.gz
      考入容器
    # docker cp spice-html5.tar.gz 4052fa46c9a9:/
   
      修改你要的景象名字为<ip:5000>/imagename:版本
    # docker tag dperson/samba:latest 172.16.5.8:5000/dperson/samba:latest 
      发布docker镜像 到目标服务器  
    $docker push 172.16.5.8:5000/dperson/samba:latest
      
      Save and Load 容器
    # docker save image_name -o file_path 
    # docker save image_name > /home/save.tar 
    # docker load -i file_path 
    # docker load < /home/save.tar
    # docker export 7691a814370e > ubuntu.tar
    # cat ubuntu.tar | docker import - test/ubuntu:v1.0
    # docker import http://example.com/example.tgz example/imagerepo
    ```

- **镜像加速器**
  - 
    ```batch
      请使用你自己的阿里加速源 
    # sudo tee /etc/docker/daemon.json <<-'EOF'
    { 
      "registry-mirrors": ["https://npf9aw3v.mirror.aliyuncs.com"]
    }
    EOF
    # sudo systemctl daemon-reload 
    # sudo systemctl restart docker
    ```
- **清除<none>悬挂镜像**
  - 
    ```batch
      docker版本到1.13.1
      这个命令将清理整个系统，并且只会保留真正在使用的镜像，容器，数据卷以及网络。 
      使用这条命令会带来一些风险： 比如一些备用镜像(用于备份，回滚等)有时候需要用到，如果这些镜像被删除了，则运行容器时需要重新下载。
    # docker system prune -a
    ```
- **强制全部删除容器**
  - 
    ```batch
    # docker rm -f  $(docker ps -qa) 
    # docker rmi <镜像名>
    # docker rm -f  $(docker ps -qa)
    ```
    
 
- **进入目标容器的cli交互模式**
  - 
    ```batch
    # docker run -it <image name> /bin/bash    
    # docker run -it <image name> /bin/sh 
    ```
- **Docker Volume信息持久卷**
  - 
    ```batch
      查看
    # docker volume ls
    # docker volume ls -q
      建立一个持久卷vol1
    # docker volume create --name vol1
      删除持久卷
    # docker volume rm $(docker volume ls -qf dangling=true)
    ```
- **配置docker使用限制 容器日志大小等设置**
  - 
    ```batch
    # cat /etc/sysconfig/docker
    OPTIONS=' --selinux-enabled --insecure-registry=172.30.0.0/16 --log-driver=json-file --log-opt max-size=50m --signature-verification=false'
    OPTIONS=' --selinux-enabled --selinux-enabled --log-driver=journald --insecure-registry=172.30.0.0/16 --log-driver=json-file --log-opt max-size=50m --signature-verification=false'
    ```
- **编译镜像方法**
  - 
    ```batch
    # docker build -t dashboardl5:0.1 /root/xCloud/dashboard/
    # docker build -t litao/dashboardl5:0.3 /root/xCloud/dashboard/
    # docker build -t <仓库名>/<镜像名>:<版本>  /root/xCloud/dashboard/
    ```
- **保存对容器的修改为新的镜像**
  - 
  ```batch
  # docker commit ID <new_image_name>
  参数：
    -a, --author="Author" 
    -m, --message="Commit message"
  ```
- **更换docker 根目录的方法**
  - 
    ```batch
    修改/etc/docker/daemon.json
    "graph":"/opt/docker"
    或
    mount -o bian /var/lib/docker /opt/docker
    或
    ln -s /var/lib/docker /opt/docker
    ```
- **更换docker 驱动为LVM**
  - 
  ```batch
  Docker Storage LVM2驱动[点击查看官网](https://docs.docker
  .com/engine/userguide/storagedriver/device-mapper-driver/#image-layering-and
  -sharing)
  ```
- **docker-compose安装**
  - 
    ```batch
    # 方法一：在线
    $ curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    $ chmod +x /usr/local/bin/docker-compose
    # Linux下等效于
    $ curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose
    
    # 方法二：使用pip安装，版本可能比较旧
    $ yum install python-pip python-dev
    $ pip install docker-compose
    
    # 方法三：作为容器安装
    $ curl -L https://github.com/docker/compose/releases/download/1.8.0/run.sh > /usr/local/bin/docker-compose
    $ chmod +x /usr/local/bin/docker-compose
    
    # 方法四：离线安装
    # wget https://github.com/docker/compose/releases/download/1.8.1/docker-compose-Linux-x86_64
    $ mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
    $ chmod +x /usr/local/bin/docker-compose
    ```