#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H%M%S")
mkdir -p /data/timelaps/

watch -n15 "raspistill -vf -hf -o /data/timelaps/"$DATE".jpg"
