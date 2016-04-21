#!/bin/bash -x


pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null


if ! test -d "$SDKMAN_DIR"; then
  curl -s get.sdkman.io | bash
  export SDKMAN_DIR=$HOME/.sdkman
fi


if ! type sdk; then 
  set +e
  source $SDKMAN_DIR/bin/sdkman-init.sh
fi


# grails
sdk install grails 3.0.16
sdk use grails 3.0.16
