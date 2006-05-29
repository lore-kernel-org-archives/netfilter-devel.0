From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/17]: Netfilter update for 2.6.18
Date: Tue, 30 May 2006 00:34:04 +0200 (MEST)
Message-ID: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
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

following is a large netfilter update for 2.6.18 with changes all
over the place, most noteworthy is the replacement of the recent
match, a new SIP connection tracking helper and two new matches.

Please apply to net-2.6.18, thanks.


 include/linux/netfilter/nf_conntrack_common.h                 |    4 
 include/linux/netfilter/nfnetlink_conntrack.h                 |    4 
 include/linux/netfilter/xt_quota.h                            |   16 
 include/linux/netfilter/xt_statistic.h                        |   32 
 include/linux/netfilter_ipv4/ip_conntrack.h                   |    2 
 include/linux/netfilter_ipv4/ip_conntrack_h323.h              |    7 
 include/linux/netfilter_ipv4/ip_conntrack_helper_h323_types.h |    3 
 include/linux/netfilter_ipv4/ip_conntrack_sip.h               |   44 
 include/linux/sysctl.h                                        |    2 
 include/net/netfilter/nf_conntrack.h                          |    1 
 net/ipv4/netfilter/Kconfig                                    |   28 
 net/ipv4/netfilter/Makefile                                   |    2 
 net/ipv4/netfilter/ip_conntrack_amanda.c                      |  143 -
 net/ipv4/netfilter/ip_conntrack_core.c                        |    6 
 net/ipv4/netfilter/ip_conntrack_ftp.c                         |   77 
 net/ipv4/netfilter/ip_conntrack_helper_h323.c                 |  169 +
 net/ipv4/netfilter/ip_conntrack_helper_h323_types.c           |    6 
 net/ipv4/netfilter/ip_conntrack_netlink.c                     |   85 
 net/ipv4/netfilter/ip_conntrack_proto_gre.c                   |    6 
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c                  |    2 
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c                   |    2 
 net/ipv4/netfilter/ip_conntrack_proto_udp.c                   |    2 
 net/ipv4/netfilter/ip_conntrack_sip.c                         |  471 +++
 net/ipv4/netfilter/ip_conntrack_standalone.c                  |   13 
 net/ipv4/netfilter/ip_nat_helper_h323.c                       |   77 
 net/ipv4/netfilter/ip_nat_sip.c                               |  249 +
 net/ipv4/netfilter/ip_nat_snmp_basic.c                        |    2 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                            |   20 
 net/ipv4/netfilter/ipt_hashlimit.c                            |   66 
 net/ipv4/netfilter/ipt_recent.c                               | 1268 ++--------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                |    2 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                  |    2 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c                |    2 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c                |    2 
 net/netfilter/Kconfig                                         |   16 
 net/netfilter/Makefile                                        |    2 
 net/netfilter/nf_conntrack_core.c                             |    6 
 net/netfilter/nf_conntrack_ftp.c                              |   77 
 net/netfilter/nf_conntrack_netlink.c                          |   85 
 net/netfilter/nf_conntrack_proto_tcp.c                        |    5 
 net/netfilter/nf_conntrack_proto_udp.c                        |    3 
 net/netfilter/nf_conntrack_standalone.c                       |   11 
 net/netfilter/xt_connmark.c                                   |    2 
 net/netfilter/xt_dccp.c                                       |    3 
 net/netfilter/xt_mark.c                                       |    2 
 net/netfilter/xt_multiport.c                                  |    7 
 net/netfilter/xt_quota.c                                      |   96 
 net/netfilter/xt_sctp.c                                       |    4 
 net/netfilter/xt_statistic.c                                  |  112 
 net/netfilter/xt_string.c                                     |    2 
 50 files changed, 2036 insertions(+), 1214 deletions(-)

Alexey Dobriyan:
      [NETFILTER]: PPTP helper: fixup gre_keymap_lookup() return type

Eric Leblond:
      [NETFILTER]: conntrack: add fixed timeout flag in connection tracking

Jing Min Zhao:
      [NETFILTER]: H.323 helper: Add support for Call Forwarding

Patrick McHardy:
      [NETFILTER]: x_tables: remove some unnecessary casts
      [NETFILTER]: x_tables: add SCTP/DCCP support where missing
      [NETFILTER]: x_tables: add quota match
      [NETFILTER]: x_tables: add statistic match
      [NETFILTER]: recent match: replace by rewritten version
      [NETFILTER]: conntrack: don't call helpers for related ICMP messages
      [NETFILTER]: conntrack: add sysctl to disable checksumming
      [NETFILTER]: ctnetlink: fix NAT configuration
      [NETFILTER]: ctnetlink: change table dumping not to require an unique ID
      [NETFILTER]: SNMP helper: fix debug module param type
      [NETFILTER]: FTP helper: search optimization
      [NETFILTER]: amanda helper: convert to textsearch infrastructure
      [NETFILTER]: H.323 helper: replace internal_net_addr parameter by routing-based heuristic
      [NETFILTER]: Add SIP connection tracking helper
