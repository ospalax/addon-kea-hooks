# ISC Kea

Testbed for building **[ISC Kea](https://www.isc.org/kea/)** software on **Alpine Linux** for **OpenNebula's NFV appliance**.

## OpenNebula VNF

One of the VNFs for OpenNebula's NFV appliance is a dhcp and Kea with its custom hooks was the best solution for our requirement (matching HW address with the IP lease).

## Hooks

Kea supports hooks - dnsmasq has some too, but they are triggered too late (after the lease is acutually done). Kea's hooks are very granular and hooked on many places during process, which scratches our itch.

## Usage

First of all you need installed `docker` and `make` command. This project (if successful) will create a few artifacts:

- docker image with build and installed ISC Kea (also saved as a tar)
- an archive with ISC Kea compiled binaries (installation prefix)

The archive is used as a artifact for ONE NFV appliance - rebuilding ISC Kea with each appliance build would be too time-consuming.


### List default build parameters

```
% cat Makefile.config
```

### Default build

```
% make
% ls -l build
```

### OpenNebula build

For OpenNebula's ONE NFV appliance there exists a handy script (adjust `MAKE_JOBS` to your setup):

```
% ./extra/onekea.sh
```

Or do something like this:

```
% env MAKE_JOBS=8 KEA_INSTALLPREFIX=/opt/one-appliance/kea make
```

## Issues

I decided to create this repo to build ISC Kea manually and use its artifacts in the appliance until Alpine kea packages are fixed and in stable branch...

### log4cplus problem

Kea packages built for Alpine are only in Edge and very unstable. I encountered a problem when kea binaries have been used as (on Alpine):

```
# ./kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
kea-dhcp4: Fatal error during start up: log4cplus is not initialized and implicit initialization is turned off
```

Bugreports already existed:

- https://gitlab.isc.org/isc-projects/kea/issues/625
- https://gitlab.alpinelinux.org/alpine/aports/issues/10480

### Alpine kea packages dependency problem

Newest version of kea packages in Edge have broken dependency for change last time I checked.
