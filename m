From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: Netfilter fixes
Date: Mon,  4 Dec 2006 11:55:56 +0100 (MET)
Message-ID: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
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

following are a few netfilter fixes. The iptables hook validation fixes
are quite critical, so I'm going to send them to -stable along with Bart's
fix.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_pptp.h |    3 
 net/bridge/br_netfilter.c                   |   36 +++++-
 net/ipv4/netfilter/arp_tables.c             |   48 ++++-----
 net/ipv4/netfilter/ip_tables.c              |  146 ++++++++++++++--------------
 net/ipv6/netfilter/ip6_tables.c             |   59 ++++-------
 net/netfilter/nf_conntrack_expect.c         |   27 ++---
 6 files changed, 168 insertions(+), 151 deletions(-)

Bart De Schuymer:
      [NETFILTER]: bridge netfilter: deal with martians correctly

Dmitry Mishin:
      [NETFILTER]: Fix {ip,ip6,arp}_tables hook validation
      [NETFILTER]: Fix iptables compat hook validation

Yasuyuki Kozakai:
      [NETFILTER]: nf_conntrack: fix warning in PPTP helper
      [NETFILTER]: nf_conntrack: Don't try to find clashed expectation
