From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: conntrack zones
Date: Mon,  8 Feb 2010 18:39:03 +0100 (MET)
Message-ID: <20100208173902.16167.8881.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39370 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0BHRjF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:39:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following is the latest version of my conntrack zone patches.
Changes since the last posting are:

- incorporate feedback from Jan
- complete zone support in all missing spots
- fixed warning with CONFIG_NF_CONNTRACK_ZONES=n

Further comments welcome.


 include/linux/netfilter/nfnetlink_conntrack.h  |    2 +
 include/linux/netfilter/xt_CT.h                |    2 +-
 include/net/ip.h                               |    3 +
 include/net/ipv6.h                             |    3 +
 include/net/netfilter/nf_conntrack.h           |    5 +-
 include/net/netfilter/nf_conntrack_core.h      |    3 +-
 include/net/netfilter/nf_conntrack_expect.h    |    9 ++-
 include/net/netfilter/nf_conntrack_extend.h    |    2 +
 include/net/netfilter/nf_conntrack_l4proto.h   |    4 +-
 include/net/netfilter/nf_conntrack_zones.h     |   23 +++++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   11 ++-
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   12 ++-
 net/ipv4/netfilter/nf_nat_core.c               |   23 +++--
 net/ipv4/netfilter/nf_nat_pptp.c               |    3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   12 ++-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   11 ++-
 net/netfilter/Kconfig                          |    9 ++
 net/netfilter/nf_conntrack_core.c              |  113 ++++++++++++++++++------
 net/netfilter/nf_conntrack_expect.c            |   21 +++--
 net/netfilter/nf_conntrack_h323_main.c         |    3 +-
 net/netfilter/nf_conntrack_netlink.c           |   92 +++++++++++++++----
 net/netfilter/nf_conntrack_pptp.c              |   14 ++--
 net/netfilter/nf_conntrack_proto_dccp.c        |    5 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    2 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    4 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |    2 +-
 net/netfilter/nf_conntrack_sip.c               |    3 +-
 net/netfilter/nf_conntrack_standalone.c        |    6 ++
 net/netfilter/xt_CT.c                          |    8 ++-
 net/netfilter/xt_connlimit.c                   |    4 +-
 31 files changed, 312 insertions(+), 105 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_zones.h

Patrick McHardy (3):
      netfilter: nf_conntrack: pass template to l4proto ->error handler
      netfilter: nf_conntrack: add support for "conntrack zones"
      netfilter: ctnetlink: add zone support
