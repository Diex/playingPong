#!/bin/bash
ffserver -f ~/Desktop/server.conf & 
ffmpeg -f v4l2 -i /dev/video1 http://localhost:8090/camera.ffm
