From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/06]: Netfilter Update
Date: Mon, 26 Jun 2006 17:43:07 +0200 (MEST)
Message-ID: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
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

following is a small netfilter update. Nothing exciting, just minor fixes and
a missing helptext. Please apply, thanks.


 net/ipv4/netfilter/arp_tables.c         |    3 ++-
 net/ipv4/netfilter/ip_queue.c           |   12 ++++++++++--
 net/ipv4/netfilter/ip_tables.c          |    3 ++-
 net/ipv6/netfilter/ip6_tables.c         |    3 ++-
 net/netfilter/Kconfig                   |    5 ++++-
 net/netfilter/nf_conntrack_netlink.c    |    1 +
 net/netfilter/nf_conntrack_proto_sctp.c |    2 ++
 net/netfilter/nfnetlink_queue.c         |   12 ++++++++++--
 net/netfilter/xt_sctp.c                 |    2 +-
 net/netfilter/xt_tcpudp.c               |    2 +-
 10 files changed, 35 insertions(+), 10 deletions(-)

Jorge Matias:
      [NETFILTER]: xt_sctp: fix --chunk-types matching

Patrick McHardy:
      [NETFILTER]: x_tables: fix xt_register_table error propagation
      [NETFILTER]: ip_queue/nfnetlink_queue: drop bridge port references when dev disappears
      [NETFILTER]: statistic match: add missing Kconfig help text

Yasuyuki Kozakai:
      [NETFILTER]: nf_conntrack: Fix undefined references to local_bh_*

Yuri Gushin:
      [NETFILTER]: xt_tcpudp: fix double unregistration in error path
