From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/13]: Netfilter -stable fixes
Date: Wed,  7 Mar 2007 22:34:26 +0100 (MET)
Message-ID: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
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

Hi,

following are a number of important netfilter fixes for -stable,
fixing (in order of importance):

- IPv6 connection tracking misclassification of fragments

- endless loops during unload of ip_conntrack/nf_conntrack with
  conntrack events enabled

- Lots of bugs (NULL pointer dereferences, reference counting, ..) in
  nfnetlink_log

- IPv6 policy routing by fwmark in the OUTPUT chain

- incorrect config #ifdefs used in the nf_conntrack code

Please apply, thanks.


 include/linux/netfilter_ipv4/ip_conntrack_core.h |    2 -
 include/net/netfilter/nf_conntrack_core.h        |    2 -
 net/ipv4/netfilter/ip_conntrack_core.c           |    2 -
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c      |    4 ++-
 net/ipv4/netfilter/nf_nat_core.c                 |    3 --
 net/ipv4/netfilter/nf_nat_proto_gre.c            |    3 --
 net/ipv4/netfilter/nf_nat_proto_icmp.c           |    3 --
 net/ipv4/netfilter/nf_nat_proto_tcp.c            |    3 --
 net/ipv4/netfilter/nf_nat_proto_udp.c            |    3 --
 net/ipv6/netfilter.c                             |    1 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c   |    1 
 net/netfilter/nf_conntrack_core.c                |    2 -
 net/netfilter/nf_conntrack_proto_gre.c           |    3 --
 net/netfilter/nf_conntrack_proto_tcp.c           |    4 ++-
 net/netfilter/nfnetlink_log.c                    |   30 ++++++++++++++---------
 15 files changed, 37 insertions(+), 29 deletions(-)

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
      [NETFILTER]: nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED
      [NETFILTER]: nfnetlink_log: zero-terminate prefix
      [NETFILTER]: nfnetlink_log: fix crash on bridged packet

Yasuyuki Kozakai:
      [NETFILTER]: ip6_route_me_harder should take into account mark
