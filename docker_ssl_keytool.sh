#!/bin/sh
# -----------------------------------------------------------------------------------------------------------
#
# SPIN Key and Sef-Signed Certificate Generator
#
# Copyright (c) 2002 Harvard Medical School and Massachusetts General Hospital, All Rights Reserved.
#
# -----------------------------------------------------------------------------------------------------------
##########
# Modified by TJ Colvin
# Declare certificate parameters here:

#The cryptographic keystore file used by Shrine.
KEYSTORE_FILE=shrine.keystore

#Default password for the keystore
KEYSTORE_PASSWORD="dbm1SHRINE99"

#Human-readable name for the cryptographic certificate generated for this Shrine node.
KEYSTORE_ALIAS=$1

#Human-readable name for the cryptographic certificate generated for this Shrine node.
KEYSTORE_HUMAN="Docker Cert for $1"

#City where the node resides; will be included in generated cryptographic certificate.
KEYSTORE_CITY="Little Rock"

#State where the node resides; will be included in generated cryptographic certificate.
KEYSTORE_STATE="AR"

#Country where the node resides; will be included in generated cryptographic certificate.
KEYSTORE_COUNTRY="US"

#Specify Host IP Address
CN="127.0.0.1"
#Name Docker Hostnames so certificate can be shared by multiple containers
SAN="IP:127.0.0.1,DNS:shrineadapterDemo1,DNS:shrineadapterDemo2,DNS:shrinecentralhubDemo,DNS:shrineqepDemo1,DNS:shrineqepDemo2,DNS:shrineqepDemo"

##########

if [ ! `which keytool` ]; then
    if [ -f /usr/java/default/bin/keytool ]; then
      ln -s /usr/java/default/bin/keytool /usr/bin/keytool
    else
      echo "KEYTOOL NOT FOUND AT /usr/java/default/bin/keytool; EXPECT SUBSEQUENT FAILURES"
    fi
fi

mode=$2

#
# Setup Local Configuration
#
    case "$mode" in
      '-generate')

     # Generate the Server Key

	 keytool -genkeypair -keysize 2048 -alias $KEYSTORE_ALIAS -dname "CN=$CN, OU=$KEYSTORE_HUMAN, O=SHRINE Network, L=$KEYSTORE_CITY, S=$KEYSTORE_STATE, C=$KEYSTORE_COUNTRY" -ext "SAN=$SAN" -keyalg RSA -keypass $KEYSTORE_PASSWORD -storepass $KEYSTORE_PASSWORD -keystore $KEYSTORE_FILE -validity 7300

	 # Verify that the key was stored

	 keytool -list -v -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD

	 # Export key to a Self-Signed Certificate

	 keytool -export -alias $KEYSTORE_ALIAS -storepass $KEYSTORE_PASSWORD -file $KEYSTORE_ALIAS.cer -keystore $KEYSTORE_FILE

      ;;

      '-import')
	 # Import other Server's Certificate
         
         # keytool -delete -alias $2 -keystore $KEYSTORE_FILE -keypass $KEYSTORE_PASSWORD
      
	 keytool -import -v -trustcacerts -alias $3 -file $3 -keystore $KEYSTORE_FILE  -keypass $KEYSTORE_PASSWORD  -storepass $KEYSTORE_PASSWORD
	 #keytool -import -v -alias $3 -file $3 -keystore $KEYSTORE_FILE  -keypass $KEYSTORE_PASSWORD  -storepass $KEYSTORE_PASSWORD

	 # Verify that Certificate was Imported

    echo
    echo "******************************** YOUR KEYSTORE ***************************"
    echo
    echo
    keytool -list -v -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD
    echo
    echo "******************************** YOUR KEYSTORE ***************************"
    echo

      ;;

      *)
	# Usage
        echo "usage:" 
	echo
	echo "ssl_keytool.sh -generate"
	echo       "(no parameters needed)"
	echo
	echo "keystore.sh -import <fully qualified name> "
	echo       "e.g. ssl_keytool.sh -import vsl-bwh.partners.org"
	echo 
	echo
    esac
