<img src="https://github.com/mclitao/openshift/blob/master/docker/docker.jpg?raw=true" alt="" width="600"/>

[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://travis-ci.org/edp963/wormhole.svg?branch=master)](https://travis-ci.org/edp963/wormhole)
[![Coverage Status](https://coveralls.io/repos/github/edp963/wormhole/badge.svg)](https://coveralls.io/github/edp963/wormhole)

## Docker学习笔记
> 来自[litao](https://www.xxx.cn/)[学习笔记](http://xxxxx.cn/)的学习内容

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
    |0|-d|后台执行模式|
    |0|-i|交互|
    |0|-t|分配一个ttyz终端|terminal|
    |0|-P|大P自动开放一个容器端口映射到宿主机|会自动映射本地49000~49900范文内的端口随机端口到容器的端口|
    |0|-p|指定一个容器端口到主机端口|-p|8080:8080|
    |0|-rm|容器运行退出时删除自己|
    |0|-h|给容器指定一个内部hostname|
    |0|--privileged=true|<font color='red'>**__特权模式__**</font>|
    |0|--pid=host|让容器共享主机pid命名空间,在容器内部使用ps\|-ef命令能看到宿主机的程序pid|
    |0|--ipc=host|让容器共享主机ipc命名空间|
    |0|--restart=always|容器退出时总是重启并运行容器,无限次数的尝试|
    |0|--restart=no|退出后不在启动容器，默认的状态。|
    |0|--restart=on-failure|非正常退出非0，才会重新启动容器|
    |0|--restart=on-failure:3|非正常退出，只重试重启动三次。|
    |0|--restart=unless-stopped|在容器退出时重启容器，docker守护启时已经停止的除外。就是不自启动。|
    |0|--volumes-from|让运行的容器引用一个持久卷使用|
    |0|--net=host|使用宿主机全部网路接口|
    |0|--net=none|不使用网络|
    |0|--net=container|多容器公用ip地址|
    |0|--net=bridge|docker默认模式，网桥模式|
    |0|--link|链接2个容器之间网络|
    |0|--expose|开放一个或一组端口|
    |0|--dns|给容器制定一个dns服务器,默认和宿主一致|
    |0|--name|给容器一个外部名字|
    |0|-m|指定可以使用的最大内存|
    |0|--env-file|以文件方式引入一度ENV变量给容器|
    |0|--entrypoint bash|进入容器手动调试，组织默认的命令执行|
    |0|-m|指定可用内存大小|超过时会被系统kill|
    |0|--memory-swap|指定内存转换分区大小|同上|
    |0|--oom-kill-disable=true|禁止宿主机内核杀死这个容器|禁止内核在没有内存时杀死该容器|该项需要和--memory、还有--memory-swap、一起使用不然很危险会出现内存超限问题|
    |0|--cpu-period=100000|
    |0|--cpu-quota=200000|
    |0|--cpuset-cpus="1,3"|指定1和3核心给这个容器|
    
 
 
 
    
      
      
    
  - 3
- **基础命令**
  - 1
  - 2
  - 3
  - 4
- **特殊命令**
  - 1
  - 2
  

## 数据下载

| ID | 文件列表                     | 描述内容 |
|:---|:-----------------------------|:---------|
| 0  |  | |
| 1  |  | |
| 3  |  | |







####md文件的参考例子：
>md是markdown文件格式,是一种可以转换为静态html的文本书写格式。
>https://github.com/BriData/Administrative-divisions-of-China/blob/master/README.md
>https://blog.csdn.net/yanxiangyfg/article/details/74990232
>http://www.mamicode.com/info-detail-2050387.html



**docker常用技巧**
```batch

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


<font color='red'>**清除镜像垃圾**</font>
```batch
  docker版本到1.13.1
  这个命令将清理整个系统，并且只会保留真正在使用的镜像，容器，数据卷以及网络。 
  使用这条命令会带来一些风险： 比如一些备用镜像(用于备份，回滚等)有时候需要用到，如果这些镜像被删除了，则运行容器时需要重新下载。
# docker system prune -a
```

* <font color='red'>**强制全部删除容器**</font>
>> 1.# docker rm -f  $(docker ps -qa) 
>> 2.# docker rmi <镜像名>
>>.3.# docker rm -f  $(docker ps -qa)
 
 
<font color='red'>**进入目标容器的cli交互模式**</font>
```batch
# docker run -it <image name> /bin/bash    
# docker run -it <image name> /bin/sh 
```

<font color='red'>**Docker Volume信息持久卷**</font>
```batch
  查看
# docker volume ls
# docker volume ls -q
  建立一个持久卷vol1
# docker volume create --name vol1
  删除持久卷
# docker volume rm $(docker volume ls -qf dangling=true)
```

<font color='red'>**docker镜像加速**</font>
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



<font color='red'>**配置docker使用限制 容器日志大小等设置**</font>
```batch
# cat /etc/sysconfig/docker
OPTIONS=' --selinux-enabled --insecure-registry=172.30.0.0/16 --log-driver=json-file --log-opt max-size=50m --signature-verification=false'
OPTIONS=' --selinux-enabled --selinux-enabled --log-driver=journald --insecure-registry=172.30.0.0/16 --log-driver=json-file --log-opt max-size=50m --signature-verification=false'
```




编译镜像
# docker build -t dashboardl5:0.1 /root/xCloud/dashboard/
# docker build -t litao/dashboardl5:0.3 /root/xCloud/dashboard/
# docker build -t <仓库名>/<镜像名>:<版本>  /root/xCloud/dashboard/
  
  保存对容器的修改为新的镜像  
  -a, --author="Author" 
  -m, --message="Commit message  "
# docker commit ID <new_image_name>


更换docker 根目录的方法
```batch
修改/etc/docker/daemon.json
"graph":"/opt/docker"
或
mount -o bian /var/lib/docker /opt/docker
或
ln -s /var/lib/docker /opt/docker
```



#LVM2存储[点击查看官网](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#image-layering-and-sharing)
###### Log in to the Docker host you want to configure and stop the Docker daemon.
###### Install the LVM2 package. The LVM2 package includes the userspace toolset that provides logical volume management facilities on linux.
###### Create a physical volume replacing /dev/xvdf with your block device.

	$ systemctl stop docker
	$ pvcreate /dev/xvdf
	$ vgcreate docker /dev/xvdf

###### Create a thin pool named thinpool.
###### In this example, the data logical is 95% of the ‘docker’ volume group size.
###### Leaving this free space allows for auto expanding of either the data or metadata if space runs low as a temporary stopgap.
	$ lvcreate --wipesignatures y -n thinpool docker -l 95%VG
	$ lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
	$ lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta
	$ vim /etc/lvm/profile/docker-thinpool.profile
	activation {
	    thin_pool_autoextend_threshold=80
	    thin_pool_autoextend_percent=20
	}

	$ lvchange --metadataprofile docker-thinpool docker/thinpool

###### If the Docker daemon was previously started, clear your graph driver directory.
###### Clearing your graph driver removes any images, containers, and volumes in your Docker installation.
	$ rm -rf /var/lib/docker/*

###### Configure the Docker daemon with specific devicemapper options.
###### There are two ways to do this. You can set options on the command line if you start the daemon there:
	--storage-driver=devicemapper --storage-opt=dm.thinpooldev=/dev/mapper/docker-thinpool --storage-opt dm.use_deferred_removal=true

###### You can also set them for startup in the daemon.json configuration, for example:
	 {	
	     "storage-driver": "devicemapper",
	     "storage-opts": [
	         "dm.thinpooldev=/dev/mapper/docker-thinpool",
	         "dm.use_deferred_removal=true"
	     ]
	 }
 
 
###### If using systemd and modifying the daemon configuration via unit or drop-in file, reload systemd to scan for changes.
	$ systemctl daemon-reload && systemctl start docker

###### After you start the Docker daemon, ensure you monitor your thin pool and volume group free space.
###### While the volume group will auto-extend, it can still fill up. To monitor logical volumes, 
###### use lvs without options or lvs -a to see tha data and metadata sizes. To monitor volume group free space, use the vgs command.
###### Logs can show the auto-extension of the thin pool when it hits the threshold, to view the logs use:

	$ journalctl -fu dm-event.service



<font color='red'>**===docker-compose安装===**</font>
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