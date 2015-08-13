FROM php:5.6-apache

#DOWNLOAD i2b2
COPY downloadi2b2.sh /downloadi2b2.sh
RUN apt-get update && apt-get -y install curl unzip \
&& /downloadi2b2.sh 375 i2b2core.zip > /dev/null \ 
&& unzip i2b2core.zip "admin/*" > /dev/null \
&& /downloadi2b2.sh 377 i2b2client.zip \
&& unzip i2b2client.zip \
&& rm -Rf i2b2core.zip \
&& rm -Rf i2b2client.zip
COPY i2b2_config_data.js /var/www/html/webclient/i2b2_config_data.js
COPY i2b2_config_data.js /var/www/html/admin/i2b2_config_data.js
RUN sed -i "s|\(https://\).*\"|\1\"|g" webclient/index.php \
&& sed -i "s|y: true|y: false|g" webclient/i2b2_config_data.js
