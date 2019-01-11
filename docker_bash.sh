#!/bin/bash
docker build -t ffmpeg-nvidia-static .
docker run -it --runtime=nvidia --volume $(pwd):/root/data ffmpeg-nvidia-static bash