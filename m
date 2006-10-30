From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: Netfilter fixes
Date: Mon, 30 Oct 2006 19:18:56 +0100 (MET)
Message-ID: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
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

the following patches contain a few important iptables fixes from the OpenVZ
guys, a fix for a nf_conntrack regression from the listhelp.h removal and
a small Kconfig update. I'll pass the important ones on to -stable once
I've caught up with all the previous fixes.

Please apply, thanks.


 net/ipv4/netfilter/arp_tables.c   |   25 +++++++++-----
 net/ipv4/netfilter/ip_tables.c    |   67 +++++++++++++++++++-------------------
 net/ipv6/netfilter/Kconfig        |    2 -
 net/ipv6/netfilter/ip6_tables.c   |   24 +++++++++----
 net/netfilter/nf_conntrack_core.c |    3 +
 5 files changed, 69 insertions(+), 52 deletions(-)

Dmitry Mishin:
      [NETFILTER]: Missed and reordered checks in {arp,ip,ip6}_tables
      [NETFILTER]: ip_tables: compat code module refcounting fix

Martin Josefsson:
      [NETFILTER]: nf_conntrack: add missing unlock in get_next_corpse()

Peter Bieringer:
      [NETFILTER]: remove masq/NAT from ip6tables Kconfig help

Vasily Averin:
      [NETFILTER]: ip_tables: compat error way cleanup
