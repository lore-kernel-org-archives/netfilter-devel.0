From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/11: netfilter -next update
Date: Fri,  6 Jun 2008 17:17:40 +0200 (MEST)
Message-ID: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48130 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbYFFPRq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a first netfilter update for net-next-2.6.git, including:

- conntrack accounting fixes
- a new IPv4/IPv6 security table for SELinux
- IPv6 support for ebtables
- ctnetlink cleanups and SCTP support
- removal of ksize "abuse" in ct_extend
- minor queuing cleanups

Please apply, thanks.


 include/linux/netfilter/nfnetlink_conntrack.h  |   10 ++
 include/linux/netfilter_bridge/ebt_ip6.h       |   40 ++++++
 include/linux/netfilter_bridge/ebt_log.h       |    3 +-
 include/linux/netfilter_ipv4.h                 |    1 +
 include/linux/netfilter_ipv6.h                 |    1 +
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 -
 include/net/netfilter/nf_conntrack.h           |   19 +++
 include/net/netns/ipv4.h                       |    1 +
 include/net/netns/ipv6.h                       |    1 +
 net/bridge/netfilter/Kconfig                   |    9 ++
 net/bridge/netfilter/Makefile                  |    1 +
 net/bridge/netfilter/ebt_ip6.c                 |  144 +++++++++++++++++++
 net/bridge/netfilter/ebt_log.c                 |   64 +++++++--
 net/ipv4/netfilter/Kconfig                     |   12 ++
 net/ipv4/netfilter/Makefile                    |    1 +
 net/ipv4/netfilter/ip_queue.c                  |    3 -
 net/ipv4/netfilter/iptable_security.c          |  180 ++++++++++++++++++++++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    5 +-
 net/ipv6/netfilter/Kconfig                     |   12 ++
 net/ipv6/netfilter/Makefile                    |    1 +
 net/ipv6/netfilter/ip6_queue.c                 |    3 -
 net/ipv6/netfilter/ip6table_security.c         |  172 ++++++++++++++++++++++
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    5 +-
 net/netfilter/nf_conntrack_core.c              |   19 +++
 net/netfilter/nf_conntrack_extend.c            |   10 +-
 net/netfilter/nf_conntrack_netlink.c           |   30 ++--
 net/netfilter/nf_conntrack_proto_dccp.c        |    3 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |   80 +++++++++++
 net/netfilter/nf_conntrack_proto_tcp.c         |    9 +-
 net/netfilter/nfnetlink_queue.c                |    1 -
 net/netfilter/xt_CONNSECMARK.c                 |   10 +-
 net/netfilter/xt_SECMARK.c                     |   10 +-
 32 files changed, 794 insertions(+), 68 deletions(-)
 create mode 100644 include/linux/netfilter_bridge/ebt_ip6.h
 create mode 100644 net/bridge/netfilter/ebt_ip6.c
 create mode 100644 net/ipv4/netfilter/iptable_security.c
 create mode 100644 net/ipv6/netfilter/ip6table_security.c

Fabian Hugelshofer (2):
      netfilter: nf_conntrack: properly account terminating packets
      netfilter: ctnetlink: include conntrack status in destroy event message

James Morris (2):
      netfilter: ip_tables: add iptables security table for mandatory access control rules
      netfilter: ip6_tables: add ip6tables security table

Kuo-lang Tseng (1):
      netfilter: ebtables: add IPv6 support

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: group errors into logical errno sets
      netfilter: ctnetlink: add full support for SCTP to ctnetlink

Patrick McHardy (1):
      netfilter: nf_conntrack: add nf_ct_kill()

Pekka Enberg (1):
      netfilter: nf_conntrack_extend: use krealloc() in nf_conntrack_extend.c V2

Rami Rosen (2):
      netfilter: nf_conntrack: remove unnecessary function declaration
      netfilter: {ip,ip6,nfnetlink}_queue: misc cleanups
