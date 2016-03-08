FROM debian
ADD sources.list /etc/apt/sources.list
RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "tasksel", "-y"]
RUN ["tasksel", "--task-packages", "standard"]
RUN ["apt-get", "clean"]
CMD ["/usr/bin/env", "LANG=zh_CN.UTF-8", "/bin/bash"]
