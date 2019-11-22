#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

getCurrentIP() {
  IP=`ifconfig venet0:0 | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}'`
}

writeConfigFile() {
  cat >>/etc/shadowsocks.json<<-EOF
  {
    "server":"0.0.0.0",
    "local_address": "127.0.0.1",
    "local_port":1080,
    "port_password":
    {
      "40001": "yuruxuan",
      "40002": "guest"
    },
    "timeout":600,
    "method":"aes-256-cfb"
  }
EOF
}

setAutoRun() {
  echo >>/etc/rc.local "ssserver -c /etc/shadowsocks.json -d start"
}

installPip() {
  wget https://pypi.python.org/packages/source/p/pip/pip-1.3.1.tar.gz --no-check-certificate
  tar -xzvf pip-1.3.1.tar.gz 
  cd pip-1.3.1
  python setup.py install
}

echo -e "\033[31m > 正在获取IP... \033[0m"
getCurrentIP
echo -e "\033[31m > 当前IP为 ${IP} \033[0m"
writeConfigFile
echo -e "\033[31m > 写入配置文件...完成 \033[0m"
`yum -y install python-setuptools`
echo -e "\033[31m > 安装setuptools...完成 \033[0m"
installPip
echo -e "\033[31m > 安装pip...完成 \033[0m"
`pip install shadowsocks`
echo -e "\033[31m > 安装shadowsocks...完成 \033[0m"
`ssserver -c /etc/shadowsocks.json -d start`
echo -e "\033[31m > shadowsocks已启动 \033[0m"
setAutoRun
echo -e "\033[31m > 开机自动运行...完成 \033[0m"
