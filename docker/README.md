# Docker Image #

This directory provides the means to build an `amazonlinux`-based container
environment that can be used for testing prior to deployment on AWS or in a
standalone fashion.

To build this image, please first build the RPM artifacts in `../rpms`, then
issue `make image` in this directory.  The resulting image will be saved as
```
quay.io/geotrellis/base:${VERSION}
```
If you wish to use a different name, apply a different label using the `docker
tag` command in the console.

For projects which do not need an Apache Spark-enabled environment with GDAL,
PDAL, HDF5, NetCDF, that mirrors an EMR environment, this may not be the
appropriate image.  See https://github.com/azavea/docker-openjdk-gdal for a
lightweight image providing only GDAL, which will serve many applications
well.
