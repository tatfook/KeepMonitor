#! /usr/bin/env bash
#
# update.sh
#
DEV_BRANCH=wxa_dev

cd /project/wikicraft
mkdir -p dev/source

cd dev/source

# clone repo
if [[ ! -d ".git" ]]; then
  rm -rf ./* ./.*
  git clone https://github.com/tatfook/wikicraft .
fi

# checkout dev branch
git rev-parse --verify $DEV_BRANCH
if [[ $? == 0 ]]; then
  # branch exists
  git checkout $DEV_BRANCH
else
  # branch not exists
  git checkout -b $DEV_BRANCH origin/$DEV_BRANCH
fi

# update code
git pull

# normal exit
exit 0
