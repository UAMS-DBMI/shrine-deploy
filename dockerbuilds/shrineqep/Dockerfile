FROM shrine:shrine
RUN mv /webapps/shrine-webclient /usr/local/tomcat/webapps/ && mv /webapps/shrine-proxy.war /usr/local/tomcat/webapps/ && ln -s /shrine/conf/AdapterMappings.xml /usr/local/tomcat/lib/AdapterMappings.xml 
COPY i2b2_config_data.js /usr/local/tomcat/webapps/shrine-webclient/
EXPOSE 8009 8080 8443
