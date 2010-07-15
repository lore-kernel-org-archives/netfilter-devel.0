From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.15 released
Date: Thu, 15 Jul 2010 21:03:55 +0200
Message-ID: <4C3F5B9B.1050506@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050608000807040705060907"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	Mohit Mehta <mohit.mehta@vyatta.com>
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050608000807040705060907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents another development release of the
conntrack-tools. This release includes:

* IPv6-icmp fix for state synchronization.
* Support for TCP window tracking (it requires a Linux >= 2.6.35).
* Improvements and fixes for the NAT filtering support for the command
line tool `conntrack'.
* Patrick McHardy's conntrack zone support (See iptables' CT target).

Among many others outstanding bugfixes. Specifically I'd like to thank
Mohit Mehta from Vyatta for their prolific bug reporting and QA testing.

Please, see changelog attached for more details.

Q: How stable are the conntrack-tools?
A: The daemon that allows to synchronize states between firewalls has
been tested in a cluster environment composed of two stateful firewalls
running Debian 5.0 (Lenny) with a Linux kernel 2.6.32, keepalived
1.1.15, using conntrackd in FT-FW mode. The test consisted of
downloading the Linux kernel source code in a tarball file via HTTP and
randomly (in periods of 10 seconds) unplugging cablelinks to force the
fail-over between the nodes. The results has shown no hangs/closure in
any TCP connection.

Q: What are the conntrack-tools?
A: The conntrack-tools are:

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

Q: Where can I download it from?
A: http://www.netfilter.org/projects/conntrack-tools/downloads.html

Q: Where can I get more information about them?
A: http://conntrack-tools.netfilter.org

Q: Where can I have a look at the user manual?
A: http://conntrack-tools.netfilter.org/manual.html

On behalf of the Netfilter Core Team,
Pablo.


--------------050608000807040705060907
Content-Type: text/plain;
 name="changes-conntrack-tools-0.9.15.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-conntrack-tools-0.9.15.txt"

Mohit Mehta (4):
      conntrackd: `-i -x' does not display internal cache in XML
      conntrackd: update error message for max netlink socket size reached
      conntrackd: enforce strict logic for NetlinkBufferSize[*] clauses
      conntrackd: replace cryptic `mfrm' by `malformed' in `-s'

Pablo Neira Ayuso (34):
      conntrackd: fix UDP filtering in configuration file
      conntrackd: add support for TCP window scale factor synchronization
      conntrackd: cleanup port addition in the message building path
      conntrackd: fix `conntrackd -c' if external cache is disabled
      conntrack: option `-t' in on the same line as `-m' in manpage
      conntrackd: PollSecs goes in the General clause for statistics
      conntrackd: split __run() routine for poll and event-driven modes
      doc: description on how to block traffic with conntrack was incomplete
      conntrack: fix `-L --src-nat --dst-nat'
      conntrack: revert fix `-L --src-nat --dst-nat'
      conntrack: fix `conntrack -L --src-nat --dst-nat' (second try)
      conntrack: `-L --src-nat --dst-nat' filter using AND, not OR logic
      conntrackd: complete TCP window scale support
      conntrack: expand array that maps option-flags to option-names
      conntrack: put all the commands and options code together
      conntrack: fix port filter with `--src-nat' and `--dst-nat'
      conntrack: add `--any-nat' to filter any NATted flow
      conntrack: add testsuite for NAT filtering options
      conntrack: re-fix inconsistent display with `--src-nat' and `--dst-nat'
      conntrack: fix bogus NATted flows in filtering
      conntrack: fix `conntrack --src-nat 3.3.3.3' and similar
      conntrack: fix `conntrack --src-nat 1.1.1.1' if PAT applied
      conntrack: fix `conntrack --any-nat 1.1.1.1' filtering
      conntrack: --[src|dst|any]-nat requires IP:PORT as argument
      conntrack: fix `conntrack --[src|dst|any]-nat IP:PORT' if port mismatches
      conntrack: cleanup parsing of the NAT arguments
      conntrackd: fix ICMPv6 support
      conntrack: add zone support
      conntrackd: open event handler once cache has been populated
      conntrackd: setup event reliability after handler creation
      conntrackd: fix parsing of NAT sequence adjustment in synchronization messages
      conntrackd: warn on TCPWindowTracking option (it requires kernel >= 2.6.35)
      build: update libnetfilter_conntrack dependency (>= 0.0.102)
      build: bump version to 0.9.15


--------------050608000807040705060907--
