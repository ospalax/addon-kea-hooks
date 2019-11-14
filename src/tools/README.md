# ikea tools

## kea-config-generator

This script helps to generate Kea's config file (e.g.: `kea-dhcp4.conf`) from scratch. It either create configuration based on arguments or completely auto-generates one based on the machine's network interfaces and addresses.

**Motivation: ease the work for OpenNebula's NFV appliance service script**

### Usage

**Execute: `./kea-config-generator -h`**


```
usage: kea-config-generator [-h] [-t <lease-time-seconds>] [-a]
                            [-l <logfile-name>] [-d <lease-database-json>]
                            [-i <iface[/<ipv4>]>] [-n <nameserver-ipv4>]
                            [-r <router-ipv4>] [-o <option-data-json>]
                            [-s <subnet4-json>] [-x <hook-json>]
                            [-L <logger-json>] [-I <id-number>]

ISC Kea dhcp4 config generator - it generates dhcp4 config file and its
content can be modified by varies options. The result is then simply printed
into stdout.

optional arguments:
  -h, --help            show this help message and exit
  -t <lease-time-seconds>, --lease-time <lease-time-seconds>
                        Life time of a lease in seconds (Default: 3600)
  -a, --authoritative   Start Kea server as authoritative for all networks
                        (Default: false)
  -l <logfile-name>, --logfile <logfile-name>
                        Name of the file for log messages (Default:
                        /var/log/kea-dhcp4.log)
  -d <lease-database-json>, --lease-database <lease-database-json>
                        JSON value representing lease database object
                        (Default: type=memfile)
  -i <iface[/<ipv4>]>, --interface <iface[/<ipv4>]>
                        Name of the interface on which to listen (e.g.: eth0
                        or better eth0/<ipv4>). This argument can be used
                        multiple of times.
  -n <nameserver-ipv4>, --domain-name-server <nameserver-ipv4>
                        Domain name server IPv4 address (global) (Default:
                        None). This argument can be used multiple of times.
                        These nameservers take precedence over others found in
                        option-data (if used).
  -r <router-ipv4>, --router <router-ipv4>
                        Router's IPv4 address (global) (Default: None). This
                        argument can be used multiple of times.
  -o <option-data-json>, --option-data <option-data-json>
                        JSON value representing option-data object (Default:
                        None). This argument can be used multiple of times.
  -s <subnet4-json>, --subnet4 <subnet4-json>
                        JSON value representing subnet4 object (Default: Auto-
                        Generated). This argument can be used multiple of
                        times.
  -x <hook-json>, --hook <hook-json>
                        JSON value representing hook object (Default: None).
                        This argument can be used multiple of times.
  -L <logger-json>, --logger <logger-json>
                        JSON value representing logger object (Default:
                        file='/var/log/kea-dhcp4.log'). This argument can be
                        used multiple of times. If used then --logfile is
                        ignored.
  -I <id-number>, --subnet-id <id-number>
                        Starting ID number for subnets (all configured subnets
                        are incremented by one from this value - when the
                        highest id is used the it will reset from and start
                        from one again). (Default: None/Auto, Min-Max:
                        1-4294967294)
```
