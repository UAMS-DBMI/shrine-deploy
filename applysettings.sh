#!/bin/bash
source settings.rc

interpolate_file ./dockerbuilds/shrine/skel/Dockerfile "SHRINE_VERSION" "${SHRINE_VERSION}" > dockerbuilds/shrine/Dockerfile

for p in ./dockerbuilds/i2b2*/skel/*properties; do
        skel="skel/"
        outfile=${p/skel/""}
        interpolate_file "${p}" "SHRINE_IP" "${SHRINE_IP}" > "${outfile}"
done

interpolate_file ./dockerbuilds/postgres/skel/i2b2setup.sql "SHRINE_IP" "${SHRINE_IP}" | \
interpolate "SHRINE_SSL_PORT" "${SHRINE_SSL_PORT}" | \
interpolate "SHRINE_USER" "${SHRINE_USER}" | \
interpolate "SHRINE_PASSWORD_CRYPTED" "${SHRINE_PASSWORD_CRYPTED}" | \
interpolate "I2B2_DOMAIN_ID" "$I2B2_DOMAIN_ID" | \
interpolate "I2B2_DB_HIVE_USER" "${I2B2_DB_HIVE_USER}" | \
interpolate "I2B2_DB_PM_USER" "${I2B2_DB_PM_USER}" | \
interpolate "I2B2_DB_CRC_DATASOURCE_NAME" "${I2B2_DB_CRC_DATASOURCE_NAME}" | \
interpolate "I2B2_DB_ONT_USER" "${I2B2_DB_ONT_USER}" | \
interpolate "I2B2_DB_SHRINE_ONT_USER" "$I2B2_DB_SHRINE_ONT_USER" | \
interpolate "I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" "$I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" | \
interpolate "I2B2_DB_SHRINE_ONT_PASSWORD" "${I2B2_DB_SHRINE_ONT_PASSWORD}" > dockerbuilds/postgres/i2b2setup.sql

interpolate_file ./dockerbuilds/postgres/skel/shrinesetup.sql "SHRINE_IP" "${SHRINE_IP}" | \
interpolate "SHRINE_SSL_PORT" "${SHRINE_SSL_PORT}" | \
interpolate "SHRINE_USER" "${SHRINE_USER}" | \
interpolate "SHRINE_PASSWORD_CRYPTED" "${SHRINE_PASSWORD_CRYPTED}" | \
interpolate "I2B2_DOMAIN_ID" "$I2B2_DOMAIN_ID" | \
interpolate "I2B2_DB_HIVE_USER" "${I2B2_DB_HIVE_USER}" | \
interpolate "I2B2_DB_PM_USER" "${I2B2_DB_PM_USER}" | \
interpolate "I2B2_DB_ONT_USER" "${I2B2_DB_ONT_USER}" | \
interpolate "I2B2_DB_SHRINE_ONT_USER" "$I2B2_DB_SHRINE_ONT_USER" | \
interpolate "I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" "$I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" | \
interpolate "I2B2_DB_SHRINE_ONT_PASSWORD" "${I2B2_DB_SHRINE_ONT_PASSWORD}" > dockerbuilds/postgres/shrinesetup.sql

interpolate_file dockerbuilds/i2b2/skel/ont-ds.xml "I2B2_DB_HIVE_DATASOURCE_NAME" "$I2B2_DB_HIVE_DATASOURCE_NAME" | \
interpolate "I2B2_DB_HIVE_JDBC_URL" "$I2B2_DB_HIVE_JDBC_URL" | \
interpolate "I2B2_DB_HIVE_USER" "$I2B2_DB_HIVE_USER" | \
interpolate "I2B2_DB_HIVE_PASSWORD" "$I2B2_DB_HIVE_PASSWORD" | \
interpolate "I2B2_DB_ONT_DATASOURCE_NAME" "$I2B2_DB_ONT_DATASOURCE_NAME" | \
interpolate "I2B2_DB_ONT_JDBC_URL" "$I2B2_DB_ONT_JDBC_URL" | \
interpolate "I2B2_DB_ONT_USER" "$I2B2_DB_ONT_USER" | \
interpolate "I2B2_DB_HIVE_PASSWORD" "$I2B2_DB_HIVE_PASSWORD" | \
interpolate "I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" "$I2B2_DB_SHRINE_ONT_DATASOURCE_NAME" | \
interpolate "I2B2_DB_SHRINE_ONT_JDBC_URL" "$I2B2_DB_SHRINE_ONT_JDBC_URL" | \
interpolate "I2B2_DB_SHRINE_ONT_USER" "$I2B2_DB_SHRINE_ONT_USER" | \
interpolate "I2B2_DB_SHRINE_ONT_PASSWORD" "$I2B2_DB_SHRINE_ONT_PASSWORD" > dockerbuilds/i2b2/ont-ds.xml





