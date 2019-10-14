#!/usr/bin/env bash

USERID=$1
GROUPID=$2

yum install -y cmake3
yum install -y geos-devel lcms2-devel libcurl-devel libpng-devel zlib-devel libxml2-devel
yum localinstall -y /tmp/rpmbuild/RPMS/x86_64/laszip-3.2.9-33.x86_64.rpm /tmp/rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm /tmp/rpmbuild/RPMS/x86_64/libgeotiff-1.4.0-33.x86_64.rpm /tmp/rpmbuild/RPMS/x86_64/hdf5-1.8.21-33.x86_64.rpm /tmp/rpmbuild/RPMS/x86_64/netcdf-4.5.0-33.x86_64.rpm /tmp/rpmbuild/RPMS/x86_64/openjpeg230-2.3.0-33.x86_64.rpm /tmp/rpmbuild/RPMS/x86_64/gdal241-2.4.1-33.x86_64.rpm
ldconfig

cd /tmp/rpmbuild
chown -R root:root /tmp/rpmbuild/SOURCES/PDAL-1.8.0.tar.gz
rpmbuild -v -bb --clean SPECS/pdal.spec
chown -R $USERID:$GROUPID /tmp/rpmbuild
