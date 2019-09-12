#
# Copyright (2019) Petr Ospalý <petr@ospalax.cz>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# make config file - it provides default values
include Makefile.config

.PHONY: all docker package clean

all: docker package

docker: $(BUILD_DIR)/$(IKEA_IMG)-$(KEA_VERSION).tar
package: $(BUILD_DIR)/$(IKEA_PKG)-$(KEA_VERSION).tar.xz

$(BUILD_DIR)/$(IKEA_PKG)-$(KEA_VERSION).tar.xz: docker
	@echo "IKEA: CREATE PACKAGE..."
	docker run --rm -it --entrypoint /bin/sh \
		-e "KEA_INSTALLPREFIX=$(KEA_INSTALLPREFIX)" \
		-e "IKEA_PKG=$(IKEA_PKG)" \
		-e "KEA_VERSION=$(KEA_VERSION)" \
		-e "UID_GID=$$(getent passwd ${USERNAME} | cut -d":" -f3,4)" \
		-v "$$(realpath '$(BUILD_DIR)'):/build/:rw" \
		-v "$$(realpath ./tools/arkea.sh):/arkea.sh:ro" \
		--user root \
		$(IKEA_TAG):$(KEA_VERSION) \
		/arkea.sh
	sha256sum "$(BUILD_DIR)/$(IKEA_PKG)-$(KEA_VERSION).tar.xz" \
		> "$(BUILD_DIR)/$(IKEA_PKG)-$(KEA_VERSION).tar.xz.sha256sum"

$(BUILD_DIR)/$(IKEA_IMG)-$(KEA_VERSION).tar: Dockerfile ikea.sh
	@echo "IKEA: START DOCKER BUILD..."
	@mkdir -p "$(BUILD_DIR)"
	docker build -t $(IKEA_TAG):$(KEA_VERSION) \
		--build-arg KEA_VERSION=$(KEA_VERSION) \
		--build-arg KEA_INSTALLPREFIX="$(KEA_INSTALLPREFIX)" \
		--build-arg MAKE_JOBS=$(MAKE_JOBS) \
		--build-arg KEEP_BUILDBLOB=$(KEEP_BUILDBLOB) \
		--build-arg KEEP_BUILDDEPS=$(KEEP_BUILDDEPS) \
		.
	docker save -o "$(BUILD_DIR)/$(IKEA_IMG)-$(KEA_VERSION).tar" \
		$(IKEA_TAG):$(KEA_VERSION)

clean:
	@echo "IKEA: DELETE BUILD DIR"
	rm -rf "$(BUILD_DIR)"

