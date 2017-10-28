FROM alpine:3.6

ENV FRP_VERSION 0.13.0

WORKDIR /tmp

# frp在s3.amazon.com上.需要翻墙下载.
COPY container-files/frp_0.13.0_linux_amd64.tar.gz frp.tar.gz

# 添加入口脚本.
COPY container-files/entrypoint.sh /entrypoint.sh
# 使用阿里云镜像源
# 修改镜像时区为上海时区
# 添加frp
RUN echo -e "https://mirrors.aliyun.com/alpine/v3.6/main" > /etc/apk/repositories \
    && apk update && apk add zip bash tzdata \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && tar -zxf frp.tar.gz && rm -rf frp.tar.gz \
    && mv frp_0.13.0_linux_amd64/frps /bin/frps \
    && mv frp_0.13.0_linux_amd64/frpc /bin/frpc \
    && rm -rf frp_0.13.0_linux_amd64 \
    && mkdir -p /home/conf \
    && chmod a+x /entrypoint.sh


CMD ["/entrypoint.sh"]
