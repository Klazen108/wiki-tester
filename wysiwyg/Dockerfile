FROM mediawiki:1.27

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

#grab wysiwyg extension, extract and link into extensions directory
RUN curl -L -s https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/archive/wysiwyg_mw130_462.tar.gz --output wysiwyg_mw130_462.tar.gz; \
mkdir -p extensions/WYSIWYG-src; \
tar xzf wysiwyg_mw130_462.tar.gz --strip-components 1 -C extensions/WYSIWYG-src; \
rm wysiwyg_mw130_462.tar.gz; \
cd extensions/; \
ln -s WYSIWYG-src/WYSIWYG WYSIWYG; \
ln -s WYSIWYG-src/SemanticForms SemanticForms; \
mv WikiEditor WikiEditor-org; \
ln -s WYSIWYG-src/WikiEditor WikiEditor;

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