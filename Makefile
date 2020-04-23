#!/usr/bin/make -f

SHELL := /bin/bash


client-image:
	docker build \
	         -t phlax/openvpn-client \
		docker/openvpn-client

server-image:
	docker build \
	         -t phlax/openvpn-server \
		docker/openvpn-server
	if [ ! -d docker-copyedit ]; then git clone https://github.com/gdraheim/docker-copyedit; fi
	chmod +x ./docker-copyedit/docker-copyedit.py
	./docker-copyedit/docker-copyedit.py -vv \
		FROM phlax/openvpn-server \
		INTO phlax/openvpn-server:latest \
		REMOVE VOLUME /etc/openvpn

images: client-image server-image

hub-images:
	docker push phlax/openvpn-server
	docker push phlax/openvpn-client

pysh:
	pip install -U pip setuptools termcolor
	pip install -e 'git+https://github.com/phlax/pysh#egg=pysh.test&subdirectory=pysh.test'
