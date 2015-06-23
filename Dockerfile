## -*- docker-image-name: "armbuild/scw-app-gogs:latest" -*-
FROM armbuild/scw-app-golang:1.4.2
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update \
 && apt-get -y -q upgrade \
 && apt-get install -y -q \
        git \
 && apt-get clean


# Install GOGS
RUN adduser --disabled-login --gecos 'Gogs' git
RUN go get -u github.com/gogits/gogs
RUN cd $GOPATH/src/github.com/gogits/gogs && go build


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
