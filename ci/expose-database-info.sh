#!/bin/bash -ex


# this will expose the database information via the web in case manually logging into the database is necessary
code='def postgres() { render System.getenv("VCAP_SERVICES") }'
sed -i "18i $code" $root/tlv/time_lapse/grails-app/controllers/time_lapse/HomeController.groovy
