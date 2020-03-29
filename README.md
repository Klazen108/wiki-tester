# wiki-tester
Mediawiki Test Driver

# Quickstart

1) Run `docker build -t wikitest .` to build the image
2) Run `docker run --rm --name wikitest -p 80:80 wikitest` to start the container (rm means delete when done)
3) Give everything about 15 seconds to boot up
4) Visit `http://localhost`
5) Try editing a page!

By default, the wiki is configured to run on `localhost:80`. Changing this isn't just as easy as changing the external port on the docker run command, because Mediawiki needs to know where it is in order to properly serve links (refer to `$wgServer` in LocalSettings.php). To change the host/port, you also need to set `MW_HOST` and `MW_PORT` as environment variables at run time. This image will handle updating the appropriate settings. e.g.,

```
docker run --rm --name wikitest -p 85:80 -e MW_PORT=85 wikitest
```

# VisualEditor 

This image uses [VisualEditor 1.34](https://www.mediawiki.org/wiki/Extension:VisualEditor). A link to download version 1.34 is available here: [Download Version 1.34 of VisualEditor](https://www.mediawiki.org/wiki/Special:ExtensionDistributor/VisualEditor)

If the git repository fails to work, that step can be skipped by downloading the release manually and copying it into the build context:

```dockerfile
COPY VisualEditor-REL1_34-74116a7.tar.gz .
RUN tar xzf VisualEditor-REL1_34-74116a7.tar.gz -C extensions; \
rm VisualEditor-REL1_34-74116a7.tar.gz
```