FROM tomcat:8.0
MAINTAINER Some poor soul
EXPOSE 8009 8080 8443
#Install wget, svn as needed
RUN apt-get update && apt-get install -y zip wget subversion \
&& mkdir /webapps \
&& svn export https://open.med.harvard.edu/svn/shrine/releases/SHRINE_VERSION/code/shrine-webclient /webapps/shrine-webclient \
&& rm -f /webapps/shrine-webclient/i2b2_config_data.js \
&& wget https://repo.open.med.harvard.edu/nexus/content/groups/public/net/shrine/shrine-war/SHRINE_VERSION/shrine-war-SHRINE_VERSION.war -O /webapps/shrine.war \
&& wget https://repo.open.med.harvard.edu/nexus/content/groups/public/net/shrine/shrine-proxy/SHRINE_VERSION/shrine-proxy-SHRINE_VERSION.war -O /webapps/shrine-proxy.war \
&& wget https://repo.open.med.harvard.edu/nexus/content/groups/public/net/shrine/steward/SHRINE_VERSION/steward-SHRINE_VERSION.war -O /webapps/steward.war 
#If you want to use a newew version of MySQL, uncomment the following
#RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.zip -O /webapps/mysqlconnector.zip \
#&& cd /webapps \
#&& mkdir -p WEB-INF/lib/ \
#&& unzip -j mysqlconnector.zip mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar -d /webapps/WEB-INF/lib/ \
#&& zip -d /webapps/steward.war WEB-INF/lib/mysql-connector-java-5.1.6.jar \
#&& zip steward.war WEB-INF/lib/* \
#&& rm -Rf mysql* WEB-INF
#Get source files, place in /root/shrine/webapps
RUN mv /webapps/shrine.war /usr/local/tomcat/webapps/
#Modify i2b2 config
RUN ln -s /shrine/conf/shrine.conf /usr/local/tomcat/lib/shrine.conf
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost && ln -s /shrine/conf/shrine.xml /usr/local/tomcat/conf/Catalina/localhost/shrine.xml
RUN rm -f /usr/local/tomcat/conf/server.xml \
&& ln -s /shrine/conf/server.xml /usr/local/tomcat/conf/server.xml
