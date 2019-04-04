%define _topdir   /tmp/rpmbuild
%define name      laszip
%define release   33
%define version   3.2.9

%define debug_package %{nil}

BuildRoot: %{buildroot}
Summary:   laszip
License:   X/MIT
Name:      %{name}
Version:   %{version}
Release:   %{release}
Source:    laszip-src-%{version}.tar.gz
Prefix:    /usr/local
Group:     Azavea

%description
LASzip

%prep
%setup -q -n laszip-src-3.2.9

%build
mkdir makefiles
cd makefiles
cmake -G "Unix Makefiles" ..
make

%install
cd makefiles
make DESTDIR=%{buildroot} install

%files
%defattr(-,root,root)
/usr/local/*
