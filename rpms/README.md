# Introduction

This directory contains the configuration and build files needed to (re)build the base image and the RPMs.

# Inventory

Built RPMs are publicly available at:

```
s3://geotrellis-build-artifacts/rpms/
```

If you need to load them during an EMR bootstrap, you can use `s3://geotrellis-build-artifacts/rpms/bootstrap.sh`.

For example:

```
BootstrapAction(
  "Install GDAL 2.4 dependencies",
  "s3://geotrellis-build-artifacts/rpms/bootstrap.sh",
  "s3://geotrellis-build-artifacts", "gdal-2.4.1"
)
```

## Caveats

### GDAL S3 Credentials in EMR jobs

Note that if you're installing a version of GDAL < 2.4.0 you'll need to restrict yourself to EC2 instance types that use the older Xen hypervisor. [A fix was added in GDAL 2.4.0](https://github.com/OSGeo/gdal/commit/9df23a3f09e5171e0051748c3de40151671cfea8#diff-6fe1009dc8083259494caa7923e28a22) to support credential detection on the newer Nitro hypervisor. This newer hypervisor includes the following instance types: `C5, M5, H1, T3` but possibly others as well.

### NetCDF remote reads

Note that opening remote NetCDF files, such as is done with the GeoTrellis GDALRasterSource requires that the following:

- Linux kernel 4.5+ with `userfaultd` support
- GDAL 2.4.0+

# Images

The following images can be built from the materials in this directory:

- [`quay.io/geodocker/emr-build:gcc4-8`](Dockerfile.gcc4) is used to build RPMs with gcc 4.8.

## Files and Directories

- [`blobs`](blobs) is an initially-empty directory that is populated with archives and RPMS from the `archives` directory.
- [`rpmbuild`](rpmbuild) is a directory containing configuration files used to produce the RPMs.
- [`scripts`](scripts) is a directory containing scripts used to build the RPMs mentioned above, as well as the `gdal-and-friends.tar.gz` tarball.
- [`Makefile`](Makefile) coordinates the build process.
- The various Dockerfiles specify the various images discussed above.
- `*.mk`: these are included in the Makefile.

# RPMs

## Building

From within this directory, type `./build.sh` to build all of the RPMs (this could take a long time).
Once they are built, type `./publish.sh s3://bucket/prefix/` where `s3://bucket/prefix/` is a "directory" on S3 for which you have write permissions.
The RPMs will be published to `s3://bucket/prefix/abc123/` where `abc123` is the present git SHA.

## Fetching

From within this directory, type `./fetch s3://bucket/prefix/abc123/` where `s3://bucket/prefix/` is the path to a "directory" on S3 where RPMs have been previously-published, and `abc123` is the git SHA from which those RPMs were produced.
