#!/bin/bash 
#
# Downloads i2b2 source files
#
# Usage: downloadi2b2.sh file_id filename_to_save
#
# Check official i2b2 website for desired file_id
#
# Do not use this script to download files if you have not accepted the i2b2 
# Software License
#
# Examples:
#
# id	file
#
# 390	i2b2core-src-1706.zip
# 389	i2b2webclient-1706.zip
# 387	i2b2createdb-1706.zip
#
# 375	i2b2core-src-1705.zip
# 377	i2b2webclient-1705.zip
# 378	i2b2createdb-1705.zip

curl --silent -c cookies.txt "https://www.i2b2.org/software/download.html?d=$1&s=2" > /dev/null
curl --silent -b cookies.txt "https://www.i2b2.org/software/download.html?d=$1&s=2" > /dev/null
curl --silent -b cookies.txt -d "d=$1&sp=3&submit=I+ACCEPT" "https://www.i2b2.org/software/download.html" > /dev/null
curl -o "$2" -J -b cookies.txt -d "d=$1&sp=4" "https://www.i2b2.org/software/download.html"
rm cookies.txt
