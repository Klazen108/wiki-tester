FROM alpine/git AS gitter
# go get the extension and pull in submodules

RUN cd /; \
git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/TinyMCE.git;

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

# VISUALEDITOR SETUP: copy the extension binaries over
COPY --from=gitter /TinyMCE extensions/TinyMCE
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
CMD apache2-foreground