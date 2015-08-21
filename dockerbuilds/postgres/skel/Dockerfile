FROM postgres:9.2

#In the future, SHRINE Ontologies may be version specific
#SQL scripts are executed in alphabetical order by the container against the default database
ENV POSTGRES_DB I2B2_DB_NAME
COPY setup.sql /docker-entrypoint-initdb.d/1_setup.sql
COPY shrinesetup.sql /docker-entrypoint-initdb.d/2_shrinesetup.sql
COPY i2b2setup.sql /i2b2setup.sql
RUN apt-get update && apt-get -y install subversion \
	&& svn --non-interactive --trust-server-cert co https://open.med.harvard.edu/svn/shrine-ontology/SHRINE_Demo_Downloads/trunk /ontology \
	&& sed -i 's|INSERT INTO SHRINE|INSERT INTO shrine_ont.SHRINE|g' /ontology/ShrineDemo.sql \
	&& mv /ontology/ShrineDemo.sql /ShrineDemo.sql \
	&& rm -Rf /ontology
