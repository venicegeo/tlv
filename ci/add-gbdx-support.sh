#!/bin/bash -ex


# add plugin
settings_file="$root/tlv/settings.gradle"
sed -i "1s/$/, 'gbdx_plugin'/" $settings_file
echo "project(':gbdx_plugin').projectDir = '../plugins/gbdx' as File" >> $settings_file
sed -i "86i compile project(':gbdx_plugin')\n" $root/tlv/time_lapse/build.gradle

# add layers menu
gbdx_layers_menu_file="$root/plugins/gbdx/grails-app/views/_layers-menu-dialogs.gsp"
network_specific_layers_menu_file="$root/tlv/plugins/network_specific/grails-app/views/plugin_menus/_layers-menu-dialogs.gsp"
cat $gbdx_layers_menu_file >> $network_specific_layers_menu_file

# add dialogs
gbdx_dialog_file="$root/plugins/gbdx/grails-app/views/_gbdx-dialogs.gsp"
tlv_dialog_file="$root/tlv/time_lapse/grails-app/views/_dialogs.gsp"
cat $gbdx_dialog_file >> $tlv_dialog_file
cat $root/plugins/gbdx/grails-app/views/_login-dialog.gsp >> $tlv_dialog_file

# add the javascript file
echo "//= require gbdx" >> $tlv_javascript_folder/index-bundle.js
