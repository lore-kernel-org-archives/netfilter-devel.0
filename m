From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/79: netfilter update
Date: Wed,  8 Oct 2008 12:46:21 +0200 (MEST)
Message-ID: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45848 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYJHKqX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is my netfilter update for 2.6.28, containing:

- a large number of patches for network namespace support from Alexey Dobrian.
  We're getting close to full netns support.

- Decoupling of netfilter family values from real protocol numbers as
  preparatory work for making ebtables and arptables use the x_tables
  infrastructure

- A set of patches from Jan Engelhardt to make ebtables and arptables use
  the x_tables infrastructure.

- A set of patches from Jan Engelhardt to support and use AF-independant
  matches and targets.

- ipt_recent IPv6 support from Jan Engelhardt

- Some cleanups (Kconfig, constifying) in the *tables area from Jan

- The TPROXY patches from Krisztian Kovacs


These patches are also available in a git-tree at, based on the latest
net-next-2.6.git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

Please apply or pull, thanks.


 Documentation/feature-removal-schedule.txt         |    3 +
 Documentation/networking/tproxy.txt                |   85 +++++
 include/linux/netfilter.h                          |   97 ++----
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/nf_conntrack_proto_gre.h   |    2 +-
 include/linux/netfilter/x_tables.h                 |  161 +++++++---
 include/linux/netfilter/xt_TPROXY.h                |   14 +
 include/linux/netfilter/xt_recent.h                |   26 ++
 include/linux/netfilter_bridge/ebtables.h          |   76 +++--
 include/linux/netfilter_ipv4/ipt_recent.h          |   28 +-
 include/net/net_namespace.h                        |    6 +
 include/net/netfilter/ipv4/nf_defrag_ipv4.h        |    6 +
 include/net/netfilter/nf_conntrack.h               |   34 ++-
 include/net/netfilter/nf_conntrack_acct.h          |   10 +-
 include/net/netfilter/nf_conntrack_core.h          |   11 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   26 +-
 include/net/netfilter/nf_conntrack_expect.h        |   22 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |   21 +-
 include/net/netfilter/nf_log.h                     |    8 +-
 include/net/netfilter/nf_queue.h                   |    6 +-
 include/net/netfilter/nf_tproxy_core.h             |   32 ++
 include/net/netns/conntrack.h                      |   30 ++
 include/net/netns/ipv4.h                           |    3 +
 net/bridge/br_netfilter.c                          |    4 +-
 net/bridge/netfilter/Kconfig                       |   30 +--
 net/bridge/netfilter/ebt_802_3.c                   |   47 ++--
 net/bridge/netfilter/ebt_among.c                   |   85 +++---
 net/bridge/netfilter/ebt_arp.c                     |   73 ++--
 net/bridge/netfilter/ebt_arpreply.c                |   49 ++--
 net/bridge/netfilter/ebt_dnat.c                    |   57 ++--
 net/bridge/netfilter/ebt_ip.c                      |   72 ++--
 net/bridge/netfilter/ebt_ip6.c                     |   76 ++---
 net/bridge/netfilter/ebt_limit.c                   |   45 ++--
 net/bridge/netfilter/ebt_log.c                     |   57 ++--
 net/bridge/netfilter/ebt_mark.c                    |   41 ++--
 net/bridge/netfilter/ebt_mark_m.c                  |   45 ++--
 net/bridge/netfilter/ebt_nflog.c                   |   44 ++--
 net/bridge/netfilter/ebt_pkttype.c                 |   41 +--
 net/bridge/netfilter/ebt_redirect.c                |   63 ++--
 net/bridge/netfilter/ebt_snat.c                    |   52 ++--
 net/bridge/netfilter/ebt_stp.c                     |   78 +++---
 net/bridge/netfilter/ebt_ulog.c                    |   58 ++--
 net/bridge/netfilter/ebt_vlan.c                    |   61 ++--
 net/bridge/netfilter/ebtables.c                    |  313 ++++++++----------
 net/core/net_namespace.c                           |    1 +
 net/ipv4/netfilter.c                               |    7 +-
 net/ipv4/netfilter/Kconfig                         |  128 ++++----
 net/ipv4/netfilter/Makefile                        |    4 +-
 net/ipv4/netfilter/arp_tables.c                    |  116 ++++---
 net/ipv4/netfilter/arpt_mangle.c                   |   15 +-
 net/ipv4/netfilter/arptable_filter.c               |    8 +-
 net/ipv4/netfilter/ip_tables.c                     |  177 +++++-----
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   29 +-
 net/ipv4/netfilter/ipt_ECN.c                       |   17 +-
 net/ipv4/netfilter/ipt_LOG.c                       |   21 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   30 +-
 net/ipv4/netfilter/ipt_NETMAP.c                    |   26 +-
 net/ipv4/netfilter/ipt_REDIRECT.c                  |   21 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |   19 +-
 net/ipv4/netfilter/ipt_TTL.c                       |   15 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |   23 +-
 net/ipv4/netfilter/ipt_addrtype.c                  |   35 +--
 net/ipv4/netfilter/ipt_ah.c                        |   24 +-
 net/ipv4/netfilter/ipt_ecn.c                       |   20 +-
 net/ipv4/netfilter/ipt_ttl.c                       |    9 +-
 net/ipv4/netfilter/iptable_filter.c                |    6 +-
 net/ipv4/netfilter/iptable_mangle.c                |   10 +-
 net/ipv4/netfilter/iptable_raw.c                   |    4 +-
 net/ipv4/netfilter/iptable_security.c              |    6 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   68 +----
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   73 +++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   22 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |   96 ++++++
 net/ipv4/netfilter/nf_nat_core.c                   |   72 +++--
 net/ipv4/netfilter/nf_nat_helper.c                 |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |    3 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   92 +++---
 net/ipv6/netfilter.c                               |    2 +-
 net/ipv6/netfilter/Kconfig                         |   77 ++---
 net/ipv6/netfilter/ip6_tables.c                    |  173 +++++-----
 net/ipv6/netfilter/ip6t_HL.c                       |   15 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |   22 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |   39 +--
 net/ipv6/netfilter/ip6t_ah.c                       |   21 +-
 net/ipv6/netfilter/ip6t_eui64.c                    |   11 +-
 net/ipv6/netfilter/ip6t_frag.c                     |   21 +-
 net/ipv6/netfilter/ip6t_hbh.c                      |   25 +-
 net/ipv6/netfilter/ip6t_hl.c                       |    9 +-
 net/ipv6/netfilter/ip6t_ipv6header.c               |   16 +-
 net/ipv6/netfilter/ip6t_mh.c                       |   25 +-
 net/ipv6/netfilter/ip6t_rt.c                       |   21 +-
 net/ipv6/netfilter/ip6table_filter.c               |    6 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   31 ++-
 net/ipv6/netfilter/ip6table_raw.c                  |   20 +-
 net/ipv6/netfilter/ip6table_security.c             |    6 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   24 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   19 +-
 net/netfilter/Kconfig                              |  236 +++++++------
 net/netfilter/Makefile                             |    6 +
 net/netfilter/core.c                               |   18 +-
 net/netfilter/nf_conntrack_acct.c                  |  100 ++++--
 net/netfilter/nf_conntrack_core.c                  |  344 ++++++++++++--------
 net/netfilter/nf_conntrack_ecache.c                |   26 +-
 net/netfilter/nf_conntrack_expect.c                |  104 ++++---
 net/netfilter/nf_conntrack_ftp.c                   |    9 +-
 net/netfilter/nf_conntrack_h323_main.c             |    6 +-
 net/netfilter/nf_conntrack_helper.c                |   40 ++-
 net/netfilter/nf_conntrack_netlink.c               |   31 +-
 net/netfilter/nf_conntrack_pptp.c                  |   36 ++-
 net/netfilter/nf_conntrack_proto.c                 |   10 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   20 +-
 net/netfilter/nf_conntrack_proto_generic.c         |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c             |  101 +++++--
 net/netfilter/nf_conntrack_proto_sctp.c            |    6 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   35 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   16 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |   20 +-
 net/netfilter/nf_conntrack_sip.c                   |    3 +-
 net/netfilter/nf_conntrack_standalone.c            |  146 +++++---
 net/netfilter/nf_internals.h                       |    4 +-
 net/netfilter/nf_log.c                             |   18 +-
 net/netfilter/nf_queue.c                           |   22 +-
 net/netfilter/nf_sockopt.c                         |   18 +-
 net/netfilter/nf_tproxy_core.c                     |   96 ++++++
 net/netfilter/nfnetlink_log.c                      |    4 +-
 net/netfilter/x_tables.c                           |  145 +++++----
 net/netfilter/xt_CLASSIFY.c                        |   44 +--
 net/netfilter/xt_CONNMARK.c                        |   78 ++----
 net/netfilter/xt_CONNSECMARK.c                     |   63 ++---
 net/netfilter/xt_DSCP.c                            |   59 ++--
 net/netfilter/xt_MARK.c                            |   76 +----
 net/netfilter/xt_NFLOG.c                           |   46 +--
 net/netfilter/xt_NFQUEUE.c                         |   10 +-
 net/netfilter/xt_NOTRACK.c                         |   30 +--
 net/netfilter/xt_RATEEST.c                         |   56 +---
 net/netfilter/xt_SECMARK.c                         |   52 +--
 net/netfilter/xt_TCPMSS.c                          |   38 +--
 net/netfilter/xt_TCPOPTSTRIP.c                     |   16 +-
 net/netfilter/xt_TPROXY.c                          |  102 ++++++
 net/netfilter/xt_TRACE.c                           |   30 +--
 net/netfilter/xt_comment.c                         |   31 +--
 net/netfilter/xt_connbytes.c                       |   56 +--
 net/netfilter/xt_connlimit.c                       |   80 ++---
 net/netfilter/xt_connmark.c                        |   68 +---
 net/netfilter/xt_conntrack.c                       |   62 ++---
 net/netfilter/xt_dccp.c                            |   27 +-
 net/netfilter/xt_dscp.c                            |   51 +--
 net/netfilter/xt_esp.c                             |   25 +-
 net/netfilter/xt_hashlimit.c                       |  104 +++----
 net/netfilter/xt_helper.c                          |   54 +--
 net/netfilter/xt_iprange.c                         |   27 +-
 net/netfilter/xt_length.c                          |   18 +-
 net/netfilter/xt_limit.c                           |   54 +--
 net/netfilter/xt_mac.c                             |   41 +--
 net/netfilter/xt_mark.c                            |   46 +---
 net/netfilter/xt_multiport.c                       |   71 ++---
 net/netfilter/xt_owner.c                           |   51 +---
 net/netfilter/xt_physdev.c                         |   49 +--
 net/netfilter/xt_pkttype.c                         |   37 +--
 net/netfilter/xt_policy.c                          |   34 +--
 net/netfilter/xt_quota.c                           |   43 +--
 net/netfilter/xt_rateest.c                         |   58 +---
 net/netfilter/xt_realm.c                           |    9 +-
 .../ipt_recent.c => netfilter/xt_recent.c}         |  348 +++++++++++++++-----
 net/netfilter/xt_sctp.c                            |   27 +-
 net/netfilter/xt_socket.c                          |  185 +++++++++++
 net/netfilter/xt_state.c                           |   24 +-
 net/netfilter/xt_statistic.c                       |   45 +--
 net/netfilter/xt_string.c                          |   53 +---
 net/netfilter/xt_tcpmss.c                          |   17 +-
 net/netfilter/xt_tcpudp.c                          |   64 ++---
 net/netfilter/xt_time.c                            |   41 +--
 net/netfilter/xt_u32.c                             |   33 +--
 net/sched/act_ipt.c                                |   46 ++--
 174 files changed, 4281 insertions(+), 3901 deletions(-)
 create mode 100644 Documentation/networking/tproxy.txt
 create mode 100644 include/linux/netfilter/xt_TPROXY.h
 create mode 100644 include/linux/netfilter/xt_recent.h
 create mode 100644 include/net/netfilter/ipv4/nf_defrag_ipv4.h
 create mode 100644 include/net/netfilter/nf_tproxy_core.h
 create mode 100644 include/net/netns/conntrack.h
 create mode 100644 net/ipv4/netfilter/nf_defrag_ipv4.c
 create mode 100644 net/netfilter/nf_tproxy_core.c
 create mode 100644 net/netfilter/xt_TPROXY.c
 rename net/{ipv4/netfilter/ipt_recent.c => netfilter/xt_recent.c} (51%)
 create mode 100644 net/netfilter/xt_socket.c

Alexey Dobriyan (38):
      netfilter: netns: remove nf_*_net() wrappers
      netfilter: netns: ip6table_raw in netns for real
      netfilter: netns: ip6table_mangle in netns for real
      netfilter: netns: ip6t_REJECT in netns for real
      netfilter: netns nf_conntrack: add netns boilerplate
      netfilter: netns nf_conntrack: add ->ct_net -- pointer from conntrack to netns
      netfilter: netns nf_conntrack: per-netns conntrack count
      netfilter: netns nf_conntrack: per-netns conntrack hash
      netfilter: netns: fix {ip,6}_route_me_harder() in netns
      netfilter: netns nf_conntrack: per-netns expectations
      netfilter: netns nf_conntrack: per-netns unconfirmed list
      netfilter: netns nf_conntrack: pass netns pointer to nf_conntrack_in()
      netfilter: netns nf_conntrack: pass netns pointer to L4 protocol's ->error hook
      netfilter: netns nf_conntrack: per-netns /proc/net/nf_conntrack, /proc/net/stat/nf_conntrack
      netfilter: netns nf_conntrack: per-netns /proc/net/nf_conntrack_expect
      netfilter: netns nf_conntrack: per-netns /proc/net/ip_conntrack, /proc/net/stat/ip_conntrack, /proc/net/ip_conntrack_expect
      netns: export netns list
      netfilter: netns nf_conntrack: unregister helper in every netns
      netfilter: netns nf_conntrack: cleanup after L3 and L4 proto unregister in every netns
      netfilter: netns nf_conntrack: pass conntrack to nf_conntrack_event_cache() not skb
      netfilter: netns nf_conntrack: per-netns event cache
      netfilter: netns nf_conntrack: per-netns statistics
      netfilter: netns nf_conntrack: per-netns /proc/net/stat/nf_conntrack, /proc/net/stat/ip_conntrack
      netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_count sysctl
      netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_checksum sysctl
      netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_log_invalid sysctl
      netfilter: netns nf_conntrack: per-netns conntrack accounting
      netfilter: netns nf_conntrack: final netns tweaks
      netfilter: netns nf_conntrack: SIP conntracking in netns
      netfilter: netns nf_conntrack: H323 conntracking in netns
      netfilter: netns nf_conntrack: GRE conntracking in netns
      netfilter: netns nf_conntrack: PPTP conntracking in netns
      netfilter: netns nat: fix ipt_MASQUERADE in netns
      netfilter: netns nat: per-netns NAT table
      netfilter: netns nat: per-netns bysource hash
      netfilter: netns nf_conntrack: fixup DNAT in netns
      netfilter: netns nat: PPTP NAT in netns
      netfilter: enable netfilter in netns

Jan Engelhardt (36):
      netfilter: Use unsigned types for hooknum and pf vars
      netfilter: rename ipt_recent to xt_recent
      netfilter: xt_recent: IPv6 support
      netfilter: Introduce NFPROTO_* constants
      netfilter: x_tables: use NFPROTO_* in extensions
      netfilter: implement NFPROTO_UNSPEC as a wildcard for extensions
      netfilter: ebtables: do centralized size checking
      netfilter: change return types of check functions for Ebtables extensions
      netfilter: change return types of match functions for ebtables extensions
      netfilter: Change return types of targets/watchers for Ebtables extensions
      netfilter: add dummy members to Ebtables code to ease transition to Xtables
      netfilter: ebt_among: obtain match size through different means
      netfilter: change Ebtables function signatures to match Xtables's
      netfilter: move Ebtables to use Xtables
      netfilter: x_tables: output bad hook mask in hexadecimal
      netfilter: ebtables: use generic table checking
      netfilter: implement hotdrop for Ebtables
      netfilter: remove unused Ebtables functions
      netfilter: remove redundant casts from Ebtables
      netfilter: ebtables: fix one wrong return value
      netfilter: xtables: do centralized checkentry call (1/2)
      netfilter: ip6tables: fix name of hopbyhop in Kconfig
      netfilter: ip6tables: fix Kconfig entry dependency for ip6t_LOG
      netfilter: ebtables: make BRIDGE_NF_EBTABLES a menuconfig option
      netfilter: xtables: sort extensions alphabetically in Kconfig
      netfilter: xtables: use "if" blocks in Kconfig
      netfilter: xtables: move extension arguments into compound structure (1/6)
      netfilter: xtables: move extension arguments into compound structure (2/6)
      netfilter: xtables: move extension arguments into compound structure (3/6)
      netfilter: xtables: move extension arguments into compound structure (4/6)
      netfilter: xtables: move extension arguments into compound structure (5/6)
      netfilter: xtables: move extension arguments into compound structure (6/6)
      netfilter: xtables: provide invoked family value to extensions
      netfilter: xtables: cut down on static data for family-independent extensions
      netfilter: xtables: use NFPROTO_UNSPEC in more extensions
      netfilter: xtables: remove bogus mangle table dependency of connmark

KOVACS Krisztian (5):
      netfilter: split netfilter IPv4 defragmentation into a separate module
      netfilter: iptables tproxy core
      netfilter: iptables socket match
      netfilter: iptables TPROXY target
      netfilter: Add documentation for tproxy
