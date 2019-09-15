/*
 *
 * Copyright (2019) Petr Ospalý <petr@ospalax.cz>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */


#include "h/onelease.h"


/* Header section */

#include <hooks/hooks.h>
#include <dhcp/pkt4.h>
#include <dhcpsrv/subnet.h>
#include <dhcpsrv/lease.h>

#include <string>

#include "h/kea_interface.h"

using namespace isc::dhcp;
using namespace isc::hooks;


/* Code section */

extern "C" {

    // This callout is called at the "pkt4_receive" hook.
    int pkt4_receive(CalloutHandle& handle) {
        // A pointer to the packet is passed to the callout via a "boost" smart
        // pointer. The include file "pkt4.h" typedefs a pointer to the Pkt4
        // object as Pkt4Ptr.  Retrieve a pointer to the object.
        Pkt4Ptr query4_ptr;
        handle.getArgument("query4", query4_ptr);

        // Point to the hardware address.
        HWAddrPtr hwaddr_ptr = query4_ptr->getHWAddr();

        // The hardware address is held in a public member variable. We simply
        // sum its value. (Demonstration of how to walk through bytes)
        // long sum = 0;
        // for (int i = 0; i < hwaddr_ptr->hwaddr_.size(); ++i) {
        //     sum += hwaddr_ptr->hwaddr_[i];
        // }

        // Store the text form of the hardware address in the context to pass
        // to the next callout.
        std::string hwaddr = hwaddr_ptr->toText();
        handle.setContext("hwaddr", hwaddr);

        return (KEA_SUCCESS);
    };


    int lease4_select(CalloutHandle& handle) {
        Pkt4Ptr query4_ptr;
        Subnet4Ptr subnet4_ptr;
        Lease4Ptr lease4_ptr;
        // bool fake_allocation; // I don't have use for it for now

        // read the current state
        handle.getArgument("query4", query4_ptr);
        handle.getArgument("subnet4", subnet4_ptr);
        handle.getArgument("lease4", lease4_ptr);

        // TODO: change lease...is it here?
        return (KEA_SUCCESS);
    }

    // This callout is called at the "pkt4_send" hook.
    int pkt4_send(CalloutHandle& handle) {
        std::string hwaddr;

        // I am being defensive here and I will use try..catch even though the
        // context should have been set...
        try {
            handle.getContext("hwaddr", hwaddr);

            Pkt4Ptr response4_ptr;
            handle.getArgument("response4", response4_ptr);

            // Get the string form of the IP address.
            std::string ipaddr = response4_ptr->getYiaddr().toText();

            if (debug_logfile)
            {
                // Write the information to the log file.
                debug_logfile \
                    << "DEBUG> hwaddr: " << hwaddr \
                    << ", ipaddr: " << ipaddr \
                    << "\n";

                // ... and to guard against a crash, we'll flush the output stream.
                flush(debug_logfile);
            }
        } catch (const NoSuchCalloutContext&) {
            // No such element in the per-request context (hwaddr)
        }

        return (KEA_SUCCESS);
    }

}


// last line

