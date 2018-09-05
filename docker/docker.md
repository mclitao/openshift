

**docker 参数**
```batch

  –privileged  特权模式
  --pid=host        让容器共享主机pid命名空间  在容器内部使用ps -ef命令能看到宿主机的程序pid
  --ipc=host        让容器共享主机ipc命名空间
  
  --restart=always  容器退出时总是重启并运行
  --restart=no 退出后不重启动容器
  --restart=on-failure  非正常退出非0，才会重新启动容器
  --restart=on-failure:3 非正常退出，只重试重启动三次。
  --restart=unless-stopped  在容器退出时重启容器，docker守护启时已经停止的除外。就是不自启动。
  
  
  --net=host  使用宿主机全部网路接口
  --net=none  不使用网络
  --net=container 多容器公用ip地址
  --net=bridge docker默认模式，网桥模式
  
  --link  链接2个容器之间网络
  --expose 开放一个或一组端口
  --dns    给容器制定一个dns服务器,默认和宿主一致
  -h       给容器指定一个内部hostname
  --name   给容器一个外部名字
  -m       指定可以使用的最大内存
  --env-file  以文件方式引入一度ENV变量给容器
  --entrypoint bash 进入容器手动调试，组织默认的命令执行
  
  -m 指定可用内存大小 超过时会被系统kill
  --memory-swap  指定内存转换分区大小 同上
  --oom-kill-disable=true  禁止宿主机内核杀死这个容器
  
  --cpu-period=100000 
  --cpu-quota=200000
  --cpuset-cpus="1,3"       指定1和3核心给这个容器
```

**docker常用技巧**
```batch

  查看最后一个启动的容器
# docker ps -l
 
   提取容器ip
# docker inspect 8cc51037c0dd |grep IPAddress |cut -f4 -d '"'

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
  
   强制全部删除容器
# docker rm -f  $(docker ps -qa)

  查询悬挂类镜像<none> 
# docker images --filter "dangling=true" 
# docker images -q --filter "dangling=true"    

  删除<none>的悬挂类Images镜像
# docker rmi $(docker images -q -f dangling=true)
# docker rmi $(docker images | awk '/^<none>/ { print $3 }')
# docker rmi $(docker images -q --filter "dangling=true") 
# docker rmi $(docker images --filter "danling=true" | awk '/^<none>/ { print $3 }')
 
 
  Save and Load 容器
# docker save image_name -o file_path 
# docker save image_name > /home/save.tar 
# docker load -i file_path 
# docker load < /home/save.tar
# docker export 7691a814370e > ubuntu.tar
# cat ubuntu.tar | docker import - test/ubuntu:v1.0
# docker import http://example.com/example.tgz example/imagerepo
 

```

**docker镜像加速**
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

