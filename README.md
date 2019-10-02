# Deploying Geotrellis-Enabled Environments #

This repository exists to ease the process of creating Geotrellis-capable
deployments.  This largely means creating binary artifacts and then using the
appropriate machinery to place those artifacts the proper environments.  Using
this repository requires a two (or more) step process to (1) build the needed
resources and then (2) deploy them.

## Creating Binary Artifacts ##

At present, this repository only builds binary resources for use on Amazon
Linux environments.  Principally, this is EMR, but may also be an
`amazonlinux`-based Docker environment.

See the `rpms` directory for details.

## Deploying Geotrellis to AWS ##

The `emr` directory contains Makefiles to allow deployment to an Amazon Elastic
Map-Reduce (EMR) cluster.  See that directory for details on how to do so.

## Docker Container ##

We provide a docker image that uses the binary RPM artifacts to build a
container environment based on the `amazonlinux` base.  This permits offline
testing prior to EMR deployment, and gives a more fully-featured environment
than some previously-existing docker images, including NetCDF, HDF5, and PDAL
support.  See the `docker` directory for more details.
