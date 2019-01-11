#!/bin/bash
docker build -t ffmpeg-nvidia-static .
docker run -t --runtime=nvidia --volume $(pwd):/root/data ffmpeg-nvidia-static cp /root/bin/{ffmpeg,ffprobe,ffplay} /root/data
sudo chown $(id -u):$(id -g) ffmpeg ffplay ffprobe
chmod +x ffmpeg ffplay ffprobe
# On my ubuntu I needed these dependencies also (so the build is not fully static):
sudo apt-get install libsdl2-2.0-0 libva2 libfdk-aac1 libx264-152 libx265-146 libva-drm2 libva-x11-2
./ffmpeg --version