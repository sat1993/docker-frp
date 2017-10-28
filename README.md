# docker-frp

frp 是一个可用于内网穿透的高性能的反向代理应用，支持 tcp, udp, http, https 协议。
docker-frp是基于此构建的项目。用于快速启动frp服务。

## Usage

docker-frp可以快速启动frps服务或frpc客户端.

```
# 构建镜像.
~ docker build -t sat1993/frp ./
# 启动服务.
~ docker run -e FRP=server sat1993/frp
```

### Environment Varables

若在启动时，不添加任何环境变量，则无法启动，至少需要确认是启动服务端还是客户端。

* FRP - 启动服务的类型，是使用`frps`启动服务端，还是使用`frpc`启动客户端。
* CONFIG - 配置文件名，需要配合`-v your_config_path:/home/conf`使用。

### Full Example

1. 启动一个简单的frps服务。

  `~ docker run -d -e FRP=server sat1993/frp`

2. 通过配置启动一个frpc客户端。

  [frpc配置参考](https://github.com/fatedier/frp/blob/master/conf/frpc_full.ini)

  ```
  ~ touch conf/frpc.ini

  # conf/frpc.ini
  # frpc.ini
  [common]
  server_addr = x.x.x.x
  server_port = 7000

  [ssh]
  type = tcp
  local_ip = 127.0.0.1
  local_port = 22
  remote_port = 6000

  ~ docker run -d -v conf/:/home/conf -e FRP=client -e CONFIG=frpc.ini sat1993/frp
  ```

3. 通过配置启动一个frps服务端

  [frps配置参考](https://github.com/fatedier/frp/blob/master/conf/frps_full.ini)

  ```
  ~ touch conf/frps.ini

  # frps.ini
  [common]
  bind_port = 7000

  ~ docker run -d -v conf/:/home/conf -e FRP=client -e CONFIG=frps.ini sat1993/frp

  ```

