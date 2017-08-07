#! /usr/bin/env bash
#
# update.sh
#
set -x

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

mkdir -p /project/wikicraft/$ENV_TYPE/source
cd /project/wikicraft/$ENV_TYPE/source

# clone repo
if [[ ! -d ".git" ]]; then
  rm -rf ./* ./.*
  git clone https://github.com/tatfook/wikicraft .
fi

# checkout branch
git rev-parse --verify $BRANCH
if [[ $? == 0 ]]; then
  # branch exists
  git checkout $BRANCH
else
  # branch not exists
  git checkout -b $BRANCH origin/$BRANCH
fi

# update code
git pull

# FIXME
# clone main pkg for now
if [[ ! -d "npl_packages" ]]; then
  mkdir -p npl_packages
  (cd npl_packages; git clone https://github.com/NPLPackages/main)
fi

# symbol link config.page file
if [[ -e $CONFIG_FILE_PATH ]]; then
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
if is_test; then
  if [[ -d $TEMP_DIR ]]; then
    rm -rf $TEMP_DIR
  fi
  cp -a $DEV_DIR $TEMP_DIR
  node r.js -o r_package.js
  rm -rf $TEMP_DIR

  mv $BUILD_DIR $TEST_DIR
fi


# normal exit
exit 0
