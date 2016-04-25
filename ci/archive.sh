#!/bin/bash -ex


pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null


# gather some data about the repo
source $root/ci/vars.sh


# ensure that the proper version of grails is available
! type grails >/dev/null 2>&1 && source $root/ci/grails.sh


# get the code
git clone --depth 1 https://github.com/time-lapse-viewer/tlv.git


# create the application documentation
#asciidoctor docs/tlv.adoc
# this will include the docs in the application jar file
mv ../docs/tlv.html time_lapse/grails-app/conf/


# compile the artifact
pushd $root/tlv/time_lapse
	# this will include the external config file in the application jar file
	mv ../config.yml grails-app/conf/

	# this needs to be taken out, otherwise it will cause servlet problems when navigating to the homepage
	sed -i '/apply plugin:"war"/d' build.gradle

	# create the jar file
	./gradlew assemble
	mv build/libs/time_lapse-0.1.jar $root/$APP.$EXT
popd
