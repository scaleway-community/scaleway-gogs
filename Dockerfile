## -*- docker-image-name: "scaleway/gogs:latest" -*-
FROM scaleway/golang:1.4.2
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update \
 && apt-get -y -q upgrade \
 && apt-get install -y -q \
        git \
	mercurial \
	mysql-server-5.5 \
	supervisor \
 && apt-get clean


# Install GOGS
RUN adduser --disabled-login --gecos 'Gogs' git
RUN go get -u github.com/gogits/gogs
RUN cd $GOPATH/src/github.com/gogits/gogs && go build

# Create database

RUN /etc/init.d/mysql start \
  && mysql -u root -e "gogs CHARACTER SET utf8 COLLATE utf8_general_ci;" \
  && killall mysqld


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
