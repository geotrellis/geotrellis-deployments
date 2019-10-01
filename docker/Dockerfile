FROM amazonlinux:2
MAINTAINER James McClain <james.mcclain@gmail.com>
MAINTAINER Justin Polchlopek <jpolchlopek@azavea.com>

RUN yum makecache fast

# Java
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && \
    yum install -y yum install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-6.noarch.rpm && \
    yum update -y
RUN yum install -y java-1.8.0-openjdk geos tar

# Spark
ADD blobs/spark-2.3.3-bin-hadoop2.7.tgz /usr/local/
RUN ln -s /usr/local/spark-2.3.3-bin-hadoop2.7 /usr/local/spark
ENV SPARK_HOME /usr/local/spark
ENV PATH="/usr/local/spark/bin:${PATH}"

# kit, caboodle
ADD RPMS /blobs/
RUN yum localinstall -y \
    /blobs/netcdf-4.5.0-33.x86_64.rpm \
    /blobs/gdal241-2.4.1-33.x86_64.rpm \
    /blobs/nodejs-8.5.0-13.x86_64.rpm \
    /blobs/openjpeg230-2.3.0-33.x86_64.rpm \
    /blobs/hdf5-1.8.21-33.x86_64.rpm \
    /blobs/pdal-1.8.0-33.x86_64.rpm \
    /blobs/laszip-3.2.9-33.x86_64.rpm \
    /blobs/proj493-4.9.3-33.x86_64.rpm \
    /blobs/libgeotiff-1.4.0-33.x86_64.rpm && \
    rm -r /blobs

RUN echo /usr/local/lib >> /etc/ld.so.conf.d/local.conf && \
    echo /usr/local/lib64 >> /etc/ld.so.conf.d/local.conf && \
    ldconfig

# Create user
RUN yum install -y shadow-utils && \
    useradd hadoop -m && usermod -a -G root hadoop && (echo 'hadoop:hadoop' | chpasswd)

USER hadoop
