From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/08]: Netfilter -stable fixes
Date: Fri, 17 Nov 2006 06:35:40 +0100 (MET)
Message-ID: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
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

Following are backports of a few important netfilter fixes for -stable,
fixing multiple bugs in the ip_tables compat layer, missing checks
during ip_tables ruleset validation and a crash on arp_tables module
unload/reload. Also included are two patches fixing incorrect Kconfig
dependencies and a LVS NAT source routing fix.

Please apply, thanks.


 include/linux/netfilter_ipv4.h         |    2 
 net/ipv4/ipvs/ip_vs_core.c             |   10 ++++
 net/ipv4/netfilter.c                   |    9 ++--
 net/ipv4/netfilter/arp_tables.c        |   27 ++++++++----
 net/ipv4/netfilter/ip_nat_standalone.c |    3 -
 net/ipv4/netfilter/ip_tables.c         |   70 +++++++++++++++++++++------------
 net/ipv4/netfilter/iptable_mangle.c    |    3 -
 net/ipv6/netfilter/ip6_tables.c        |   24 +++++++----
 net/netfilter/Kconfig                  |    6 +-
 9 files changed, 104 insertions(+), 50 deletions(-)

Patrick McHardy:
      [NETFILTER]: ip_tables: missing check for CAP_NET_ADMIN in compat layer
      [NETFILTER]: ip_tables: compat error way cleanup
      [NETFILTER]: ip_tables: fix module refcount leaks in compat error paths
      [NETFILTER]: Missed and reordered checks in {arp,ip,ip6}_tables
      [NETFILTER]: arp_tables: missing unregistration on module unload
      [NETFILTER]: Honour source routing for LVS-NAT
      [NETFILTER]: Kconfig: fix xt_physdev dependencies
      [NETFILTER]: xt_CONNSECMARK: fix Kconfig dependencies
