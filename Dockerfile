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

WORKDIR /ikea

COPY ikea.sh ./

RUN chmod 0755 ikea.sh

RUN ./ikea.sh "${KEA_VERSION}" "${KEA_INSTALLPREFIX}" "${MAKE_JOBS}"

