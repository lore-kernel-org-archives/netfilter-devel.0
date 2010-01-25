From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 00/09]: netfilter: CT target/conntrack zones
Date: Mon, 25 Jan 2010 16:37:33 +0100 (MET)
Message-ID: <20100125153732.15305.68011.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45970 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0AYPhe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:37:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches contain a new version of the conntrack zones
patchset, including a new xtables target to (among other things) assign
conntracks to a specific zone, replacing the device attribute used
in the previous version.

Quick overview:

- Patch 1 adds a struct net * parameter to the xtables target parameter
  structures as preparation for the CT target, which needs to allocate
  a conntrack entry in the proper namespace

- Patch 2 splits up the IPCT_STATUS event as requested by Jozsef. The
  CT target can be used for selective conntrack event delivery, this
  allows more fine grained control over the delivered events.

- Patch 3 adds selective conntrack event delivery by adding two masks
  for conntrack and expectation events to struct nf_conntrack_ecache,
  which are used to filter out events.

- Patch 4 fixes ctnetlink to only assign helpers for matching protocols
  to conntrack entries and fixes expectation deletion by helper name.
  This is also preparation for the CT target, which can also assign
  helpers to new connections.

- Patch 5 adds support for conntrack templates, which are specially marked
  conntrack entries attached to the skb that are used to initialize
  specific parameters of new connections.

- Patch 6 adds the CT target

- Patch 7 contains preparatory work for assigning conntracks to zones:
  the template needs to be passed to L4 ->error handlers for ICMP and
  ICMPv6 to perform the conntrack lookup in the correct zone

- Patch 8 adds zone support to nf_conntrack and the CT target. This works
  by incorporating a numerical "zone" identifier into the conntrack/NAT
  hashes and comparing it during lookups.

- Patch 9 adds zone support to ctnetlink by dumping and parsing a new
  CTA_ZONE attribute that contains the zone ID.

Comments welcome.


 include/linux/netfilter/nf_conntrack_common.h  |   22 +++
 include/linux/netfilter/nfnetlink_conntrack.h  |    2 +
 include/linux/netfilter/x_tables.h             |    2 +
 include/linux/netfilter/xt_CT.h                |   14 ++
 include/net/ip.h                               |    3 +
 include/net/ipv6.h                             |    3 +
 include/net/netfilter/nf_conntrack.h           |    5 +-
 include/net/netfilter/nf_conntrack_core.h      |    3 +-
 include/net/netfilter/nf_conntrack_ecache.h    |   58 ++++-----
 include/net/netfilter/nf_conntrack_expect.h    |    9 +-
 include/net/netfilter/nf_conntrack_extend.h    |    2 +
 include/net/netfilter/nf_conntrack_helper.h    |    8 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |    4 +-
 include/net/netfilter/nf_conntrack_zones.h     |   21 +++
 net/bridge/netfilter/ebtables.c                |   10 +-
 net/ipv4/netfilter/ip_tables.c                 |    8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   11 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    9 +-
 net/ipv4/netfilter/nf_nat_core.c               |   23 ++--
 net/ipv4/netfilter/nf_nat_pptp.c               |    3 +-
 net/ipv6/netfilter/ip6_tables.c                |    8 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    9 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   11 +-
 net/netfilter/Kconfig                          |   15 ++
 net/netfilter/Makefile                         |    1 +
 net/netfilter/nf_conntrack_core.c              |  164 +++++++++++++++++-------
 net/netfilter/nf_conntrack_expect.c            |   21 ++-
 net/netfilter/nf_conntrack_h323_main.c         |    3 +-
 net/netfilter/nf_conntrack_helper.c            |   44 ++++++-
 net/netfilter/nf_conntrack_netlink.c           |  125 +++++++++++++-----
 net/netfilter/nf_conntrack_pptp.c              |   14 +-
 net/netfilter/nf_conntrack_proto_dccp.c        |    5 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    4 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    6 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |    4 +-
 net/netfilter/nf_conntrack_sip.c               |    3 +-
 net/netfilter/nf_conntrack_standalone.c        |    6 +
 net/netfilter/xt_CT.c                          |  147 +++++++++++++++++++++
 net/netfilter/xt_connlimit.c                   |    2 +-
 42 files changed, 628 insertions(+), 190 deletions(-)
 create mode 100644 include/linux/netfilter/xt_CT.h
 create mode 100644 include/net/netfilter/nf_conntrack_zones.h
 create mode 100644 net/netfilter/xt_CT.c

Patrick McHardy (9):
      netfilter: add struct net * to target parameters
      netfilter: nf_conntrack: split up IPCT_STATUS event
      netfilter: ctnetlink: support selective event delivery
      netfilter: ctnetlink: only assign helpers for matching protocols
      netfilter: nf_conntrack: support conntrack templates
      netfilter: xtables: add CT target
      netfilter: nf_conntrack: pass template to l4proto ->error handler
      netfilter: nf_conntrack: add support for "conntrack zones"
      netfilter: ctnetlink: add zone support
