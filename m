From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Mon, 10 Sep 2007 00:20:38 +0200 (MEST)
Message-ID: <20070909221736.25157.46398.sendpatchset@localhost.localdomain>
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

these patches fix an incorrect warning message in IPv4 connection tracking
and the module unload deadlock notices by Neil Horman.

Please apply, thanks.


 include/linux/netfilter.h                      |    5 +--
 net/bridge/netfilter/ebtables.c                |    1 +
 net/ipv4/ipvs/ip_vs_ctl.c                      |    1 +
 net/ipv4/netfilter/arp_tables.c                |    1 +
 net/ipv4/netfilter/ip_tables.c                 |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   11 ++----
 net/ipv6/netfilter/ip6_tables.c                |    1 +
 net/netfilter/nf_sockopt.c                     |   36 +++++++----------------
 8 files changed, 22 insertions(+), 35 deletions(-)

Neil Horman (1):
      [NETFILTER]: Fix/improve deadlock condition on module removal netfilter

Patrick McHardy (1):
      [NETFILTER]: nf_conntrack_ipv4: fix "Frag of proto ..." messages
