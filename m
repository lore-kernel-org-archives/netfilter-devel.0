From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/64]: Netfilter update
Date: Tue, 18 Dec 2007 00:46:12 +0100 (MET)
Message-ID: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38878 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXLQXqO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a rather large netfilter update for 2.6.25. The diffstat
looks a bit worse than it is, most files are only touched due to
__read_mostly and const annotations. The rough overview is:

- Some type consitency improvements for ip_tables compat support,
  doesn't actual change or fix anything, but the current code is
  rather inconsistent and only works for ip_tables, not the other
  copy-and-paste ports.

- Compat support for ip6_tables and arp_tables

- Resyncing of ip_tables, ip6_tables and arp_tables, not entirely
  completed yet, but I'll do that on top since its getting more
  and more complicated to do in proper order with this huge stack
  of patches.

- More const and __read_mostly annotations

- NAT API change to stop using hook numbers to indicate mapping types,
  which is a relict from before rusty-nat

- Conversion of multiple files to typeful netlink attribute helpers

- nfnetlink_log resyncing with the nfnetlink_queue changes (which are
  in most parts copies of each other). Also not completely done yet,
  will be completed on top.

- Eric's hashlimit optimizations

- Similar optimizations for the other non-power-of-two netfilter hashes

- ctnetlink updates from Pablo, adding better support for helpers, SCTP
  and secmark

- Some cleanups by Jan, mainly converting multiple IPv4/IPv6 address
  types to a single unified one

- Finally, the CONFIG_NETFILTER_ADVANCED patch. Its more intrusive than
  I hoped and the choices weren't really clear, so Its last in the
  series. Please have a look whether you think its useful like this,
  otherwise feel free to drop it.

Please apply, thanks.


 include/linux/netfilter.h                      |   85 +--
 include/linux/netfilter/nf_conntrack_common.h  |    8 +
 include/linux/netfilter/nf_conntrack_h323.h    |    6 +-
 include/linux/netfilter/nfnetlink_conntrack.h  |   11 +
 include/linux/netfilter/nfnetlink_log.h        |    1 +
 include/linux/netfilter/x_tables.h             |   51 +-
 include/linux/netfilter/xt_connlimit.h         |    9 +-
 include/linux/netfilter_arp/arp_tables.h       |   50 +-
 include/linux/netfilter_ipv4/ip_tables.h       |   76 +--
 include/linux/netfilter_ipv6/ip6_tables.h      |   73 +-
 include/net/netfilter/nf_conntrack_expect.h    |    4 +-
 include/net/netfilter/nf_conntrack_tuple.h     |   17 +-
 include/net/netfilter/nf_log.h                 |   59 ++
 include/net/netfilter/nf_nat.h                 |    2 +-
 include/net/netfilter/nf_nat_protocol.h        |   18 +-
 include/net/netlink.h                          |   12 +
 net/Kconfig                                    |   12 +
 net/bridge/netfilter/Kconfig                   |    2 +-
 net/bridge/netfilter/ebt_log.c                 |    3 +-
 net/bridge/netfilter/ebt_ulog.c                |    3 +-
 net/compat.c                                   |  106 ---
 net/decnet/netfilter/Kconfig                   |    1 +
 net/ipv4/netfilter.c                           |    2 +-
 net/ipv4/netfilter/Kconfig                     |   26 +-
 net/ipv4/netfilter/arp_tables.c                |  984 +++++++++++++++++----
 net/ipv4/netfilter/ip_tables.c                 |  386 ++++-----
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    4 +-
 net/ipv4/netfilter/ipt_LOG.c                   |    3 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c                |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c              |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   19 +-
 net/ipv4/netfilter/nf_nat_core.c               |   58 +-
 net/ipv4/netfilter/nf_nat_h323.c               |   26 +-
 net/ipv4/netfilter/nf_nat_helper.c             |    9 +-
 net/ipv4/netfilter/nf_nat_pptp.c               |    6 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c          |    3 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |    2 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |    2 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c          |    2 +-
 net/ipv4/netfilter/nf_nat_proto_unknown.c      |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c               |    8 +-
 net/ipv4/netfilter/nf_nat_sip.c                |    6 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    2 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    6 +-
 net/ipv6/netfilter.c                           |    2 +-
 net/ipv6/netfilter/Kconfig                     |   23 +-
 net/ipv6/netfilter/ip6_tables.c                | 1157 +++++++++++++++++++-----
 net/ipv6/netfilter/ip6t_LOG.c                  |    3 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   19 +-
 net/netfilter/Kconfig                          |   71 ++-
 net/netfilter/core.c                           |    6 +-
 net/netfilter/nf_conntrack_core.c              |   12 +-
 net/netfilter/nf_conntrack_expect.c            |   12 +-
 net/netfilter/nf_conntrack_ftp.c               |    2 +-
 net/netfilter/nf_conntrack_h323_asn1.c         |    8 +-
 net/netfilter/nf_conntrack_h323_main.c         |   36 +-
 net/netfilter/nf_conntrack_netlink.c           |  254 +++++-
 net/netfilter/nf_conntrack_proto_sctp.c        |   18 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |   23 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    1 +
 net/netfilter/nf_conntrack_proto_udplite.c     |    1 +
 net/netfilter/nf_conntrack_sip.c               |    8 +-
 net/netfilter/nf_log.c                         |   12 +-
 net/netfilter/nf_queue.c                       |    4 +-
 net/netfilter/nfnetlink_log.c                  |  203 ++---
 net/netfilter/nfnetlink_queue.c                |   23 +-
 net/netfilter/x_tables.c                       |   63 ++-
 net/netfilter/xt_CONNMARK.c                    |    7 +-
 net/netfilter/xt_CONNSECMARK.c                 |    7 +-
 net/netfilter/xt_MARK.c                        |   55 +-
 net/netfilter/xt_NFLOG.c                       |    1 +
 net/netfilter/xt_TCPMSS.c                      |    7 +-
 net/netfilter/xt_connbytes.c                   |    2 +-
 net/netfilter/xt_connlimit.c                   |   25 +-
 net/netfilter/xt_connmark.c                    |    7 +-
 net/netfilter/xt_conntrack.c                   |    5 +-
 net/netfilter/xt_hashlimit.c                   |   31 +-
 net/netfilter/xt_helper.c                      |    2 +-
 net/netfilter/xt_limit.c                       |    5 +
 net/netfilter/xt_mark.c                        |    5 +
 net/netfilter/xt_policy.c                      |    2 +-
 net/netfilter/xt_state.c                       |    2 +-
 net/netfilter/xt_string.c                      |    2 +-
 86 files changed, 2995 insertions(+), 1313 deletions(-)
 create mode 100644 include/net/netfilter/nf_log.h

Benjamin LaHaise (1):
      [NETFILTER]: xt_TCPMSS: don't allow netfilter --setmss to increase mss

Eric Dumazet (2):
      [NETFILTER]: xt_hashlimit: speedup hash_dst()
      [NETFILTER]: xt_hashlimit: reduce overhead without IPv6

Jan Engelhardt (4):
      [NETFILTER]: x_tables: use %u format specifiers
      [NETFILTER]: Introduce nf_inet_address
      [NETFILTER]: Parenthesize macro parameters
      [NETFILTER]: xt_connlimit: use the new union nf_inet_addr

Pablo Neira Ayuso (4):
      [NETFILTER]: ctnetlink: add support for NAT sequence adjustments
      [NETFILTER]: ctnetlink: add support for master tuple event notification and dumping
      [NETFILTER]: ctnetlink: add support for secmark
      [NETFILTER]: nf_conntrack_sctp: add ctnetlink support

Patrick McHardy (53):
      [NETFILTER]: ip_tables: kill useless wrapper
      [NETFILTER]: ip_tables: reformat compat code
      [NETFILTER]: x_tables: make xt_compat_match_from_user usable in iterator macros
      [NETFILTER]: {ip,ip6,arp}_tables: consolidate iterator macros
      [NETFILTER]: ip_tables: account for struct ipt_entry/struct compat_ipt_entry size diff
      [NETFILTER]: ip_tables: fix compat types
      [NETFILTER]: ip_tables: move compat offset calculation to x_tables
      [NETFILTER]: ip6_tables: kill a few useless defines/forward declarations
      [NETFILTER]: ip6_tables: move entry, match and target checks to seperate functions
      [NETFILTER]: ip6_tables: use vmalloc_node()
      [NETFILTER]: ip6_tables: move counter allocation to seperate function
      [NETFILTER]: ip6_tables: move IP6T_SO_GET_INFO handling to seperate function
      [NETFILTER]: ip6_tables: resync get_entries() with ip_tables
      [NETFILTER]: ip6_tables: add compat support
      [NETFILTER]: x_tables: enable compat translation for IPv6 matches/targets
      [NETFILTER]: xt_MARK: support revision 1 for IPv6
      [NETFILTER]: xt_MARK: add compat support for revision 0
      [NETFILTER]: {ip,ip6}_tables: reformat to eliminate differences
      [NETFILTER]: {ip,ip6}_tables: fix format strings
      [NETFILTER]: ip6_tables: fix stack leagage
      [NETFILTER]: ip6_tables: use raw_smp_processor_id() in do_add_counters()
      [NETFILTER]: ip_tables: remove ipchains compatibility hack
      [NETFILTER]: ip6_tables: use XT_ALIGN
      [NETFILTER]: arp_tables: remove obsolete standard_check function
      [NETFILTER]: arp_tables: use XT_ALIGN
      [NETFILTER]: arp_tables: use vmalloc_node()
      [NETFILTER]: arp_tables: remove ipchains compat hack
      [NETFILTER]: arp_tables: move entry and target checks to seperate functions
      [NETFILTER]: arp_tables: move counter allocation to seperate function
      [NETFILTER]: arp_tables: move ARPT_SO_GET_INFO handling to seperate function
      [NETFILTER]: arp_tables: resync get_entries() with ip_tables
      [NETFILTER]: arp_tables: add compat support
      [NETLINK]: Add NLA_PUT_BE16/nla_get_be16()
      [NETFILTER]: ctnetlink: use netlink attribute helpers
      [NETFILTER]: ctnetlink: fix expectation timeout dumping
      [NETFILTER]: nf_nat_proto_gre: add missing module reference
      [NETFILTER]: nf_nat: mark NAT protocols const
      [NETFILTER]: nf_nat: sprinkle a few __read_mostlys
      [NETFILTER]: nf_nat: pass manip type instead of hook to nf_nat_setup_info
      [NETFILTER]: nf_log: move logging stuff to seperate header
      [NETFILTER]: nf_log: constify struct nf_logger and nf_log_packet loginfo arg
      [NETFILTER]: nf_log: remove incomprehensible comment
      [NETFILTER]: nfnetlink_log: fix checks in nfulnl_recv_config
      [NETFILTER]: nfnetlink_{queue,log}: return ENOTSUPP for unknown cfg commands
      [NETFILTER]: nfnetlink_log: remove excessive debugging
      [NETFILTER]: nfnetlink_{queue,log}: return proper error codes in instance_create
      [NETFILTER]: nfnetlink_log: use endianness-aware attribute functions
      [NETFILTER]: nfnetlink_log: include GID in netlink message
      [NETFILTER]: Kill function prototype for non-existing function
      [NETFILTER]: constify nf_afinfo
      [NETFILTER]: nf_nat: properly use RCU for ip_nat_decode_session
      [NETFILTER]: non-power-of-two jhash optimizations
      [NETFILTER]: Add CONFIG_NETFILTER_ADVANCED option
