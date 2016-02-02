NAME =			gogs
VERSION =		latest
VERSION_ALIASES =	0.8.25 0.8 0
TITLE =			GOGS
DESCRIPTION =		GOGS
SOURCE_URL =		https://github.com/scaleway/image-app-gogs
VENDOR_URL =		http://gogs.io

IMAGE_VOLUME_SIZE =     150G
IMAGE_BOOTSCRIPT =      stable
IMAGE_NAME =            GOGS 0.8.25


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk

