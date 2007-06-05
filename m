From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Tue,  5 Jun 2007 15:35:08 +0200 (MEST)
Message-ID: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
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

these patches fix improper textsearch_prepare return value checks in the amanda
conntrack helper, the iptables compat crash reported by Jan Engelhardt and some
connection tracking helper unload races.

Please apply, thanks.


 include/linux/netfilter_ipv4/ip_tables.h       |   17 +++++
 net/ipv4/netfilter/ip_tables.c                 |   81 +++++++++++++++++++------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   13 ++--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    9 ++
 net/netfilter/nf_conntrack_amanda.c            |   12 +--
 net/netfilter/nf_conntrack_core.c              |   26 +++++---
 net/netfilter/nf_conntrack_expect.c            |    4 +
 net/netfilter/nf_conntrack_helper.c            |    2 
 net/netfilter/nf_conntrack_netlink.c           |   34 +++++++---
 net/netfilter/nf_conntrack_proto_gre.c         |    2 
 10 files changed, 147 insertions(+), 53 deletions(-)

Akinobu Mita (1):
      [NETFILTER]: nf_conntrack_amanda: fix textsearch_prepare() error check

Dmitry Mishin (1):
      [NETFILTER]: ip_tables: fix compat related crash

Patrick McHardy (1):
      [NETFILTER]: nf_conntrack: fix helper module unload races
