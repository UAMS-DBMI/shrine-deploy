FROM shrine:shrine
RUN mv /webapps/shrine-webclient /usr/local/tomcat/webapps/ \
&& mv /webapps/shrine-proxy.war /usr/local/tomcat/webapps/ \
&& mv /webapps/steward.war /usr/local/tomcat/webapps/ \
&& ln -s /shrine/conf/steward.conf /usr/local/tomcat/lib/steward.conf \
&& ln -s /shrine/conf/steward.xml /usr/local/tomcat/conf/Catalina/localhost/steward.xml
COPY i2b2_config_data.js /usr/local/tomcat/webapps/shrine-webclient/
COPY cell_config_data.js /usr/local/tomcat/webapps/shrine-webclient/js-i2b2/cells/SHRINE/
EXPOSE 8009 8080 8443
