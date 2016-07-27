#!/bin/bash -ex


# add piazza dialogs
cat $root/plugins/piazza/grails-app/views/_login-dialog.gsp >> $root/tlv/time_lapse/grails-app/views/_dialogs.gsp

# add the piazza javascript file
mv $root/plugins/piazza/grails-app/assets/javascripts/piazza.js $root/tlv/time_lapse/grails-app/assets/javascripts/
"//= require piazza" >> $root/tlv/time_lapse/grails-app/assets/javascripts/index-bundle.js
