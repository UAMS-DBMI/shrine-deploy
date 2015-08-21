FROM shrine:shrine
MAINTAINER Some poor soul

EXPOSE 8009 8080 8443

#Symlinks must matche volume provided when container launches
RUN ln -s /shrine/conf/AdapterMappings.xml /usr/local/tomcat/lib/AdapterMappings.xml \
	&& ln -s /shrine/conf/AdapterMappings.csv /usr/local/tomcat/lib/AdapterMappings.csv
