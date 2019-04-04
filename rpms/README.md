# Introduction #

This directory contains the configuration and build files needed to (re)build the base image and the RPMs.

# Inventory #

## Images ##

The following images can be built from the materials in this directory:

   - [`quay.io/geodocker/emr-build:gcc4-8`](Dockerfile.gcc4) is used to build RPMs with gcc 4.8.

## Files and Directories ##

   - [`blobs`](blobs) is an initially-empty directory that is populated with archives and RPMS from the `archives` directory.
   - [`rpmbuild`](rpmbuild) is a directory containing configuration files used to produce the RPMs.
   - [`scripts`](scripts) is a directory containing scripts used to build the RPMs mentioned above, as well as the `gdal-and-friends.tar.gz` tarball.
   - [`Makefile`](Makefile) coordinates the build process.
   - The various Dockerfiles specify the various images discussed above.
   - `*.mk`: these are included in the Makefile.

# RPMs #

## Building ##

From within this directory, type `./build.sh` to build all of the RPMs (this could take a long time).
Once they are built, type `./publish.sh s3://bucket/prefix/` where `s3://bucket/prefix/` is a "directory" on S3 for which you have write permissions.
The RPMs will be published to `s3://bucket/prefix/abc123/` where `abc123` is the present git SHA.

## Fetching ##

From within this directory, type `./fetch s3://bucket/prefix/abc123/` where `s3://bucket/prefix/` is the path to a "directory" on S3 where RPMs have been previously-published, and `abc123` is the git SHA from which those RPMs were produced.
