#!/bin/bash

#Restarts SHRINE Containers without dropping databases

INSTALL_PATH=`pwd`

function stop_rm {
	sudo docker rm `sudo docker stop $1`
}

stop_rm shrinecentralhubDemo
stop_rm shrineqepDemo

sudo docker run -it -h shrineqepDemo --name shrineqepDemo --link mysqlshrineqepDemoDB:mysql -p 6443:8443 -v ${INSTALL_PATH}/configs/shrineqepDemo/:/shrine/ --link i2b2:i2b2 -d shrine:shrineqep

sudo docker run -it -h shrinecentralhubDemo --name shrinecentralhubDemo --link mysqlshrinecentralhubDemoDB:mysql --link shrineqepDemo:shrineadapterDemo -p 8443:8443 -v ${INSTALL_PATH}/configs/shrinecentralhubDemo/:/shrine/ -d shrine:shrinehub

