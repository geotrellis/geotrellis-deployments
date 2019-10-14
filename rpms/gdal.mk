rpmbuild/SOURCES/proj-4.9.3.tar.gz:
	curl -L "http://download.osgeo.org/proj/proj-4.9.3.tar.gz" -o $@

rpmbuild/SOURCES/hdf5-1.8.21.tar.bz2:
	curl -L "https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.21.tar.bz2" -o $@

rpmbuild/SOURCES/netcdf-4.5.0.tar.gz:
	curl -L "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.5.0.tar.gz" -o $@

rpmbuild/SOURCES/openjpeg-2.3.0.tar.gz:
	curl -L "https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz" -o $@

rpmbuild/SOURCES/gdal-2.4.1.tar.gz:
	curl -L "http://download.osgeo.org/gdal/2.4.1/gdal-2.4.1.tar.gz" -o $@

rpmbuild/SOURCES/libgeotiff-1.4.0.tar.gz:
	curl -L "http://github.com/OSGeo/libgeotiff/archive/1.4.0.tar.gz" -o $@

rpmbuild/SOURCES/PDAL-1.8.0.tar.gz:
	curl -L "http://github.com/PDAL/PDAL/archive/1.8.0.tar.gz" -o $@

rpmbuild/SOURCES/laszip-src-3.2.9.tar.gz:
	curl -L "https://github.com/LASzip/LASzip/releases/download/3.2.9/laszip-src-3.2.9.tar.gz" -o $@

rpmbuild/RPMS/x86_64/openjpeg-2.3.0-33.x86_64.rpm: rpmbuild/SPECS/openjpeg.spec rpmbuild/SOURCES/openjpeg-2.3.0.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/openjpeg.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/hdf5-1.8.21-33.x86_64.rpm: rpmbuild/SPECS/hdf5.spec rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm rpmbuild/SOURCES/hdf5-1.8.21.tar.bz2
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/hdf5.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/netcdf-4.5.0-33.x86_64.rpm: rpmbuild/SPECS/netcdf.spec rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm rpmbuild/SOURCES/netcdf-4.5.0.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/netcdf.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm rpmbuild/RPMS/x86_64/proj493-lib-4.9.3-33.x86_64.rpm: rpmbuild/SPECS/proj.spec rpmbuild/SOURCES/proj-4.9.3.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/proj.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/gdal241-2.4.1-33.x86_64.rpm rpmbuild/RPMS/x86_64/gdal241-lib-2.4.1-33.x86_64.rpm: rpmbuild/SPECS/gdal.spec rpmbuild/RPMS/x86_64/openjpeg-2.3.0-33.x86_64.rpm rpmbuild/RPMS/x86_64/proj493-4.9.3-33.x86_64.rpm rpmbuild/RPMS/x86_64/hdf5-1.8.21-33.x86_64.rpm rpmbuild/RPMS/x86_64/netcdf-4.5.0-33.x86_64.rpm rpmbuild/SOURCES/gdal-2.4.1.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/gdal.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/libgeotiff-1.4.0-33.x86_64.rpm: rpmbuild/SPECS/libgeotiff.spec rpmbuild/SOURCES/libgeotiff-1.4.0.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/libgeotiff.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/laszip-3.2.9-33.x86_64.rpm: rpmbuild/SPECS/laszip.spec rpmbuild/SOURCES/laszip-src-3.2.9.tar.gz
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/laszip.sh $(shell id -u) $(shell id -g)

rpmbuild/RPMS/x86_64/pdal180-1.8.0-33.x86_64.rpm: rpmbuild/SPECS/pdal.spec rpmbuild/SOURCES/PDAL-1.8.0.tar.gz rpmbuild/RPMS/x86_64/gdal241-2.4.1-33.x86_64.rpm rpmbuild/RPMS/x86_64/libgeotiff-1.4.0-33.x86_64.rpm rpmbuild/RPMS/x86_64/laszip-3.2.9-33.x86_64.rpm
	docker run -it --rm \
          -v $(shell pwd)/rpmbuild:/tmp/rpmbuild:rw \
          -v $(shell pwd)/scripts:/scripts:ro \
          $(GCC4IMAGE) /scripts/pdal.sh $(shell id -u) $(shell id -g)
