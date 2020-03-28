FROM mediawiki:1.27.7

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

#run the install script
RUN php maintenance/install.php \
--server=localhost:81 \
--scriptpath="" \
--installdbuser=testadmin \
--installdbpass=testpass \
--dbname=my_wiki \
--dbpath=/var/www/data \
--dbtype=sqlite \
--pass=testpass \
"Test Wiki" "testadmin"; \
php maintenance/update.php --quick; \
chmod -R 777 /var/www/data

COPY SettingsExtension.php .
RUN cat SettingsExtension.php >> LocalSettings.php