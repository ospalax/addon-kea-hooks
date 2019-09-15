#
# Copyright (2019) Petr Ospalý <petr@ospalax.cz>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS builder

ARG KEA_VERSION
ARG KEA_INSTALLPREFIX
ARG MAKE_JOBS
ARG KEEP_BUILDBLOB
ARG KEEP_BUILDDEPS
ARG INSTALL_HOOKS

ENV KEA_VERSION "${KEA_VERSION}"
ENV KEA_INSTALLPREFIX "${KEA_INSTALLPREFIX}"
ENV MAKE_JOBS "${MAKE_JOBS}"
ENV KEEP_BUILDBLOB "${KEEP_BUILDBLOB}"
ENV KEEP_BUILDDEPS "${KEEP_BUILDDEPS}"
ENV INSTALL_HOOKS "${INSTALL_HOOKS}"

#
# build and install ISC Kea
#

WORKDIR /ikea

COPY ikea.sh ./
COPY src/hooks/ ./hooks/

RUN chmod 0755 ikea.sh

RUN ./ikea.sh


###############################################################################
# final image
###############################################################################

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}
LABEL maintainer="Petr Ospalý (osp) <petr@ospalax.cz>"

ARG KEA_VERSION
ARG KEA_INSTALLPREFIX

ENV KEA_VERSION "${KEA_VERSION}"
ENV KEA_INSTALLPREFIX "${KEA_INSTALLPREFIX}"

RUN \
    apk update \
    && \
    apk add --no-cache \
        boost \
        postgresql-client \
        mariadb-client \
        mariadb-connector-c \
        cassandra-cpp-driver \
        openssl \
        ca-certificates \
        curl \
        xz \
    && \
    apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        log4cplus \
    && \
    rm -rf /var/cache/apk/*

# install build artifact
COPY --from=builder "${KEA_INSTALLPREFIX}" "${KEA_INSTALLPREFIX}"
COPY --from=builder /etc/ld-musl-* /etc/

RUN ldconfig "${KEA_INSTALLPREFIX}/lib"

# run microservice
#ENTRYPOINT ["${KEA_INSTALLPREFIX}/sbin/kea-dhcp4"]
#CMD ["-c", "${KEA_INSTALLPREFIX}/etc/kea/kea-dhcp4.conf"]
