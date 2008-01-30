From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/69]: Netfilter Update
Date: Wed, 30 Jan 2008 21:16:52 +0100 (MET)
Message-ID: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60622 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbYA3UQz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:16:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is the final netfilter update for 2.6.25. containing the ipta=
bles
netns work by Alexey Dobriyan, lots of sparse warning fixes by Stephen,=
 Eric
and myself, const annotations throughout netfilter by Jan Engelhardt,
a set of patches to finally use RCU for the conntrack and NAT hashes, s=
ome
conntrack optimizations and some minor misc cleanups.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_pptp.h        |    2 +-
 include/linux/netfilter/nf_conntrack_sip.h         |    6 +-
 include/linux/netfilter/x_tables.h                 |   28 +-
 include/linux/netfilter/xt_conntrack.h             |   30 +-
 include/linux/netfilter/xt_hashlimit.h             |   37 ++-
 include/linux/netfilter/xt_owner.h                 |    4 +-
 include/linux/netfilter_arp/arp_tables.h           |    5 +-
 include/linux/netfilter_ipv4/ip_tables.h           |    5 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |    5 +-
 include/linux/skbuff.h                             |    3 -
 include/linux/types.h                              |    2 +-
 include/net/arp.h                                  |    8 +-
 include/net/net_namespace.h                        |    4 +
 include/net/netfilter/nf_conntrack.h               |   15 +-
 include/net/netfilter/nf_conntrack_core.h          |    6 +-
 include/net/netfilter/nf_conntrack_expect.h        |    2 +
 include/net/netfilter/nf_conntrack_helper.h        |    4 -
 include/net/netfilter/nf_conntrack_l3proto.h       |    4 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |   25 +-
 include/net/netfilter/nf_conntrack_tuple.h         |   17 +-
 include/net/netfilter/nf_log.h                     |    2 +-
 include/net/netns/ipv4.h                           |    6 +
 include/net/netns/ipv6.h                           |    5 +
 include/net/netns/x_tables.h                       |   10 +
 net/bridge/br_netfilter.c                          |    4 -
 net/bridge/netfilter/ebt_802_3.c                   |   10 +-
 net/bridge/netfilter/ebt_among.c                   |   27 +-
 net/bridge/netfilter/ebt_arp.c                     |   17 +-
 net/bridge/netfilter/ebt_arpreply.c                |   17 +-
 net/bridge/netfilter/ebt_dnat.c                    |    8 +-
 net/bridge/netfilter/ebt_ip.c                      |   14 +-
 net/bridge/netfilter/ebt_limit.c                   |    6 +-
 net/bridge/netfilter/ebt_log.c                     |   19 +-
 net/bridge/netfilter/ebt_mark.c                    |    8 +-
 net/bridge/netfilter/ebt_mark_m.c                  |    8 +-
 net/bridge/netfilter/ebt_pkttype.c                 |    8 +-
 net/bridge/netfilter/ebt_redirect.c                |    8 +-
 net/bridge/netfilter/ebt_snat.c                    |   11 +-
 net/bridge/netfilter/ebt_stp.c                     |   28 +-
 net/bridge/netfilter/ebt_ulog.c                    |    9 +-
 net/bridge/netfilter/ebt_vlan.c                    |   12 +-
 net/ipv4/arp.c                                     |    9 +-
 net/ipv4/netfilter/arp_tables.c                    |  102 ++++--
 net/ipv4/netfilter/arptable_filter.c               |   31 ++-
 net/ipv4/netfilter/ip_queue.c                      |   18 +-
 net/ipv4/netfilter/ip_tables.c                     |  112 ++++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    7 -
 net/ipv4/netfilter/ipt_recent.c                    |    6 +-
 net/ipv4/netfilter/iptable_filter.c                |   33 ++-
 net/ipv4/netfilter/iptable_mangle.c                |   33 ++-
 net/ipv4/netfilter/iptable_raw.c                   |   33 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   14 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   40 ++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   22 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   42 +--
 net/ipv4/netfilter/nf_nat_h323.c                   |    5 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |    3 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   10 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   16 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c             |    2 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c              |    2 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c              |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   16 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    2 +-
 net/ipv4/netfilter/nf_nat_tftp.c                   |    2 +-
 net/ipv6/netfilter/ip6_queue.c                     |   18 +-
 net/ipv6/netfilter/ip6_tables.c                    |  113 ++++---
 net/ipv6/netfilter/ip6table_filter.c               |   33 ++-
 net/ipv6/netfilter/ip6table_mangle.c               |   33 ++-
 net/ipv6/netfilter/ip6table_raw.c                  |   31 ++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    7 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   22 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   16 +-
 net/netfilter/nf_conntrack_core.c                  |  234 +++++++-----=
-
 net/netfilter/nf_conntrack_expect.c                |   53 ++--
 net/netfilter/nf_conntrack_h323_asn1.c             |  156 +++++----
 net/netfilter/nf_conntrack_h323_main.c             |   23 +-
 net/netfilter/nf_conntrack_h323_types.c            |  346 ++++++++++--=
--------
 net/netfilter/nf_conntrack_helper.c                |   60 +---
 net/netfilter/nf_conntrack_irc.c                   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |   68 ++--
 net/netfilter/nf_conntrack_pptp.c                  |   14 +-
 net/netfilter/nf_conntrack_proto_generic.c         |    6 +-
 net/netfilter/nf_conntrack_proto_gre.c             |    6 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |    6 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  192 ++++++------
 net/netfilter/nf_conntrack_proto_udp.c             |   19 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |   19 +-
 net/netfilter/nf_conntrack_sane.c                  |    9 +-
 net/netfilter/nf_conntrack_sip.c                   |   29 +-
 net/netfilter/nf_conntrack_standalone.c            |   66 ++--
 net/netfilter/nf_conntrack_tftp.c                  |    5 +-
 net/netfilter/nf_log.c                             |    2 +
 net/netfilter/nfnetlink_log.c                      |    4 +-
 net/netfilter/nfnetlink_queue.c                    |    6 +-
 net/netfilter/x_tables.c                           |  313 ++++++++++++=
-------
 net/netfilter/xt_TCPMSS.c                          |   62 ++++-
 net/netfilter/xt_connlimit.c                       |    6 +-
 net/netfilter/xt_conntrack.c                       |   50 +++-
 net/netfilter/xt_hashlimit.c                       |  324 ++++++++++++=
++++--
 net/netfilter/xt_iprange.c                         |    2 +-
 net/netfilter/xt_owner.c                           |   14 +-
 103 files changed, 2089 insertions(+), 1295 deletions(-)
 create mode 100644 include/net/netns/x_tables.h

Alexey Dobriyan (13):
      [NETFILTER]: x_tables: change xt_table_register() return value co=
nvention
      [NETFILTER]: x_tables: per-netns xt_tables
      [NETFILTER]: x_tables: return new table from {arp,ip,ip6}t_regist=
er_table()
      [NETFILTER]: ip_tables: propagate netns from userspace
      [NETFILTER]: ip_tables: per-netns FILTER, MANGLE, RAW
      [NETFILTER]: ip6_tables: netns preparation
      [NETFILTER]: ip6_tables: per-netns IPv6 FILTER, MANGLE, RAW
      [NETFILTER]: arp_tables: netns preparation
      [NETFILTER]: arp_tables: per-netns arp_tables FILTER
      [NETFILTER]: netns: put table module on netns stop
      [NETFILTER]: x_tables: semi-rewrite of /proc/net/foo_tables_*
      [NETFILTER]: x_tables: netns propagation for /proc/net/*_tables_n=
ames
      [NETFILTER]: x_tables: create per-netns /proc/net/*_tables_*

Eric Dumazet (1):
      [NETFILTER]: Supress some sparse warnings

Eric Leblond (1):
      [NETFILTER]: nf_conntrack_netlink: transmit mark during all event=
s

Helge Deller (1):
      [NETFILTER]: nf_log: add netfilter gcc printf format checking

Ilpo J=E4rvinen (2):
      [NETFILTER]: ipt_CLUSTERIP: kill clusterip_config_entry_get
      [NETFILTER]: nf_conntrack: kill unused static inline (do_iter)

Jan Engelhardt (20):
      [NETFILTER]: Use const in struct xt_match, xt_target, xt_table
      linux/types.h: Use __u64 for aligned_u64
      [NETFILTER]: xt_conntrack: add port and direction matching
      [NETFILTER]: ebtables: remove casts, use consts
      [NETFILTER]: ebtables: Update modules' descriptions
      [NETFILTER]: ebtables: mark matches, targets and watchers __read_=
mostly
      [NETFILTER]: xt_TCPMSS: consider reverse route's MTU in clamp-to-=
pmtu
      [NETFILTER]: xt_owner: allow matching UID/GID ranges
      [NETFILTER]: nf_conntrack_h323: clean up code a bit
      [NETFILTER]: xt_hashlimit match, revision 1
      [NETFILTER]: nf_conntrack_h323: constify and annotate H.323 helpe=
r
      [NETFILTER]: nf_{conntrack,nat}_sip: annotate SIP helper with con=
st
      [NETFILTER]: nf_{conntrack,nat}_tftp: annotate TFTP helper with c=
onst
      [NETFILTER]: nf_{conntrack,nat}_pptp: annotate PPtP helper with c=
onst
      [NETFILTER]: nf_conntrack_sane: annotate SANE helper with const
      [NETFILTER]: nf_{conntrack,nat}_proto_tcp: constify and annotate =
TCP modules
      [NETFILTER]: nf_{conntrack,nat}_proto_udp{,lite}: annotate with c=
onst
      [NETFILTER]: nf_{conntrack,nat}_proto_gre: annotate with const
      [NETFILTER]: nf_{conntrack,nat}_icmp: constify and annotate
      [NETFILTER]: nf_conntrack: annotate l3protos with const

Patrick McHardy (25):
      [NETFILTER]: nf_nat: remove double bysource hash initialization
      [NETFILTER]: bridge netfilter: remove nf_bridge_info read-only ne=
toutdev member
      [NETFILTER]: nfnetlink_log: fix typo
      [NETFILTER]: ipt_recent: fix sparse warnings
      [NETFILTER]: {ip,arp,ip6}_tables: fix sparse warnings in compat c=
ode
      [NETFILTER]: nf_conntrack_ipv6: fix sparse warnings
      [NETFILTER]: nf_conntrack_netlink: fix unbalanced locking
      [NETFILTER]: nf_conntrack: fix accounting with fixed timeouts
      [NETFILTER]: nf_conntrack: use RCU for conntrack helpers
      [NETFILTER]: nf_conntrack_core: avoid taking nf_conntrack_lock in=
 nf_conntrack_alter_reply
      [NETFILTER]: nf_conntrack_expect: use RCU for expectation hash
      [NETFILTER]: nf_conntrack: use RCU for conntrack hash
      [NETFILTER]: nf_conntrack: switch rwlock to spinlock
      [NETFILTER]: nf_conntrack: optimize __nf_conntrack_find()
      [NETFILTER]: nf_conntrack: avoid duplicate protocol comparison in=
 nf_ct_tuple_equal()
      [NETFILTER]: nf_conntrack: optimize hash_conntrack()
      [NETFILTER]: nf_conntrack: reorder struct nf_conntrack_l4proto
      [NETFILTER]: nf_conntrack: don't inline early_drop()
      [NETFILTER]: nf_conntrack: naming unification
      [NETFILTER]: nf_nat: use RCU for bysource hash
      [NETFILTER]: nf_nat: switch rwlock to spinlock
      [NETFILTER]: {ip,ip6}_queue: fix build error
      [NETFILTER]: nf_conntrack: fix sparse warning
      [NETFILTER]: nf_nat: fix sparse warning
      [NETFILTER]: xt_iprange: fix sparse warnings

Stephen Hemminger (6):
      [NETFILTER]: nf_nat_snmp: sparse warning
      [NETFILTER]: nf_conntrack: sparse warnings
      [NETFILTER]: nfnetlink_log: sparse warning fixes
      [NETFILTER]: conntrack: get rid of sparse warnings
      [NETFILTER]: more sparse fixes
      [NETFILTER]: nf_conntrack_h3223: sparse fixes
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
