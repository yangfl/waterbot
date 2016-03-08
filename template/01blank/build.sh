#!/bin/sh
sudo /usr/share/docker.io/contrib/mkimage.sh -t waterbot/blank --no-compression debootstrap testing http://ftp.sjtu.edu.cn/debian/
# docker build --pull=true -t waterbot/blank .
