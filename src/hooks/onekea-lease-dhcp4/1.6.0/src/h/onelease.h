/*
 *
 * Copyright (2019) Petr Ospalý <petr@ospalax.cz>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

#ifndef SAFEGUARD__ONELEASE_H_HEADER__
#define SAFEGUARD__ONELEASE_H_HEADER__
// do not put any code BEFORE these two lines


#include <hooks/hooks.h>
#include <dhcpsrv/subnet.h>
#include <dhcpsrv/lease.h>


// Here we do all the 'lease' assignment work
int onekea_lease4(isc::hooks::CalloutHandle& handle,
                  isc::dhcp::Subnet4Ptr subnet4_ptr,
                  isc::dhcp::Lease4Ptr lease4_ptr,
                  const std::string callout_name);

// do not put any code AFTER this line
#endif // SAFEGUARD__ONELEASE_H_HEADER__

