--Creates a SHRINE project, a SHRINE user, and the tables for the SHRINE ontology
--CREATE SHRINE APPLICATION USER AND PROJECT
-- Create user shrine/demouser
insert into I2B2_DB_PM_USER.PM_USER_DATA (user_id, full_name, password, status_cd) values ('SHRINE_USER', 'shrine', 'SHRINE_PASSWORD_CRYPTED', 'A');
-- CREATE THE PROJECT for SHRINE
insert into I2B2_DB_PM_USER.PM_PROJECT_DATA (project_id, project_name, project_wiki, project_path, status_cd) values ('SHRINE', 'SHRINE', 'http://open.med.harvard.edu/display/SHRINE', '/SHRINE', 'A');
insert into I2B2_DB_PM_USER.PM_PROJECT_USER_ROLES (PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD) values ('SHRINE', 'SHRINE_USER', 'USER', 'A');
insert into I2B2_DB_PM_USER.PM_PROJECT_USER_ROLES (PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD) values ('SHRINE', 'SHRINE_USER', 'DATA_OBFSC', 'A');
--Prevents 'Missing Concept in Ontology Cell' error
insert into I2B2_DB_PM_USER.PM_PROJECT_USER_ROLES (PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD) values ('SHRINE', 'AGG_SERVICE_ACCOUNT', 'MANAGER', 'A');
insert into I2B2_DB_PM_USER.PM_PROJECT_USER_ROLES (PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD) values ('SHRINE', 'AGG_SERVICE_ACCOUNT', 'USER', 'A');
insert into I2B2_DB_PM_USER.PM_PROJECT_USER_ROLES (PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD) values ('SHRINE', 'AGG_SERVICE_ACCOUNT', 'DATA_AGG', 'A');
insert into I2B2_DB_PM_USER.PM_PROJECT_USER_ROLES (PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD) values ('SHRINE', 'AGG_SERVICE_ACCOUNT', 'DATA_OBFSC', 'A');
-- captures information and registers the cells associated to the hive.
UPDATE I2B2_DB_PM_USER.PM_CELL_DATA SET url = replace(url, 'localhost', 'i2b2');
insert into I2B2_DB_PM_USER.PM_CELL_DATA (cell_id, project_path, name, method_cd, url, can_override, status_cd) values ('CRC', '/SHRINE', 'SHRINE Federated Query', 'REST', 'https://SHRINE_IP:SHRINE_SSL_PORT/shrine/rest/i2b2/', 1, 'A');
--CONFIGURE DB and CRC LOOKUP FOR ONTOLOGY
INSERT INTO I2B2_DB_HIVE_USER.ONT_DB_LOOKUP (C_DOMAIN_ID, C_PROJECT_PATH, C_OWNER_ID, C_DB_FULLSCHEMA, C_DB_DATASOURCE, C_DB_SERVERTYPE, C_DB_NICENAME) VALUES ('I2B2_DOMAIN_ID','SHRINE/','@','I2B2_DB_SHRINE_ONT_USER','java:/I2B2_DB_SHRINE_ONT_DATASOURCE_NAME','POSTGRESQL','SHRINE');
INSERT INTO I2B2_DB_HIVE_USER.CRC_DB_LOOKUP (C_DOMAIN_ID, C_PROJECT_PATH, C_OWNER_ID, C_DB_FULLSCHEMA, C_DB_DATASOURCE, C_DB_SERVERTYPE, C_DB_NICENAME) VALUES ( 'I2B2_DOMAIN_ID', '/SHRINE/', '@', 'i2b2demodata', 'java:/I2B2_DB_CRC_DATASOURCE_NAME', 'POSTGRESQL', 'SHRINE' );
-- Create a new entry in table access allowing this Ontology to be used for project SHRINE
UPDATE i2b2hive.crc_db_lookup SET c_db_fullschema = 'i2b2demodata';
UPDATE i2b2hive.ont_db_lookup SET c_db_fullschema = 'i2b2metadata' where c_project_path = 'Demo/';
UPDATE i2b2hive.work_db_lookup SET c_db_fullschema = 'i2b2workdata';
