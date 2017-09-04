#! /bin/bash
#
# download-template.sh
#
# usage: ./download-template.sh 0.7.284
# output: page text

#######################################################
# get version number first
#######################################################
#
# sample curl result
#
#  <UpdateVersion>
#  0.7.325
#  </UpdateVersion>
#  <FullUpdatePackUrl>
#  http://update.61.com/haqi/coreupdate/coredownload/list/full.txt
#  </FullUpdatePackUrl>
#
# strip all newlines into one line, convinient for us to get version number
#
version_info=$(curl http://tmlog.paraengine.com/version.php | tr -d '\n')
ver=$(sed -ne 's/.*<UpdateVersion>\(.*\)<\/UpdateVersion>.*/\1/p;q;' <<< "$version_info")

# gitlab api private token, important!!!
PRIVATE_TOKEN=uE4FRNo2AxBw2Wh1XVTv

# post data managed by python script
# input key link addresses and output the post_data for gitlab api
post_data=$(./post-data.py \
  --version ${ver} \
  --baiduyun_link 'http://pan.baidu.com/s/1dFuYuJJ' \
  --launcher_link 'http://www.nplproject.com/download/paracraft/latest/ParacraftLauncher.exe' \
  --full_link 'http://www.nplproject.com/zh/download/paracraft/latest/paracraft_full.exe' \
  --andriod_link 'http://www.pgyer.com/bUyL' \
  --ios_link 'http://www.pgyer.com/para'
)

# update page content
address=http://gitlab.keepwork.com/api/v4/projects/3432/repository/commits

# FUCK!!!! curl only works only when no ^I(tab) in data string
curl -v --request POST \
  --url ${address} \
  --header 'cache-control: no-cache' \
  --header "content-type: application/json" \
  --header "private-token: ${PRIVATE_TOKEN}" \
  -d "$post_data"
