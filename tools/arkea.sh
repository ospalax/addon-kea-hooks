#!/bin/sh

#
# Copyright (2019) Petr Ospalý <petr@ospalax.cz>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

set -ex

KEA_INSTALLPREFIX="${KEA_INSTALLPREFIX:-/usr/local}"

for i in \
    IKEA_PKG \
    KEA_VERSION \
    ALPINE_VERSION \
    ;
do
    _value=$(eval echo "\"\$${i}\"")
    if [ -z "$_value" ] ; then
        echo "ERROR: Variable '${i}' is unset" 1>&2
        exit 1
    fi
done

# here is expected that /build directory is provided as a bind mount for docker
tar cJf "/build/${IKEA_PKG}-${KEA_VERSION}-alpine${ALPINE_VERSION}.tar.xz" \
	"${KEA_INSTALLPREFIX}/etc" \
	"${KEA_INSTALLPREFIX}/include" \
	"${KEA_INSTALLPREFIX}/lib" \
	"${KEA_INSTALLPREFIX}/sbin" \
	"${KEA_INSTALLPREFIX}/share" \
	"${KEA_INSTALLPREFIX}/var" \
	/etc/ld-musl-$(arch).path

chown "${UID_GID:-$(id -u).}" \
    "/build/${IKEA_PKG}-${KEA_VERSION}-alpine${ALPINE_VERSION}.tar.xz"

exit 0

