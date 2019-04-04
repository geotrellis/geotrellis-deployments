# EMR Deployment Scripts #

This subdirectory provides the necessary means to start an EMR cluster on
Amazon's computing infrastructure which provides Geotrellis capabilities.  The
primary means for interaction with this cluster are through Jupyter notebooks
and spark-submit commands.

> Note: using `spark-submit` requires that application-dependent make targets
> be constructed to submit an EMR step.  Given the lack of concrete
> applications to run, these targets do not yet exist.

Two Jupyter kernels will be provided that will allow for different sorts of
work flows.  The first is a Python kernel available under the `GeoPySpark`
entry in the `New` menu on the Jupyter home page.  This kernel allows for
Spark processes mediated by GeoPySpark, with the myriad visualization options
provided by the underlying IPython kernel through Folium, matplotlib, and
other plugins.

The second option is to use the Scala kernel, provided by the
[Almond](http://almond-sh.github.io/almond/stable/docs/intro) plugin, which
runs on top of [Ammonite](http://ammonite.io).  When creating a new Scala
project, the boilerplate for building a SparkSession object and loading
external dependencies can be inserted at the top of the notebook by clicking
the star icon in the toolbar.

> Note: The Scala kernel is not yet up to full working order.  It is possible,
> however, to ssh into the master node and use spark-shell if one wishes to
> have an interactive Scala session.  No documentation will be provided for
> this method, as the current goal is to allow all required interaction via
> Jupyter.

## Cluster Configuration and Management ##

Cluster management here is provided through a Makefile and a collection of
supporting files.  Proper setup of this cluster may require tweaks to any of
the support files and/or environment variables.  We describe the likely points
of configuration, followed by the make targets that are used to work with the
cluster.

### Configuration Files ###

#### `config-aws.mk` ####

`EC2_KEY`: Supply the name of the key pair you wish to use.  This implies that
whichever name you provide corresponds to a PEM file in the user's home
directory named `${EC2_KEY}.pem`.

`SUBNET_ID`: Ensures that all nodes are launched in a consistent network
domain.  Possible values for this variable can be found in the VPC subnets
panel from the AWS EMR console.

#### `config-emr.mk` ####

`NAME`: The display name that will be seen in the Clusters panel of the EMR
console.

`SECURITY_GROUP`: Used for the purposes of network security management.  The
named security group must already exist and be configured with the appropriate
ingress/egress rules for the current application.

`MASTER_INSTANCE` and `WORKER_INSTANCE`: The type of instances to use for each
node type.  (E.g., `m3.large`.)

`WORKER_COUNT`: Number of worker nodes to provision.

`USE_SPOT`, `MASTER_PRICE`, and `WORKER_PRICE`: If `USE_SPOT` is true,
provision nodes on the spot market, with bid prices given in the
`MASTER_PRICE` and `WORKER_PRICE` vars.  The maximum bid price should be set
according to node type and region.

#### `config-run.mk` ####

`S3_URI`: An S3 URI (of the form `s3://bucket/prefix/path`) that will store
files relevant to the operation of the cluster.  In this folder, there must
exist an `rpms` subtree that contains RPM resources needed to bootstrap the
cluster (see `RPMS_VERSION` below), and files will be placed in the `scripts`
subfolder to facilitate cluster startup.

`NB_BUCKET` and `NB_PREFIX`: The location on S3 where Jupyter notebooks will
be found/stored.  The bucket must exist prior to startup, but the prefix does
not.  If the prefix exists, any files contained therein will be available to
the Jupyter instance after login.

`GEOPYSPARK_VERSION`: The GeoPySpark version to be used.  This version must
have a corresponding JAR file available at
`s3://geopyspark-resources/jars/geotrellis-backend-assembly-${GEOPYSPARK_VERSION}.jar`.

`RPMS_VERSION`: Identifies the version of the RPM and .whl repository to use
during cluster bootstrapping.  This implies that the
`s3://${S3_URI}/rpms/${RPMS_VERSION}` subfolder exists and is populated by the
necessary resources.  See
[here](https://github.com/geodocker/geodocker-jupyter-geopyspark/tree/master/rpms/build)
for more information on how to generate these resources.

#### `cluster-configurations.json` ####

Provides configurations to the applications provided by the EMR cluster
(Spark, YARN, Zeppelin, etc.).  See
[here](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html)
for more details.

### Environment Variables ###

`GEOPYSPARKSHA`: If you intend to work with a development version of
GeoPySpark, you may specify the SHA of a Github commit to use during the
build.  This will be pulled from the `locationtech-labs/geopyspark`
repository.

> Note: This will not adjust the mechanism for downloading the supporting jar
> file, which will still be downloaded as described in the documentation for
> `GEOPYSPARK_VERSION` above.  This limitation can be removed in a subsequent
> update to these scripts.

`CLUSTER_ID`: If you are working with multiple clusters, you may need to
specify the cluster ID for the target cluster, or the last created cluster
will be the default target.

### Make Targets ###

#### `make create-cluster` ####

This make target sets up an EMR cluster according to the configurations given above.

#### `make terminate-cluster` ####

Shuts down the running cluster.

#### `make ssh` ####

Opens an `ssh` connection to the cluster's master node.

#### `make proxy` ####

Opens an `ssh` tunnel to the cluster for use with Foxy Proxy to allow access
to the YARN Resource Manager, Spark History server, Ganglia, and any other
remote apps running on the cluster.
