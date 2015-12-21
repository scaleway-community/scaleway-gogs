## -*- docker-image-name: "scaleway/gogs:latest" -*-
FROM scaleway/golang:1.5.2
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -qq update \
 && apt-get -y -q upgrade \
 && apt-get install -y -q \
	mailutils \
	mysql-server-5.5 \
	nginx \
	supervisor \
 && apt-get clean


# Install GOGS
ENV GOGS_VERSION=0.8.10
RUN adduser --disabled-login --gecos 'Gogs' git \
 && go get -tags="v$GOGS_VERSION" github.com/gogits/gogs \
 && cd $GOPATH/src/github.com/gogits/gogs && go build


# Create database
RUN /etc/init.d/mysql start \
  && mysql -u root -e "CREATE DATABASE gogs CHARACTER SET utf8 COLLATE utf8_general_ci;" \
  && killall mysqld


# Configure NginX
RUN ln -sf /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs \
 && rm -f /etc/nginx/sites-enabled/default


# Disable TLS (postfix)
RUN sed -i "s/smtpd_use_tls=yes/smtpd_use_tls=no/" /etc/postfix/main.cf \
 && sed -i "s/inet_interfaces = .*/inet_interfaces = localhost/" /etc/postfix/main.cf


ADD ./patches/etc/ /etc/
ADD ./patches/root/ /root/
ADD ./patches/usr/local/ /usr/local/
ADD ./patches/go/ /go/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
