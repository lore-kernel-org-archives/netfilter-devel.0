From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release conntrack-tools 0.9.6
Date: Sat, 08 Mar 2008 14:05:45 +0100
Message-ID: <47D28F29.6080707@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010407050901050203090904"
To: netfilter-announce@lists.netfilter.org, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter-failover list <netfilter-failover@li
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010407050901050203090904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents another development release of
the conntrack-tools. This release includes important improvements, new
features and bugfixes:

* IPv6 support and new manpage for conntrackd
* XML and timestamp support for conntrack
* secmark support
* improved performance
* support for VLAN interfaces
* support for related connections and NAT sequence adjustments (helpers)
* improved statistics support
* tons of cleanups and improvements from Max Kellermann

Detailed changelog is attached.

What are the conntrack-tools?

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

Where can I download it from?

http://www.netfilter.org/projects/conntrack-tools/downloads.html

Where can I get more information about them?

http://people.netfilter.org/pablo/conntrack-tools/

Enjoy,
	Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010407050901050203090904
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

version 0.9.6 (2008/03/08)
------------------------------

Pablo Neira Ayuso <pablo@netfilter.org>:

o fix compilation problem due to missing headers (Krisztian Kovacs)
o include kernel options and Fedora comments in the INSTALL file
o remove -lpthread during compilation
o update library function checking in configure.in

= conntrack =
o fix missing `-g' and `-n' options in getopt_long control string
o add support for secmark (requires Linux kernel >= 2.6.25)
o add mark and secmark information to the manpage
o cleanup error message
o add support for -E -o xml,timestamp

= conntrackd =
o Add IPv6 support
o Remove window tracking disabling limitation (requires Linux kernel >= 2.6.22)
o syslog support (based on patch from Simon Lodal)
o add CacheWriteThrough clause: external cache write through policy
o add support for secmark (requires Linux kernel >= 2.6.25)
o add conntrackd (8) manpage
o raise ignorepool maximum limit from 1024 to INT_MAX
o Use more appropriate names for the existing synchronization modes:
	o rename `persistent' mode to `alarm'
	o rename `nack' mode to `ftfw'
o Now default synchronization mode is ftfw instead of alarm
o rename `examples' directory to `doc'
o add support for related conntracks (requires Linux kernel >= 2.6.22)
o show error and warning messages to stderr
o hash lookup speedups based on comments from netdev's discussions
o add support for connection logging to the statistics mode via Logfile
o minor irrelevant fixes for uncommon error paths and fix several typos
o detach daemon from its terminal (Ben Lenitz <BLentz@channing-bete.com>)
o obsolete `-S' option: Use information provided by the config file
o daemonize conntrackd after initialization
o rename class `buffer' to `queue' which is what it really implements
o fix logfiles permissions, do not default to umask
o wake up the daemon iff there are real events to handle instead of polling
o add support for tagged vlan interfaces in the config file, e.g. eth0.1
o implement a rb-tree based alarm framework
o constify queue_iterate()
o use list_del_init() and list_empty() to check if a node is in the list
o remove unix socket file on exit
o use umask() to set up file permissions
o add support for NAT sequence adjustment (requires Linux kernel >= 2.6.25)
o remove TODO file from release tarballs
o compose the file descriptor set at initialization stage to save some cycles
o cleanup: remove config_set from main(), use config_file variable instead

Max Kellermann <max@duempel.org>:

o fix shadow warnings by renaming variables or making them local
o remove "-g" from Makefile.am, this should be specified by the user
o enable C99 mode
o use C99 integers (uint32_t instead of u_int32_t)
o remove several superfluous initializations

= conntrack =
o check for malloc() failure in merge_opts
o eliminate local variable by returning from the loop
o explicitly cast in nat_parse()

= conntrackd =
o resolve global variable "alarm" conflict with alarm() function in unistd.h.
o enable gcc warnings, including -Werror
o use list_for_each_entry() instead of list_for_each()
o use const when possible
o remove prefetch in slist.h since it confuses gcc
o fix illegal use of return in the yacc code, use break instead
o fix wrong invocations after prototype cleanup
o set the return type of the parse functions to "void"
o use the comma operator instead of curly braces
o add missing function prototypes
o merge several *_alarm() functions into init_alarm()
o use add_alarm() in mod_alarm() to avoid code duplication
o import tcp_state_helper only once
o add missing printf arguments
o use timeradd() since manipulating tv_sec directly
o fix lots of gcc warnings
o don't call INIT_LIST_HEAD on list item when unneeded
o always close stdin - even in non-daemon mode, it is of no use
o chdir("/") to release the cwd inode
o ignore setsid() failure, because there is only one possible and
o fix harmless error condition
o fix memory leaks in several error output paths
o import only required C headers and put local headers on top to check
o fix double free() bug in the error output path of mcast_create()
o eliminate unsed cache_get_conntrack() in rs_list_to_tx()
o remove capability code and rely on the error returned by the syscall
o major simplification of the logging infrastructure
o use fputs() instead of fprintf() in log.c
o improve error message if netlink initialization fails
o merge mod_alarm() into add_alarm(), remove alarm_set_expiration()
o remove init_alarm() before add_alarm()
o fix error checking of local_create_server()
o added struct local_server, several cleanups in local socket infrastructure
o remove unused prototypes in network.h
o check if the received packet is large enough
o introduce alarm_pending()
o cleanup: use size_t instead of integer
o several cleanups in the rbtree-based alarm
o whitespace cleanups

--------------010407050901050203090904--
