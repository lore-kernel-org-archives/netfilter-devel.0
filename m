From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 1.0.0 released
Date: Sun, 27 Feb 2011 03:28:11 +0100
Message-ID: <4D69B6BB.7020309@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080308000000070906010208"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35313 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1B0C2P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 21:28:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080308000000070906010208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents the first stable release of the
conntrack-tools, that is composed of:

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well, although ulogd2 is the prefered option for logging. The daemon is
highly configurable and extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

This summary of changes with regards to previous is the following:

- improvements for the autotools/build infrastructure from Jan Engelhardt.
- lots of documentation updates.
- SYN_SENT2 support for the command line tool conntrack (which was added
in Linux kernel >= 2.6.31).
- allow to listen to update and destroy expectation events (it requires
a Linux kernel >= 2.6.37).
- conntrack timestamping support with -o ktimestamp (this support
requires the upcoming Linux 2.6.38).
- one fix for conntrackd: two very consecutive commit invocations with
option -c may result in the hang of the second commit invocation if the
first commit did not finish yet. As a result the second commit
invocation required a manual SIGTERM.

See changelog attached for more details.

You can download it from:
http://www.netfilter.org/projects/conntrack-tools/downloads.html

More information at:
http://conntrack-tools.netfilter.org

Official documentation at:
http://conntrack-tools.netfilter.org/manual.html

enjoy!
Pablo

--------------080308000000070906010208
Content-Type: text/plain;
 name="changes-conntrack-tools-1.0.0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-conntrack-tools-1.0.0.txt"

Jan Engelhardt (12):
      build: use autoconf-suggested naming of files
      build: use modern call syntax for AM_INIT_AUTOMAKE
      build: drop unused $(all_includes)
      build: remove statements without effect
      build: remove unused $(all_libraries)
      build: no need for error message in PKG_CHECK_MODULES
      Add .gitignore files
      build: resolve automake warning
      build: default to not building static libraries
      build: run autoupdate to replace obsolete constructs
      build: use AM_YFLAGS instead of overriding YACC
      build: remove redundant bison/lex tests

Pablo Neira Ayuso (25):
      conntrackd: fix wrong kernel requirements for TCPWindowTracking in example files
      conntrackd: minor documentation update (two new questions in the FAQ)
      conntrack: fix missing line break in conntrack(8) manpage
      conntrack: allow to listen to all kind of expectation events
      doc: update conntrack-tools manual
      doc: remove reference to the CT target
      local: don't override initial return value
      sync: don't override initial return value of local handler
      cache: close commit request if we already have one in progress
      cache: log if we received a commit request while already one in progress
      conntrackd: event iteration limiter is already reset in main select loop
      conntrackd: rise number of committed entries per step
      conntrack: add -o ktimestamp option (it requires linux >= 2.6.38)
      conntrackd: use nfct_copy() with override flag in cache_object_new()
      conntrack: allocate template objects in the heap
      conntrackd: remove use of deprecated nfct_maxsize()
      doc: document -s option of conntrackd in the manual
      doc: document redundant link support for conntrackd
      conntrack: display informative message if expectation table is flushed
      conntrack: support SYN_SENT2 TCP state as --state parameter
      doc: add reference to the CT target again
      doc: add missing conntrackd -s invocation with options
      build: conntrack-tools now requires libnetfilter_conntrack >= 0.9.1
      doc: prepare 1.0.0 release in conntrack-tools manual
      build: bump version to 1.0.0


--------------080308000000070906010208--
