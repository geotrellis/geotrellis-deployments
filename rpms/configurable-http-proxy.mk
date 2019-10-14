rpmbuild/SOURCES/node-v8.5.0.tar.gz:
	curl -L "https://nodejs.org/dist/v8.5.0/node-v8.5.0.tar.gz" -o $@

rpmbuild/SOURCES/configurable-http-proxy.tar:
	mkdir configurable-http-proxy
	tar cf $@ configurable-http-proxy
	rmdir configurable-http-proxy

rpmbuild/RPMS/x86_64/nodejs-8.5.0-13.x86_64.rpm: rpmbuild/SPECS/nodejs.spec \
scripts/nodejs.sh \
rpmbuild/SOURCES/node-v8.5.0.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/nodejs.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/configurable-http-proxy-0.0.0-13.x86_64.rpm: rpmbuild/SPECS/configurable-http-proxy.spec \
scripts/configurable-http-proxy.sh \
rpmbuild/SOURCES/configurable-http-proxy.tar \
rpmbuild/RPMS/x86_64/nodejs-8.5.0-13.x86_64.rpm
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/configurable-http-proxy.sh $(shell id -u) $(shell id -g)
