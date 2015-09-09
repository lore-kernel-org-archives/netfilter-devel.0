From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 1.4.3 release
Date: Wed, 9 Sep 2015 17:58:38 +0200
Message-ID: <20150909155838.GA5958@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Transfer-Encoding: 8bit
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        conntrack-tools 1.4.3

The conntrack-tools are a set of tools targeted at system
administrators. They are conntrack, the userspace command line
interface, and conntrackd, the userspace daemon. The tool conntrack
provides a full featured interface that is intended to replace the old
/proc/net/ip_conntrack interface. Using conntrack, you can view and
manage the in-kernel connection tracking state table from userspace.
On the other hand, conntrackd covers the specific aspects of stateful
firewalls to enable highly available scenarios, and can be used as
statistics collector as well.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/conntrack-tools/downloads.html
ftp://ftp.netfilter.org/pub/conntrack-tools/

Have fun!

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-conntrack-tools-1.4.3.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero (2):
      man: fix hyphen used as minus sign
      nfct: don't link against libnetfilter_conntrack

Arturo Borrero Gonzalez (2):
      list: fix prefetch dummy
      doc/debian.conntrackd.init.d: drop file

Ash Hughes (1):
      conntrackd: userspace SSDP helper

Chas Williams III (1):
      cthelper: don't pass up a 0 length queue

Clemence Faure (1):
      conntrack: support add/delete of conntrack labels

Felix Janda (6):
      configure: Add AM_PROG_AR to silence automake warning
      include: Sync with kernel headers
      src: Use stdint types
      src: Include <sys/select.h> for fd_set
      src: Define _GNU_SOURCE to get members of tcphdr&ucphdr
      netlink: Use <fcntl.h> instead of legacy synonym <sys/fcntl.h>

Florian Westphal (3):
      conntrack: minor cleanup
      conntrack: support multiple -l options
      conntrack: do not exit when update returns an error

Hani Benhabiles (2):
      nfct: Fix use-after-free / double-free
      conntrackd: Don't hardcode libs dir path

Jarno Rajahalme (1):
      conntrack: fix setting labels in updates

Pablo Neira Ayuso (33):
      conntrack: fix dump of IPv6 entries in the dying and unconfirmed list
      conntrackd: cthelper: allow to attach expectations via nfqueue
      conntrackd: helpers: add DHCPv6 helper
      nfct: modularize extensions
      build: add --disable-cthelper and --disable-cttimeout
      nfct: timeout: use getprotoent
      nfct: timeout: split nfct_cmd_timeout_add in several functions
      nfct: src: add nfct_mnl_talk and use it
      nfct: src: consolidate netlink socket creation
      conntrackd: cthelper: add SANE helper
      conntrackd: cthelper: add TFTP helper
      conntrackd: cthelper: add amanda helper
      build: don't include leftover .orig and .rej files in doc/
      nfct: remove unneeded included header
      nfct: timeout: add support for default protocol timeout tuning
      udp: bind UDP sender side to same interface of the receiver side
      conntrackd: build: fix crash when optional kernel modules are not loaded
      conntrack: fix doc/cli/test.sh create-expect
      conntrackd: allow strings with underscore from flex scanner
      expect: Fix wrong memset usage
      tests: conntrack: don't overwrite read-only shell variable
      conntrackd: fix sanitization of expection attribute in the wire format
      conntrackd: NTA_MAX is also an invalid attribute
      conntrackd: fix leak in fork_process_new()
      conntrackd: fix descriptor leak in do_local_request()
      conntrackd: fix error handling in nfq_queue_cb()
      conntrackd: simplify branch in tcp_accept()
      conntrackd: use strncpy to set up the cache name
      conntrackd: missing break in expectation message parser function
      tests: fix run-test.sh
      nfct: Update syntax to specify command before subsystem
      nfct: update syntax in documentation
      conntrack-tools 1.4.3 release

Paul Aitken (2):
      conntrackd: remove unused 'numbytes'
      cthelper: Optimise nfq_queue_cb

Szilárd Pfeiffer (3):
      conntrack: refactor handling of address options
      conntrack: fix expectation entry creation
      conntrack: made the protocol option value case insensitive

Thomas Jarosch (1):
      channel: Fix file descriptor leak in channel_open() on error


--HcAYCG3uE/tztfnV--
