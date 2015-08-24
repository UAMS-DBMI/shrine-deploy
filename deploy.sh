#!/usr/bin/env bash 

# Deployment script for SHRINE containers

# Specify the location of the deployment script
INSTALL_PATH=$(pwd)

# Get list of SHRINE nodes to deploy from ./configs directory 
configs=($INSTALL_PATH/configs/*)

# Specify folder naming convention.
# Default: configs/shrine#TYPE#NAME
# Example: configs/shrinehubDemo1
regexShrine="$INSTALL_PATH/configs/(shrine(.*))"

# Load parameters and apply the skeleton files
"$INSTALL_PATH/applysettings.sh"

declare -A shrineconfigs

# Create an array of shrineconfigs and their associated folder path
for sc in ${configs[@]}; do
	if [[ $sc =~ $regexShrine ]]; then
		suffix="${BASH_REMATCH[2]}"
		shrineconfigs[$suffix]="$BASH_REMATCH"
		echo "Found Shrine Config for: $suffix"
	fi
done

# Check for existence of SHRINE folders
if [ ${#shrineconfigs[@]} == 0 ]; then
	echo "No Shrine folders found in configs/. Exiting!"
	exit 3;
fi

# Specify Docker buildfile order
# Build from top-to-bottom and left-to-right
builddeps=(mysql postgres i2b2base tomcat shrine)
buildi2b2=(i2b2load i2b2 i2b2admin)
buildshrine=(shrineqep)

# Usage: deploy appname param
function deploy {

	case $1 in
		mysql)
			# param: container_name
			storename=$2
			storenameDB=${storename}DB
			#Create volume for persistant storage with name from commandlinei
			#CAPTURE PROCESS ID, EXECUTE SQL SCRIPT, STOP PROCESS ID
			newproc=$(sudo docker run -it -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD='u@msSHR!n3' \
			-e MYSQL_DATABASE='shrine_query_history' -e MYSQL_USER='shrine2015' -e MYSQL_PASSWORD='qu3rYU$3r' \
			--name=$storename  -d shrine:mysql)
			echo "Waiting 30 seconds to allow database server to start..."
			sleep 30
			sudo docker run -it --link $storename:mysql --rm shrine:mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" \
			-P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /buildtables.sql'
			sudo docker stop $newproc

			#FINALLY, LAUNCH DB FOR GOOD
			sudo docker run -it --volumes-from $storename --name=$storenameDB -d shrine:mysql
			;;
		shrine)
			# param: shrineconfig_key
			[[ $2 =~ (shrine(adapter|centralhub|hub|qep|.*)(.*)) ]]
			type=${BASH_REMATCH[2]}
			name=${BASH_REMATCH[1]}
			chcon -Rt svirt_sandbox_file_t "${INSTALL_PATH}/configs/$name"
			MYSQL_INSTANCE_NAME="mysql$name"
			# Deploy MySQL database with each SHIRNE node
			deploy mysql "$MYSQL_INSTANCE_NAME"
			if [[ $type == adapter ]]; then
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				-v ${INSTALL_PATH}/configs/$name/:/shrine/ -d shrine:shrineadapter
			elif [[ $type == hub ]]; then
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				--link shrineadapterDemo:shrineadapterDemo --link shrineadapterDemo:shrineadapterDemo \
				-p 6443:8443 -v $INSTALL_PATH/configs/$name/:/shrine/ \
				--link i2b2:i2b2 -d shrine:shrinehub
			elif [[ $type == centralhub ]]; then
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				--link shrineqepDemo:shrineadapterDemo --link i2b2:i2b2 \
				-p 7443:8443 -v $INSTALL_PATH/configs/$name/:/shrine/ \
				-d shrine:shrinehub
                        elif [[ $type == qep ]]; then
                                sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
                                -p 6443:8443 -v $INSTALL_PATH/configs/$name/:/shrine/ \
                                --link i2b2:i2b2 -d shrine:shrineqep
			else
				sudo docker run -it -h $name --name $name --link ${MYSQL_INSTANCE_NAME}DB:mysql \
				-p 6443:8443 -v $INSTALL_PATH/configs/$name/:/shrine/ \
				-d shrine:shrineallinone
			fi
			;;
		postgres_load)
				# param: container_name
				storename=postgres$2
				sudo docker run -it --name $storename -p 5432:5432 -v /var/lib/postgresql/data -e POSTGRES_PASSWORD=pgrootpass \
				-e POSTGRESDB=$I2B2_DB_NAME -d shrine:postgres
				sleep 30
			;;
		postgres)
				# param: container_name
				storename=postgres$2
				sudo docker stop $storename
				sudo docker run -it --name ${storename}DB -h ${storename}DB --volumes-from $storename -d shrine:postgres
			;;
		i2b2)
				# param: container_name
				sudo docker run -it --name $2 -h $2 --link postgresi2b2DB:postgresi2b2 -p 9090:9090 -d shrine:i2b2
				sudo docker run -it --name ${2}admin -h ${2}admin --link i2b2:i2b2 -p 8090:80 -d shrine:i2b2admin
			;;
	esac
}

# Store all images under one designation
# TODO: Tab with SHRINE version
for build in ${builddeps[@]}; do
	sudo docker build -t shrine:$build dockerbuilds/$build/
done

# Load data for i2b2. This includes the SHRINE ontology and the users

# postgres_load is exposed on the hosts main interface during this stage.
deploy postgres_load i2b2

# i2b2 scripts are executed against the postgres_load instance
for build in ${buildi2b2[@]}; do
	sudo docker build --no-cache -t shrine:$build dockerbuilds/$build/
done
# This loads the i2b2 modifications after the scripts have been run
sudo docker exec postgresi2b2 psql -U postgres -f /ShrineDemo.sql i2b2
sudo docker exec postgresi2b2 psql -U postgres -f /i2b2setup.sql i2b2
# Sleep while data inserts are performed
echo 'Inserting SHRINE Ontology. Please wait.'
sleep 60
echo 'Done Inserting SHRINE Ontology.'
# postgres deployment will shut down the postgres_load container
deploy postgres i2b2
deploy i2b2 i2b2

# Build and deploy SHRINE
for build in ${buildshrine[@]}; do
	sudo docker build -t shrine:$build dockerbuilds/$build/
done

# Finally, deploy shrine and pass in the configs folder name to deploy from
deploy shrine shrineqepDemo
deploy shrine shrinecentralhubDemo
