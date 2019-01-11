# Start with NVidia CUDA base image
FROM nvidia/cuda:10.0-devel

MAINTAINER Nobody

# Install dependent packages
RUN apt-get update -qq -y && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  nasm \
  yasm \
  libx264-dev \
  libx265-dev \
  libnuma-dev \
  libvpx-dev \
  libfdk-aac-dev \
  libmp3lame-dev \
  libopus-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libfribidi-dev \
  libharfbuzz-dev

# This instruction is somewhere
  
RUN git clone https://github.com/FFmpeg/nv-codec-headers /root/nv-codec-headers && \
  cd /root/nv-codec-headers &&\
  make -j8 && \
  make install -j8 && \
  cd /root && rm -rf nv-codec-headers

# Following instructions directly from https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

RUN mkdir -p ~/ffmpeg_sources ~/bin && \
    cd ~/ffmpeg_sources && \
    wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2
    
# TODO: --enable-libaom

# RUN git clone https://github.com/libass/libass.git

# RUN cd /libass/ && ./autogen.sh && ./configure --disable-shared && make -j 4 && make install

# for static binary: --extra-ldexeflags="-static" \

# PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" 
    
RUN cd ~/ffmpeg_sources/ffmpeg && \
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --extra-libs="-lpthread -lm -lz" \
      --bindir="$HOME/bin" \
      --enable-pic \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree \
      --disable-shared \
      --enable-nvenc --enable-cuda \
      --enable-cuvid --enable-libnpp \
      --extra-cflags=-I/usr/local/cuda/include \
      --extra-cflags=-I/usr/local/include \
      --extra-ldflags=-L/usr/local/cuda/lib64 && \
    PATH="$HOME/bin:$PATH" make -j8 && \
    make install -j8 && \
    hash -r


ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility

WORKDIR /root
