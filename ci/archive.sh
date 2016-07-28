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


source $root/ci/create-docs.sh

source $root/ci/modify-config.sh

source $root/ci/expose-database-info.sh

source $root/ci/restrict-us-searches.sh

source $root/ci/add-piazza-support.sh

source $root/ci/add-beachfront-support.sh

cat $root/plugins/beachfront/grails-app/assets/javascripts/index-bundle.js

# compile the artifact
pushd $root/tlv/time_lapse
	# this needs to be taken out, otherwise it will cause servlet problems when navigating to the homepage
	sed -i '/apply plugin:"war"/d' build.gradle

	## use PCF postgres database
	# get the necessary jar
	sed -i -e 's/runtime "com.h2database:h2"/runtime "org.postgresql:postgresql:9.4-1206-jdbc42"/g' build.gradle
	# delete default database configuration and replace with postgres configuration
	sed -i '9,47d' grails-app/conf/application.yml
	mv $root/application.groovy grails-app/conf

	# create the jar file
	./gradlew assemble
	mv build/libs/time_lapse-0.1.jar $root/$APP.$EXT
popd
