#!/bin/bash 
#
# Downloads i2b2 source files
#
# Usage: downloadi2b2.sh file_id filename_to_save
#
# Check official i2b2 website for desired file_id

curl --silent -c cookies.txt "https://www.i2b2.org/software/download.html?d=$1&s=2" > /dev/null
curl --silent -b cookies.txt "https://www.i2b2.org/software/download.html?d=$1&s=2" > /dev/null
curl --silent -b cookies.txt -d "d=$1&sp=3&submit=I+ACCEPT" "https://www.i2b2.org/software/download.html" > /dev/null
curl -o $2 -J -b cookies.txt -d "d=$1&sp=4" "https://www.i2b2.org/software/download.html"
rm cookies.txt
