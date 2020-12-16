#!/bin/bash
docker build -t ffmpeg-nvidia-static .
docker run -it --rm --gpus all --volume $(pwd):/root/data ffmpeg-nvidia-static bash
