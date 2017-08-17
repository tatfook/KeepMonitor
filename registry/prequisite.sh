#! /usr/bin/env bash
#
# prequisite.sh
#

# link: https://github.com/docker/distribution/issues/948
echo "================================="
echo "1. you should make a little change to openssl.cnf"
echo "================================="

echo
openssl version -a

echo "================================="
echo "look at the last line, edit OPENSSLDIR/openssl.cnf"
echo "make change like below(use your own IP)"
echo "================================="

cat <<EOF
...
[ v3_ca ]
subjectAltName=IP:192.168.1.10
...
EOF

options=("yes" "no")
select opt in "${options[@]}"
do
  case $opt in
    "yes")
      echo "good"
      break
      ;;
    "no")
      echo "you should finish step 1 first"
      exit 1
      ;;
    *) echo "invalid option";;
  esac
done

# link: https://docs.docker.com/registry/insecure/#using-self-signed-certificates
echo "================================="
echo "2. generating certfiles"
echo "remember fill **Common Name** with the IP_in_openssl.cnf"
echo "================================="

CERT_DIR=/data/docker-registry/certs
mkdir -p $CERT_DIR
if [[ ! -f $CERT_DIR/domain.crt ]]; then
  cd $CERT_DIR
  openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout domain.key \
    -x509 -days 365 -out domain.crt
  cd -
fi

echo "================================="
echo "3. Copy the domain.crt file(scp or rsync) to /etc/docker/certs.d/<IP_in_openssl.cnf>:5000/ca.crt on every Docker client host(including registry server itself)."
echo "================================="


