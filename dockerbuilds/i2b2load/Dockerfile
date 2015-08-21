FROM shrine:i2b2base
MAINTAINER Only the brave
# TODO: Need a better way to load data into the database
# During the build stage, there is no container-linking. To workaround this, the database
# is made publicly accessible and then the below scripts are able to populate the tables.
COPY crcdata.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata/db.properties
COPY hivedata.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Hivedata/db.properties
COPY metadata.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Metadata/db.properties
COPY pm.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Pmdata/db.properties
COPY workplace.db.properties /opt/jboss/i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/Workdata/db.properties

RUN cd i2b2db/edu.harvard.i2b2.data/Release_1-7/NewInstall/ \
	&& cd Crcdata \
	&& ant -f data_build.xml create_crcdata_tables_release_1-7 \
	&& ant -f data_build.xml create_procedures_release_1-7 \
	&& ant -f data_build.xml db_demodata_load_data \
	&& cd ../Hivedata \
	&& ant -f data_build.xml create_hivedata_tables_release_1-7 \
	&& ant -f data_build.xml db_hivedata_load_data \
	&& cd ../Pmdata \
	&& ant -f data_build.xml create_pmdata_tables_release_1-7 \
	&& ant -f data_build.xml create_triggers_release_1-7 \
	&& ant -f data_build.xml db_pmdata_load_data \
	&& cd ../Metadata \
	&& ant -f data_build.xml create_metadata_tables_release_1-7 \
	&& ant -f data_build.xml db_metadata_load_data \
	&& cd ../Workdata \
	&& ant -f data_build.xml create_workdata_tables_release_1-7 \ 
	&& ant -f data_build.xml db_workdata_load_data
