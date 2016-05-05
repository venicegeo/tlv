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
asciidoctor --version
asciidoctor $root/tlv/docs/tlv.adoc

# this will include the docs in the application jar file
mv $root/tlv/docs/tlv.html $root/tlv/time_lapse/grails-app/conf/


# compile the artifact
pushd $root/tlv/time_lapse
	# this will include the external config file in the application jar file
	set +x # don't want to show any passwords
	export HISTFILE=/dev/null
	git clone https://$NAQUINKJ_USER:$NAQUINKJ_PASS@gitlab.devops.geointservices.io/$NAQUINKJ_USER/tlv.git
	cat tlv/config.yml >> grails-app/conf/application.yml
	set -x

	# this needs to be taken out, otherwise it will cause servlet problems when navigating to the homepage
	sed -i '/apply plugin:"war"/d' build.gradle

	# create the jar file
	./gradlew assemble
	mv build/libs/time_lapse-0.1.jar $root/$APP.$EXT
popd

