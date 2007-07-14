From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/08]: Netfilter Update part II
Date: Sat, 14 Jul 2007 17:12:34 +0200 (MEST)
Message-ID: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
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

following is a second small netfilter update with patches that missed the
first one, containing a new match for limiting the number of connections
by a host, some cleanup by Yasuyuki and UDP-Lite conntrack support. NAT
support is still missing, I'll probably add that in 2.6.24.

Please apply, thanks.


 include/linux/netfilter/xt_connlimit.h         |   17 ++
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 +
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 +-
 include/net/netfilter/nf_conntrack.h           |    4 +
 include/net/netfilter/nf_conntrack_l3proto.h   |    8 +-
 net/bridge/netfilter/ebtables.c                |    4 +-
 net/ipv4/netfilter/arp_tables.c                |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   25 ++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   57 +----
 net/ipv6/netfilter/ip6_tables.c                |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   31 ++-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   46 +---
 net/netfilter/Kconfig                          |   17 ++
 net/netfilter/Makefile                         |    2 +
 net/netfilter/nf_conntrack_core.c              |   37 +++-
 net/netfilter/nf_conntrack_l3proto_generic.c   |    9 +-
 net/netfilter/nf_conntrack_proto_generic.c     |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    4 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    4 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    4 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |  266 ++++++++++++++++++++
 net/netfilter/xt_connlimit.c                   |  313 ++++++++++++++++++++++++
 23 files changed, 730 insertions(+), 130 deletions(-)
 create mode 100644 include/linux/netfilter/xt_connlimit.h
 create mode 100644 net/netfilter/nf_conntrack_proto_udplite.c
 create mode 100644 net/netfilter/xt_connlimit.c

Jan Engelhardt (1):
      [NETFILTER]: x_tables: add connlimit match

Patrick McHardy (3):
      [NETFILTER]: Lower *tables printk severity
      [NETFILTER]: nf_conntrack: mark protocols __read_mostly
      [NETFILTER]: nf_conntrack: UDPLITE support

Yasuyuki Kozakai (4):
      [NETFILTER]: nf_conntrack: Increment error count on parsing IPv4 header
      [NETFILTER]: nf_conntrack: make l3proto->prepare() generic and renames it
      [NETFILTER]: nf_conntrack: Introduces nf_ct_get_tuplepr and uses it
      [NETFILTER]: nf_conntrack: Don't track locally generated special ICMP error
