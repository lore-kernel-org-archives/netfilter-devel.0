From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/10]: Netfilter fixes
Date: Sun,  4 Mar 2007 21:19:58 +0100 (MET)
Message-ID: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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

following are a number of netfilter fixes for 2.6.21, fixing an
endless loop during module unload with conntrack events enabled,
multiple problems with nfnetlink_log, incorrect ctnetlink config
ifdefs in nf_conntrack and nf_nat and missing mark initialization
in ip6_route_me_harder. Most of them should also go in -stable,
I'll send backports soon.

Please apply, thanks.


 include/linux/netfilter_ipv4/ip_conntrack_core.h |    2 -
 include/net/netfilter/nf_conntrack_core.h        |    2 -
 net/ipv4/netfilter/ip_conntrack_core.c           |    2 -
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c      |    4 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c   |    6 +----
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c     |    6 +----
 net/ipv4/netfilter/nf_nat_core.c                 |    3 --
 net/ipv4/netfilter/nf_nat_proto_gre.c            |    3 --
 net/ipv4/netfilter/nf_nat_proto_icmp.c           |    3 --
 net/ipv4/netfilter/nf_nat_proto_tcp.c            |    3 --
 net/ipv4/netfilter/nf_nat_proto_udp.c            |    3 --
 net/ipv6/netfilter.c                             |    1 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c   |    6 +----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c   |    6 +----
 net/netfilter/nf_conntrack_core.c                |    5 +---
 net/netfilter/nf_conntrack_proto_gre.c           |    3 --
 net/netfilter/nf_conntrack_proto_tcp.c           |   13 +++++------
 net/netfilter/nf_conntrack_proto_udp.c           |    6 +----
 net/netfilter/nfnetlink_log.c                    |   26 +++++++++++++++--------
 19 files changed, 48 insertions(+), 55 deletions(-)

Michal Miroslaw:
      [NETFILTER]: nfnetlink_log: fix reference leak
      [NETFILTER]: nfnetlink_log: fix use after free
      [NETFILTER]: nfnetlink_log: fix NULL pointer dereference
      [NETFILTER]: nfnetlink_log: fix possible NULL pointer dereference
      [NETFILTER]: nfnetlink_log: fix reference counting

Patrick McHardy:
      [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
      [NETFILTER]: nf_conntrack/nf_nat: fix incorrect config ifdefs
      [NETFILTER]: tcp conntrack: accept SYN|URG as valid
      [NETFILTER]: nfnetlink_log: fix module reference counting

Yasuyuki Kozakai:
      [NETFILTER]: ip6_route_me_harder should take into account mark
