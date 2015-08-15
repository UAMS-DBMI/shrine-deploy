FROM postgres:9.2

COPY setup.sql /setup.sql
COPY shrinesetup.sql /shrinesetup.sql
COPY i2b2setup.sql /i2b2setup.sql
RUN apt-get update && apt-get -y install subversion \
&& svn co https://open.med.harvard.edu/svn/shrine/releases/SHRINE_VERSION/ontology/SHRINE_Demo_Downloads /ontology \
&& mv /ontology/*.sql / && rm -Rf /ontology && sed -i 's|INSERT INTO SHRINE|INSERT INTO shrine_ont.SHRINE|g' /ShrineDemo.sql
RUN touch /docker-entrypoint-initdb.d/insert.sh && chmod +x /docker-entrypoint-initdb.d/insert.sh \
&& echo "#!/bin/bash" >> /docker-entrypoint-initdb.d/insert.sh \
&& echo 'echo "CREATE DATABASE i2b2;" | gosu postgres postgres --single' >> /docker-entrypoint-initdb.d/insert.sh \
&& echo "gosu postgres postgres --single i2b2 < /setup.sql" >> /docker-entrypoint-initdb.d/insert.sh \
&& echo "gosu postgres postgres --single i2b2 < /i2b2setup.sql" >> /docker-entrypoint-initdb.d/insert.sh \
&& echo "gosu postgres postgres --single i2b2 < /shrinesetup.sql" >> /docker-entrypoint-initdb.d/insert.sh \
&& echo "gosu postgres postgres --single i2b2 < /ShrineDemo.sql" >> /docker-entrypoint-initdb.d/insert.sh
