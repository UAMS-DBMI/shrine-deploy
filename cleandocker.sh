#!/usr/bin/env bash
#WARNING: This will stop and remove ALL docker containers and their associated volumes

sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q)
sudo ./delscript.sh
