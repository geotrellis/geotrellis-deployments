#!/usr/bin/env bash

if [ ! -z "$1" ]
then
    aws s3 sync rpmbuild/RPMS/x86_64/ "$1"
else
    echo "Need location"
fi
