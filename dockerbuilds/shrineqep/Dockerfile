FROM shrine:shrine

EXPOSE 8009 8080 8443

COPY i2b2_config_data.js /usr/local/tomcat/webapps/shrine-webclient/
COPY cell_config_data.js /usr/local/tomcat/webapps/shrine-webclient/js-i2b2/cells/SHRINE/

RUN mv /webapps/shrine-webclient /usr/local/tomcat/webapps/ \
	&& mv /webapps/shrine-proxy.war /usr/local/tomcat/webapps/ \
	&& mv /webapps/steward.war /usr/local/tomcat/webapps/ \
	#Symlinks must match files passed in as a volume when the container is launched
	&& ln -s /shrine/conf/steward.conf /usr/local/tomcat/lib/steward.conf \
	&& ln -s /shrine/conf/steward.xml /usr/local/tomcat/conf/Catalina/localhost/steward.xml \
	&& ln -s /shrine/conf/AdapterMappings.xml /usr/local/tomcat/lib/AdapterMappings.xml \ 
	&& ln -s /shrine/conf/AdapterMappings.csv /usr/local/tomcat/lib/AdapterMappings.csv 
