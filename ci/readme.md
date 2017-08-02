# CI/CD for keepwork

构建服务器

## details

**tools**
- jenkins ci server
- docker container

**部署在内网还是公网**

内网 pros
- 构建本身是一个私有的过程，没有强烈的必要使用外网的服务器
- 使用docker本身已保障运行环境的一致性
- 速度快

cons
- 代码由github托管，如果由git commit hook来触发ci，相对困难
- 只能在公司内部访问
- 解决上面访问的问题需要VPN

公网 pros
- 随地访问
- 和github commit hook相关联

cons
- 访问速度相对慢
- 错误操作导致安全问题

结论：比较倾向于部署ci到外部服务器，使用docker保证dev/test/prod环境的一致；dev/test部署在一起，prod单独用另外的机器；
dev/test时常构建， 在构建没有问题的基础上，再部署prod

**jenkins部署于宿主机还是docker**

如果jenkins部署于宿主机，可以轻易操作本机的docker，与prod服务器docker。
但是使用docker in docker的方式，也没有什么问题，还保证了jenkins服务的独立。

结论：jenkins服务部署于docker中，使用docker in
docker，对dev/test进行构建测试；适当时机将构建部署远程


## progress

- [x] 分离jenkins配置，方便本地测试后再迁移
- [ ] 基于官方jenkins docker镜像，构建带docker的镜像
- [x] docker in docker
- [ ] 为keepwork，构建docker镜像
- [ ] jenkins构建keepwork (dev/test)
- [x] jenkins多用户权限配置



### docker in docker

use docker in docker for ci is not a good idea, read this
[wonderful post!!](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)

### seperate jenkins configuration

we use [this][base image] as base
image. when running a new container, mount local dir with data volumn.

assume mount /home/zdw/tmp/jenkins_home dir with volumn:

    sudo docker run -d -v /home/zdw/tmp/jenkins_home:/var/jenkins_home -p 8080:8080 jenkins/jenkins

visit localhost:8080, all operations with jenkins will be saved into data volumn
dir.

backup this directory and you can migrate jenkins running on docker in
other machine. just compress and transfer to other machine and run docker `-v
/<the path>:/var/jenkins_home`. wonderful.

**attention**, uid must be 1000, read [here][base image] for more details.


### jenkins image

create dockerfile base on [this image][base image]

### keepwork image





[base image](https://github.com/jenkinsci/docker/blob/master/README.md)

