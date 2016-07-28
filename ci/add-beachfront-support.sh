#!/bin/bash -ex


# add beachfront layers menu
beachfront_layers_menu_file="$root/plugins/beachfront/grails-app/views/_layers-menu-dialogs.gsp"
tlv_layers_menu_file="$root/tlv/time_lapse/grails-app/views/menus/_layers-menu-dialogs.gsp"
sed -i "21r $beachfront_layers_menu_file" $tlv_layers_menu_file

# add beachfront dialogs
beachfront_dialog_file="$root/plugins/beachfront/grails-app/views/_beachfront-dialogs.gsp"
tlv_dialog_file="$root/tlv/time_lapse/grails-app/views/_dialogs.gsp"
cat $beachfront_dialog_file >> $tlv_dialog_file

# add the beachfront javascript file
beachfront_javascript_file="$root/plugins/beachfront/grails-app/assets/javascripts/beachfront.js"
tlv_javascript_folder="$root/tlv/time_lapse/grails-app/assets/javascripts/"
mv $beachfront_javascript_file $tlv_javascript_folder
echo "//= require beachfront\n" >> $tlv_javascript_folder/index-bundle.js
