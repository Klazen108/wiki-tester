FROM thenets/parsoid:0.11.0 AS parsoid

# we'll copy files from the parsoid image

FROM mediawiki:1.34

RUN apt-get update && apt-get install -y nodejs

# bring over the parsoid files
# $PARSOID_HOME = /var/lib/parsoid
COPY --from=parsoid /var/lib/parsoid /var/lib/parsoid
COPY --from=parsoid /run-parsoid.sh /run-parsoid.sh

ENV PARSOID_HOME=/var/lib/parsoid \
    # PARSOID_USER=parsoid \
    # PARSOID_VERSION [v0.8.1, v0.9.0, v0.10.0, v0.11.0, master]
    PARSOID_VERSION=v0.11.0 \
    PARSOID_DOMAIN_localhost=http://localhost:80/api.php
# PARSOID_DOMAIN_localhost will load the correct settings into the config file

COPY VisualEditor-REL1_34-74116a7.tar.gz .

# grab wysiwyg extension, extract and link into extensions directory
RUN tar xzf VisualEditor-REL1_34-74116a7.tar.gz -C extensions; \
rm VisualEditor-REL1_34-74116a7.tar.gz

# run the install script
RUN php maintenance/install.php \
--server=localhost:80 \
--scriptpath="" \
--installdbuser=testadmin \
--installdbpass=testpass \
--dbname=my_wiki \
--dbpath=/var/www/data \
--dbtype=sqlite \
--pass="testpass" \
"Test Wiki" "testadmin"; \
php maintenance/update.php --quick; \
chmod -R 777 /var/www/data

COPY SettingsExtension.php .
RUN cat SettingsExtension.php >> LocalSettings.php

CMD /run-parsoid.sh & apache2-foreground