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


# install asciidoctor
type asciidoctor > /dev/null 2>&1 || gem install asciidoctor
PATH=$HOME/bin:$PATH

# create the application documentation
asciidoctor $root/tlv/docs/tlv.adoc

# this will include the docs in the application jar file
mv $root/tlv/docs/tlv.html $root/tlv/time_lapse/grails-app/conf/


# compile the artifact
pushd $root/tlv/time_lapse
	# this will include the external config file in the application jar file
	set +x # don't want to show any passwords
	export HISTFILE=/dev/null # prevent credentials from appearing in the bash_history
	git clone --depth 1 https://$NAQUINKJ_USER:$NAQUINKJ_PASS@gitlab.devops.geointservices.io/$NAQUINKJ_USER/tlv.git
	cat tlv/config.yml >> grails-app/conf/application.yml
	set -x

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
	cat grails-app/conf/application.yml
	
	# testing where pg database is
	sed -i "18i }" grails-app/controllers/time_lapse/HomeController.groovy
	sed -i '18i render System.getenv("VCAP_SERVICES")' grails-app/controllers/time_lapse/HomeController.groovy
	sed -i "18i def postgres() {" grails-app/controllers/time_lapse/HomeController.groovy

	# create the jar file
	./gradlew assemble
	mv build/libs/time_lapse-0.1.jar $root/$APP.$EXT
popd
