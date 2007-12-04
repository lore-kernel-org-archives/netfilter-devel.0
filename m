From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/49]: Netfilter update
Date: Tue,  4 Dec 2007 13:01:54 +0100 (MET)
Message-ID: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62089 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXLDMB4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:01:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is the first batch of my netfilter patches for 2.6.25,
containing (among other things) some x_tables unification patches
for the owner and tos matches and the TOS target, and new
TCPOPTSTRIP target to strip away TCP options as workaround for
broken firewalls, a new RATEEST target + rateest match for rate
estimation, a large queueing cleanup and some optimizations and
a few patches to remove runtime dependencies of x_tables modules
and the H.323 helper on IPv6 modules. The CONFIG_NETFILTER_ADVANCED
patch is not included yet since I'm not entirely happy with it.

Please apply, thanks.


 Documentation/feature-removal-schedule.txt     |    9 -
 include/linux/netfilter.h                      |   39 +--
 include/linux/netfilter/Kbuild                 |    3 +
 include/linux/netfilter/x_tables.h             |    5 +-
 include/linux/netfilter/xt_DSCP.h              |    5 +
 include/linux/netfilter/xt_RATEEST.h           |   11 +
 include/linux/netfilter/xt_TCPOPTSTRIP.h       |   13 +
 include/linux/netfilter/xt_dscp.h              |    6 +
 include/linux/netfilter/xt_owner.h             |   16 +
 include/linux/netfilter/xt_rateest.h           |   33 ++
 include/linux/netfilter_ipv4/ipt_addrtype.h    |   14 +
 include/net/dsfield.h                          |    6 +-
 include/net/netfilter/nf_queue.h               |   34 ++
 include/net/netfilter/xt_rateest.h             |   17 +
 include/net/route.h                            |    1 +
 net/bridge/br_netfilter.c                      |    2 +-
 net/bridge/netfilter/ebtable_filter.c          |    2 +-
 net/bridge/netfilter/ebtable_nat.c             |    2 +-
 net/decnet/netfilter/dn_rtmsg.c                |    2 +-
 net/ipv4/fib_frontend.c                        |   21 +-
 net/ipv4/ipvs/ip_vs_core.c                     |  104 ++---
 net/ipv4/netfilter.c                           |   21 +-
 net/ipv4/netfilter/Kconfig                     |   49 +--
 net/ipv4/netfilter/Makefile                    |    4 -
 net/ipv4/netfilter/arp_tables.c                |    5 +-
 net/ipv4/netfilter/arptable_filter.c           |    2 +-
 net/ipv4/netfilter/ip_queue.c                  |  183 +++-----
 net/ipv4/netfilter/ip_tables.c                 |   24 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   49 +--
 net/ipv4/netfilter/ipt_ECN.c                   |   35 +-
 net/ipv4/netfilter/ipt_LOG.c                   |   40 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |   35 +-
 net/ipv4/netfilter/ipt_NETMAP.c                |   35 +-
 net/ipv4/netfilter/ipt_REDIRECT.c              |   35 +-
 net/ipv4/netfilter/ipt_REJECT.c                |   37 +-
 net/ipv4/netfilter/ipt_SAME.c                  |  180 --------
 net/ipv4/netfilter/ipt_TOS.c                   |   35 +-
 net/ipv4/netfilter/ipt_TTL.c                   |   34 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |   45 +-
 net/ipv4/netfilter/ipt_addrtype.c              |  113 ++++-
 net/ipv4/netfilter/ipt_ah.c                    |   37 +-
 net/ipv4/netfilter/ipt_ecn.c                   |   33 +-
 net/ipv4/netfilter/ipt_iprange.c               |   26 +-
 net/ipv4/netfilter/ipt_owner.c                 |   93 ----
 net/ipv4/netfilter/ipt_recent.c                |   39 +-
 net/ipv4/netfilter/ipt_tos.c                   |   55 ---
 net/ipv4/netfilter/ipt_ttl.c                   |   24 +-
 net/ipv4/netfilter/iptable_filter.c            |    2 +-
 net/ipv4/netfilter/iptable_mangle.c            |    2 +-
 net/ipv4/netfilter/iptable_raw.c               |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    1 -
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 +-
 net/ipv6/netfilter.c                           |   22 +-
 net/ipv6/netfilter/Kconfig                     |   25 +-
 net/ipv6/netfilter/Makefile                    |    1 -
 net/ipv6/netfilter/ip6_queue.c                 |  188 +++-----
 net/ipv6/netfilter/ip6_tables.c                |    5 +-
 net/ipv6/netfilter/ip6t_HL.c                   |   37 +-
 net/ipv6/netfilter/ip6t_LOG.c                  |   40 +-
 net/ipv6/netfilter/ip6t_REJECT.c               |   37 +-
 net/ipv6/netfilter/ip6t_ah.c                   |   37 +-
 net/ipv6/netfilter/ip6t_eui64.c                |   28 +-
 net/ipv6/netfilter/ip6t_frag.c                 |   38 +-
 net/ipv6/netfilter/ip6t_hbh.c                  |   42 +-
 net/ipv6/netfilter/ip6t_hl.c                   |   24 +-
 net/ipv6/netfilter/ip6t_ipv6header.c           |   38 +-
 net/ipv6/netfilter/ip6t_mh.c                   |   37 +-
 net/ipv6/netfilter/ip6t_owner.c                |   93 ----
 net/ipv6/netfilter/ip6t_rt.c                   |   37 +-
 net/ipv6/netfilter/ip6table_filter.c           |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c           |    2 +-
 net/ipv6/netfilter/ip6table_raw.c              |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/netfilter/Kconfig                          |   74 +++-
 net/netfilter/Makefile                         |    4 +
 net/netfilter/core.c                           |   16 +-
 net/netfilter/nf_conntrack_h323_main.c         |   19 +-
 net/netfilter/nf_queue.c                       |  179 ++++----
 net/netfilter/nfnetlink_queue.c                |  584 +++++++++---------------
 net/netfilter/x_tables.c                       |    2 +-
 net/netfilter/xt_CLASSIFY.c                    |   30 +-
 net/netfilter/xt_CONNMARK.c                    |   56 +--
 net/netfilter/xt_CONNSECMARK.c                 |   47 +-
 net/netfilter/xt_DSCP.c                        |  165 ++++++--
 net/netfilter/xt_MARK.c                        |   69 ++--
 net/netfilter/xt_NFLOG.c                       |   36 +-
 net/netfilter/xt_NFQUEUE.c                     |   30 +-
 net/netfilter/xt_NOTRACK.c                     |   28 +-
 net/netfilter/xt_RATEEST.c                     |  204 +++++++++
 net/netfilter/xt_SECMARK.c                     |   38 +-
 net/netfilter/xt_TCPMSS.c                      |   56 +--
 net/netfilter/xt_TCPOPTSTRIP.c                 |  147 ++++++
 net/netfilter/xt_TRACE.c                       |   28 +-
 net/netfilter/xt_comment.c                     |   31 +-
 net/netfilter/xt_connbytes.c                   |   52 +--
 net/netfilter/xt_connlimit.c                   |   50 +-
 net/netfilter/xt_connmark.c                    |   58 +--
 net/netfilter/xt_conntrack.c                   |   51 +--
 net/netfilter/xt_dccp.c                        |   41 +-
 net/netfilter/xt_dscp.c                        |  112 ++++--
 net/netfilter/xt_esp.c                         |   41 +-
 net/netfilter/xt_hashlimit.c                   |   71 ++--
 net/netfilter/xt_helper.c                      |   52 +--
 net/netfilter/xt_length.c                      |   43 +-
 net/netfilter/xt_limit.c                       |   50 +--
 net/netfilter/xt_mac.c                         |   29 +-
 net/netfilter/xt_mark.c                        |   49 +--
 net/netfilter/xt_multiport.c                   |   98 ++---
 net/netfilter/xt_owner.c                       |  211 +++++++++
 net/netfilter/xt_physdev.c                     |   43 +-
 net/netfilter/xt_pkttype.c                     |   32 +-
 net/netfilter/xt_policy.c                      |   43 +-
 net/netfilter/xt_quota.c                       |   36 +-
 net/netfilter/xt_rateest.c                     |  178 +++++++
 net/netfilter/xt_realm.c                       |   28 +-
 net/netfilter/xt_sctp.c                        |   41 +-
 net/netfilter/xt_state.c                       |   50 +--
 net/netfilter/xt_statistic.c                   |   40 +-
 net/netfilter/xt_string.c                      |   50 +--
 net/netfilter/xt_tcpmss.c                      |   31 +-
 net/netfilter/xt_tcpudp.c                      |   77 ++--
 net/netfilter/xt_time.c                        |   38 +-
 net/netfilter/xt_u32.c                         |   27 +-
 net/sched/sch_ingress.c                        |   44 +-
 125 files changed, 3015 insertions(+), 2955 deletions(-)
 create mode 100644 include/linux/netfilter/xt_RATEEST.h
 create mode 100644 include/linux/netfilter/xt_TCPOPTSTRIP.h
 create mode 100644 include/linux/netfilter/xt_owner.h
 create mode 100644 include/linux/netfilter/xt_rateest.h
 create mode 100644 include/net/netfilter/nf_queue.h
 create mode 100644 include/net/netfilter/xt_rateest.h
 delete mode 100644 net/ipv4/netfilter/ipt_SAME.c
 delete mode 100644 net/ipv4/netfilter/ipt_owner.c
 delete mode 100644 net/ipv4/netfilter/ipt_tos.c
 delete mode 100644 net/ipv6/netfilter/ip6t_owner.c
 create mode 100644 net/netfilter/xt_RATEEST.c
 create mode 100644 net/netfilter/xt_TCPOPTSTRIP.c
 create mode 100644 net/netfilter/xt_owner.c
 create mode 100644 net/netfilter/xt_rateest.c

Eric Dumazet (1):
      [NETFILTER]: x_tables: struct xt_table_info diet

Jan Engelhardt (8):
      [NETFILTER]: x_tables: consistent and unique symbol names
      [NETFILTER]: merge ipt_owner/ip6t_owner in xt_owner
      [NETFILTER]: Use lowercase names for matches in Kconfig
      [NET]: Constify include/net/dsfield.h
      [NETFILTER]: Merge ipt_tos into xt_dscp
      [NETFILTER]: Merge ipt_TOS into xt_DSCP
      [NETFILTER]: IPv6 capable xt_tos v1 match
      [NETFILTER]: IPv6 capable xt_TOS v1 target

Laszlo Attila Toth (2):
      [IPV4]: Add inet_dev_addr_type()
      [NETFILTER]: ipt_addrtype: limit address type checking to an interface

Li Zefan (1):
      [NETFILTER]: replace list_for_each with list_for_each_entry

Maciej Soltysiak (1):
      [NETFILTER]: {ip,ip6}t_LOG: log GID

Patrick McHardy (35):
      [NETFILTER]: x_tables: remove obsolete overflow check
      [NETFILTER]: ip_tables: remove obsolete SAME target
      [NETFILTER]: x_tables: add RATEEST target
      [NETFILTER]: x_tables: add rateest match
      [NETFILTER]: xt_hashlimit: remove ip6tables module dependency
      [NETFILTER]: nf_ct_h323: remove ipv6 module dependency
      [NETFILTER]: nf_conntrack_proto_icmp: kill extern declaration in .c file
      [NETFILTER]: Use nf_register_hooks for multiple registrations
      [NETFILTER]: Mark hooks __read_mostly
      [NETFILTER]: nf_queue: minor cleanup
      [NETFILTER]: nf_queue: remove unnecessary hook existance check
      [NETFILTER]: nf_queue: make queue_handler const
      [NETFILTER]: nf_queue: remove unused data pointer
      [NETFILTER]: nf_queue: move queueing related functions/struct to seperate header
      [NETFILTER]: {nf_netlink,ip,ip6}_queue: use list_for_each_entry
      [NETFILTER]: nfnetlink_queue: deobfuscate entry lookups
      [NETFILTER]: ip_queue: deobfuscate entry lookups
      [NETFILTER]: ip6_queue: deobfuscate entry lookups
      [NETFILTER]: ip6_queue: resync dev-index based flushing
      [NETFILTER]: nf_queue: move list_head/skb/id to struct nf_info
      [NETFILTER]: {nfnetlink,ip,ip6}_queue: kill issue_verdict
      [NETFILTER]: nf_queue: clean up error paths
      [NETFILTER]: remove annoying debugging message
      [NETFILTER]: nfnetlink_queue: avoid unnecessary atomic operation
      [NETFILTER]: nfnetlink_queue: fix checks in nfqnl_recv_config
      [NETFILTER]: nfnetlink: use RCU for queue instances hash
      [NETFILTER]: nfnetlink_queue: kill useless wrapper
      [NETFILTER]: nfnetlink_queue: remove useless debugging
      [NETFILTER]: nfnetlink_queue: mark hash table __read_mostly
      [NETFILTER]: nfnetlink_queue: use endianness-aware attribute functions
      [NETFILTER]: nfnetlink_queue: eliminate impossible switch case
      [NETFILTER]: nfnetlink_queue: remove useless enqueue status codes
      [NETFILTER]: nfnetlink_queue: update copyright
      [NETFILTER]: remove NF_CONNTRACK_ENABLED option
      [NETFILTER]: Select CONFIG_NETFILTER_NETLINK when needed

Sven Schnelle (1):
      [NETFILTER]: x_tables: add TCPOPTSTRIP target
