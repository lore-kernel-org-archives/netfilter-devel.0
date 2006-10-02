From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/05]: Honour source routing for LVS-NAT
Date: Mon,  2 Oct 2006 17:46:07 +0200 (MEST)
Message-ID: <20061002154720.13121.79607.sendpatchset@localhost.localdomain>
References: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Honour source routing for LVS-NAT

For policy routing, packets originating from this machine itself may be
routed differently to packets passing through. We want this packet to be
routed as if it came from this machine itself. So re-compute the routing
information using ip_route_me_harder().

This patch is derived from work by Ken Brownfield

Cc: Ken Brownfield <krb@irridia.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1bc8aeeaf12d73774421e408d7f6461a20cebc5e
tree 273fb8d8604554aecf263bef82a43f781a019333
parent fa2cba7f2f3ce89d34fdb903f7d80494439e6b59
author Simon Horman <horms@verge.net.au> Mon, 02 Oct 2006 17:39:45 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Oct 2006 17:39:45 +0200

 net/ipv4/ipvs/ip_vs_core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index 6dee039..1445bb4 100644
--- a/net/ipv4/ipvs/ip_vs_core.c
+++ b/net/ipv4/ipvs/ip_vs_core.c
@@ -813,6 +813,16 @@ ip_vs_out(unsigned int hooknum, struct s
 	skb->nh.iph->saddr = cp->vaddr;
 	ip_send_check(skb->nh.iph);
 
+ 	/* For policy routing, packets originating from this
+ 	 * machine itself may be routed differently to packets
+ 	 * passing through.  We want this packet to be routed as
+ 	 * if it came from this machine itself.  So re-compute
+ 	 * the routing information.
+ 	 */
+ 	if (ip_route_me_harder(pskb, RTN_LOCAL) != 0)
+ 		goto drop;
+	skb = *pskb;
+
 	IP_VS_DBG_PKT(10, pp, skb, 0, "After SNAT");
 
 	ip_vs_out_stats(cp, skb);
