From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER00/07]: Netfilter update+fixes
Date: Fri,  2 Nov 2007 12:23:10 +0100 (MET)
Message-ID: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45728 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXKBLXM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following are some minor netfilter updates, cleanups and fixes, consisting
of an ipq seq-file conversion, some Makefile cleanups, removal of unneeded
rcu_dereference calls in the NAT helpers, a nf_sockopt list helper cleanup
and a fix for ebtables gratuitous arp matching.

Please apply, thanks.


 include/linux/netfilter/Kbuild      |   18 ++++++++--------
 include/linux/netfilter_ipv4/Kbuild |   28 +++++++++++++-------------
 include/linux/netfilter_ipv6/Kbuild |    2 +-
 net/bridge/netfilter/ebt_arp.c      |    2 +-
 net/ipv4/netfilter/Makefile         |   20 +++++++++---------
 net/ipv4/netfilter/ip_queue.c       |   37 ++++++++++++++++++----------------
 net/ipv4/netfilter/nf_nat_amanda.c  |    2 +-
 net/ipv4/netfilter/nf_nat_ftp.c     |    2 +-
 net/ipv4/netfilter/nf_nat_h323.c    |   18 ++++++++--------
 net/ipv4/netfilter/nf_nat_irc.c     |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c    |    8 +++---
 net/ipv4/netfilter/nf_nat_sip.c     |    4 +-
 net/ipv4/netfilter/nf_nat_tftp.c    |    2 +-
 net/ipv6/netfilter/Makefile         |   28 +++++++++++++++-----------
 net/ipv6/netfilter/ip6_queue.c      |   37 ++++++++++++++++++----------------
 net/netfilter/Makefile              |   14 ++++++------
 net/netfilter/nf_sockopt.c          |   13 +++--------
 net/netfilter/xt_connlimit.c        |    5 ++-
 net/netfilter/xt_time.c             |    3 +-
 net/netfilter/xt_u32.c              |    5 ++-
 20 files changed, 129 insertions(+), 121 deletions(-)

Alexey Dobriyan (2):
      [NETFILTER]: ip{,6}_queue: convert to seq_file interface
      [NETFILTER]: nf_sockopts list head cleanup

Bart De Schuymer (1):
      [NETFILTER]: ebt_arp: fix --arp-gratuitous matching dependence on --arp-ip-{src,dst}

Jan Engelhardt (3):
      [NETFILTER]: Copyright/Email update
      [NETFILTER]: Clean up Makefile
      [NETFILTER]: Sort matches/targets in Kbuild file

Patrick McHardy (1):
      [NETFILTER]: remove unneeded rcu_dereference() calls
