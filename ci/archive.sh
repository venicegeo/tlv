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

# compile the artifact
pushd $root/tlv/time_lapse

	## don't show any US data
	# place the US boundary geojson so that it gets included in the application jar file
	mv $root/us-boundaries.geojson grails-app/conf

	# load the US border data when the application starts
	bootStrapFile="grails-app/init/BootStrap.groovy"
	sed -i "4i grailsApplication.config.usBoundaries = new MultiPolygon(json.geometry.coordinates)" $bootStrapFile
	sed -i "4i def json = new JsonSlurper().parseText(file.getText())" $bootStrapFile
	sed -i "4i def file = getClass().getResource(\"/us-boundaries.geojson\")" $bootStrapFile
	sed -i "2i def grailsApplication" $bootStrapFile
	sed -i "1i import groovy.json.JsonSlurper" $bootStrapFile
	sed -i "1i import geoscript.geom.MultiPolygon" $bootStrapFile

	# add a restriction to only allow OCONUS searches
	searchLibraryServiceFile="../plugins/network_specific/grails-app/services/network_specific/SearchLibraryService.groovy"
	sed -i "22i if (grailsApplication.config.usBoundaries.contains(point)) { return [error: \"This location lies within US borders.\"] }" $searchLibraryServiceFile
	sed -i "22i def point = new Point(location.longitude, location.latitude)" $searchLibraryServiceFile
	sed -i "4i import geoscript.geom.Point" $searchLibraryServiceFile

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
#
