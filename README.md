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

In the future, we hope to produce Python wheels to enable use of
[GeoPySpark](https://github.com/locationtech-labs/geopyspark) on our target
environments.

## Deploying Geotrellis to AWS ##

The `emr` directory contains Makefiles to allow deployment to an Amazon Elastic
Map-Reduce (EMR) cluster.  See that directory for details on how to do so.
