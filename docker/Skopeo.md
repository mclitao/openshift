# Skopeo[![Build Status](https://travis-ci.org/containers/skopeo.svg?branch=master)](https://travis-ci.org/containers/skopeo)
=
<img src="https://raw.githubusercontent.com/mclitao/openshift/master/docker/Skopeo.svg" width="250">
----


## Skopeo的使用
> 来自[skope](https://github.com/containers/skopeo)

### 笔记目录

- **Skopeo用途**
  - 
    在没有要docker守护服务时就可以复制 A仓库：镜像 到 B:仓库：镜像
    
- **Skopeod的相关资料**
  -  
     https://rhelblog.redhat.com/2017/05/11/skopeo-copy-to-the-rescue/

- **安装Skopeo**
  -  
    ```batch
    #这里的所有命令在debian 8.6的环节上运行通过
    #编译安装skopeo
    $ git clone https://github.com/projectatomic/skopeo $GOPATH/src/github.com/projectatomic/skopeo
    $ sudo apt-get install libgpgme11-dev libdevmapper-dev btrfs-tools go-md2man
    $ cd $GOPATH/src/github.com/projectatomic/skopeo 
    $ make binary-local
    $ sudo make install
    
    #下载hello-world的image
    $ skopeo copy docker://hello-world oci:hello-world
    $ tree hello-world/
    hello-world/
    ├── blobs
    │   └── sha256
    │       ├── 636fcf0bc8246e08d2df4771dc764d35ea50428b8dfaa904773b0707cb4f6303
    │       ├── 7520415ce76232cdd62ecc345cea5ea44f5b6b144dc62351f2cd2b08382532a3
    │       └── 9b8e3ce88f3a2aaa478cfe613632f38d27be5eddaa002a719fa1bfa9ff4f7f63
    ├── oci-layout
    └── refs
        └── latest
    ```
    
- **Skopeo CLI**
  -  
    ```batch
      复制以镜像仓库A中的镜像 到仓库B中,不需要docker守护进程的存在
    # skopeo copy dockerA://internal.registry/myimage:latest  dockerB://production.registry/myimage:v1.0
        
      仓库带账户密码凭证的
    # skopeo copy --dest-creds prod_user:prod_pass /
            dockerA://internal.registry/myimage:latest /
            dockerB://production.registry/myimage:v1.0    
    ```