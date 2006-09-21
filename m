From: Horms <horms@verge.net.au>
Subject: [patch 2/3] Honour source routing for LVS-NAT
Date: Thu, 21 Sep 2006 18:22:43 +0900
Message-ID: <20060921093021.418727000@tabatha.lab.ultramonkey.org>
References: <20060921092241.441882000@tabatha.lab.ultramonkey.org>
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
	David Black <dave@jamsoft.com>, Joseph Mack NA3T <jmack@wm7d.net>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060921092109.GH17391@verge.net.au>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=ip_route_me_harder-ipvs.patch
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

For policy routing, packets originating from this machine itself may be
routed differently to packets passing through. We want this packet to be
routed as if it came from this machine itself. So re-compute the routing
information using ip_route_me_harder().

This patch is derived from work by Ken Brownfield

Cc: Ken Brownfield <krb@irridia.com>
Signed-Off-By: Simon Horman <horms@verge.net.au>

Index: net-2.6.19/net/ipv4/ipvs/ip_vs_core.c
===================================================================
--- net-2.6.19.orig/net/ipv4/ipvs/ip_vs_core.c	2006-09-21 17:56:30.000000000 +0900
+++ net-2.6.19/net/ipv4/ipvs/ip_vs_core.c	2006-09-21 18:27:34.000000000 +0900
@@ -813,6 +813,16 @@
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

--

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
