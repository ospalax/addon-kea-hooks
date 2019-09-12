#!/bin/sh

set -ex

KEA_INSTALLPREFIX=/opt/one-appliance/kea
MAKE_JOBS="${MAKE_JOBS:-4}"
IKEA_TAG=onekea
IKEA_IMG=onekea-image
IKEA_PKG=onekea
KEEP_BUILDBLOB=yes

export KEA_INSTALLPREFIX
export MAKE_JOBS
export IKEA_TAG
export IKEA_IMG
export IKEA_PKG
export KEEP_BUILDBLOB

WORKDIR=$(git rev-parse --show-toplevel)

cd "$WORKDIR"

time make package

cd -

