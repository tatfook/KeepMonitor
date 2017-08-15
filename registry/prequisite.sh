#! /usr/bin/env bash
#
# prequisite.sh
#

# link: https://github.com/docker/distribution/issues/948
echo "1. you should make a little change to openssl.cnf"
echo
openssl version -a
echo "look at the last line, edit OPENSSLDIR/openssl.cnf"
echo "make change like below(use your own IP)"
cat <<EOF
...
[ v3_ca ]
subjectAltName=IP:192.168.1.10
...
EOF

# link: https://docs.docker.com/registry/insecure/#using-self-signed-certificates
echo "2. generating certfiles"
echo "remember fill "

CERT_DIR=/data/docker-registry/certs
mkdir -p $CERT_DIR
if [[ ! -f $CERT_DIR/domain.crt ]]; then
  cd $CERT_DIR
  openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout domain.key \
    -x509 -days 365 -out domain.crt
  cd -
fi

echo "3. Copy the domain.crt file to /etc/docker/certs.d/<IP_in_openssl.cnf>:5000/ca.crt on every Docker client host."


