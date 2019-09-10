#
# Copyright (2019) Petr Ospalý <petr@ospalax.cz>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

FROM alpine:3.10
LABEL maintainer="Petr Ospalý (osp) <petr@ospalax.cz>"

ARG KEA_VERSION
ARG KEA_INSTALLPREFIX
ARG MAKE_JOBS
ARG KEEP_BUILDBLOB
ARG KEEP_BUILDDEPS

ENV KEA_VERSION "${KEA_VERSION}"
ENV KEA_INSTALLPREFIX "${KEA_INSTALLPREFIX}"
ENV MAKE_JOBS "${MAKE_JOBS}"
ENV KEEP_BUILDBLOB "${KEEP_BUILDBLOB}"
ENV KEEP_BUILDDEPS "${KEEP_BUILDDEPS}"

WORKDIR /ikea

COPY ikea.sh ./

RUN chmod 0755 ikea.sh

RUN ./ikea.sh

