#!/usr/bin/env bash
# Applies parameters from settings.rc to files located in
# dockerbuilds/{container}/skel/* and places them in 
# dockerbuilds/{container}/

# Load parameters and helper functions
source settings.rc

# Keep a list of files created during this process for cleanup
rm -f files_created | touch files_create

for p in ./dockerbuilds/*/skel/Dockerfile; do
	skel="skel/"
	outfile=${p/$skel/}
	interpolate_file "${p}" "SHRINE_VERSION" "$SHRINE_VERSION" | \
		interpolate "I2B2_DB_NAME" "$I2B2_DB_NAME" > "${outfile}"
	echo ${outfile} >> files_created
done

for p in ./dockerbuilds/i2b2*/skel/*properties; do
	skel="skel/"
	outfile=${p/$skel/}
	interpolate_file "${p}" "SHRINE_IP" "${SHRINE_IP}" | \
		interpolate "I2B2_DEFAULT_SCHEMA_PASSWORD" "$I2B2_DEFAULT_SCHEMA_PASSWORD" > "${outfile}"
	echo ${outfile} >> files_created
done

for p in ./dockerbuilds/i2b2*/skel/*.xml; do
	skel="skel/"
	outfile=${p/$skel/}
	interpolate_file "${p}" "I2B2_DB_HIVE_DATASOURCE_NAME" "$I2B2_DB_HIVE_DATASOURCE_NAME" | \
		interpolate "I2B2_DB_HIVE_JDBC_URL" "$I2B2_DB_HIVE_JDBC_URL" | \
		interpolate "I2B2_DB_HIVE_USER" "$I2B2_DB_HIVE_USER" | \
		interpolate "I2B2_DB_HIVE_PASSWORD" "$I2B2_DB_HIVE_PASSWORD" | \
		interpolate "I2B2_DB_ONT_DATASOURCE_NAME" "$I2B2_DB_ONT_DATASOURCE_NAME" | \
		interpolate "I2B2_DB_ONT_JDBC_URL" "$I2B2_DB_ONT_JDBC_URL" | \
		interpolate "I2B2_DB_ONT_USER" "$I2B2_DB_ONT_USER" | \
		interpolate "I2B2_DB_HIVE_PASSWORD" "$I2B2_DB_HIVE_PASSWORD" | \
		interpolate "I2B2_DB_CRC_USER" "$I2B2_DB_CRC_USER" | \
		interpolate "I2B2_DB_CRC_PASSWORD" "$I2B2_DB_CRC_PASSWORD" | \
		interpolate "I2B2_DB_PM_USER" "$I2B2_DB_PM_USER" | \
		interpolate "I2B2_DB_PM_PASSWORD" "$I2B2_DB_PM_PASSWORD" | \
		interpolate "I2B2_DB_WORK_USER" "$I2B2_DB_WORK_USER" | \
		interpolate "I2B2_DB_WORK_PASSWORD" "$I2B2_DB_WORK_PASSWORD" | \
		interpolate "I2B2_DEFAULT_SCHEMA_PASSWORD" "$I2B2_DEFAULT_SCHEMA_PASSWORD" | \
		interpolate "I2B2_DEFAULT_DATABASE_ADDR" "$I2B2_DEFAULT_DATABASE_ADDR" | \
		interpolate "I2B2_DB_NAME" "$I2B2_DB_NAME" | \
		interpolate "I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" "$I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" | \
		interpolate "I2B2_DB_SHRINE_ONT_JDBC_URL" "$I2B2_DB_SHRINE_ONT_JDBC_URL" | \
		interpolate "I2B2_DB_SHRINE_ONT_USER" "$I2B2_DB_SHRINE_ONT_USER" | \
		interpolate "I2B2_DB_SHRINE_ONT_PASSWORD" "$I2B2_DB_SHRINE_ONT_PASSWORD" > "${outfile}"
	echo ${outfile} >> files_created
done

for p in ./dockerbuilds/i2b2admin/skel/*.js; do
	skel="skel/"
	outfile=${p/$skel/}
	interpolate_file "${p}" "I2B2_REST_IP" "$I2B2_REST_IP" | \
		interpolate "I2B2_REST_PORT" "$I2B2_REST_PORT" | \
		interpolate "I2B2_DOMAIN_ID" "$I2B2_DOMAIN_ID" > "${outfile}"
	echo ${outfile} >> files_created
done

for p in ./dockerbuilds/shrine*/skel/*.js; do
	skel="skel/"
	outfile=${p/$skel/}
	interpolate_file "${p}" "SHRINE_IP" "$SHRINE_IP" | \
		interpolate "SHRINE_SSL_PORT" "$SHRINE_SSL_PORT" | \
		interpolate "I2B2_REST_IP" "$I2B2_REST_IP" | \
		interpolate "I2B2_REST_PORT" "$I2B2_REST_PORT" | \
		interpolate "I2B2_DOMAIN_ID" "$I2B2_DOMAIN_ID" > "${outfile}"
	echo ${outfile} >> files_created
done

for p in ./dockerbuilds/*/skel/*.sql; do
	skel="skel/"
	outfile=${p/$skel/}
	interpolate_file "${p}" "SHRINE_IP" "${SHRINE_IP}" | \
		interpolate "SHRINE_SSL_PORT" "${SHRINE_SSL_PORT}" | \
		interpolate "SHRINE_USER" "${SHRINE_USER}" | \
		interpolate "SHRINE_PASSWORD_CRYPTED" "${SHRINE_PASSWORD_CRYPTED}" | \
		interpolate "I2B2_DOMAIN_ID" "$I2B2_DOMAIN_ID" | \
		interpolate "I2B2_DB_HIVE_USER" "${I2B2_DB_HIVE_USER}" | \
		interpolate "I2B2_DB_PM_USER" "${I2B2_DB_PM_USER}" | \
		interpolate "I2B2_DB_CRC_USER" "${I2B2_DB_CRC_USER}" | \
		interpolate "I2B2_DB_CRC_DATASOURCE_NAME" "${I2B2_DB_CRC_DATASOURCE_NAME}" | \
		interpolate "I2B2_DB_ONT_USER" "${I2B2_DB_ONT_USER}" | \
		interpolate "I2B2_DB_SHRINE_ONT_USER" "$I2B2_DB_SHRINE_ONT_USER" | \
		interpolate "I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" "$I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" | \
		interpolate "I2B2_DB_SHRINE_ONT_PASSWORD" "${I2B2_DB_SHRINE_ONT_PASSWORD}" > "${outfile}"
	echo ${outfile} >> files_created
done
