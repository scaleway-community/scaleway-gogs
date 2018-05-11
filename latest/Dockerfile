## -*- docker-image-name: "scaleway/gogs:latest" -*-
ARG SCW_ARCH
FROM scaleway/golang:${SCW_ARCH}-latest

MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

ARG GOGS_RELEASE_URL_X86
ARG GOGS_RELEASE_URL_ARM


# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter


# Install packages
RUN apt-get install -y -q  \
	mailutils          \
	mysql-server-5.7   \
	nginx              \
	supervisor         \
  unzip              \
 && apt-get clean


# Downloads GOGS 
RUN case "${ARCH}" in                                     \
  armv7l|armhf|arm)                                       \
    curl --silent -L -o gogs.zip ${GOGS_RELEASE_URL_ARM}  \
    ;;                                                    \
  amd64|x86_64)                                           \
    curl --silent -L -o gogs.zip ${GOGS_RELEASE_URL_X86}  \
    ;;                                                    \
  *) echo "Unhandled architecture: ${ARCH}"; exit 1 ;;             \
  esac

# Install GOGS
RUN adduser --disabled-login --gecos 'Gogs' git           \
 && unzip gogs.zip -d /usr/lib/               \
 && echo "PATH=$PATH:/usr/lib/gogs/" > /etc/profile.d/golang.sh      \
 && rm /gogs.zip


# Configure NginX
RUN ln -sf /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs \
 && rm -f /etc/nginx/sites-enabled/default


# Disable TLS (postfix)
RUN sed -i "s/smtpd_use_tls=yes/smtpd_use_tls=no/" /etc/postfix/main.cf \
 && sed -i "s/inet_interfaces = .*/inet_interfaces = localhost/" /etc/postfix/main.cf


COPY ./overlay/ /

RUN systemctl enable mysql init-mysql init-gogs


# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
