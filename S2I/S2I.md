
# S2I (Source To Images)
>官方CLI：https://github.com/openshift/source-to-image/blob/master/docs/cli.md

使用base+source=AppImages
S2I需要两种资源：
    第一：baseimage 就是箱子
    第二：需要包含.s2i的源码项目
    

###将当前wwwdata/html目录下的源码做成httpd-app产品镜像,使用rhscl/httpd-24-rhel7作为箱子
>s2i build file:///wwwdata/html rhscl/httpd-24-rhel7 httpd-app

