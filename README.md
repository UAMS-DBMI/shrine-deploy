# shrine-deploy

## Synopsis

Configures and deploys a complete container-based environment for SHRINE (Shared Health Research Information Network). This includes i2b2, SHRINE, their associated web clients, and databases. It may also be used to deploy a single SHRINE node if your environment already contains the required infrastructure.

## How to use

1. Modify settings.rc and docker_ssl_keytool.sh with appropriate parameters

2. Populate configs/ with your SHRINE configuration files (see examples/configs/)

3. Generate certificates using docker_ssl_keytool.sh for nodes as needed
  - ./docker_ssl_keytool.sh shrinedocker -generate
  - ./docker_ssl_keytool.sh shrinedocker -import shrinedocker.cer
  - cp ./{shrine.keystore,shrinedocker.cer} configs/shrinenode/certs/

4. Run ./deploy.sh

## Motivation

This project was born out of a need to test multiple SHRINE configurations, and to simplify integration with an existing i2b2-based data warehouse. It achieves this by deploying an i2b2 container and a PostgreSQL database that hosts the shared ontology for the SHRINE network, demo data for testing, and a project management cell for user authentication. With these core components offloaded from the enterprise data warehouse, only small changes are required to enable the SHRINE application access to the institution's data after the required concept mappings have been completed for the shared ontology being used.

## License

i2b2 software components are retrieved as part of the build process and are subject to their licensing terms.
