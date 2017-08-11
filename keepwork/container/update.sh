#! /usr/bin/env bash
#
# update.sh
#
# default env is dev
ENV_TYPE=dev
if [[ $1 == "test" ]]; then
  ENV_TYPE=test
fi

is_test() {
  [[ $ENV_TYPE == "test" ]]
}

BRANCH=dev
if is_test; then
  BRANCH=master
fi

CONFIG_FILE_PATH=/project/wikicraft/info/config.page
CONFIG_FILE_LINK_PATH=/project/wikicraft/$ENV_TYPE/source/www/wiki/helpers/config.page

# hard link config.page file avoid cp wrong link
if [[ -e $CONFIG_FILE_PATH ]] && [[ ! -e $CONFIG_FILE_LINK_PATH ]]; then
  ln -s $CONFIG_FILE_PATH $CONFIG_FILE_LINK_PATH
fi

# nodejs compress code, only for test env
# how it work
# 1 mkdir temp_www_build
# 2 cp www to temp_www_build
# 3 node r.js -o r_package.js
# 4 new js files are placed in www_build dir, as release version
# 5 remember remove temp_www_build dir
TEMP_DIR=temp_www_build
BUILD_DIR=www_build

DEV_DIR=www
TEST_DIR=test

clean_dir() {
  if [[ -d $1 ]]; then
    rm -rf $1
  fi
}

if is_test; then
  clean_dir $TEMP_DIR
  clean_dir $BUILD_DIR

  cp -a $DEV_DIR $TEMP_DIR
  node r.js -o r_package.js
  clean_dir $TEMP_DIR

  clean_dir $TEST_DIR
  mv $BUILD_DIR $TEST_DIR
fi

