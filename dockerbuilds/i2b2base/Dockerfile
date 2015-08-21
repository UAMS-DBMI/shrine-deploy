FROM jboss/wildfly
MAINTAINER Only the brave
EXPOSE 9090
USER root
#INSTALL Ant and ALTER default port number to 9090 to match i2b2 defaults
RUN yum -y install ant \
	&& sed -i "s|\(http\.port\):8080|\1:9090|g" /opt/jboss/wildfly/standalone/configuration/standalone.xml
#Environment for i2b2. JAVA_HOME is already defined
ENV JBOSS_HOME /opt/jboss/wildfly 
ENV ANT_HOME /usr/share/ant
ENV PATH $PATH:$ANT_HOME/bin:$JAVA_HOME/bin
#DOWNLOAD and INSTALL Axis2
USER jboss
RUN curl -O http://www.interior-dsgn.com/apache//axis/axis2/java/core/1.6.3/axis2-1.6.3-war.zip \
	&& mkdir -p /opt/jboss/wildfly/standalone/deployments/i2b2.war/ \
	&& unzip axis2-1.6.3-war.zip axis2.war \
	&& unzip axis2.war -d /opt/jboss/wildfly/standalone/deployments/i2b2.war/ \
	&& rm -f axis* \
	&& touch /opt/jboss/wildfly/standalone/deployments/i2b2.war.dodeploy

#DOWNLOAD i2b2
ADD downloadi2b2.sh /downloadi2b2.sh
RUN /downloadi2b2.sh 375 i2b2core.zip \
	&& unzip i2b2core.zip -d i2b2core \
	#UPDATE PATHS FOR BUILD
	&& sed -i "s|\(jboss\.home=\).*|\1$JBOSS_HOME|g" i2b2core/*/build.properties \
	&& sed -i "s|\(edu.harvard.i2b2.crc.applicationdir=\).*|\1$JBOSS_HOME/standalone/configuration/crcapp|g" i2b2core/*/etc/spring/crc_application_directory.properties \
	&& sed -i "s|\(ontology.applicationdir=\).*|\1$JBOSS_HOME/standalone/configuration/ontologyapp|g" i2b2core/*/etc/spring/ontology_application_directory.properties \
	&& sed -i "s|\(workplace.applicationdir=\).*|\1$JBOSS_HOME/standalone/configuration/workplaceapp|g" i2b2core/*/etc/spring/workplace_application_directory.properties \
	#&& sed -i "s|localhost:9090|localhost:8080|g" i2b2core/*/etc/spring/ontology.properties \
	#&& sed -i "s|localhost:
	#UPDATE SCHEMAS
	&& sed -i "s|\(queryprocessor.ds.lookup.servertype=\).*|\1PostgreSQL|g" i2b2core/*/etc/spring/crc.properties \
	&& sed -i "s|\(queryprocessor.ds.lookup.schemaname=\).*|\1i2b2hive|g" i2b2core/*/etc/spring/crc.properties \
	&& sed -i "s|\(edu.harvard.i2b2.crc.loader.ds.lookup.servertype=\).*|\1PostgreSQL|g" i2b2core/*/etc/spring/edu.harvard.i2b2.crc.loader.properties \
	&& sed -i "s|\(edu.harvard.i2b2.crc.loader.ds.lookup.schemaname=\).*|\1i2b2hive|g" i2b2core/*/etc/spring/edu.harvard.i2b2.crc.loader.properties \
	&& sed -i "s|\(ontology.bootstrapdb.metadataschema=\).*|\1i2b2hive|g" i2b2core/*/etc/spring/ontology.properties \
	&& sed -i "s|\(workplace.bootstrapdb.metadataschema=\).*|\1i2b2hive|g" i2b2core/*/etc/spring/workplace.properties \
	&& /downloadi2b2.sh 378 i2b2createdb.zip \
	&& unzip i2b2createdb.zip -d i2b2db \
	&& rm -f i2b2*.zip
