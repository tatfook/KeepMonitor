# CI/CD for keepwork

构建服务器

## plan

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


