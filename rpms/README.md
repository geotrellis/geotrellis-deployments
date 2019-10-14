# RPM Binaries for Geotrellis Environments

This directory contains the configuration, build files, and Docker images
needed to build a set of RPMs that are useful for working with Geotrellis. If
you are not intending to alter the composition or versions of the RPM
packages, then you should be able to use the published binaries and do not
need to build these artifacts yourself. Specifically:

> **Do nothing** if you are intending to deploy to EMR and have access to
> pre-built RPMs. Simply point the EMR scripts to the relevant resources on
> S3 at `s3://geotrellis-build-artifacts/rpms/`. [See below](#working-with-sbt-lighter) if using sbt-lighter.

> **[Fetch](#Fetching), do not build** if you have access to an already-built set of
> RPMs, and your purpose is to use these RPMs to build a Docker container.

## Caveats

### GDAL S3 Credentials in EMR jobs

Note that if you're installing a version of GDAL < 2.4.0 you'll need to restrict yourself to EC2 instance types that use the older Xen hypervisor. [A fix was added in GDAL 2.4.0](https://github.com/OSGeo/gdal/commit/9df23a3f09e5171e0051748c3de40151671cfea8#diff-6fe1009dc8083259494caa7923e28a22) to support credential detection on the newer Nitro hypervisor. This newer hypervisor includes the following instance types: `C5, M5, H1, T3` but possibly others as well.

### NetCDF remote reads

Note that opening remote NetCDF files, such as is done with the GeoTrellis GDALRasterSource requires that the following:

- Linux kernel 4.5+ with `userfaultd` support
- GDAL 2.4.0+

# RPMs

## Fetching

From this directory, issue `./fetch s3://bucket/prefix/` where
`s3://bucket/prefix/` is the path to a "directory" on S3 where RPMs have been
previously published, such as `s3://geotrellis-build-artifacts/rpms/`. This
will download the available RPMs as if you had built them yourself. You
may then go to the `docker` directory off the project root and follow the
instructions for building the image.

## Building

If you need to build these resources yourself, either because you have
adjusted the versions or added additional resources, or because you do not
have access to pre-built binaries, then execute `./build.sh` from this
directory to build all of the RPMs. _This may take a long time._

## Publishing

Once the RPMs are built, you may execute `./publish.sh s3://bucket/prefix/`
where `s3://bucket/prefix/` is a "directory" on S3 for which you have write
permissions. The RPMs will be published to this location.

# Inventory

## Images

[`quay.io/geodocker/emr-build:gcc4-8`](Dockerfile.gcc4) is used to provide a
consistent environment for building RPMs with gcc 4.8.

## Files and Directories

- [`rpmbuild`](rpmbuild) is a directory containing configuration files used to produce the RPMs.
- [`scripts`](scripts) is a directory containing scripts used to build the RPMs mentioned above.
- [`Makefile`](Makefile) coordinates the build process.
- `*.mk`: these are included in the Makefile.

# Working with SBT Lighter

If you're bootstrapping your EMR clusters with the [SBT lighter plugin](https://github.com/pishen/sbt-lighter) you can configure your cluster to use the RPMs described here with the following bootstrap action:

```scala
BootstrapAction(
  "Install GDAL 2.4 dependencies",
  "s3://geotrellis-build-artifacts/rpms/bootstrap.sh",
  "s3://geotrellis-build-artifacts", "gdal-2.4.1"
)
```
