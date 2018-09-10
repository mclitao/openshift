<img src="https://github.com/mclitao/openshift/blob/master/BIGDATA/Hadoop.jpg?raw=true" alt="" width="300"/>


[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://travis-ci.org/containers/skopeo.svg?branch=master)](https://travis-ci.org/containers/skopeo)


## HadoopHA笔记
> 来自[mclitao](https://www.xxx.cn/)[学习笔记](http://xxxxx.cn/)的内容

### 笔记目录

#####Hadoop官方HA地址：
>http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithNFS.html

- **Hadoop配置文件表**
  - 
    |ID | 文件列表                              |     描述内容      |
    |:--|:--------------------------------------|:----------------- |
    | 0 |/hadoop/module/jdk1.8 | java环境版本1.8|
    | 1 |/hadoop/module/hadoop-2.7.6/cor-site.xml|hadoop的核心配置文件|
    | 2 |/hadoop/module/hadoop-2.7.6/hadoop-env.sh|hadoop的环境变量脚本|
    | 3 |/hadoop/module/hadoop-2.7.6/hdfs-site.xml|hdfs服务的核心配置文件|
    | 4 |/hadoop/module/hadoop-2.7.6/mapred-site.xml|MapReducce服务的核心配置文件|
    | 5 |/hadoop/module/hadoop-2.7.6/saves|Slaves数据节点的配置文件|
    | 6 |/hadoop/module/hadoop-2.7.6/yarn-site|yarn服务的核心的配置文件|

- **Zookeeper集群**
   - 
    |ID | Name |   Description     |
    |:--|:-----|:----------------- |
    |0|官网地址|https://zookeeper.apache.org/|
    |1|下载地址|http://mirror.bit.edu.cn/apache/zookeeper/|
    |2|部署笔记|https://github.com/mclitao/openshift/blob/master/BIGDATA/Zookeeper.md|

- **Hadoop组件说明**
   - 
    |ID | Name |   Description     |
    |:--|:-----|:----------------- |
    |0|NameNode|管理组件-Boss|
    |1|DFSZKFailoverController(zkfs)|HA组件|
    |2|JournalNode|NameNode之间用来通信的进程维护者edit log的变化|
    |3|ResourceManager|集群的资源管理和调度分配例如YARN-regional manager|
    |4|NodeManager|节点代理-department manager|
    |5|DataNode|数据服务组件-staff|
    |6|QuorumPeerMain|zookeeper的选举|

- **HadoopHA的转变流程图**
   -
    这里有两个NameNode，一个处于active状态，一个处于standby状态。ActiveNamenode对外提供服务，而StandbyNamenode则不对外提供服务，仅同步active 
    namenode的状态，以便在故障时快速进行切换。hadoop2.0提供了两种HDFS HA的解决方案，NFS和QJM，这里我们使用QJM。在该方案中两个namenode间通过JournalNode同步元数据信息，一条数据只要写入JournalNode即认为写入成功。通常配置奇数个JournalNode，依靠zookeeper来协调。这里还配置了一个zookeeper集群，用于ZKFC故障转移。ResourceManager也是有一个Active，一个Standby，状态由zookeeper进行协调。
    <img src="https://github.com/mclitao/openshift/blob/master/BIGDATA/HadoopHA.png?raw=true" alt="" width="600"/>

- **Hadoop集群节点服务列表**
   -
    |ID | NAME | IP |  Node Type      |
    |:--|:-----|:-----|:--------------|
    |0|ha1|192.168.23.205|NameNode<br>DFSZKFailoverController|
    |1|ha2|192.168.23.206|NameNode<br>DFSZKFailoverController|
    |2|ha3|192.168.23.207|ResourceManager|
    |3|ha4|192.168.23.208|ResourceManager|
    |4|ha5|192.168.23.209|NodeManager<br>DataNode<br>JournalNode<br>QuorumPeerMain|
    |5|ha6|192.168.23.230|NodeManager<br>DataNode<br>JournalNode<br>QuorumPeerMain|
    |6|ha7|192.168.23.231|NodeManager<br>DataNode<br>JournalNode<br>QuorumPeerMain|

    ><h6>注意： 启动Yarn时Namenode和ResourceManger如果不是同一台机器，不能在NameNode上启动 yarn，应该在ResouceManager所在的机器上启动yarn。</h6>    

- **Hadoop的部署**
  - 
    ```
    第一步：基础环境配置操作：
        参考hadoop的安装方法
    
    第二步：配置HA的Hadoop操作：
        修改hadoop-env.sh环境脚本
        # hadoop]$ vi hadoop-env.sh 
          export JAVA_HOME=/hadoop/module/jdk1.8 该这行

        # vi core-site.xml
            <configuration>
            <!-- 指定HDFS中NameNode的地址为bigdata，两个namenode的逻辑名字 -->
                 <property>
                 <name>fs.defaultFS</name>
                     <value>hdfs://bigdata</value>
                 </property>
            <!-- 指定hadoop运行时产生临时文件的目录 -->
                 <property>
                 <name>hadoop.tmp.dir</name>
                 <value>/hadoop/module/hadoop-2.7.6/data/full/tmp</value>
                 </property>
             <!-- 指定zookeeper地址，ha机制依赖于zookeeper 关键的一步就是这里 -->
                 <property>
                 <name>ha.zookeeper.quorum</name>
                 <value>ha5:2181,ha6:2181,ha7:2181</value>
                 </property>
            </configuration>

                修改hdfs-site.xml
            # vi hdfs-site.xml
                <configuration>
                <!--指定hdfs的nameservice为bigdata，需要和core-site.xml中的保持一致 -->
                <property>
                <name>dfs.nameservices</name>
                <value>bigdata</value>
                </property>
                <!-- bigdata的HA下面有两个NameNode，分别是nn1，nn2 -->
                <property>
                <name>dfs.ha.namenodes.bigdata</name>
                <value>nn1,nn2</value>
                </property>
                <!-- nn1的RPC通信地址 -->
                <property>
                <name>dfs.namenode.rpc-address.bigdata.nn1</name>
                <value>ha1:9000</value>
                </property>
                <!-- nn1的http通信地址 -->
                <property>
                <name>dfs.namenode.http-address.bigdata.nn1</name>
                <value>ha1:50070</value>
                </property>
                <!-- nn2的RPC通信地址 -->
                <property>
                <name>dfs.namenode.rpc-address.bigdata.nn2</name>
                <value>ha2:9000</value>
                </property>
                <!-- nn2的http通信地址 -->
                <property>
                <name>dfs.namenode.http-address.bigdata.nn2</name>
                <value>ha2:50070</value>
                </property>
                <!-- 指定NameNode的edits元数据在JournalNode上的存放位置 -->
                <property>
                <name>dfs.namenode.shared.edits.dir</name>
                <value>qjournal://ha5:8485;ha6:8485;ha7:8485/bigdata</value>
                </property>
                <!-- 指定JournalNode在本地磁盘存放数据的位置 -->
                <property>
                <name>dfs.journalnode.edits.dir</name>
                <value>/home/hadoop/journaldata</value>
                </property>
                <!-- 开启NameNode失败自动切换 -->
                <property>
                <name>dfs.ha.automatic-failover.enabled</name>
                <value>true</value>
                </property>
                <!-- 配置失败自动切换实现方式 -->
                <property>
                <name>dfs.client.failover.proxy.provider.bigdata</name>
                <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
                </property>
                <!-- 配置隔离机制方法，多个机制用换行分割，即每个机制暂用一行，防止脑裂-->
                <property>
                <name>dfs.ha.fencing.methods</name>
                <value>
                sshfence
                shell(/bin/true)
                </value>
                </property>
                <!-- 使用sshfence隔离机制时需要ssh免登陆 -->
                <property>
                <name>dfs.ha.fencing.ssh.private-key-files</name>
                <value>/home/hadoop/.ssh/id_rsa</value>
                </property>
                <!-- 配置sshfence隔离机制超时时间，超时则执行shell脚本 -->
                <property>
                <name>dfs.ha.fencing.ssh.connect-timeout</name>
                <value>30000</value>
                </property>
                </configuration>

       #vi yarn-site.xml
            <configuration>
            <!-- 开启RM高可用 -->
            <property>
            <name>yarn.resourcemanager.ha.enabled</name>
            <value>true</value>
            </property>
            <!-- 指定RM的cluster id -->
            <property>
            <name>yarn.resourcemanager.cluster-id</name>
            <value>yrc</value>
            </property>
            <!-- 指定RM的名字 -->
            <property>
            <name>yarn.resourcemanager.ha.rm-ids</name>
            <value>rm1,rm2</value>
            </property>
            <!-- 分别指定RM的地址 -->
            <property>
            <name>yarn.resourcemanager.hostname.rm1</name>
            <value>ha3</value>
            </property>
            <property>
            <name>yarn.resourcemanager.hostname.rm2</name>
            <value>ha4</value>
            </property>
            <!-- 指定zk集群地址，yarn的高可用借助zookeeper实现 -->
            <property>
            <name>yarn.resourcemanager.zk-address</name>
            <value>ha5:2181,ha6:2181,ha7:2181</value>
            </property>
            <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
            </property>
            </configuration>

        # vi slaves（datanode，nodemanager的主机）
            ha5
            ha6
            ha7
            
        配置文件改好后，将hadoop拷贝到其他节点..
        # scp -r /hadoop ha2:/    
        
    第三步：启动hadoop集群并初始化：
    
          启动JournalNode
        # cd /hadoop/hadoop-2.6.4
        # sbin/hadoop-daemon.sh start journalnode
        
          启动格式化hdfs
        # hdfs namenode -format
          然后拷到另一个namenode下
        # scp -r tmp/ hadoop02:/home/hadoop/app/hadoop-2.6.4/
          （hdfs namenode -bootstrapStandby）
          
            生成了hdpdata的数据 格式化zkfc（在ha1上执行一次即可）
        # hdfs zkfc -formatZK
        可以/zookeeper/bin/zkCli.sh连上去查看

            启动hdfs
        # start-dfs.sh
            启动yarn
        # start-yarn.sh
            
            启动yarn时还需要手动起ha4主机上的resourcemanager
        # yarn-daemon.sh start resourcemanager
        高可用的hadoop集群在这里配置完毕！