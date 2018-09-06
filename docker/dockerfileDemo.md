

# DockerFile的例子
```batch
INSTRUCTION argument指令不区分大小写。但是，命名约定为全部大写
所有Dockerfile都必须以FROM命令开始。 FROM命令会指定镜像基于哪个基础镜像创建，接下来的命令也会基于这个基础镜像。
FROM命令可以多次使用，表示会创建多个镜像。具体语法如下：
FROM <image name>

FROM centos   基于centos这个镜像来构建

MAINTAINER <author name>  镜像作者

RUN 《command》

ADD：复制文件指令。它有两个参数<source>和<destination>。destination是容器内的路径。source可以是URL或者是启动配置上下文中的一个文件
ADD <src> <destiantion>
 
CMD：提供了容器默认的执行命令。 Dockerfile只允许使用一次CMD指令。 使用多个CMD会抵消之前所有的指令，只有最后一个指令生效。 CMD有三种形式：
CMD ["executable","param1","param2"]
CMD ["param1","param2"]
CMD command param1 param2

EXPOSE：指定容器在运行时监听的端口
EXPOSE <port>

ENTRYPOINT：配置给容器一个可执行的命令，这意味着在每次使用镜像创建容器时一个特定的应用程序可以被设置为默认程序。同时也意味着该镜像每次被调用时仅能运行指定的应用。类似于CMD，Docker只允许一个ENTRYPOINT，多个ENTRYPOINT会抵消之前所有的指令，只执行最后的ENTRYPOINT指令。语法如下：
ENTRYPOINT ["executable","param1","param2"]
ENTRYPOINT command param1 param2

WORKDIR：指定RUN、CMD与ENTRYPOINT命令的工作目录
WORKDIR /path/to/workdir

ENV 设置环境变量，它们使用键值对，增加运行程序的灵活性
ENV <key> <value>

USER :镜像运行时设置一个UID
USER <uid>

VOLUME : 授权访问从容器内到主机上的目录
VOLUME ['/data']

```


>Dockerfile创建支持ssh服务自启动的容器镜像
```batch

[root@docker]# vim /etc/docker/Dockerfile
[root@docker docker]# cat Dockerfile 
#选择一个镜像作为基础
FROM docker.io/centos:6
#作者信息
MAINTAINER jie Yang "jie@163.com"
#安装的软件包 
RUN yum install -y openssh-server sudo
#Centos7.2无需此项：
#RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
#添加用户并设置sudo

RUN echo "123456" |passwd --stdin root
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
RUN useradd admin
RUN echo "admin:admin" | chpasswd
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers
#centos6必须有，否则无法登录 
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
#Centos7：
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

#ADD authorized_keys /root/.ssh/authorized_keys
#ADD run.sh /run.sh
#RUN chmod 755 /run.sh

#创建锁文件
RUN mkdir /var/run/sshd
#指定端口
EXPOSE 22
#启动sshd
CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/run.sh"]
############################################
# cat run.sh
#!/bin/bash
/usr/sbin/sshd -D


启动httpd:
CMD ["/usr/sbin/apachectl","-D","FOREGROUND"]

```


*************************************************
>Redis demo 
```batch
 FROM centos:7
 MAINTAINER Jay.yang <zxf668899@163.com>
 
 RUN yum -y install gcc gcc-c++ make wget \
 	&& cd /opt \
 	&& curl http://download.redis.io/releases/redis-3.0.3.tar.gz|tar zx \
         && wget https://github.com/zxf668899/PHP-Nginx/blob/master/NoSql/redis.conf \
         && cd redis-3.0.3 && make && make install \
         && mkdir -p /usr/local/redis/etc \
 	&& mv /opt/redis.conf /usr/local/redis/etc \
 	&& yum -y remove gcc make wget \
         && yum clean all \
         && rm -rf /tmp/* /opt/* /var/cache/{yum,ldconfig}
 
 EXPOSE 6379
 CMD ["/usr/local/bin/redis-server","/usr/local/redis/etc/redis.conf"]
 
```
*************************************************
> PHP & Nginx 
```batch 
FROM centos:7.2
MAINTAINER allone

RUN yum -y install \
        apr-devel apr-util-devel cmake \
        gcc gcc-c++ GeoIP GeoIP-devel libtool \
        perl-devel perl-ExtUtils-Embed make \
        wget \
        && cd /opt \
        && wget http://10.2.229.10/Nginx-PHP7-SourcePackage.tar.gz \
        && tar zxf Nginx-PHP7-SourcePackage.tar.gz \
        && cd Nginx-PHP7-SourcePackage \
        && ./docker-install.sh \
        && yum -y remove gcc cmake make wget iptables \
        && yum clean all \
        && rm -rf /tmp/* /opt/* /var/cache/{yum,ldconfig}

EXPOSE 80
CMD ["./entrypoint.sh"]
```

> Nginx 
```batch
 # ./nginx -t
 ./nginx: error while loading shared libraries: libprofiler.so.0: cannot open shared object file: No such fil
 e or directory
 # ldd nginx 
 	linux-vdso.so.1 =>  (0x00007ffdef7f4000)
 	libdl.so.2 => /lib64/libdl.so.2 (0x00007faca4ae5000)
 	libpthread.so.0 => /lib64/libpthread.so.0 (0x00007faca48c9000)
 	libcrypt.so.1 => /lib64/libcrypt.so.1 (0x00007faca4691000)
 	libprofiler.so.0 => not found     ##《《《《《《
 	libc.so.6 => /lib64/libc.so.6 (0x00007faca42cf000)
 	/lib64/ld-linux-x86-64.so.2 (0x00007faca4cee000)
 	libfreebl3.so => /lib64/libfreebl3.so (0x00007faca40cb000)
 ln -s /usr/local/lib/libprofiler.so /lib64/libprofiler.so.0		

```

> centos7 php demo
```batch
FROM centos:7.2
MAINTAINER Jay.yang <zxf668899@163.com>

RUN yum -y install \
        apr-devel apr-util-devel cmake \
        gcc gcc-c++ GeoIP GeoIP-devel libtool \
        perl-devel perl-ExtUtils-Embed make \
        && cd /opt \
        && curl http://10.2.229.10/php-one.tar.gz|tar zx \
        && cd php-one \
        && ./docker-php.sh \
        && yum -y remove gcc cmake make \
        && yum clean all \
        && rm -rf /tmp/* /opt/* /var/cache/{yum,ldconfig}

CMD ["/usr/local/php/sbin/php-fpm"]
 
```

>centos 7 Demo1
```batch
FROM centos:7
MAINTAINER jie.yang <"zxf668899@163.com">

RUN yum -y install wget && \
		wget https://github.com/zxf668899/Docker_nginx/blob/master/ssdb.tar.gz && \
		tar zxf ssdb.tar.gz -C /usr/local/
        mv ssdb /usr/local && \
        mkdir /etc/ssdb && mkdir /var/lib/ssdb && \
        cp /usr/local/ssdb/ssdb-server /usr/bin && \
        mv /usr/local/ssdb/ssdb.conf /etc/ssdb && \
        yum -y remove tar curl vim-minimal

EXPOSE 8888
CMD ["/usr/local/ssdb/ssdb-server","/etc/ssdb/ssdb.conf"]
```

> centos7 Demo2
```batch
FROM centos:7
MAINTAINER jie.yang <"zxf668899@163.com">

RUN yum update -y && \
  yum -y install --setopt=tsflags=nodocs make wget which autoconf unzip gcc gcc-c++ && \
  wget --no-check-certificate https://github.com/ideawu/ssdb/archive/master.zip && \
  unzip master.zip && \
  cd ssdb-master && \
  make && make install && \
  cd .. && \
  yum -y erase vim-minimal unzip wget tar gcc gcc-c++ make which autoconf && \
  yum clean all && \
  rm -rf ssdb-master master.zip /var/lib/yum/* /tmp/* /var/tmp/* && \
  mkdir /etc/ssdb && \
  mkdir /etc/ssdb/var && \
  mv /usr/local/ssdb/ssdb.conf /etc/ssdb/

EXPOSE 8888
VOLUME [/usr/local/ssdb, /etc/ssdb]
ENTRYPOINT /usr/local/ssdb/ssdb-server /etc/ssdb/ssdb.conf

```

