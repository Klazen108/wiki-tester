# wiki-tester
Mediawiki Test Driver

# Quickstart

1) [Download Version 1.34 of VisualEditor](https://www.mediawiki.org/wiki/Special:ExtensionDistributor/VisualEditor)
2) Save the `VisualEditor-REL1_34-74116a7.tar.gz` file to the same folder as the Dockerfile (this folder)
3) Run `docker build -t wikitest .` to build the image
4) Run `docker run --rm --name wikitest -p 80:80 -p 8000:8000 wikitest` to start the container
5) Visit `http://localhost`
6) Try editing a page!