FROM alpine:3.19

# base tools
RUN apk add --no-cache \
  bash busybox git tar jq findutils gettext-envsubst

# build tools
RUN apk add --no-cache \
  make cmake clang autoconf automake g++ m4 meson nasm ninja patch pkgconf python3 libtool

# codecs
RUN apk add --no-cache \
  jansson-dev lame-dev libass-dev libjpeg-turbo-dev libtheora-dev libvorbis-dev libvpx-dev \
  libxml2-dev numactl-dev opus-dev speex-dev x264-dev

# Intel Quick Sync Video support
RUN apk add --no-cache \
  libva-dev libdrm-dev

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh", "alpine-3.19"]
