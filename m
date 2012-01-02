From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: iptables 1.4.12.2 released
Date: Mon, 2 Jan 2012 18:52:42 +0100
Message-ID: <20120102175242.GA26435@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41401 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab2ABRwx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:52:53 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The netfilter coreteam presents:

    iptables version 1.4.12.2

This is a stable release, it only includes bugfixes.

Version 1.4.12.2 can be obtained from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

On behalf of the Netfilter Core Team.
Happy firewalling!

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.4.12.2.txt"

Florian Westphal (2):
      libxt_NFQUEUE: fix --queue-bypass ipt-save output
      libxt_connbytes: fix handling of --connbytes FROM

Jan Engelhardt (17):
      xtoptions: fill in fallback value for nvals
      libxt_statistic: link with -lm
      libxt_RATEEST: link with -lm
      build: scan for unreferenced symbols
      iptables: move kernel version find routing into libxtables
      Merge branch 'stable' of git://dev.medozas.de/iptables
      Merge branch 'stable'
      build: sort file list before build
      doc: fix undesired newline in ip6tables-restore(8)
      ip6tables-restore: implement missing -T option
      doc: document iptables-restore's -T option
      build: restore build order of modules
      build: make check stage not fail when building statically
      libipt_SAME: set PROTO_RANDOM on all ranges
      doc: clarification on the meaning of -p 0
      libiptc: provide separate pkgconfig files
      nfnl_osf: add missing libnfnetlink_CFLAGS to compile process

Pablo Neira Ayuso (1):
      Bump version to 1.4.12.2

Richard Weinberger (1):
      xtoptions: simplify xtables_parse_interface

Thomas Jarosch (1):
      libxtables: Fix file descriptor leak in xtables_lmap_init on error

Tom Eastep (2):
      libxt_conntrack: improve error message on parsing violation
      libxt_CONNSECMARK: fix spacing in output


--LZvS9be/3tNcYl/X--
