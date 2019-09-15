# ISC Kea Hooks

Documentation for Kea and hooks:

- https://jenkins.isc.org/job/Kea_doc/doxygen/
- https://jenkins.isc.org/job/Kea_doc/doxygen/df/d46/hooksdgDevelopersGuide.html
- https://jenkins.isc.org/job/Kea_doc/doxygen/de/df3/dhcpv4Hooks.html

## ONE Kea Lease Hook

This is quite a simple hook to implement OpenNebula's NFV appliance requirement: assign IPv4 address (via DHCP) from MAC address value.

OpenNebula generates MAC addresses for VM's network interfaces in a particular way. Every virtual interface is assigned to some specific network with specific subnet/range. By default there is no DHCP service but OpenNebula assigns (internally) some (mostly the lowest unassigned) valid IPv4 from this range regardless and if the user enables the `NETWORK CONTEXT` then OpenNebula will setup VM with this static address.

Part of this internal IPv4 assignment is also the creation of a matching MAC address. By matching I mean that the last four bytes in MAC address equal to the four bytes representing the IPv4 address.

So if you create VM with the interface attached to a OpenNebula's network:

```
192.168.233.0/24
```

with an ip range pool of:

```
192.168.233.100 - 192.168.233.200
```

then OpenNebula assigns this interface the IPv4 address (by being the first):

```
192.168.233.100
```

and the generated MAC address will be:

```
02:00:c0:a8:e9:64
```

First two bytes are always `02` and `00` (two and zero) and the rest match like this:

- `c0` is hexadecimal for decimal: `192`
- `a8` is hexadecimal for decimal: `168`
- `e9` is hexadecimal for decimal: `233`
- `64` is hexadecimal for decimal: `100`

The point of this hook is to honor this inner working of OpenNebula to not confuse users and for VMs to have a convenient and predicable dynamic addresses...
