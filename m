From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/15]: Netfilter patches for 2.6.21
Date: Wed,  7 Feb 2007 09:22:29 +0100 (MET)
Message-ID: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

following is a first batch of my netfilter patches for 2.6.21.
Besides some cleanup, the highlights are:

- New SANE connection tracking helper
- New ip6tables Mobility Header match
- x_tables TCPMSS target port with IPv6 support
- Automatic liberal TCP connection tracking for picked up connections
- Optional source port randomization for SNAT

Once again the diffstat is quite huge, but mainly because of some harmless
cleanup of x_tables wrappers, touching almost all iptables related files.

Please apply, thanks.


 include/linux/netfilter/Kbuild              |    1 
 include/linux/netfilter/nf_conntrack_sane.h |   21 +
 include/linux/netfilter/nf_conntrack_tcp.h  |    4 
 include/linux/netfilter/xt_TCPMSS.h         |   10 
 include/linux/netfilter_ipv4/ip_nat.h       |    1 
 include/linux/netfilter_ipv4/ip_tables.h    |   24 --
 include/linux/netfilter_ipv4/ipt_TCPMSS.h   |    7 
 include/linux/netfilter_ipv6/ip6_tables.h   |   35 ++-
 include/linux/netfilter_ipv6/ip6t_mh.h      |   15 +
 include/net/netfilter/nf_conntrack.h        |    2 
 include/net/netfilter/nf_nat.h              |    1 
 net/bridge/br_netfilter.c                   |   29 --
 net/bridge/netfilter/ebt_ip.c               |    1 
 net/bridge/netfilter/ebt_log.c              |    1 
 net/ipv4/netfilter/Kconfig                  |   26 --
 net/ipv4/netfilter/Makefile                 |    1 
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |   40 +--
 net/ipv4/netfilter/ip_nat_core.c            |   12 -
 net/ipv4/netfilter/ip_nat_proto_tcp.c       |    5 
 net/ipv4/netfilter/ip_nat_proto_udp.c       |    5 
 net/ipv4/netfilter/ip_nat_rule.c            |   32 +--
 net/ipv4/netfilter/ip_tables.c              |   40 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |   15 -
 net/ipv4/netfilter/ipt_ECN.c                |   13 -
 net/ipv4/netfilter/ipt_LOG.c                |   18 +
 net/ipv4/netfilter/ipt_MASQUERADE.c         |    9 
 net/ipv4/netfilter/ipt_NETMAP.c             |    8 
 net/ipv4/netfilter/ipt_REDIRECT.c           |    8 
 net/ipv4/netfilter/ipt_REJECT.c             |   10 
 net/ipv4/netfilter/ipt_SAME.c               |    8 
 net/ipv4/netfilter/ipt_TCPMSS.c             |  207 -------------------
 net/ipv4/netfilter/ipt_TOS.c                |   11 -
 net/ipv4/netfilter/ipt_TTL.c                |   11 -
 net/ipv4/netfilter/ipt_ULOG.c               |   20 -
 net/ipv4/netfilter/ipt_addrtype.c           |    9 
 net/ipv4/netfilter/ipt_ah.c                 |   10 
 net/ipv4/netfilter/ipt_ecn.c                |   10 
 net/ipv4/netfilter/ipt_iprange.c            |   10 
 net/ipv4/netfilter/ipt_owner.c              |    9 
 net/ipv4/netfilter/ipt_recent.c             |   12 -
 net/ipv4/netfilter/ipt_tos.c                |   10 
 net/ipv4/netfilter/ipt_ttl.c                |   11 -
 net/ipv4/netfilter/iptable_filter.c         |    2 
 net/ipv4/netfilter/iptable_mangle.c         |    2 
 net/ipv4/netfilter/iptable_raw.c            |    2 
 net/ipv4/netfilter/nf_nat_core.c            |   12 -
 net/ipv4/netfilter/nf_nat_proto_tcp.c       |    4 
 net/ipv4/netfilter/nf_nat_proto_udp.c       |    4 
 net/ipv4/netfilter/nf_nat_rule.c            |    8 
 net/ipv4/netfilter/nf_nat_standalone.c      |    6 
 net/ipv6/netfilter/Kconfig                  |    8 
 net/ipv6/netfilter/Makefile                 |    1 
 net/ipv6/netfilter/ip6_tables.c             |   12 -
 net/ipv6/netfilter/ip6t_HL.c                |   17 -
 net/ipv6/netfilter/ip6t_LOG.c               |   17 +
 net/ipv6/netfilter/ip6t_REJECT.c            |   10 
 net/ipv6/netfilter/ip6t_ah.c                |    8 
 net/ipv6/netfilter/ip6t_eui64.c             |    8 
 net/ipv6/netfilter/ip6t_frag.c              |    8 
 net/ipv6/netfilter/ip6t_hbh.c               |    1 
 net/ipv6/netfilter/ip6t_hl.c                |   11 -
 net/ipv6/netfilter/ip6t_ipv6header.c        |    8 
 net/ipv6/netfilter/ip6t_mh.c                |  108 ++++++++++
 net/ipv6/netfilter/ip6t_owner.c             |    8 
 net/ipv6/netfilter/ip6t_rt.c                |    8 
 net/ipv6/netfilter/ip6table_filter.c        |   21 -
 net/ipv6/netfilter/ip6table_mangle.c        |   21 -
 net/ipv6/netfilter/ip6table_raw.c           |   19 -
 net/netfilter/Kconfig                       |   39 +++
 net/netfilter/Makefile                      |    2 
 net/netfilter/nf_conntrack_proto_tcp.c      |   40 +--
 net/netfilter/nf_conntrack_sane.c           |  242 ++++++++++++++++++++++
 net/netfilter/xt_CLASSIFY.c                 |    4 
 net/netfilter/xt_CONNMARK.c                 |    5 
 net/netfilter/xt_CONNSECMARK.c              |    6 
 net/netfilter/xt_MARK.c                     |    8 
 net/netfilter/xt_SECMARK.c                  |    4 
 net/netfilter/xt_TCPMSS.c                   |  296 ++++++++++++++++++++++++++++
 net/netfilter/xt_hashlimit.c                |    1 
 net/sched/act_ipt.c                         |    2 
 net/sched/sch_sfq.c                         |    2 
 81 files changed, 1110 insertions(+), 607 deletions(-)

Eric Leblond:
      [NETFILTER]: NAT: optional source port randomization support

Jan Engelhardt:
      [NETFILTER]: Remove useless comparisons before assignments
      [NETFILTER]: x_tables: fix return values for LOG/ULOG
      [NETFILTER]: {ip,ip6}_tables: remove x_tables wrapper functions
      [NETFILTER]: {ip,ip6}_tables: use struct xt_table instead of redefined structure names

Masahide NAKAMURA:
      [NETFILTER]: ip6_tables: support MH match

Michal Schmidt:
      [NETFILTER]: Add SANE connection tracking helper

Patrick McHardy:
      [NETFILTER]: tcp conntrack: do liberal tracking for picked up connections
      [NETFILTER]: nf_conntrack_tcp: make sysctl variables static
      [NETFILTER]: nf_nat: remove broken HOOKNAME macro
      [NETFILTER]: bridge-netfilter: use nf_register_hooks/nf_unregister_hooks
      [NET]: Add UDPLITE support in a few missing spots
      [NETFILTER]: add IPv6-capable TCPMSS target
      [NETFILTER]: ip_tables: remove declaration of non-existant ipt_find_target function
      [NETFILTER]: ip6_tables: remove redundant structure definitions
