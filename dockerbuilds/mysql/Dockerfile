FROM mysql:5.5
EXPOSE 3306
RUN apt-get update && apt-get install -y wget
ENV SHRINE_SVN_URL_BASE https://open.med.harvard.edu/svn/shrine/releases/1.19.1

RUN touch /buildtables.sql \
&& cd / \
&& echo "USE shrine_query_history;" >> buildtables.sql \
&& wget --no-check-certificate ${SHRINE_SVN_URL_BASE}/code/adapter/src/main/resources/adapter.sql \
&& cat adapter.sql >> buildtables.sql \
&& wget --no-check-certificate ${SHRINE_SVN_URL_BASE}/code/broadcaster-aggregator/src/main/resources/hub.sql \
&& cat hub.sql >> buildtables.sql \
&& wget --no-check-certificate ${SHRINE_SVN_URL_BASE}/code/service/src/main/resources/create_broadcaster_audit_table.sql \
&& cat create_broadcaster_audit_table.sql >> buildtables.sql \
#TODO CREATE NEW DATABASE FOR USE BY DATASTEWARD APP
#&& echo "USE stewartDB;" >> buildtables.sql \
&& wget --no-check-certificate ${SHRINE_SVN_URL_BASE}/code/steward/src/main/sql/mysql.ddl \
&& cat mysql.ddl >> buildtables.sql

#mysql -u $SHRINE_MYSQL_USER -p$SHRINE_MYSQL_PASSWORD -D shrine_query_history < adapter.sql
#mysql -u $SHRINE_MYSQL_USER -p$SHRINE_MYSQL_PASSWORD -D shrine_query_history < hub.sql
#mysql -u $SHRINE_MYSQL_USER -p$SHRINE_MYSQL_PASSWORD -D shrine_query_history < create_broadcaster_audit_table.sql
