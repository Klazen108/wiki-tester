FROM thenets/parsoid:0.11.0 AS parsoid
# we'll copy files from the parsoid image

FROM alpine/git AS gitter
# go get the extension and pull in submodules

RUN cd /; \
git clone -b REL1_34 https://gerrit.wikimedia.org/r/mediawiki/extensions/VisualEditor.git; \
cd VisualEditor; \
git submodule update --init

FROM mediawiki:1.34

# MEDIAWIKI SETUP: run the install script, make sqlitedb accessible by apache, 
# allow server host/port to be defined by environment vars
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
chmod -R 777 /var/www/data; \
sed -i 's/^$wgServer.*$/$wgServer=\$_ENV["MW_HOST"].":".\$_ENV["MW_PORT"];/' LocalSettings.php

# PARSOID SETUP: install nodejs, copy parsoid binaries over
RUN apt-get update && apt-get install -y nodejs
# $PARSOID_HOME = /var/lib/parsoid
COPY --from=parsoid /var/lib/parsoid /var/lib/parsoid
COPY --from=parsoid /run-parsoid.sh /run-parsoid.sh
ENV PARSOID_HOME=/var/lib/parsoid \
    PARSOID_VERSION=v0.11.0 \
    PARSOID_DOMAIN_localhost=http://localhost:80/api.php
# PARSOID_DOMAIN_localhost will load the correct settings into the config file
# note that parsoid is running internally in the container here, so we use the internal host+port,
# not the external one!

# VISUALEDITOR SETUP: copy the extension binaries over
COPY --from=gitter /VisualEditor extensions/VisualEditor
# copy the settings needed for VisualEditor into the LocalSettings file
COPY SettingsExtension.php .
RUN cat SettingsExtension.php >> LocalSettings.php

# ENVIRONMENT SETUP

# externally visible host+port for the wiki - change this if yours is accessible elsewhere
# defaults to localhost:80 (so needs port 80 to be exposed, and only works locally)
# see mediawiki localsettings $wgServer
# NOTE: for production installs, should probably just add LocalSettings.php as a volume
# this image is just for quick and dirty testing purposes!
ENV MW_HOST=localhost \
    MW_PORT=80

# start parsoid and mediawiki
CMD /run-parsoid.sh & apache2-foreground