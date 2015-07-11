From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v2 0/3] Netfilter zone directions
Date: Sat, 11 Jul 2015 03:14:04 +0200
Message-ID: <cover.1436574843.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:42501 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbGKG11 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jul 2015 02:27:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is v2 of the originally named flextuples [1] patch set, but
this time after discussions from NFWS completely reworked towards
integration into the existing zones infrastructure. Please see
individual patches for details.

Thanks!

 [1] http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/57412/

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
 include/net/netfilter/nf_conntrack_zones.h         |  87 +++++++++++--
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   9 ++
 include/uapi/linux/netfilter/xt_CT.h               |   8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   4 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   3 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |  20 +--
 net/ipv4/netfilter/nf_nat_pptp.c                   |   3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   3 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   5 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |  21 ++--
 net/netfilter/ipvs/ip_vs_nfct.c                    |   5 +-
 net/netfilter/nf_conntrack_core.c                  |  93 ++++++++------
 net/netfilter/nf_conntrack_expect.c                |  22 ++--
 net/netfilter/nf_conntrack_h323_main.c             |   4 +-
 net/netfilter/nf_conntrack_netlink.c               | 138 ++++++++++++++-------
 net/netfilter/nf_conntrack_pptp.c                  |   7 +-
 net/netfilter/nf_conntrack_sip.c                   |   3 +-
 net/netfilter/nf_conntrack_standalone.c            |  24 +++-
 net/netfilter/nf_nat_core.c                        |  24 ++--
 net/netfilter/nf_synproxy_core.c                   |   6 +-
 net/netfilter/xt_CT.c                              |  25 +++-
 net/netfilter/xt_connlimit.c                       |  13 +-
 net/sched/act_connmark.c                           |   6 +-
 27 files changed, 395 insertions(+), 162 deletions(-)

-- 
1.9.3

