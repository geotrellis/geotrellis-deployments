# RPM Binaries for Geotrellis Environments #

This directory contains the configuration, build files, and Docker images
needed to build a set of RPMs that are useful for working with Geotrellis.  If
you are not intending to alter the composition or versions of the RPM
packages, then you should be able to use the published binaries described in
the README at the root of this project and do not need to build these
artifacts yourself. Specifically:

  > **Do nothing** if you are intending to deploy to EMR and have access to
  > pre-built RPMs.  Simply point the EMR scripts to the relevant resources on
  > S3.

  > **Fetch, do not build** if you have access to an already-built set of
  > RPMs, and your purpose is to use these RPMs to build a Docker container.

If you have a special use case, and the pre-built binaries are not sufficient,
then you may need to build them yourself.

# Using this Repository #

## Fetching ##

From this directory, issue `./fetch s3://bucket/prefix/` where
`s3://bucket/prefix/` is the path to a "directory" on S3 where RPMs have been
previously published.  This will download the available RPMs as if you had
built them yourself.  You may then go to the `docker` directory off the
project root and follow the instructions for building the image.

## Building ##

If you need to build these resources yourself, either because you have
adjusted the versions or added additional resources, or because you do not
have access to pre-built binaries, then execute `./build.sh` from this
directory to build all of the RPMs.  *This may take a long time.*

## Publishing ##

Once the RPMs are built, you may execute `./publish.sh s3://bucket/prefix/`
where `s3://bucket/prefix/` is a "directory" on S3 for which you have write
permissions.  The RPMs will be published to this location.

# Inventory #

## Images ##

[`quay.io/geodocker/emr-build:gcc4-8`](Dockerfile.gcc4) is used to provide a
consistent environment for building RPMs with gcc 4.8.

## Files and Directories ##

   - [`rpmbuild`](rpmbuild) is a directory containing configuration files used
     to produce the RPMs.
   - [`scripts`](scripts) is a directory containing scripts used to build the
     RPMs mentioned above.
   - [`Makefile`](Makefile) coordinates the build process.
   - `*.mk`: these are included in the Makefile.
