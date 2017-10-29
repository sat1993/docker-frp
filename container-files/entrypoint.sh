#!/bin/sh -e

# 没有参数进行提示.或者没有配置frp.
if [ -z "$FRP" ] || ([ "$FRP" != "server" ] && [ "$FRP" != "client" ]); then
  echo "Usage: docker run -e FRP={server/client} CONFIG=config_file_name.ini sat1993/frp-server"
  echo "FRP    --- Exec frps or frpc command"
  echo "CONFIG --- Your config file name. Need -v your_config_path:/home/conf when runing a container"
  exit 1
fi
# Server端调用frps
if [ -n "$FRP" ] && [ "$FRP" == "server" ]; then
  ARGS="frps"
  if [ -z "$CONFIG" ]; then
    # server端没有配置可以使用默认配置.
    echo -e "[common]\nbind_port=7000" > /home/conf/default.ini
    echo "Not Find Server Config File"
    echo "Use tcp port 7000 run frp server"
    CONFIG="default.ini"
  fi
# Client端调用frpc
elif [ -n "$FRP" ] && [ "$FRP" == "client" ]; then
  ARGS="frpc"
  # client必须要有配置.
  if [ -z "$CONFIG" ]; then
    echo "Need a config file for frp client!"
    echo "See Client Config https://github.com/fatedier/frp/blob/master/conf/frpc_full.ini"
    exit 1
  fi
fi
# 如果制定的配置文件不存在则提示.
if [ ! -s "/home/conf/$CONFIG" ]; then
  echo "Config file $CONFIG not found or $CONFIG is a empty file"
  echo "See Config File From https://github.com/fatedier/frp/blob/master/README.md#configuration-file"
  exit 1
fi

ARGS="$ARGS -c /home/conf/$CONFIG"

set -x
exec $ARGS
