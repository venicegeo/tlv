#!/bin/bash -ex


# add plugin
settings_file="$root/tlv/settings.gradle"
sed -i "1s/$/, 'piazza_plugin'/" $settings_file
echo "project(':piazza_plugin').projectDir = '../plugins/piazza' as File" >> $settings_file

sed -i "86i compile project(':piazza_plugin')\n" $root/tlv/time_lapse/build.gradle

# add dialogs
echo "<g:render plugin = 'piazzaPlugin' template = '/login-dialog'/>" >> $root/tlv/time_lapse/grails-app/views/_dialogs.gsp

# add javascript file
echo "//= require piazza" >> $root/tlv/time_lapse/grails-app/assets/javascripts/index-bundle.js
