#!/usr/bin/env bash

USERID=$1
GROUPID=$2

cd /tmp/rpmbuild
chown -R root:root /tmp/rpmbuild/SOURCES/laszip-src-3.2.9.tar.gz
rpmbuild -v -bb --clean SPECS/laszip.spec
chown -R $USERID:$GROUPID /tmp/rpmbuild
