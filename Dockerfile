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
	nginx \
	mysql-server-5.5 \
	supervisor \
	mailutils \
 && apt-get clean


# Install GOGS
RUN adduser --disabled-login --gecos 'Gogs' git
RUN go get -u github.com/gogits/gogs
RUN cd $GOPATH/src/github.com/gogits/gogs && go build

# Create database

RUN /etc/init.d/mysql start \
  && mysql -u root -e "CREATE DATABASE gogs CHARACTER SET utf8 COLLATE utf8_general_ci;" \
  && killall mysqld

ADD ./patches/etc/ /etc/
ADD ./patches/root/ /root/
ADD ./patches/usr/local/ /usr/local/
ADD ./patches/go/ /go/

# Configure NginX
RUN ln -sf /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs && \
    rm -f /etc/nginx/sites-enabled/default

# Disable TLS (postfix)
RUN sed -i "s/smtpd_use_tls=yes/smtpd_use_tls=no/" /etc/postfix/main.cf

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
