From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/50]: Netfilter 2.6.23 update
Date: Sat,  7 Jul 2007 14:23:00 +0200 (MEST)
Message-ID: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following is a large netfilter update for 2.6.23, featuring

- rework of the conntrack allocator by Yasuyuki. We're now using
  dynamically sized extension areas for things like helper data,
  expectations, NAT. This fixes a number of problems resulting
  from the old allocator scheme, most importantly we don't need
  to search the helper and expectation lists twice anymore.

- conversion of the conntrack and NAT hash tables to hlists

- patches to reduce the ability to mask tuples in expectations
  and helpers, which allows to keep them in a hash table. This
  fixes an easy DoS against conntrack and should also improve
  performance.

- improvement of conntrack eviction under pressure

- new xt_TRACE target that allows to trace packets through the
  netfilter hooks (unfortunately needs 1 bit in the skb)

- new xt_u32 match, which is the iptables equivalent to cls_u32

- some cleanup work by Jan Engelhardt to use bools where possible

- lots of minor cleanups: conversion from self-made debugging
  macros to pr_debug, __read_mostly annotations, ...

Please apply, thanks.


 Documentation/feature-removal-schedule.txt         |    8 +
 include/linux/netfilter.h                          |    3 +-
 include/linux/netfilter/nf_conntrack_pptp.h        |    2 +
 include/linux/netfilter/x_tables.h                 |   36 +-
 include/linux/netfilter/xt_u32.h                   |   40 ++
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h       |    4 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |   10 +-
 include/linux/skbuff.h                             |    4 +-
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |   23 +-
 include/net/netfilter/nf_conntrack.h               |   66 +---
 include/net/netfilter/nf_conntrack_core.h          |   11 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   17 +-
 include/net/netfilter/nf_conntrack_expect.h        |   42 +-
 include/net/netfilter/nf_conntrack_extend.h        |   85 ++++
 include/net/netfilter/nf_conntrack_helper.h        |   16 +-
 include/net/netfilter/nf_conntrack_l3proto.h       |    2 -
 include/net/netfilter/nf_conntrack_tuple.h         |   78 ++--
 include/net/netfilter/nf_nat.h                     |   28 +-
 include/net/netfilter/nf_nat_core.h                |    1 +
 net/core/skbuff.c                                  |    8 +
 net/ipv4/ip_output.c                               |    4 +
 net/ipv4/netfilter/Kconfig                         |    2 +-
 net/ipv4/netfilter/arp_tables.c                    |    6 +-
 net/ipv4/netfilter/arpt_mangle.c                   |   10 +-
 net/ipv4/netfilter/ip_tables.c                     |  175 ++++++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |  116 ++---
 net/ipv4/netfilter/ipt_ECN.c                       |   36 +-
 net/ipv4/netfilter/ipt_LOG.c                       |   56 ++-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   30 +-
 net/ipv4/netfilter/ipt_NETMAP.c                    |   23 +-
 net/ipv4/netfilter/ipt_REDIRECT.c                  |   20 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |   30 +-
 net/ipv4/netfilter/ipt_SAME.c                      |   69 ++--
 net/ipv4/netfilter/ipt_TOS.c                       |    8 +-
 net/ipv4/netfilter/ipt_TTL.c                       |   14 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |   68 ++--
 net/ipv4/netfilter/ipt_addrtype.c                  |   14 +-
 net/ipv4/netfilter/ipt_ah.c                        |   25 +-
 net/ipv4/netfilter/ipt_ecn.c                       |   59 ++--
 net/ipv4/netfilter/ipt_iprange.c                   |   50 +--
 net/ipv4/netfilter/ipt_owner.c                     |   20 +-
 net/ipv4/netfilter/ipt_recent.c                    |   43 +-
 net/ipv4/netfilter/ipt_tos.c                       |    6 +-
 net/ipv4/netfilter/ipt_ttl.c                       |   26 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   36 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |  106 +++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   26 +-
 net/ipv4/netfilter/nf_nat_amanda.c                 |    4 +-
 net/ipv4/netfilter/nf_nat_core.c                   |  127 ++++--
 net/ipv4/netfilter/nf_nat_ftp.c                    |   18 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |  121 +++---
 net/ipv4/netfilter/nf_nat_helper.c                 |   55 +--
 net/ipv4/netfilter/nf_nat_irc.c                    |   17 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   43 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   17 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   48 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   18 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    6 -
 net/ipv4/netfilter/nf_nat_standalone.c             |   47 +--
 net/ipv4/netfilter/nf_nat_tftp.c                   |    2 +-
 net/ipv6/ip6_output.c                              |    4 +
 net/ipv6/netfilter/ip6_tables.c                    |  200 ++++++--
 net/ipv6/netfilter/ip6t_HL.c                       |   14 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |   57 ++-
 net/ipv6/netfilter/ip6t_REJECT.c                   |   45 +-
 net/ipv6/netfilter/ip6t_ah.c                       |   82 ++--
 net/ipv6/netfilter/ip6t_eui64.c                    |   20 +-
 net/ipv6/netfilter/ip6t_frag.c                     |  111 ++---
 net/ipv6/netfilter/ip6t_hbh.c                      |   88 ++--
 net/ipv6/netfilter/ip6t_hl.c                       |   22 +-
 net/ipv6/netfilter/ip6t_ipv6header.c               |   22 +-
 net/ipv6/netfilter/ip6t_mh.c                       |   30 +-
 net/ipv6/netfilter/ip6t_owner.c                    |   26 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  134 +++---
 net/ipv6/netfilter/ip6table_mangle.c               |    6 -
 net/ipv6/netfilter/ip6table_raw.c                  |    6 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   16 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   26 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   52 +--
 net/netfilter/Kconfig                              |   25 +
 net/netfilter/Makefile                             |    4 +-
 net/netfilter/core.c                               |    6 +-
 net/netfilter/nf_conntrack_amanda.c                |   17 +-
 net/netfilter/nf_conntrack_core.c                  |  513 +++++++-------------
 net/netfilter/nf_conntrack_ecache.c                |   16 +-
 net/netfilter/nf_conntrack_expect.c                |  365 +++++++++-----
 net/netfilter/nf_conntrack_extend.c                |  195 ++++++++
 net/netfilter/nf_conntrack_ftp.c                   |  143 +++----
 net/netfilter/nf_conntrack_h323_asn1.c             |   18 +-
 net/netfilter/nf_conntrack_h323_main.c             |  307 ++++++-------
 net/netfilter/nf_conntrack_helper.c                |  131 ++++--
 net/netfilter/nf_conntrack_irc.c                   |   39 +-
 net/netfilter/nf_conntrack_l3proto_generic.c       |   13 -
 net/netfilter/nf_conntrack_netbios_ns.c            |   12 +-
 net/netfilter/nf_conntrack_netlink.c               |  182 +++++---
 net/netfilter/nf_conntrack_pptp.c                  |  120 +++---
 net/netfilter/nf_conntrack_proto_gre.c             |   28 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   92 ++---
 net/netfilter/nf_conntrack_proto_tcp.c             |  129 +++---
 net/netfilter/nf_conntrack_sane.c                  |   45 +--
 net/netfilter/nf_conntrack_sip.c                   |   37 +-
 net/netfilter/nf_conntrack_standalone.c            |   43 +-
 net/netfilter/nf_conntrack_tftp.c                  |   32 +-
 net/netfilter/nf_queue.c                           |   57 ++-
 net/netfilter/nfnetlink_queue.c                    |    4 +-
 net/netfilter/x_tables.c                           |    9 +-
 net/netfilter/xt_CLASSIFY.c                        |    2 +-
 net/netfilter/xt_CONNMARK.c                        |   18 +-
 net/netfilter/xt_CONNSECMARK.c                     |   18 +-
 net/netfilter/xt_DSCP.c                            |   18 +-
 net/netfilter/xt_MARK.c                            |   24 +-
 net/netfilter/xt_NFLOG.c                           |   12 +-
 net/netfilter/xt_NFQUEUE.c                         |    2 +-
 net/netfilter/xt_NOTRACK.c                         |    2 +-
 net/netfilter/xt_SECMARK.c                         |   26 +-
 net/netfilter/xt_TCPMSS.c                          |   28 +-
 net/netfilter/xt_TRACE.c                           |   53 ++
 net/netfilter/xt_comment.c                         |    8 +-
 net/netfilter/xt_connbytes.c                       |   32 +-
 net/netfilter/xt_connmark.c                        |   26 +-
 net/netfilter/xt_conntrack.c                       |   42 +-
 net/netfilter/xt_dccp.c                            |   50 +-
 net/netfilter/xt_dscp.c                            |   48 +-
 net/netfilter/xt_esp.c                             |   24 +-
 net/netfilter/xt_hashlimit.c                       |   63 ++--
 net/netfilter/xt_helper.c                          |   61 +--
 net/netfilter/xt_length.c                          |   14 +-
 net/netfilter/xt_limit.c                           |   23 +-
 net/netfilter/xt_mac.c                             |   16 +-
 net/netfilter/xt_mark.c                            |   16 +-
 net/netfilter/xt_multiport.c                       |   54 +-
 net/netfilter/xt_physdev.c                         |   48 +-
 net/netfilter/xt_pkttype.c                         |   10 +-
 net/netfilter/xt_policy.c                          |   50 +-
 net/netfilter/xt_quota.c                           |   21 +-
 net/netfilter/xt_realm.c                           |    8 +-
 net/netfilter/xt_sctp.c                            |   61 ++--
 net/netfilter/xt_state.c                           |   20 +-
 net/netfilter/xt_statistic.c                       |   20 +-
 net/netfilter/xt_string.c                          |   38 +-
 net/netfilter/xt_tcpmss.c                          |   10 +-
 net/netfilter/xt_tcpudp.c                          |   63 ++--
 net/netfilter/xt_u32.c                             |  135 +++++
 143 files changed, 3636 insertions(+), 3156 deletions(-)
 create mode 100644 include/linux/netfilter/xt_u32.h
 create mode 100644 include/net/netfilter/nf_conntrack_extend.h
 create mode 100644 net/netfilter/nf_conntrack_extend.c
 create mode 100644 net/netfilter/xt_TRACE.c
 create mode 100644 net/netfilter/xt_u32.c

Balazs Scheidler (1):
      [NETFILTER]: x_tables: add more detail to error message about match/target mask mismatch

Jan Engelhardt (8):
      [NETFILTER]: x_tables: switch hotdrop to bool
      [NETFILTER]: x_tables: switch xt_match->match to bool
      [NETFILTER]: x_tables: switch xt_match->checkentry to bool
      [NETFILTER]: x_tables: switch xt_target->checkentry to bool
      [NETFILTER]: add some consts, remove some casts
      [NETFILTER]: Remove incorrect inline markers
      [NETFILTER]: Remove redundant parentheses/braces
      [NETFILTER]: Add u32 match

Jerome Borsboom (1):
      [NETFILTER]: nf_nat_sip: only perform RTP DNAT if SIP session was SNATed

Jing Min Zhao (1):
      [NETFILTER]: nf_conntrack_h323: check range first in sequence extension

Jozsef Kadlecsik (1):
      [NETFILTER]: x_tables: add TRACE target

Patrick McHardy (26):
      [NETFILTER]: x_tables: mark matches and targets __read_mostly
      [NETFILTER]: nf_conntrack_extend: use __read_mostly for struct nf_ct_ext_type
      [NETFILTER]: nf_conntrack: round up hashsize to next multiple of PAGE_SIZE
      [NETFILTER]: nf_conntrack: use hlists for conntrack hash
      [NETFILTER]: nf_conntrack: remove 'ignore_conntrack' argument from nf_conntrack_find_get
      [NETFILTER]: nf_conntrack: export hash allocation/destruction functions
      [NETFILTER]: nf_nat: use hlists for bysource hash
      [NETFILTER]: nf_conntrack_expect: function naming unification
      [NETFILTER]: nf_conntrack_ftp: use nf_ct_expect_init
      [NETFILTER]: nf_conntrack: reduce masks to a subset of tuples
      [NETFILTER]: nf_conntrack_expect: avoid useless list walking
      [NETFILTER]: nf_conntrack_netlink: sync expectation dumping with conntrack table dumping
      [NETFILTER]: nf_conntrack: move expectaton related init code to nf_conntrack_expect.c
      [NETFILTER]: nf_conntrack: use hashtable for expectations
      [NETFILTER]: nf_conntrack_expect: convert proc functions to hash
      [NETFILTER]: nf_conntrack_helper/nf_conntrack_netlink: convert to expectation hash
      [NETFILTER]: nf_conntrack_expect: maintain per conntrack expectation list
      [NETFILTER]: nf_conntrack_expect: introduce nf_conntrack_expect_max sysct
      [NETFILTER]: nf_conntrack_helper: use hashtable for conntrack helpers
      [NETFILTER]: nf_conntrack: mark helpers __read_mostly
      [NETFILTER]: nf_conntrack: early_drop improvement
      [NETFILTER]: ipt_SAME: add to feature-removal-schedule
      [NETFILTER]: ipt_CLUSTERIP: add compat code
      [NETFILTER]: nf_conntrack_h323: turn some printks into DEBUGPs
      [NETFILTER]: xt_helper: use RCU
      [NETFILTER]: Convert DEBUGP to pr_debug

Yasuyuki Kozakai (12):
      [NETFILTER]: ip6_tables: fix explanation of valid upper protocol number
      [NETFILTER]: nf_nat: move NAT declarations from nf_conntrack_ipv4.h to nf_nat.h
      [NETFILTER]: nf_conntrack: introduce extension infrastructure
      [NETFILTER]: nf_conntrack: use extension infrastructure for helper
      [NETFILTER]: nf_nat: add reference to conntrack from entry of bysource list
      [NETFILTER]: nf_nat: use extension infrastructure
      [NETFILTER]: nf_nat: remove unused nf_nat_module_is_loaded
      [NETFILTER]: nf_conntrack: remove old memory allocator of conntrack
      [NETFILTER]: nf_nat: kill global 'destroy' operation
      [NETFILTER]: nf_nat: merge nf_conn and nf_nat_info
      [NETFILTER]: nfnetlink_queue: don't unregister handler of other subsystem
      [NETFILTER]: nf_queue: Use RCU and mutex for queue handlers
