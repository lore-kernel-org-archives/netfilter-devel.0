From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/38]: Netfilter update
Date: Tue, 15 Jan 2008 07:19:12 +0100 (MET)
Message-ID: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62157 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYAOGTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is another netfilter update. The diffstat contains mostly
noise from a MODULE_DESCRIPTION update, the main changes are:

- removal of EXPERIMENTAL dependencies for all but a few selected modules

- Updates from Jan for multiple matches and targets to use fixed types,
  scheduling of the old version for removal in 2009

- IPv6 support for a few more matches and targets

- SCTP conntrack cleanup

- REJECT target conversion to construct TCP RSTs from scratch to properly
  deal with IP options

- Minor cleanups and optimizations

Please apply, thanks.


 Documentation/feature-removal-schedule.txt         |   32 ++
 include/linux/netfilter.h                          |    4 +
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/nf_conntrack_sctp.h        |    1 -
 include/linux/netfilter/xt_CONNMARK.h              |    5 +
 include/linux/netfilter/xt_MARK.h                  |    4 +
 include/linux/netfilter/xt_RATEEST.h               |    2 +
 include/linux/netfilter/xt_connlimit.h             |    2 +-
 include/linux/netfilter/xt_connmark.h              |    5 +
 include/linux/netfilter/xt_conntrack.h             |   16 +-
 include/linux/netfilter/xt_hashlimit.h             |    2 +-
 include/linux/netfilter/xt_iprange.h               |   17 +
 include/linux/netfilter/xt_mark.h                  |    5 +
 include/linux/netfilter/xt_policy.h                |   23 ++-
 include/linux/netfilter/xt_quota.h                 |    2 +
 include/linux/netfilter/xt_rateest.h               |    2 +
 include/linux/netfilter/xt_statistic.h             |    1 +
 include/linux/netfilter/xt_string.h                |    2 +
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h       |    1 +
 include/linux/netfilter_ipv4/ipt_iprange.h         |    6 +-
 include/net/netfilter/nf_conntrack.h               |    7 -
 include/net/netfilter/nf_conntrack_core.h          |   12 -
 include/net/netfilter/nf_conntrack_helper.h        |    4 +
 include/net/netfilter/nf_conntrack_l3proto.h       |    3 -
 net/ipv4/netfilter.c                               |   10 +
 net/ipv4/netfilter/Kconfig                         |   14 +-
 net/ipv4/netfilter/Makefile                        |    1 -
 net/ipv4/netfilter/ip_tables.c                     |   47 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    2 +-
 net/ipv4/netfilter/ipt_ECN.c                       |    2 +-
 net/ipv4/netfilter/ipt_LOG.c                       |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c                    |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c                  |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |  104 +++----
 net/ipv4/netfilter/ipt_TOS.c                       |   82 -----
 net/ipv4/netfilter/ipt_TTL.c                       |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c                  |    2 +-
 net/ipv4/netfilter/ipt_ah.c                        |    2 +-
 net/ipv4/netfilter/ipt_ecn.c                       |    2 +-
 net/ipv4/netfilter/ipt_iprange.c                   |   77 -----
 net/ipv4/netfilter/ipt_recent.c                    |    2 +-
 net/ipv4/netfilter/ipt_ttl.c                       |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    7 -
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    5 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |    8 -
 net/ipv6/netfilter/Kconfig                         |   12 +-
 net/ipv6/netfilter/ip6_tables.c                    |   42 ++--
 net/ipv6/netfilter/ip6t_HL.c                       |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/ipv6/netfilter/ip6t_ah.c                       |    2 +-
 net/ipv6/netfilter/ip6t_eui64.c                    |    2 +-
 net/ipv6/netfilter/ip6t_frag.c                     |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c                      |    2 +-
 net/ipv6/netfilter/ip6t_hl.c                       |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c               |    2 +-
 net/ipv6/netfilter/ip6t_mh.c                       |    2 +-
 net/ipv6/netfilter/ip6t_rt.c                       |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    7 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |    8 -
 net/netfilter/Kconfig                              |   37 ++-
 net/netfilter/Makefile                             |    2 +-
 net/netfilter/core.c                               |    9 +
 net/netfilter/nf_conntrack_core.c                  |    5 +-
 net/netfilter/nf_conntrack_l3proto_generic.c       |    7 -
 net/netfilter/nf_conntrack_proto_generic.c         |    8 -
 net/netfilter/nf_conntrack_proto_sctp.c            |  310 ++++++++++----------
 net/netfilter/nf_conntrack_proto_tcp.c             |   69 ++---
 net/netfilter/nf_conntrack_proto_udp.c             |    9 -
 net/netfilter/nf_conntrack_proto_udplite.c         |    9 -
 net/netfilter/nf_conntrack_standalone.c            |    5 +-
 net/netfilter/nf_sysctl.c                          |   25 --
 net/netfilter/xt_CLASSIFY.c                        |    2 +-
 net/netfilter/xt_CONNMARK.c                        |  119 ++++++--
 net/netfilter/xt_CONNSECMARK.c                     |    2 +-
 net/netfilter/xt_DSCP.c                            |    8 +-
 net/netfilter/xt_MARK.c                            |   76 ++++--
 net/netfilter/xt_NFLOG.c                           |    2 +-
 net/netfilter/xt_NFQUEUE.c                         |    2 +-
 net/netfilter/xt_NOTRACK.c                         |    1 +
 net/netfilter/xt_RATEEST.c                         |    2 +-
 net/netfilter/xt_SECMARK.c                         |    2 +-
 net/netfilter/xt_TCPMSS.c                          |    2 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |    2 +-
 net/netfilter/xt_TRACE.c                           |    1 +
 net/netfilter/xt_comment.c                         |    2 +-
 net/netfilter/xt_connbytes.c                       |    2 +-
 net/netfilter/xt_connlimit.c                       |    2 +-
 net/netfilter/xt_connmark.c                        |   90 +++++--
 net/netfilter/xt_conntrack.c                       |  209 ++++++++++++--
 net/netfilter/xt_dccp.c                            |    2 +-
 net/netfilter/xt_dscp.c                            |    2 +-
 net/netfilter/xt_esp.c                             |    2 +-
 net/netfilter/xt_hashlimit.c                       |    2 +-
 net/netfilter/xt_helper.c                          |    2 +-
 net/netfilter/xt_iprange.c                         |  180 ++++++++++++
 net/netfilter/xt_length.c                          |    2 +-
 net/netfilter/xt_limit.c                           |    2 +-
 net/netfilter/xt_mac.c                             |    2 +-
 net/netfilter/xt_mark.c                            |   74 ++++--
 net/netfilter/xt_multiport.c                       |    2 +-
 net/netfilter/xt_owner.c                           |    2 +-
 net/netfilter/xt_physdev.c                         |    2 +-
 net/netfilter/xt_pkttype.c                         |   19 +-
 net/netfilter/xt_policy.c                          |   17 +-
 net/netfilter/xt_quota.c                           |    1 +
 net/netfilter/xt_realm.c                           |    2 +-
 net/netfilter/xt_sctp.c                            |    2 +-
 net/netfilter/xt_statistic.c                       |    2 +-
 net/netfilter/xt_string.c                          |    2 +-
 net/netfilter/xt_tcpmss.c                          |    2 +-
 net/netfilter/xt_tcpudp.c                          |    2 +-
 net/netfilter/xt_time.c                            |    2 +-
 net/netfilter/xt_u32.c                             |    2 +-
 116 files changed, 1168 insertions(+), 813 deletions(-)
 create mode 100644 include/linux/netfilter/xt_iprange.h
 delete mode 100644 net/ipv4/netfilter/ipt_TOS.c
 delete mode 100644 net/ipv4/netfilter/ipt_iprange.c
 delete mode 100644 net/netfilter/nf_sysctl.c
 create mode 100644 net/netfilter/xt_iprange.c

Denys Vlasenko (1):
      [NETFILTER]: {ip,ip6}_tables: remove some inlines

Jan Engelhardt (17):
      [NETFILTER]: remove ipt_TOS.c
      [NETFILTER]: xt_TOS: Change semantic of mask value
      [NETFILTER]: xt_TOS: Properly set the TOS field
      [NETFILTER]: Annotate start of kernel fields in NF headers
      [NETFILTER]: xt_CONNMARK target, revision 1
      [NETFILTER]: xt_MARK target, revision 2
      [NETFILTER]: xt_connmark match, revision 1
      [NETFILTER]: Extend nf_inet_addr with in{,6}_addr
      [NETFILTER]: xt_conntrack match, revision 1
      [NETFILTER]: xt_mark match, revision 1
      [NETFILTER]: xt_pkttype: Add explicit check for IPv4
      [NETFILTER]: xt_pkttype: IPv6 multicast address recognition
      [NETFILTER]: xt_policy: use the new union nf_inet_addr
      [NETFILTER]: Update modules' descriptions
      [NETFILTER]: Rename ipt_iprange to xt_iprange
      [NETFILTER]: xt_iprange match, revision 1
      [NETFILTER]: Update feature-removal-schedule.txt

Patrick McHardy (20):
      [NETFILTER]: Hide a few more options under NETFILTER_ADVANCED
      [NETFILTER]: Remove some EXPERIMENTAL dependencies
      [NETFILTER]: ipt_REJECT: properly handle IP options
      [NETFILTER]: nf_conntrack_{tcp,sctp}: mark state table const
      [NETFILTER]: nf_conntrack_{tcp,sctp}: shrink state table
      [NETFILTER]: nf_conntrack_tcp: remove timeout indirection
      [NETFILTER]: nf_conntrack_sctp: basic cleanups
      [NETFILTER]: nf_conntrack_sctp: use proper types for bitops
      [NETFILTER]: nf_conntrack_sctp: reduce line length
      [NETFILTER]: nf_conntrack_sctp: reduce line length further
      [NETFILTER]: nf_conntrack_sctp: consolidate sctp_packet() error paths
      [NETFILTER]: nf_conntrack_sctp: rename "newconntrack" variable
      [NETFILTER]: nf_conntrack_sctp: don't take sctp_lock once per chunk
      [NETFILTER]: nf_conntrack_sctp: remove unused ttag field from conntrack data
      [NETFILTER]: nf_conntrack_sctp: replace magic value by symbolic constant
      [NETFILTER]: nf_conntrack_sctp: remove timeout indirection
      [NETFILTER]: kill nf_sysctl.c
      [NETFILTER]: nf_conntrack: clean up a few header files
      [NETFILTER]: nf_conntrack: remove print_conntrack function from l3protos
      [NETFILTER]: nf_conntrack: make print_conntrack function optional for l4protos
