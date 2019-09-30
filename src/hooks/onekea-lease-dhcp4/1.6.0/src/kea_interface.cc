/*
 *
 * Copyright (2019) Petr Ospalý <petr@ospalax.cz>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */


#include "h/kea_interface.h"


/* Header section */

#include <hooks/hooks.h>
#include <cc/data.h>

using namespace isc::hooks;
using namespace isc::data;

// Kea has reversed boolean values...
int KEA_SUCCESS = 0;
int KEA_FAILURE = 1;

// Hook can be loaded but it may be disabled...
bool onekea_dhcp4_lease_enabled = true;

// Debug log (if enabled)
std::fstream debug_logfile;


/* Code section */

extern "C" {

    // the only mandatory function - don't change!
    int version() {
        return (KEA_HOOKS_VERSION);
    }

    // when library is loaded (on kea start for example)
    // from the doc:
    // "load" must 0 on success and non-zero on error. The hooks framework will
    // abandon the loading of the library if "load" returns an error status.
    int load(LibraryHandle& handle) {
        // these are parameters in the config (all have defaults...)
        // for example:
        // "parameters": {
        //     "enabled": true,
        //     "logger-name": "onekea-lease-dhcp4",
        //     "debug": true,
        //     "debug-logfile": "/var/log/onekea-lease-dhcp4-debug.log"
        // }
        ConstElementPtr param_enabled = handle.getParameter("enabled");
        ConstElementPtr param_debug = handle.getParameter("debug");
        ConstElementPtr param_debug_logfile = handle.getParameter("debug-logfile");
        ConstElementPtr param_logger_name = handle.getParameter("logger-name");

        // set defaults
        bool debug = false;
        std::string debug_filename = "/var/log/onekea-lease-dhcp4-debug.log";
        std::string logger_name = "onekea-lease-dhcp4";

        // check parameters

        if (param_enabled)
        {
            if (param_enabled->getType() != Element::boolean) {
                return (KEA_FAILURE);
            }
            onekea_dhcp4_lease_enabled = param_enabled->boolValue();
        }

        if (param_debug)
        {
            if (param_debug->getType() != Element::boolean) {
                return (KEA_FAILURE);
            }
            debug = param_debug->boolValue();
        }

        if (param_debug_logfile)
        {
            if (param_debug_logfile->getType() != Element::string) {
                return (KEA_FAILURE);
            }
            debug_filename = param_debug_logfile->stringValue();
        }

        if (param_logger_name)
        {
            if (param_logger_name->getType() != Element::string) {
                return (KEA_FAILURE);
            }
            logger_name = param_logger_name->stringValue();
        }

        // Are we debugging?
        if (debug)
        {
            debug_logfile.open(debug_filename,
                           std::fstream::out | std::fstream::app);

            // let's dump a testing message to the debug log
            debug_logfile \
                << "DEBUG> [ONEKEA STARTED]: " << logger_name \
                << "\n" \
                << "DEBUG> ONEKEA dhcp4 lease hook: " << \
                    std::string(onekea_dhcp4_lease_enabled \
                            ? "ENABLED" : "DISABLED") \
                << "\n";

            // to guard against a crash, we'll flush the output stream
            flush(debug_logfile);

            return (debug_logfile ? KEA_SUCCESS : KEA_FAILURE);
        }

        return KEA_SUCCESS;
    }

    // when library is unloaded (on kea shutdown for example)
    // from the doc:
    // As with "load", a zero value must be returned on success and a non-zero
    // value on an error. The hooks framework will record a non-zero status
    // return as an error in the current Kea log but otherwise ignore it.
    int unload() {
        if (debug_logfile) {
            // closing debug log with last message
            debug_logfile \
                << "DEBUG> [ONEKEA ENDED]" \
                << "\n\n";

            debug_logfile.close();
        }

        return (KEA_SUCCESS);
    }

}


// last line

