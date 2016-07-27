#!/bin/bash -ex


# add piazza dialogs
cat $root/plugins/piazza/grails-app/views/_login-dialog.gsp >> $root/tlv/time_lapse/grails-app/views/_dialogs.gsp

# add the piazza javascript file
mv $root/plugins/piazza/grails-app/assets/javascript/piazza.js $root/tlv/time_lapse/grails-app/assets/javascript/
"//= require piazza" >> $root/tlv/time_lapse/grails-app/assets/javascript/index-bundle.js
