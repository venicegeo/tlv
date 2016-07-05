#!/bin/bash -ex


# place the US boundary geojson so that it gets included in the application jar file
mv $root/us-boundaries.geojson $root/tlv/time_lapse/grails-app/conf

# load the US border data when the application starts
bootStrapFile="$root/tlv/time_lapse/grails-app/init/BootStrap.groovy"
sed -i "4i grailsApplication.config.usBoundaries = new MultiPolygon(json.geometry.coordinates)" $bootStrapFile
sed -i "4i def json = new JsonSlurper().parseText(file.getText())" $bootStrapFile
sed -i "4i def file = getClass().getResource(\"/us-boundaries.geojson\")" $bootStrapFile
sed -i "2i def grailsApplication" $bootStrapFile
sed -i "1i import groovy.json.JsonSlurper" $bootStrapFile
sed -i "1i import geoscript.geom.MultiPolygon" $bootStrapFile

# add a restriction to only allow OCONUS searches
searchLibraryServiceFile="$root/tlv/plugins/network_specific/grails-app/services/network_specific/SearchLibraryService.groovy"
sed -i "25i if (grailsApplication.config.usBoundaries.contains(point)) { return [error: \"This location lies within US borders.\"] }" $searchLibraryServiceFile
sed -i "25i def point = new Point(results.location[0], results.location[1])" $searchLibraryServiceFile
sed -i "4i import geoscript.geom.Point" $searchLibraryServiceFile
