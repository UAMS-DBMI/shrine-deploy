FROM shrine:i2b2base
MAINTAINER Only the brave
#These properties files are not used, but if you want to re-run the build process within the container,
#they have the correct server addresses.
COPY crcdata.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata/db.properties
COPY pm.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Pmdata/db.properties
COPY metadata.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Metadata/db.properties
COPY hivedata.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Hivedata/db.properties
COPY workplace.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Workdata/db.properties

COPY crc-ds.xml /opt/jboss/i2b2core/edu.harvard.i2b2.crc/etc/jboss/crc-ds.xml
COPY pm-ds.xml /opt/jboss/i2b2core/edu.harvard.i2b2.pm/etc/jboss/pm-ds.xml
COPY ont-ds.xml /opt/jboss/i2b2core/edu.harvard.i2b2.ontology/etc/jboss/ont-ds.xml
COPY work-ds.xml /opt/jboss/i2b2core/edu.harvard.i2b2.workplace/etc/jboss/work-ds.xml

COPY CRCLoaderApplicationContext.xml /opt/jboss/i2b2core/edu.harvard.i2b2.crc/etc/spring/CRCLoaderApplicationContext.xml

#INSERT PM TABLES WITH DATA AND DEPLOY
RUN rm -f "$JBOSS_HOME/standalone/deployments/i2b2.war/WEB-INF/conf/axis2.xml" \ 
	&& cd i2b2core/edu.harvard.i2b2.server-common \
	&& ant clean dist deploy jboss_pre_deployment_setup \
	&& cd ../edu.harvard.i2b2.pm \
	&& ant -f master_build.xml clean build-all deploy \
	&& cd ../edu.harvard.i2b2.ontology \
	&& ant -f master_build.xml clean build-all deploy \
	&& cd ../edu.harvard.i2b2.crc \
	&& ant -f master_build.xml clean build-all deploy \
	&& cd ../edu.harvard.i2b2.workplace \
	&& ant -f master_build.xml clean build-all deploy
