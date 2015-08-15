#!/bin/bash -x

configs=(configs/*)	
regexShrine="configs/(shrine(.*))"
#SOURCE VARIABLES
./applysettings.sh
INSTALL_PATH=`pwd`
#INSTALL_PATH MUST BE DEFINED
#DOCKER VERSION MUST BE DEFINED

declare -A shrineconfigs

for sc in ${configs[@]}; do
	if [[ $sc =~ $regexShrine ]]; then
		suffix="${BASH_REMATCH[2]}"
		shrineconfigs[$suffix]="$BASH_REMATCH"
		echo "Found Shrine Config for: $suffix"
	fi
done

#CHECK FOR EXISTENCE OF SHRINE FOLDERS
if [ ${#shrineconfigs[@]} == 0 ]; then
	echo "No Shrine folders found in configs/. Exiting!"
	exit 3;
fi

#SPECIFY DOCKER BUILDFILE ORDER
#buildorder=(mysql postgres tomcat i2b2 i2b2admin shrine shrineadapter shrinehub)
builddeps=(mysql postgres i2b2base tomcat shrine)
buildi2b2=(i2b2load i2b2 i2b2admin)
buildshrine=(shrinehub shrineqep)

#WRITE FUNCTIONS FOR EACH DEPLOYMENT TYPE, FOREXAMPLE MOVE MySQL into this file

#Call deploy appname role
function deploy {

	case $1 in
		mysql)
			#Take in name of shrine store
			#volume mysqlshrinestore
			storename=$2
			storenameDB=${storename}DB
			#Create volume for persistant storage with name from commandlinei
			#CAPTURE PROCESS ID, EXECUTE SQL SCRIPT, STOP PROCESS ID
			newproc=`sudo docker run -it -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD='u@msSHR!n3' \
			-e MYSQL_DATABASE='shrine_query_history' -e MYSQL_USER='shrine2015' -e MYSQL_PASSWORD='qu3rYU$3r' \
			--name=$storename  -d shrine:mysql`
			echo "Waiting for 10 seconds to allow database server to start..."
			#TODO CHECK FOR ERROR ON exec mysql, sleep and repeat until successful
			sleep 30
			sudo docker run -it --link $storename:mysql --rm shrine:mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" \
			-P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /buildtables.sql'
			sudo docker stop $newproc

			#FINALLY, LAUNCH DB FOR GOOD
			sudo docker run -it --volumes-from $storename --name=$storenameDB -d shrine:mysql;;
		shrine)
			[[ $2 =~ (shrine(adapter|centralhub|hub|qep|.*)(.*)) ]]
			type=${BASH_REMATCH[2]}
			name=${BASH_REMATCH[1]}
			chcon -Rt svirt_sandbox_file_t ${INSTALL_PATH}/configs/$name
			MYSQL_INSTANCE_NAME=mysql$name
			deploy mysql $MYSQL_INSTANCE_NAME
			#EXECUTE ALL OF THE SHRINE CONTAINERS WITH THEIR MYSQL DBs 
			if [[ $type == adapter ]]; then
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				-v ${INSTALL_PATH}/configs/$name/:/shrine/ -d shrine:shrineadapter
			elif [[ $type == hub ]]; then
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				--link shrineadapterDemo:shrineadapterDemo --link shrineadapterDemo:shrineadapterDemo \
				-p 6443:8443 -p 6060:8080 -p 8009:8009 -v $INSTALL_PATH/configs/$name/:/shrine/ \
				--link i2b2:i2b2 -d shrine:shrinehub
			elif [[ $type == centralhub ]]; then
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				--link shrineqepDemo:shrineadapterDemo --link shrineqepDemo:shrineadapterDemo \
				-p 7443:8443 -v $INSTALL_PATH/configs/$name/:/shrine/ \
				-d shrine:shrinehub
                        elif [[ $type == qep ]]; then
                                sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
                                --link shrinecentralhubDemo:hub \
                                -p 6443:8443 -p 6060:8080 -p 8009:8009 -v $INSTALL_PATH/configs/$name/:/shrine/ \
                                --link i2b2:i2b2 -d shrine:shrineqep
			else
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				-p 6443:8443 -p 6060:8080 -p 8009:8009 -v $INSTALL_PATH/configs/$name/:/shrine/ \
				-d shrine:shrineallinone
			fi;;
		postgres_load)
				storename=postgres$2
				sudo docker run -it --name $storename -p 5432:5432 -v /var/lib/postgresql/data -e POSTGRES_PASSWORD=pgrootpass -d shrine:postgres
				sleep 30
			;;
		postgres)
				storename=postgres$2
				sudo docker stop $storename
				sudo docker run -it --name ${storename}DB -h ${storename}DB --volumes-from $storename -d shrine:postgres
			;;
		i2b2)
				sudo docker run -it --name $2 -h $2 --link postgresi2b2DB:postgresi2b2 -p 9090:9090 -d shrine:i2b2
				sudo docker run -it --name ${2}admin -h ${2}admin --link i2b2:i2b2 -p 8090:80 -d shrine:i2b2admin
			;;
	esac
}

#STORE ALL IMAGES UNDER ONE DESIGNATION FOR NOW. THINK ABOUT IT
#CATCH ANY ERRORS AND EXIT IF FAILS
#for build in ${builddeps[@]}; do
#	sudo docker build -t shrine:$build dockerbuilds/$build/
#done

#BE PREPARED TO ROLLBACK ALL DOCKER IMAGES
declare -A success
declare -A fail

# Load data for i2b2. This includes the SHRINE ontology and the users
#deploy postgres_load i2b2
#for build in ${buildi2b2[@]}; do
#	sudo docker build --no-cache -t shrine:$build dockerbuilds/$build/
#done
#sudo docker exec -it postgresi2b2 psql -U postgres -f /i2b2setup.sql i2b2

#deploy postgres i2b2
#deploy i2b2 i2b2

# Build and deploy SHRINE
for build in ${buildshrine[@]}; do
	sudo docker build --no-cache -t shrine:$build dockerbuilds/$build/
done
deploy shrine shrineqepDemo
deploy shrine shrinecentralhubDemo
