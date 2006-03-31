From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter Update
Date: Fri, 31 Mar 2006 03:09:05 +0200 (MEST)
Message-ID: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
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

following are my netfilter patches for 2.6.17. The "fix expectation
notifier unregistration" should go in -stable too, I'll send it
there separately. Please apply.


 include/linux/netfilter/x_tables.h            |   67 +
 include/linux/netfilter/xt_multiport.h        |   30 
 include/linux/netfilter_ipv4/ip_tables.h      |   18 
 include/linux/netfilter_ipv4/ipt_multiport.h  |   31 
 include/linux/netfilter_ipv6/ip6t_multiport.h |   25 
 net/compat.c                                  |    3 
 net/ipv4/netfilter/Kconfig                    |   10 
 net/ipv4/netfilter/Makefile                   |    1 
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    2 
 net/ipv4/netfilter/ip_tables.c                | 1286 +++++++++++++++++++++-----
 net/ipv4/netfilter/ipt_multiport.c            |  195 ---
 net/ipv6/netfilter/Kconfig                    |   10 
 net/ipv6/netfilter/Makefile                   |    1 
 net/ipv6/netfilter/ip6t_multiport.c           |  125 --
 net/netfilter/Kconfig                         |   10 
 net/netfilter/Makefile                        |    1 
 net/netfilter/nf_conntrack_netlink.c          |    6 
 net/netfilter/x_tables.c                      |  113 ++
 net/netfilter/xt_multiport.c                  |  314 ++++++
 19 files changed, 1656 insertions(+), 592 deletions(-)

Dmitry Mishin:
      [NETFILTER]: iptables 32bit compat layer

Martin Josefsson:
      [NETFILTER]: fix ifdef for connmark support in nf_conntrack_netlink
      [NETFILTER]: {ip,nf}_conntrack_netlink: fix expectation notifier unregistration

Yasuyuki Kozakai:
      [NETFILTER]: x_tables: unify IPv4/IPv6 multiport match
