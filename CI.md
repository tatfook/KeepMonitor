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
- [x] 为keepwork，构建docker镜像
- [x] 基于官方jenkins docker镜像，构建带docker的镜像
- [x] docker in docker
- [x] jenkins多用户权限配置
- [ ] jenkins构建keepwork (dev/test)


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


## deploy

server need
- docker
- docker-compose

### jenkins

config

all jenkins config and build history are placed in /var/jenkins_home dir as a data volume mounted in docker. it makes migration easier.

docker in docker

don't use docker in docker, use sidling docker instead. mount
/var/run/docker.sock into ci container so that you can control docker in ci
container just
like you control docker on your machine. surprising!!!!

start ci server

    sudo docker pull jenkins/jenkins
    cd ci
    sudo docker-compose up -d


### keepwork services

there are two different env that code running: dev and test. every env owns a
server container and a data container. they mount the same data volume and share source code.

server container runs a npl web server in foreground and never stops. data
container is restarted by jenkins regularly. it pulls code and does some related
work and then exists. then server container accesses the updated code and
provide improved service. ;)

up and running

    sudo docker pull node
    sudo docker pull xuntian/npl-runtime
    cd keepwork
    sudo docker-compose up -d

at the frist time, server container is up instantly but data container pulling
code is far more slower. so you maybe encount 404 when you browser site address
right after `docker-compose up`. wait until both two data container process
exists and it'll be right.

data

they all share one named data volume `keepwork_container`. you can access it in
`/var/lib/docker/volumes/keepwork_container`

config file

there's one secret file named `config.page`, it's not managed by git repo
because it contains too much secrets. copy it manually into `info/` dir of data
volume and script will automatically link it.

### nginx
TODO




[base image](https://github.com/jenkinsci/docker/blob/master/README.md)

