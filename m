From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/41]: Netfilter Update
Date: Mon, 14 Apr 2008 12:16:18 +0200 (MEST)
Message-ID: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36230 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYDNKQU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is part 2 of my netfilter patches for 2.6.26. The highlights
are:

- ip_tables network namespace support from Alexey Dobriyan
- some cleanups, const annotatations and boolean conversion by Jan Engelhardt
- SCTP/UDP-Lite NAT support, DCCP conntrack/NAT support
- nfnetlink_log support for bridge netfilter
- some assorted cleanups

I've also uploaded a git tree to:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.26.git

Please apply or pull, thanks.


 include/linux/netfilter.h                          |   76 ++-
 include/linux/netfilter/nf_conntrack_dccp.h        |   40 +
 include/linux/netfilter/nfnetlink_conntrack.h      |    8 +
 include/linux/netfilter/x_tables.h                 |    4 +-
 include/linux/netfilter/xt_sctp.h                  |   84 +--
 include/linux/netfilter_arp/arp_tables.h           |   17 +-
 include/linux/netfilter_bridge/ebt_nflog.h         |   21 +
 include/linux/netfilter_ipv4.h                     |    2 -
 include/net/netfilter/nf_conntrack.h               |   32 +-
 include/net/netfilter/nf_conntrack_core.h          |    4 +-
 include/net/netfilter/nf_conntrack_l3proto.h       |   19 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |   13 +-
 include/net/netfilter/nf_conntrack_tuple.h         |   47 +-
 include/net/netfilter/nf_nat_helper.h              |    3 +
 include/net/netfilter/nf_nat_protocol.h            |   46 +-
 include/net/netfilter/nf_nat_rule.h                |    3 -
 net/bridge/netfilter/Kconfig                       |   14 +
 net/bridge/netfilter/Makefile                      |    1 +
 net/bridge/netfilter/ebt_nflog.c                   |   74 ++
 net/bridge/netfilter/ebtable_broute.c              |    2 +-
 net/bridge/netfilter/ebtable_filter.c              |    2 +-
 net/bridge/netfilter/ebtable_nat.c                 |    2 +-
 net/ipv4/netfilter.c                               |   37 +-
 net/ipv4/netfilter/Kconfig                         |   15 +
 net/ipv4/netfilter/Makefile                        |    5 +-
 net/ipv4/netfilter/arp_tables.c                    |   66 +-
 net/ipv4/netfilter/arpt_mangle.c                   |   12 +-
 net/ipv4/netfilter/arptable_filter.c               |    7 +-
 net/ipv4/netfilter/ip_tables.c                     |   35 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   14 +-
 net/ipv4/netfilter/ipt_ECN.c                       |    2 +-
 net/ipv4/netfilter/ipt_LOG.c                       |    9 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |    6 +-
 net/ipv4/netfilter/ipt_recent.c                    |    6 +-
 net/ipv4/netfilter/iptable_filter.c                |   21 +-
 net/ipv4/netfilter/iptable_mangle.c                |   51 +-
 net/ipv4/netfilter/iptable_raw.c                   |    8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   70 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   13 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   27 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   61 +--
 net/ipv4/netfilter/nf_nat_helper.c                 |    1 -
 net/ipv4/netfilter/nf_nat_pptp.c                   |    2 +-
 net/ipv4/netfilter/nf_nat_proto_common.c           |  120 +++
 net/ipv4/netfilter/nf_nat_proto_dccp.c             |  108 +++
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   45 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c             |   19 +-
 net/ipv4/netfilter/nf_nat_proto_sctp.c             |   96 +++
 net/ipv4/netfilter/nf_nat_proto_tcp.c              |   80 +--
 net/ipv4/netfilter/nf_nat_proto_udp.c              |   77 +--
 net/ipv4/netfilter/nf_nat_proto_udplite.c          |   99 +++
 net/ipv4/netfilter/nf_nat_proto_unknown.c          |   25 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   25 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |   17 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |   76 +--
 net/ipv6/netfilter.c                               |   42 +-
 net/ipv6/netfilter/ip6_tables.c                    |   33 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |    6 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    3 +-
 net/ipv6/netfilter/ip6t_ipv6header.c               |    3 +-
 net/ipv6/netfilter/ip6t_rt.c                       |    3 +-
 net/ipv6/netfilter/ip6table_filter.c               |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c               |    2 +-
 net/ipv6/netfilter/ip6table_raw.c                  |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   14 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   29 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    8 +-
 net/netfilter/Kconfig                              |   10 +
 net/netfilter/Makefile                             |    1 +
 net/netfilter/nf_conntrack_amanda.c                |    6 +-
 net/netfilter/nf_conntrack_core.c                  |   29 +-
 net/netfilter/nf_conntrack_extend.c                |    3 +
 net/netfilter/nf_conntrack_ftp.c                   |    9 +-
 net/netfilter/nf_conntrack_h323_main.c             |   65 +-
 net/netfilter/nf_conntrack_helper.c                |    2 +-
 net/netfilter/nf_conntrack_irc.c                   |   14 +-
 net/netfilter/nf_conntrack_l3proto_generic.c       |   12 +-
 net/netfilter/nf_conntrack_netlink.c               |   34 +-
 net/netfilter/nf_conntrack_pptp.c                  |    8 +-
 net/netfilter/nf_conntrack_proto.c                 |    9 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |  815 ++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_generic.c         |   20 +-
 net/netfilter/nf_conntrack_proto_gre.c             |   31 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   50 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   64 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   18 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |   55 +-
 net/netfilter/nf_conntrack_sane.c                  |    5 +-
 net/netfilter/nf_conntrack_sip.c                   |   21 +-
 net/netfilter/nf_conntrack_standalone.c            |  131 ++--
 net/netfilter/nf_conntrack_tftp.c                  |   10 +-
 net/netfilter/x_tables.c                           |   18 +-
 net/netfilter/xt_CONNSECMARK.c                     |    2 +-
 net/netfilter/xt_RATEEST.c                         |    2 +-
 net/netfilter/xt_connlimit.c                       |   10 +-
 net/netfilter/xt_conntrack.c                       |    4 +-
 net/netfilter/xt_dccp.c                            |    3 +-
 net/netfilter/xt_esp.c                             |    3 +-
 net/netfilter/xt_multiport.c                       |    6 +-
 net/netfilter/xt_policy.c                          |    2 +-
 net/netfilter/xt_rateest.c                         |    4 +-
 net/netfilter/xt_sctp.c                            |    6 +-
 net/netfilter/xt_tcpmss.c                          |    6 +-
 net/netfilter/xt_tcpudp.c                          |    9 +-
 net/netfilter/xt_time.c                            |    2 +-
 105 files changed, 2383 insertions(+), 1032 deletions(-)
 create mode 100644 include/linux/netfilter/nf_conntrack_dccp.h
 create mode 100644 include/linux/netfilter_bridge/ebt_nflog.h
 create mode 100644 net/bridge/netfilter/ebt_nflog.c
 create mode 100644 net/ipv4/netfilter/nf_nat_proto_common.c
 create mode 100644 net/ipv4/netfilter/nf_nat_proto_dccp.c
 create mode 100644 net/ipv4/netfilter/nf_nat_proto_sctp.c
 create mode 100644 net/ipv4/netfilter/nf_nat_proto_udplite.c
 create mode 100644 net/netfilter/nf_conntrack_proto_dccp.c

Alexey Dobriyan (2):
      [NETFILTER]: nf_conntrack: less hairy ifdefs around proc and sysctl
      [NETFILTER]: ip_tables: per-netns FILTER/MANGLE/RAW tables for real

Jan Engelhardt (16):
      [NETFILTER]: xt_sctp: simplify xt_sctp.h
      [NETFILTER]: annotate xtables targets with const and remove casts
      [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
      [NETFILTER]: annotate rest of nf_conntrack_* with const
      [NETFILTER]: annotate rest of nf_nat_* with const
      [NETFILTER]: remove arpt_table indirection macro
      [NETFILTER]: remove arpt_target indirection macro
      [NETFILTER]: remove arpt_(un)register_target indirection macros
      [NETFILTER]: Explicitly initialize .priority in arptable_filter
      [NETFILTER]: Remove unused callbacks in nf_conntrack_l3proto
      [NETFILTER]: nf_conntrack: use bool type in struct nf_conntrack_l3proto
      [NETFILTER]: nf_conntrack: use bool type in struct nf_conntrack_l4proto
      [NETFILTER]: nf_conntrack: use bool type in struct nf_conntrack_tuple.h
      [NETFILTER]: nf_nat: use bool type in nf_nat_proto
      [NETFILTER]: nf_conntrack: const annotations in nf_conntrack_sctp, nf_nat_proto_gre
      [NETFILTER]: nf_conntrack: replace NF_CT_DUMP_TUPLE macro indrection by function call

Patrick McHardy (20):
      [NETFILTER]: {ip,ip6}t_LOG: print MARK value in log output
      [NETFILTER]: nf_conntrack_sip: clear address in parse_addr()
      [NETFILTER]: {ip,ip6,arp}_tables: return EAGAIN for invalid SO_GET_ENTRIES size
      [NETFILTER]: nf_nat: add helpers for common NAT protocol operations
      [NETFILTER]: nf_nat: fix random mode not to overwrite port rover
      [NETFILTER]: nf_nat: move NAT ctnetlink helpers to nf_nat_proto_common
      [NETFILTER]: nf_conntrack_netlink: clean up NAT protocol parsing
      [NETFILTER]: nf_nat: remove unused name from struct nf_nat_protocol
      [NETFILTER]: nf_nat: add UDP-Lite support
      [NETFILTER]: Add partial checksum validation helper
      [NETFILTER]: nf_conntrack: add DCCP protocol support
      [NETFILTER]: nf_nat: add DCCP protocol support
      [NETFILTER]: nf_nat: add SCTP protocol support
      [NETFILTER]: nf_nat: remove obsolete check for ICMP redirects
      [NETFILTER]: nf_nat: don't add NAT extension for confirmed conntracks
      [NETFILTER]: nf_conntrack_extend: warn on confirmed conntracks
      [NETFILTER]: nf_nat: kill helper and seq_adjust hooks
      [NETFILTER]: nf_conntrack_tcp: catch invalid state updates over ctnetlink
      [NETFILTER]: nf_conntrack: add tuplehash l3num/protonum accessors
      [NETFILTER]: nf_conntrack: fix incorrect check for expectations

Peter Warasin (1):
      [NETFILTER]: bridge: add ebt_nflog watcher

Robert P. J. Day (2):
      [NETFILTER]: bridge netfilter: use non-deprecated __RW_LOCK_UNLOCKED macro.
      [NETFILTER]: Use non-deprecated __RW_LOCK_UNLOCKED macro
