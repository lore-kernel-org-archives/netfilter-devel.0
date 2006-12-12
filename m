From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/06]: Netfilter fixes
Date: Tue, 12 Dec 2006 09:06:18 +0100 (MET)
Message-ID: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
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

following are a few netfilter fixes (mostly conntrack related), a patch to unify
the iptables compat and non-compat verification code and Al Viro's iptables loop
check optimization with similar changes to ip6_tables and arp_tables.

Please apply or pull from http://people.netfilter.org/~kaber/nf-2.6.git/, thanks.


 include/net/netfilter/nf_conntrack_compat.h |   10 +
 net/ipv4/netfilter/Kconfig                  |    2 
 net/ipv4/netfilter/arp_tables.c             |    5 
 net/ipv4/netfilter/ip_tables.c              |  181 ++++++++++++----------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |    8 +
 net/ipv6/netfilter/ip6_tables.c             |    5 
 net/netfilter/Kconfig                       |    2 
 net/netfilter/xt_CONNMARK.c                 |   14 ++
 net/netfilter/xt_CONNSECMARK.c              |   14 ++
 net/netfilter/xt_connbytes.c                |   14 ++
 net/netfilter/xt_connmark.c                 |    7 -
 net/netfilter/xt_conntrack.c                |    8 -
 net/netfilter/xt_helper.c                   |    8 -
 net/netfilter/xt_state.c                    |    7 -
 14 files changed, 154 insertions(+), 131 deletions(-)

Al Viro:
      [NETFILTER]: {ip,ip6,arp}_tables: fix exponential worst-case search for loops

Dmitry Mishin:
      [NETFILTER]: ip_tables: ipt and ipt_compat checks unification

Patrick McHardy:
      [NETFILTER]: Fix INET=n linking error

Yasuyuki Kozakai:
      [NETFILTER]: nf_nat: fix NF_NAT dependency
      [NETFILTER]: x_tables: error if ip_conntrack is asked to handle IPv6 packets
      [NETFILTER]: x_tables: add missing try to load conntrack from match/targets
