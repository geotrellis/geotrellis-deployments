VERSION := 1
IMAGETAG := quay.io/geotrellis/base:$(VERSION)

blobs/spark-2.3.3-bin-hadoop2.7.tgz:
	curl -L "http://archive.apache.org/dist/spark/spark-2.3.3/spark-2.3.3-bin-hadoop2.7.tgz" -o $@

RPMS/netcdf-4.5.0-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/netcdf-4.5.0-33.x86_64.rpm
RPMS/gdal241-2.4.1-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/gdal241-2.4.1-33.x86_64.rpm
RPMS/nodejs-8.5.0-13.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/nodejs-8.5.0-13.x86_64.rpm
RPMS/openjpeg230-2.3.0-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/openjpeg230-2.3.0-33.x86_64.rpm
RPMS/hdf5-1.8.21-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/hdf5-1.8.21-33.x86_64.rpm
RPMS/pdal-1.8.0-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/pdal-1.8.0-33.x86_64.rpm
RPMS/laszip-3.2.9-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/laszip-3.2.9-33.x86_64.rpm
RPMS/proj493-4.9.3-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm
RPMS/libgeotiff-1.4.0-33.x86_64.rpm: ../rpms/rpmbuild/RPMS/x86_64/libgeotiff-1.4.0-33.x86_64.rpm

RPMS:
	mkdir -p RPMS

rpms: RPMS RPMS/netcdf-4.5.0-33.x86_64.rpm RPMS/gdal241-2.4.1-33.x86_64.rpm \
RPMS/nodejs-8.5.0-13.x86_64.rpm RPMS/openjpeg230-2.3.0-33.x86_64.rpm \
RPMS/hdf5-1.8.21-33.x86_64.rpm RPMS/pdal-1.8.0-33.x86_64.rpm \
RPMS/laszip-3.2.9-33.x86_64.rpm RPMS/proj493-4.9.3-33.x86_64.rpm \
RPMS/libgeotiff-1.4.0-33.x86_64.rpm

RPMS/%:
	cp -f $< $@


image: rpms blobs/spark-2.3.3-bin-hadoop2.7.tgz
	docker build -t $(IMAGETAG) .

clean:
	unlink RPMS
