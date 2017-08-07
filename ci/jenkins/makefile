#
# makefile
# zdw, 2017-08-03 15:50
#

PROXY=http://www:1234567@192.168.0.200:8282

all:
	sudo docker build\
		--build-arg="http_proxy=${PROXY}"\
		--build-arg="https_proxy=${PROXY}"\
		-t ci_jenkins .


# vim:ft=make
#
