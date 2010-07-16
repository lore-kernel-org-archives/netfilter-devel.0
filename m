From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] ulogd 2.0.0beta4
Date: Fri, 16 Jul 2010 18:08:32 +0200
Message-ID: <4C408400.2030005@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030102010007060101000809"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39783 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965891Ab0GPQIu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:08:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030102010007060101000809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project presents:

  * ulogd 2.0.0beta4

ulogd is a userspace logging daemon for netfilter/iptables related
logging. This includes per-packet logging of security violations,
per-packet logging for accounting purpose as well as per-flow logging.

ulogd comes in two flavours: ulogd-1.x has been around since 2000 and is
the stable series. All production systems should use the stable series
at this time. The 1.x series are frozen, do not expect new features into
this line. ulogd-2.x is currently in beta stage.

This release includes several fixes, improvements and the new XML output
plugin for packet and log-based logging.

You can download them from:

http://www.netfilter.org/projects/ulogd/downloads.html
ftp://ftp.netfilter.org/pub/ulogd/

happy logging,
Pablo (on behalf of the Netfilter project)

--------------030102010007060101000809
Content-Type: text/plain;
 name="changes-ulogd-2.0.0beta4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-ulogd-2.0.0beta4.txt"

Christophe Fish (1):
      IP2BIN: fix missing protocol key

Eric Leblond (12):
      nflog: adjust unit which was inaccurate.
      ifindex: avoid memory allocation
      ip2str: suppress explicit allocation of some output key values
      ip2bin: suppress explicit allocation of some output key values
      hwhdr: suppress explicit allocation
      ip2bin: add AF_BRIDGE family support.
      db plugins: free memory at exit.
      ulogd: include config.h in all files.
      ulogd: permit compilation of plugin outside of tree
      DB plugin: add capability to specify complete INSERT command
      Documentation: information about procedure variable.
      Revert "ulogd: permit compilation of plugin outside of tree"

Pablo Neira Ayuso (24):
      NFCT: fix NULL dereference when hashtable is full
      NFCT: improve netlink overrun handling
      NFCT: add configurable option to set the value of the resynchronization timer
      NFCT: avoid spamming report about netlink overruns
      build: remove -lpthread from Makefile
      IPFIX: preliminary fixes, yet unusable
      NFCT: cleanup constructor and destructor functions
      NFCT: change `pollinterval' behaviour
      NFCT: use new hashtable implementation for better performance
      NFCT: split event handler if hashtable is used or not
      NFCT: fix number of options (missing one)
      NFCT: fix reset counters via SIGUSR2 signal
      src: use ARRAY_SIZE to calculate the array size of keys
      LOGEMU: fix crash if output file cannot be accessed
      fix incorrect negative EINTR checking in main loop
      output: add new plugin XML to output logs in XML
      output: XML: support reopening file via SIGHUP
      output: XML: add infix in output file
      NFCT: fix plugin re-use in different stacks
      fix wrong list addition in plugin re-use logic
      NFCT: copy the conntrack object to the plugin once
      IPFIX: remove plugin until it is usable
      build: bump version to 2.0.0beta4 and update dependencies
      build: remove obsolete reference to debian/ dir in Makefile

Pierre Chifflier (3):
      ulogd: configure all plugins before resolving keys.
      Remove debian directory
      Fix wrong definition of views in flat DB schema

Romain Bignon (1):
      DB plugins: fixed bug with INSERT* procedures


--------------030102010007060101000809--
