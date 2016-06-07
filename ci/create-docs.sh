#!/bin/bash -ex


# install asciidoctor
type asciidoctor > /dev/null 2>&1 || gem install asciidoctor
PATH=$HOME/bin:$PATH

# create the application documentation
asciidoctor $root/tlv/docs/tlv.adoc

# this will include the docs in the application jar file
mv $root/tlv/docs/tlv.html $root/tlv/time_lapse/grails-app/conf
