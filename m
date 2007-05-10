From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/09]: Netfilter patches
Date: Thu, 10 May 2007 15:41:09 +0200 (MEST)
Message-ID: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
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

following are a few netfilter patches, containing some cleanup of
nf_conntrack, nf_nat and ip_tables, additionally there are two
fixes to clear the private helper area when reassigning helpers
and compat support for xt_conntrack.

Please apply, thanks.


 include/linux/netfilter/x_tables.h           |    8 +
 include/linux/netfilter_arp/arp_tables.h     |   41 +++++++
 include/linux/netfilter_ipv4/ip_tables.h     |   22 ++++
 include/linux/netfilter_ipv6/ip6_tables.h    |   22 ++++
 include/net/netfilter/nf_conntrack.h         |    7 -
 include/net/netfilter/nf_conntrack_l3proto.h |    3 
 include/net/netfilter/nf_nat_rule.h          |   11 --
 net/ipv4/netfilter/arptable_filter.c         |  140 ++++-----------------------
 net/ipv4/netfilter/iptable_filter.c          |   73 ++++----------
 net/ipv4/netfilter/iptable_mangle.c          |   99 +++++--------------
 net/ipv4/netfilter/iptable_raw.c             |   78 +++++----------
 net/ipv4/netfilter/nf_nat_rule.c             |   86 ++--------------
 net/ipv4/netfilter/nf_nat_standalone.c       |   11 --
 net/ipv6/netfilter/ip6table_filter.c         |   70 ++++---------
 net/ipv6/netfilter/ip6table_mangle.c         |   96 +++++-------------
 net/ipv6/netfilter/ip6table_raw.c            |   52 ----------
 net/netfilter/nf_conntrack_core.c            |   14 +-
 net/netfilter/nf_conntrack_netlink.c         |   40 ++++---
 net/netfilter/xt_conntrack.c                 |   54 ++++++++++
 19 files changed, 354 insertions(+), 573 deletions(-)

Patrick McHardy (4):
      [NETFILTER]: Clean up table initialization
      [NETFILTER]: iptable_{filter,mangle}: more descriptive "happy cracking" message
      [NETFILTER]: iptable_raw: ignore short packets sent by SOCK_RAW sockets
      [NETFILTER]: xt_conntrack: add compat support

Yasuyuki Kozakai (5):
      [NETFILTER]: nf_nat: remove unused argument of function allocating binding
      [NETFILTER]: nf_conntrack: Removes duplicated declarations
      [NETFILTER]: nf_conntrack: Removes unused destroy operation of l3proto
      [NETFILTER]: ctnetlink: clear helper area and handle unchanged helper
      [NETFILTER]: nf_nat: Clears helper private area when NATing
