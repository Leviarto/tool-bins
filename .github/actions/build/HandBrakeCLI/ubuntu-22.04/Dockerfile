FROM ubuntu:22.04

# ignore suggested dependencies
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
# prevent prompt errors during package installation
ARG DEBIAN_FRONTEND=noninteractive

# fetch packages list
RUN apt-get -y update

# base tools (gettext for envsubst)
RUN apt-get -y install \
  git tar zlib1g-dev jq gettext

# build tools
RUN apt-get -y install \
  build-essential cmake clang autoconf automake m4 make meson nasm ninja-build patch pkg-config libtool libtool-bin

# codec source packages
RUN apt-get -y install \
  libass-dev libbz2-dev libfontconfig-dev libfreetype-dev libfribidi-dev \
  libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate0-dev \
  libspeex-dev libtheora-dev libturbojpeg0-dev libvorbis-dev libx264-dev libxml2-dev libvpx-dev

# associated codec shared lib packages (2024-03-01):
# libass9 libjansson4 libmp3lame0 libopus0 libspeex1 libtheora0 libturbojpeg libva-drm2 libva2 libvorbisenc2 libvorbis0a libvpx7 libx264-163

# Intel Quick Sync Video support
RUN apt-get -y install \
  libva-dev libdrm-dev

# clean-up package lists
RUN rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh", "ubuntu-22.04"]
