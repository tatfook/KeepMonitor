#! /usr/bin/env bash
#
# start.sh
#
set -x

ENV_TYPE=dev
if [[ $1 == "test" ]]; then
  ENV_TYPE=test
fi

is_test() {
  [[ $ENV_TYPE == "test" ]]
}


BASE_DIR=/project/wikicraft/$ENV_TYPE
LOG_DIR=$BASE_DIR/log
SOURCE_DIR=$BASE_DIR/source

# ROOT DIR in cmdline must be a relative value base on SOURCE_DIR
ROOT_DIR=www
PORT=8900
if is_test; then
  ROOT_DIR=test
  PORT=8099
fi

mkdir -p $SOURCE_DIR
mkdir -p $LOG_DIR

# TODO backup log
cd $SOURCE_DIR
ulimit -c unlimited
npl -D bootstrapper="script/apps/WebServer/WebServer.lua"  root="$ROOT_DIR/" port="$PORT" logfile="$LOG_DIR/$ENV_TYPE.log"


backup_log() {
  local typ=$1
  local curtime=`date +%Y-%m-%d_%H-%M-%S`
  mkdir -p "log"
  cp  "${typ}_log.log" "log/${typ}_log_${curtime}.log"
  cat "${typ}_log.log" | grep -i "<runtime" >> "log/${typ}_error.log"
}

start_server() {
  local server_type=$1

  if [ $server_type = "test" ]; then
    if [ -e ${build_dir} ]; then
      rm -fr ${test_dir}
      cp -fr ${build_dir} ${test_dir}
    fi
    ulimit -c unlimited
    backup_log ${test_dir}
    echo "" > "${test_dir}_log.log"
    npl bootstrapper="script/apps/WebServer/WebServer.lua"  root="${test_dir}/" port="8099" logfile="${test_dir}_log.log"
  elif [ $server_type = "rls" ]; then
    if [ -e ${build_dir} ]; then
      rm -fr ${rls_dir}
      cp -fr ${build_dir} ${rls_dir}
    fi
    ulimit -c unlimited
    backup_log ${rls_dir}
    echo "" > "${rls_dir}_log.log"
    npl bootstrapper="script/apps/WebServer/WebServer.lua"  root="${rls_dir}/" port="8088" logfile="${rls_dir}_log.log"
  elif [ $server_type = "dev" ]; then
    ulimit -c unlimited
    backup_log ${dev_dir}
    echo "" > "${dev_dir}_log.log"
    npl bootstrapper="script/apps/WebServer/WebServer.lua"  root="${dev_dir}/" port="8900" logfile="${dev_dir}_log.log"
  fi
}

restart_server() {
  local server_type=$1

  stop_server $server_type
  start_server $server_type
}

main() {
  local server_type=$2
  if [ -z $server_type  ]; then
    server_type="all"
  fi
  if [ "$1" == "build" ]; then
    # 打包  ./start.sh build
    if [ -e ${build_dir} ]; then
      rm -fr ${build_dir}
    fi
    temp_build_dir="temp_${build_dir}"
    if [ -e ${temp_build_dir} ]; then
      rm -fr ${temp_build_dir}
    fi

    cp -fr ${dev_dir} ${temp_build_dir}
    node r.js -o r_package.js
    rm -fr ${temp_build_dir}
  elif [ "$1" == "start" ]; then
    # etc:  ./start.sh start dev|test|rls
    echo "start server :"$server_type
    start_server $server_type
  elif [ "$1" == "stop" ]; then
    # etc:  ./start.sh stop dev|test|rls
    echo "stop server :"$server_type
    stop_server $server_type
  else
    # etc:  ./start.sh restart dev|test|rls
    # $server_type为空 重启 dev 和 test  不重启rls
    echo "restart server :"$server_type
    restart_server $server_type
  fi
}

