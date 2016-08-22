#!/bin/bash -ex


# add beachfront layers menu
beachfront_layers_menu_file="$root/plugins/beachfront/grails-app/views/_layers-menu-dialogs.gsp"
network_specific_layers_menu_file="$root/tlv/plugins/network_specific/grails-app/views/menus/_layers-menu-dialogs.gsp"
cat $beachfront_layers_menu_file >> $network_specific_layers_menu_file

# add beachfront dialogs
beachfront_dialog_file="$root/plugins/beachfront/grails-app/views/_beachfront-dialogs.gsp"
tlv_dialog_file="$root/tlv/time_lapse/grails-app/views/_dialogs.gsp"
cat $beachfront_dialog_file >> $tlv_dialog_file

# add the beachfront javascript file
beachfront_javascript_file="$root/plugins/beachfront/grails-app/assets/javascripts/beachfront.js"
tlv_javascript_folder="$root/tlv/time_lapse/grails-app/assets/javascripts/"
mv $beachfront_javascript_file $tlv_javascript_folder
echo "//= require beachfront" >> $tlv_javascript_folder/index-bundle.js
