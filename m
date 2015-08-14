From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v5 0/2] Netfilter zone directions
Date: Fri, 14 Aug 2015 16:03:38 +0200
Message-ID: <cover.1439559328.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:49818 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbHNODp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Aug 2015 10:03:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a rework of the originally named flextuples [1] patch set,
but after discussions from NFWS completely reworked towards
integration into the existing zones infrastructure.

Please see individual patches for details. Unchanged user space
iptables frontend is at [2]. As discussed, I will follow-up with
libnetfilter_conntrack and conntrack support afterwards.

Thanks!

 [1] http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/57412/
 [2] http://patchwork.ozlabs.org/patch/505355/

v4 -> v5:
 - Dropped patch 1 as already applied
 - Changed stand-alone procfs output and ctnetlink tuples as
   discussed with Pablo, rest unchanged
 - Retested everything
v3 -> v4:
 - Rebased & retested everything onto latest nf-next
 - Added nested CTA_TUPLE_ZONE attribute with direction meta data
 - Renamed CTA_DIR; sysctl was already in it's own function
v2 -> v3:
 - Have a global default zone object, use it directly
 - Do not touch uapi-exposed ct->status bits, but integrate
   the marking flag into the zones structure
 - Rebased onto latest nf-next, rerun all stress tests
v1 -> v2:
 - Reworked entire set, integration into zones
 - Rebased onto latest nf-next

Daniel Borkmann (2):
  netfilter: nf_conntrack: add direction support for zones
  netfilter: nf_conntrack: add efficient mark to zone mapping

 include/net/netfilter/nf_conntrack_zones.h         |  74 ++++++++-
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   1 +
 include/uapi/linux/netfilter/xt_CT.h               |   8 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   3 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |   8 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   4 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |   8 +-
 net/netfilter/nf_conntrack_core.c                  |  95 +++++------
 net/netfilter/nf_conntrack_expect.c                |   8 +-
 net/netfilter/nf_conntrack_netlink.c               | 176 +++++++++++++++------
 net/netfilter/nf_conntrack_standalone.c            |  30 +++-
 net/netfilter/nf_nat_core.c                        |  13 +-
 net/netfilter/xt_CT.c                              |  20 ++-
 net/sched/act_connmark.c                           |   1 +
 14 files changed, 321 insertions(+), 128 deletions(-)

-- 
1.9.3

