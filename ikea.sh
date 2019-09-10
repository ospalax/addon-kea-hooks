#!/bin/sh

#
# Copyright (2019) Petr Ospalý <petr@ospalax.cz>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

set -ex

KEA_VERSION="$1"
KEA_INSTALLPREFIX="${2:-/usr/local}"
MAKE_JOBS="${3:-1}"

#
# functions
#

install_kea_runtime_deps()
{
    apk update

    apk add --no-cache \
        boost \
        postgresql-client \
        mariadb-client \
        mariadb-connector-c \
        cassandra-cpp-driver \
        openssl \
        ca-certificates \
        curl \
        ;

    apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        log4cplus
}

install_kea_build_deps()
{
    apk add --no-cache --virtual .build-deps \
        build-base \
        file \
        gnupg \
        pkgconf \
        automake \
        libtool \
        docbook-xsl \
        libxslt \
        doxygen \
        openssl-dev \
        boost-dev \
        postgresql-dev \
        mariadb-dev \
        musl-dev \
        zlib-dev \
        bzip2-dev \
        sqlite-dev \
        cassandra-cpp-driver-dev \
        python3-dev \
        ;

    apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        log4cplus-dev
}

install_kea_from_source()
{
    curl -LOR \
        "https://ftp.isc.org/isc/kea/${KEA_VERSION}/kea-${KEA_VERSION}.tar.gz{,.sha512.asc}"

    mkdir -m 0700 -p /root/.gnupg

    gpg2 \
        --no-options \
        --verbose \
        --keyid-format 0xlong \
        --keyserver-options \
        auto-key-retrieve=true \
        --verify \
        kea-${KEA_VERSION}.tar.gz*asc \
        kea-${KEA_VERSION}.tar.gz

    tar xzpf kea-${KEA_VERSION}.tar.gz

    rm -rf \
        kea-${KEA_VERSION}.tar.gz* \
        /root/.gnupg* \

    cd kea-${KEA_VERSION}

    ./configure \
        --prefix="${KEA_INSTALLPREFIX}" \
        --enable-shell \
        --with-mysql=/usr/bin/mysql_config \
        --with-pgsql=/usr/bin/pg_config \
        --with-cql=/usr/bin/pkg-config \
        --with-openssl \
        --with-log4cplus=/usr \
        ;

    make -j ${MAKE_JOBS} && make install-strip

    cd -

    echo "/lib:/usr/local/lib:/usr/lib" > /etc/ld-musl-x86_64.path
    echo "${KEA_INSTALLPREFIX}/lib" >> /etc/ld-musl-x86_64.path
    ldconfig "${KEA_INSTALLPREFIX}/lib"
}

clean_apk()
{
    apk --purge del .build-deps log4cplus-dev
    rm -rf /var/cache/apk/*
}

clean_kea_build()
{
    rm -rf /ikea/kea-${KEA_VERSION}
}

#
# main
#

# install packages
install_kea_runtime_deps
install_kea_build_deps

# build and install
install_kea_from_source

# cleanup
clean_apk
clean_kea_build

exit 0

