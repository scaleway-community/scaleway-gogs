## -*- docker-image-name: "scaleway/gogs:latest" -*-
FROM scaleway/golang:amd64-1.6
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/golang:armhf-1.6        # arch=armv7l
#FROM scaleway/ubuntu:arm64-1.6y       # arch=arm64
#FROM scaleway/ubuntu:i386-1.6         # arch=i386
#FROM scaleway/ubuntu:mips-1.6         # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter


# Install packages
RUN apt-get -qq update     \
 && apt-get -y -q upgrade  \
 && apt-get install -y -q  \
	mailutils          \
	mysql-server-5.5   \
	nginx              \
	supervisor         \
 && apt-get clean


# Install GOGS
ENV GOGS_VERSION=0.8.25
RUN adduser --disabled-login --gecos 'Gogs' git           \
 && go get -tags="v$GOGS_VERSION" github.com/gogits/gogs  \
 && cd $GOPATH/src/github.com/gogits/gogs && go build


# Create database
RUN /etc/init.d/mysql start                                                              \
 && mysql -u root -e "CREATE DATABASE gogs CHARACTER SET utf8 COLLATE utf8_general_ci;"  \
 && killall mysqld


# Configure NginX
RUN ln -sf /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs \
 && rm -f /etc/nginx/sites-enabled/default


# Disable TLS (postfix)
RUN sed -i "s/smtpd_use_tls=yes/smtpd_use_tls=no/" /etc/postfix/main.cf \
 && sed -i "s/inet_interfaces = .*/inet_interfaces = localhost/" /etc/postfix/main.cf


COPY ./overlay/ /


# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
