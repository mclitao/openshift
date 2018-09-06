
# This repo demonstrates openshift v3 s2i scripts usage

1) Install s2i command line tool
2) Create builder image
3) Create application image using Builder image

![Worksflow](https://raw.githubusercontent.com/debianmaster/openshift-s2i-example/master/images/s2i.png)

> To Install s2i command line tool https://github.com/debianmaster/Notes/wiki/Source-2-Image---(s2i)--on-openshift   
```sh
s2i --help
```    
  
> In order to use openshift s2i image  create directory  .s2i and files under .s2i as follows   
```sh
mkdir -p .s2i/bin
touch .s2i/bin/assemble.sh
touch .s2i/bin/run.sh
touch .s2i/bin/usage.sh
```



#### assemble.sh  
> This file is used dynamically adding artifacts into base image and creating a app image as a result.   
> 这个脚本负责打包编译，负责将外边的代码拷贝发布到目标运行目录webapps
```sh
cp -Rf /tmp/src/. $CATALINA_HOME/webapps
echo "WAR's copied"
```

#### run.sh
> This file is used for mentioning startup script.   
> 这个脚本负责运行assemble.sh编译好的应用
```sh
${CATALINA_HOME}/bin/catalina.sh run
```

### Create builder image
> tomcat8-jdk8  is my future builder image name   
> 编译镜像
```sh
docker build -t tomcat8-jdk8 .
```

### Test builder image by deploying war  (Optional)
>  on base image tomcat8-jdk8 deploy the war (contents) that is present in test/test-app and make a app image called (tomcat8-jdk8-app)   
>  在基础镜像tomcat-jdk8上发布war包并开始合并2次编译镜像这里就是s2i核心部分
```sh
s2i build test/test-app tomcat8-jdk8 tomcat8-jdk8-app
```

### Test the app image
> 你可以手动运行编译好的镜像并进入里面查看一下是否拥有上边的每个功能目录以及.s2i目录下的程序文件
```sh
docker run -d  -p 8080:8080  tomcat8-jdk8-app 
```

## Using the template provided in this repo.
> 直接使用Openshif的build s2i功能编译 不向上面一步一步手动编译那样麻烦这里是自动完成的
```sh
oc import-image --from=openshift/base-centos7 openshift/base-centos7 -n openshift --confirm
oc new-build --strategy=docker --name=tomcat8-jdk8 https://github.com/debianmaster/openshift-s2i-example.git -n openshift
oc create -f tomcat8-jdk8-war.template
```
> Goto ui -> Add to project and look for tomcat8-jdk8-war template. 
> In the step above we are creating a base image with tomcat and java and storing it on openshift namespace   

![alt text](https://raw.githubusercontent.com/debianmaster/openshift-s2i-example/master/add2proj.png "Add to Proj")











> You can skip the part below unless you want to know how i have create the tomcat8-jdk8-war.template file in this repo    











## Creating template on Openshift   (Optional)

> i have arrived at the template  tomcat8-jdk8-war.template in this repo by creating following objects indivudually and then creating a template out of it.  (with few modifications)   

#### Create Image stream & export templates 
```sh
oc new-app tomcat8-jdk8~https://github.com/debianmaster/sample-binaries.git --name='tomcat8-jdk8-war'
oc export is,bc,dc,svc --as-template=tomcat8-jdk8  > template
```

> Modify the template above and rename it as tomcat8-jdk8-war.template   






