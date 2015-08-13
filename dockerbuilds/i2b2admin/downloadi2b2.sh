#!/bin/bash 
curl --silent -c cookies.txt "https://www.i2b2.org/software/download.html?d=$1&s=2" > /dev/null
curl --silent -b cookies.txt "https://www.i2b2.org/software/download.html?d=$1&s=2" > /dev/null
curl --silent -b cookies.txt -d "d=$1&sp=3&submit=I+ACCEPT" "https://www.i2b2.org/software/download.html" > /dev/null
curl -o $2 -J -b cookies.txt -d "d=$1&sp=4" "https://www.i2b2.org/software/download.html"
