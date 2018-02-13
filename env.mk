IMAGE_NAME = gogs
IMAGE_VERSION = latest
IMAGE_VERSION_ALIASES =	0.11.34 0.11 0
IMAGE_TITLE = GOGS
IMAGE_DESCRIPTION = GOGS
IMAGE_SOURCE_URL = https://github.com/scaleway/image-app-gogs
IMAGE_VENDOR_URL = http://gogs.io
IMAGE_BOOTSCRIPT = mainline 4.9

GOGS_RELEASE_URL=$(shell curl -s https://api.github.com/repos/gogits/gogs/releases | jq '.[0].assets[] | select( .name == "linux_amd64.tar.gz") | .["browser_download_url"]')
BUILD_ARGS = GOGS_RELEASE_URL=$(GOGS_RELEASE_URL)
