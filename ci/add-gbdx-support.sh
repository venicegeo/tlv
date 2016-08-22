#!/bin/bash -ex


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
gbdx_javascript_file="$root/plugins/gbdx/grails-app/assets/javascripts/gbdx.js"
tlv_javascript_folder="$root/tlv/time_lapse/grails-app/assets/javascripts/"
mv $gbdx_javascript_file $tlv_javascript_folder
echo "//= require gbdx" >> $tlv_javascript_folder/index-bundle.js
