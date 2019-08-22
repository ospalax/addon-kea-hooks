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
package: $(BUILD_DIR)/$(IKEA_PKG)-$(KEA_VERSION).tgz

$(BUILD_DIR)/$(IKEA_PKG)-$(KEA_VERSION).tgz: docker
	@echo "IKEA: CREATE PACKAGE..."
	@mkdir -p "$(BUILD_DIR)/tmp"
	cd "$(BUILD_DIR)/tmp" && \
		mkdir -p "./$(KEA_INSTALLPREFIX)" etc && \
		rmdir "./$(KEA_INSTALLPREFIX)" && \
		CID=$$(docker create --rm $(IKEA_TAG):$(KEA_VERSION)) && \
		docker cp -a "$${CID}:$(KEA_INSTALLPREFIX)" \
			"./$(KEA_INSTALLPREFIX)" && \
		docker cp "$${CID}:/etc/ld-musl-x86_64.path" ./etc/ && \
		tar -czf ../$(IKEA_PKG)-$(KEA_VERSION).tgz \
			"./$(KEA_INSTALLPREFIX)" \
			./etc/ld-musl-x86_64.path && \
		docker rm -f "$${CID}" && \
		cd .. && rm -rf tmp

$(BUILD_DIR)/$(IKEA_IMG)-$(KEA_VERSION).tar: Dockerfile ikea.sh
	@echo "IKEA: START DOCKER BUILD..."
	@mkdir -p "$(BUILD_DIR)"
	docker build -t $(IKEA_TAG):$(KEA_VERSION) \
		--build-arg KEA_VERSION=$(KEA_VERSION) \
		--build-arg KEA_INSTALLPREFIX="$(KEA_INSTALLPREFIX)" \
		--build-arg MAKE_JOBS=$(MAKE_JOBS) \
		.
	docker save -o "$(BUILD_DIR)/$(IKEA_IMG)-$(KEA_VERSION).tar" \
		$(IKEA_TAG):$(KEA_VERSION)

clean:
	@echo "IKEA: DELETE BUILD DIR"
	rm -rf "$(BUILD_DIR)"

