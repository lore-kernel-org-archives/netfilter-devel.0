From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v3 0/3] Netfilter zone directions
Date: Wed, 22 Jul 2015 12:54:45 +0200
Message-ID: <cover.1437561897.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41626 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbbGVKyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2015 06:54:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is v3 of the originally named flextuples [1] patch set, but
this time after discussions from NFWS completely reworked towards
integration into the existing zones infrastructure. Please see
individual patches for details.

Thanks!

 [1] http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/57412/

v2 -> v3:
 - Have a global default zone object, use it directly
 - Do not touch uapi-exposed ct->status bits, but integrate
   the marking flag into the zones structure
 - Rebased onto latest nf-next, rerun all stress tests
v1 -> v2:
 - Reworked entire set, integration into zones
 - Rebased onto latest nf-next

Daniel Borkmann (3):
  netfilter: nf_conntrack: push zone object into functions
  netfilter: nf_conntrack: add direction support for zones
  netfilter: nf_conntrack: add efficient mark to zone mapping

 include/net/netfilter/nf_conntrack.h               |   6 +-
 include/net/netfilter/nf_conntrack_core.h          |   3 +-
 include/net/netfilter/nf_conntrack_expect.h        |  11 +-
 include/net/netfilter/nf_conntrack_zones.h         |  82 ++++++++++--
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   9 ++
 include/uapi/linux/netfilter/xt_CT.h               |   8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   4 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |  18 +--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   5 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |  19 +--
 net/netfilter/ipvs/ip_vs_nfct.c                    |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  95 ++++++++------
 net/netfilter/nf_conntrack_expect.c                |  19 +--
 net/netfilter/nf_conntrack_netlink.c               | 139 ++++++++++++++-------
 net/netfilter/nf_conntrack_pptp.c                  |   3 +-
 net/netfilter/nf_conntrack_standalone.c            |  24 +++-
 net/netfilter/nf_nat_core.c                        |  24 ++--
 net/netfilter/nf_synproxy_core.c                   |   4 +-
 net/netfilter/xt_CT.c                              |  26 +++-
 net/netfilter/xt_connlimit.c                       |   9 +-
 net/sched/act_connmark.c                           |   6 +-
 23 files changed, 366 insertions(+), 154 deletions(-)

-- 
1.9.3

