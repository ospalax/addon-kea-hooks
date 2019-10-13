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

#include <vector>
#include <exception>

// My exceptions
class ErrEmptyIPv4Str : public std::exception
{
   virtual const char * what () const throw ()
   {
      return "Empty IPv4 address string!";
   }
};

// Here we do all the 'onelease' assignment work
int kea_onelease4(isc::hooks::CalloutHandle& handle,
                  isc::dhcp::Subnet4Ptr subnet4_ptr,
                  isc::dhcp::Lease4Ptr lease4_ptr,
                  const std::string callout_name);

// Checks and compares the byte prefix with the HW address
bool match_byte_prefix(const std::vector<uint8_t> &byte_prefix,
                       const std::vector<uint8_t> &hw_addr);


// do not put any code AFTER this line
#endif // SAFEGUARD__ONELEASE_H_HEADER__

