#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H%M%S")

watch -n15 "raspistill -vf -hf -o /data/timelaps/"$DATE".jpg"
