NAME =			gogs
VERSION =		latest
VERSION_ALIASES =	0.9.13 0.9 0
TITLE =			GOGS
DESCRIPTION =		GOGS
SOURCE_URL =		https://github.com/scaleway/image-app-gogs
VENDOR_URL =		http://gogs.io
DEFAULT_IMAGE_ARCH =	x86_64


IMAGE_VOLUME_SIZE =     50G
IMAGE_BOOTSCRIPT =      stable
IMAGE_NAME =            GOGS 0.9.13


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - https://j.mp/scw-builder | bash
-include docker-rules.mk

