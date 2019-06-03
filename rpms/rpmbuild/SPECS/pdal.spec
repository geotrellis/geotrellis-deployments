%define _topdir   /tmp/rpmbuild
%define name      pdal
%define release   33
%define version   1.8.0

%define debug_package %{nil}

BuildRoot: %{buildroot}
Summary:   PDAL
License:   X/MIT
Name:      %{name}
Version:   %{version}
Release:   %{release}
Source:    PDAL-%{version}.tar.gz
Prefix:    /usr/local
Group:     Azavea
Requires:  libpng
Requires:  libcurl
Requires:  geos
Requires:  hdf5
Requires:  netcdf
Requires:  laszip
Requires:  libgeotiff
BuildRequires: geos-devel
BuildRequires: lcms2-devel
BuildRequires: libcurl-devel
BuildRequires: libpng-devel
BuildRequires: libxml2-devel
BuildRequires: openjpeg230
BuildRequires: zlib-devel
BuildRequires: libgeotiff
BuildRequires: laszip
BuildRequires: hdf5
BuildRequires: netcdf
BuildRequires: gdal241
BuildRequires: cmake3

%description
GDAL

%prep
%setup -q -n PDAL-1.8.0

%build
mkdir makefiles
cd makefiles
cmake3 -G "Unix Makefiles" ..
make

%install
cd makefiles
make DESTDIR=%{buildroot} install

%files
%defattr(-,root,root)
/usr/local/*
