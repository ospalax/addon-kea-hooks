/*
 *
 * Copyright (2019) Petr Ospalý <petr@ospalax.cz>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

#ifndef SAFEGUARD__KEA_INTERFACE_H_HEADER__
#define SAFEGUARD__KEA_INTERFACE_H_HEADER__
// do not put any code BEFORE these two lines

#include <fstream>
#include <vector>

// Kea return values
extern int KEA_SUCCESS;
extern int KEA_FAILURE;

// Hook can be loaded but it may be disabled...
extern bool kea_onelease4_enabled;

// By default all prefixes are accepted, otherwise it will expect a string
// representing a two-byte hexadecimal value, eg:
//  00:FF
//  00 FF
//  00FF
//  0x00FF
// This string will be converted to a byte array (vector)
extern std::vector<uint8_t> kea_onelease4_byte_prefix;

// Debug log (if enabled)
extern std::fstream debug_logfile;

// do not put any code AFTER this line
#endif // SAFEGUARD__KEA_INTERFACE_H_HEADER__

