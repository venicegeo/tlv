#!/bin/bash -ex


# this will include the external config file in the application jar file
set +x # don't want to show any passwords
export HISTFILE=/dev/null # prevent credentials from appearing in the bash_history
git clone --depth 1 https://$NAQUINKJ_USER:$NAQUINKJ_PASS@gitlab.devops.geointservices.io/$NAQUINKJ_USER/tlv.git gitlab_tlv
ls -alh
cat $root/gitlab_tlv/config.yml >> $root/tlv/time_lapse/grails-app/conf/application.yml
set -x
