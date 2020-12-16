#!/bin/bash

docker run -it \
--rm --gpus all \
ffmpeg-nvidia-static:latest \
bash
