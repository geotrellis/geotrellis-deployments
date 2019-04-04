%define _topdir   /tmp/rpmbuild
%define name      libgeotiff
%define release   33
%define version   1.4.0

%define debug_package %{nil}

BuildRoot: %{buildroot}
Summary:   libgeotiff
License:   X/MIT
Name:      %{name}
Version:   %{version}
Release:   %{release}
Source:    libgeotiff-%{version}.tar.gz
Prefix:    /usr/local
Group:     Azavea
BuildRequires: proj493

%description
GDAL

%prep
%setup -q -n libgeotiff-1.4.0

%build
cd libgeotiff
mkdir makefiles
cd makefiles
cmake -G "Unix Makefiles" ..
make

%install
cd libgeotiff/makefiles
make DESTDIR=%{buildroot} install

%files
%defattr(-,root,root)
/usr/local/*
