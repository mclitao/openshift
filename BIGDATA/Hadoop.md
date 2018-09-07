<img src="https://github.com/mclitao/openshift/blob/master/BIGDATA/Hadoop.jpg?raw=true" alt="" width="300"/>


[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://travis-ci.org/containers/skopeo.svg?branch=master)](https://travis-ci.org/containers/skopeo)


## Hadoop学习笔记
> 来自[mclitao](https://www.xxx.cn/)[学习笔记](http://xxxxx.cn/)的内容

### 笔记目录

- **Hadoop配置文件表**
  - 
    |ID | 文件列表                              |     描述内容      |
    |:--|:--------------------------------------|:----------------- |
    | 0 |/usr/lib/systemd/system/docker.service | 服务文件位置      |

- **Hadoop参数表**
   - 
    |ID | 参数 |     描述内容      |
    |:--|:-----|:----------------- |
    |0|-i|交互|
    |1|-t|分配一个ttyz终端|terminal|
   
- **Hadoop集群节点服务列表**
   -
    |ID | NAME | IP |  Node Type      |
    |:--|:-----|:-----|:--------------|
    |0|node1|192.168.100.21|NameNode<br>SecondaryNameNode<br>ResourceManager|
    |1|node2|192.168.100.22|NodeManager|
    |2|node3|192.168.100.23|NodeManager|
    |3|node4|192.168.100.24|NodeManager|
   
    ><h6>注意： 启动Yarn时Namenode和ResourceManger如果不是同一台机器，不能在NameNode上启动 yarn，应该在ResouceManager所在的机器上启动yarn。</h6>    

- **Hadoop的部署**
  - 
    ```
    第一步：基础环境配置操作：
          添加hadoop用户   
        # useradd hadoop 
        # passwd  hadoop
           设置sudo的使用权利
        # vi /etc/sudoers
            ## Allow root to run any commands anywhere
            root    ALL=(ALL)     ALL
            hadoop   ALL=(ALL)     ALL
            现在可以用hadoop帐号登录，然后用命令 su - ，切换用户即可获得root权限进行操作。　
            
            建立hadoop使用目录,并给好权限。    
        # mkdir -p /hadoop/module
        # mkdir -p /hadoop/software
        # chown hadoop:hadoop /hadoop/module
        # chown hadoop:hadoop /hadoop/software
    
            查询是否安装java和版本
        # rpm -qa|grep java
            如果安装的版本低于1.7，卸载该jdk
        # rpm -e –nodeps
            安装jdk
        # cd /hadoop/software
        # wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  
        http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
        # tar zxvf  jdk-8u171-linux-x64.tar.gz  -C  /hadoop/module
        # mv /hadoop/module/jdk1.8.0_171 /hadoop/module/jdk1.8
            设置JAVA_HOME  
        # vi /etc/profile
            export  JAVA_HOME=/opt/module/jdk1.8
            export  PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/sbin
            source  /etc/profile
        # 向其他节点复制jdk
        # scp -r /opt/module/jdk1.8 root@node22:`pwd`
        # scp -r /opt/module/jdk1.8 root@node23:`pwd`
        # scp -r /opt/module/jdk1.8 root@node24:`pwd`
        # scp /etc/profile root@node22:/etc/
        # scp /etc/profile root@node23:/etc/
        # scp /etc/profile root@node24:/etc/
          在每个主机上都重新载入一下/etc/profile
        # source /etc/profile
            测试  java -version
    
    第二步：部署Hadoop操作：
    
        # cd /hadoop/module    
        # vi core-site.xml
            <configuration>
            <!-- 指定HDFS中NameNode的地址 -->
                 <property>
                 <name>fs.defaultFS</name>
                     <value>hdfs://node21:9000</value>
                 </property>
            <!-- 指定hadoop运行时产生文件的存储目录 -->
                 <property>
                 <name>hadoop.tmp.dir</name>
                 <value>/hadoop/module/hadoop-2.7.6/data/full/tmp</value>
                 </property>
            </configuration>
        
                修改hadoop-env.sh环境脚本
            # hadoop]$ vi hadoop-env.sh 
              export JAVA_HOME=/hadoop/module/jdk1.8 该这行
        
                修改hdfs-site.xml
            # vi hdfs-site.xml
                <configuration>
                <!-- 设置dfs副本数，不设置默认是3个   -->
                    <property>
                        <name>dfs.replication</name>
                        <value>2</value> 2副本数
                    </property>
                <!-- 设置secondname的端口   -->
                    <property>
                        <name>dfs.namenode.secondary.http-address</name>
                        <value>node21:50090</value>
                    </property>
                </configuration>
            
        分发hadoop到节点
        # scp -r hadoop-2.7.6/ admin@node22:`pwd`
        # scp -r hadoop-2.7.6/ admin@node23:`pwd`
        # scp -r hadoop-2.7.6/ admin@node24:`pwd`
        
    第三步：启动hadoop集群并初始化：
            如果集群是第一次启动，需要格式化namenode
        # hdfs namenode -format
            启动hdfs
        # start-dfs.sh
            启动yarn
        # start-yarn.sh
            
            每台节点查看jps进程\管理节点多一些服务
        [hadoop@node1 ~]# jps
        1339 ResourceManager
        1198 SecondaryNameNode
        1439 NodeManager
        1440 NameNode
        1912 Jps
        
        [hadoop@node2 ~]# jps
        1362 Jps
        1149 DataNode
        1262 NodeManager

        [hadoop@node2 ~]# jps
        1362 Jps
        1149 DataNode
        1262 NodeManager

        [hadoop@node4 ~]# jps
        1362 Jps
        1149 DataNode
        1262 NodeManager
        
        WEBURL:node1:50070

- **基础服务命令**
  - 
    ```
        格式化 HDFS 集群
      # bin/hdfs namenode -format
      
        启动 hdfs 集群
      # sbin/start-dfs.sh
      
        停止hdfs 集群
      # sbin/stop-dfs.sh
      
        格式化 zookeeper
      # bin/hdfs zkfc -formatZK
      
        启动namenode
      # sbin/hadoop-daemon.sh start namenode
      
        启动 yarn 服务
      # sbin/start-yarn.sh
      
        关闭 yarn 服务
      # sbin/stop-yarn.sh
       
        启动resourcemanager
      # sbin/yarn-daemon.sh start resourcemanager
    ```
    
- **1.HDFS命令**
  - 
    ```
    第一类：文件路径增删改查系列：
    # hdfs dfs -mkdir dir  创建文件夹
    # hdfs dfs -rmr dir  删除文件夹dir
    # hdfs dfs -ls  查看目录文件信息
    # hdfs dfs -lsr  递归查看文件目录信息
    # hdfs dfs -stat path 返回指定路径的信息
    
    第二类：空间大小查看系列命令：
    # hdfs dfs -du -h dir 按照适合阅读的形式人性化显示文件大小
    # hdfs dfs -dus uri  递归显示目标文件的大小
    # hdfs dfs -du path/file显示目标文件file的大小
    
    第三类:权限管理类：
    # hdfs dfs -chgrp  group path  改变文件所属组
    # hdfs dfs -chgrp -R /dir  递归更改dir目录的所属组
    # hdfs dfs -chmod [-R] 权限 -path  改变文件的权限 
    # hdfs dfs -chown owner[-group] /dir 改变文件的所有者
    # hdfs dfs -chown -R  owner[-group] /dir  递归更改dir目录的所属用户
    
    第四类：文件操作（上传下载复制）系列：
    # hdfs dfs -touchz a.txt 创建长度为0的空文件a.txt
    # hdfs dfs -rm file   删除文件file
    # hdfs dfs -put file dir  向dir文件上传file文件
    # hdfs dfs -put filea dir/fileb 向dir上传文件filea并且把filea改名为fileb
    # hdfs dfs -get file dir  下载file到本地文件夹
    # hdfs dfs -getmerge hdfs://Master:9000/data/SogouResult.txt CombinedResult  把hdfs里面的多个文件合并成一个文件，合并后文件位于本地系统
    # hdfs dfs -cat file   查看文件file
    # hdfs fs -text /dir/a.txt  如果文件是文本格式，相当于cat，如果文件是压缩格式，则会先解压，再查看
    # hdfs fs -tail /dir/a.txt查看dir目录下面a.txt文件的最后1000字节
    # hdfs dfs -copyFromLocal localsrc path 从本地复制文件
    # hdfs dfs -copyToLocal /hdfs/a.txt /local/a.txt  从hdfs拷贝到本地
    # hdfs dfs -copyFromLocal /dir/source /dir/target  把文件从原路径拷贝到目标路径
    # hdfs dfs -mv /path/a.txt /path/b.txt 把文件从a目录移动到b目录，可用于回收站恢复文件
    
    第五类：判断系列：
    # hdfs fs -test -e /dir/a.txt 判断文件是否存在，正0负1
    # hdfs fs -test -d /dir  判断dir是否为目录，正0负1
    # hdfs fs -test -z /dir/a.txt  判断文件是否为空，正0负1
    
    第六类：系统功能管理类：
    # hdfs dfs -expunge 清空回收站
    # hdfs dfsadmin -safemode enter 进入安全模式
    # hdfs dfsadmin -sfaemode leave 离开安全模式
    # hdfs dfsadmin -decommission datanodename 关闭某个datanode节点
    # hdfs dfsadmin -finalizeUpgrade 终结升级操作
    # hdfs dfsadmin -upgradeProcess status 查看升级操作状态
    # hdfs version 查看hdfs版本
    # hdfs daemonlog -getlevel <host:port> <name>  打印运行在<host:port>的守护进程的日志级别
    # hdfs daemonlog -setlevel <host:port> <name> <level>  设置运行在<host:port>的守护进程的日志级别
    # hdfs dfs -setrep -w 副本数 -R path 设置文件的副本数
    ```  

- **2.MapReduce命令**
  - 
      ```
      # hdfs jar file.jar 执行jar包程序
      # # hdfs job -kill job_201005310937_0053  杀死正在执行的jar包程序
      # hdfs job -submit <job-file>  提交作业
      # hdfs job -status <job-id>   打印map和reduce完成百分比和所有计数器。
      # hdfs job -counter <job-id> <group-name> <counter-name>  打印计数器的值。
      # hdfs job -kill <job-id>  杀死指定作业。
      # hdfs job -events <job-id> <from-event-#> <#-of-events> 打印给定范围内jobtracker接收到的事件细节。
      # hdfs job -history [all] <jobOutputDir>     
      # hdfs job -history <jobOutputDir> 打印作业的细节、失败及被杀死原因的细节。更多的关于一个作业的细节比如成功的任务，做过的任务尝试等信息可以通过指定[all]选项查看。
      # hdfs job -list [all]  显示所有作业。-list只显示将要完成的作业。
      # hdfs job -kill -task <task-id>   杀死任务。被杀死的任务不会不利于失败尝试。
      # hdfs job -fail -task <task-id>   使任务失败。被失败的任务会对失败尝试不利。
      ```
- **3.hdfs系统检查工具fsck**
  - 
      ```
    # hdfs fsck <path> -move    移动受损文件到/lost+found
    # hdfs fsck <path> -delete   删除受损文件。
    # hdfs fsck <path> -openforwrite   打印出写打开的文件。
    # hdfs fsck <path> -files     打印出正被检查的文件。
    # hdfs fsck <path> -blocks     打印出块信息报告。
    # hdfs fsck <path> -locations     打印出每个块的位置信息。
    # hdfs fsck <path> -racks    打印出data-node的网络拓扑结构。
      ```

- **4.运行pipies作业**
  - 
      ```
    # hdfs pipes -conf <path> 作业的配置
    # hdfs pipes -jobconf <key=value>, <key=value>, ...  增加/覆盖作业的配置项
    # hdfs pipes -input <path>  输入目录
    # hdfs pipes -output <path> 输出目录
    # hdfs pipes -jar <jar file> Jar文件名
    # hdfs pipes -inputformat <class> InputFormat类
    # hdfs pipes -map <class> Java Map类
    # hdfs pipes -partitioner <class> Java Partitioner
    # hdfs pipes -reduce <class> Java Reduce类
    # hdfs pipes -writer <class> Java RecordWriter
    # hdfs pipes -program <executable> 可执行程序的URI
    # hdfs pipes -reduces <num> reduce个数
      ```
   
- **5.**
  - 
      ```
      ```