From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/08]: Honour source routing for LVS-NAT
Date: Fri, 17 Nov 2006 06:35:48 +0100 (MET)
Message-ID: <20061117053548.10231.71519.sendpatchset@localhost.localdomain>
References: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
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

This patch (-stable version) also includes commit
b4c4ed175ff0ee816df48571cfa9b73f521964b6 ([NETFILTER]: add type parameter
to ip_route_me_harder), which is a precondition for the fix.

Cc: Ken Brownfield <krb@irridia.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit cf08e74a590c945d3c0b95886ea3fad8ff73793d
tree d5c1a44360bb9a4a2d59e37a9f0dc3c6ce0b6c49
parent 6b22b99ecd431b63aece1fa5b1faa01b75a8302e
author Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:25:11 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:25:11 +0100

 include/linux/netfilter_ipv4.h         |    2 +-
 net/ipv4/ipvs/ip_vs_core.c             |   10 ++++++++++
 net/ipv4/netfilter.c                   |    9 ++++++---
 net/ipv4/netfilter/ip_nat_standalone.c |    3 ++-
 net/ipv4/netfilter/iptable_mangle.c    |    3 ++-
 5 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index ce02c98..5b63a23 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -77,7 +77,7 @@ enum nf_ip_hook_priorities {
 #define SO_ORIGINAL_DST 80
 
 #ifdef __KERNEL__
-extern int ip_route_me_harder(struct sk_buff **pskb);
+extern int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type);
 extern int ip_xfrm_me_harder(struct sk_buff **pskb);
 extern unsigned int nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 				   unsigned int dataoff, u_int8_t protocol);
diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index 3f47ad8..f594635 100644
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
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 6a9e34b..327ba37 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -8,7 +8,7 @@ #include <net/xfrm.h>
 #include <net/ip.h>
 
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
-int ip_route_me_harder(struct sk_buff **pskb)
+int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct rtable *rt;
@@ -16,10 +16,13 @@ int ip_route_me_harder(struct sk_buff **
 	struct dst_entry *odst;
 	unsigned int hh_len;
 
+	if (addr_type == RTN_UNSPEC)
+		addr_type = inet_addr_type(iph->saddr);
+
 	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
 	 * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
 	 */
-	if (inet_addr_type(iph->saddr) == RTN_LOCAL) {
+	if (addr_type == RTN_LOCAL) {
 		fl.nl_u.ip4_u.daddr = iph->daddr;
 		fl.nl_u.ip4_u.saddr = iph->saddr;
 		fl.nl_u.ip4_u.tos = RT_TOS(iph->tos);
@@ -156,7 +159,7 @@ static int nf_ip_reroute(struct sk_buff 
 		if (!(iph->tos == rt_info->tos
 		      && iph->daddr == rt_info->daddr
 		      && iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(pskb);
+			return ip_route_me_harder(pskb, RTN_UNSPEC);
 	}
 	return 0;
 }
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 6db485f..c508544 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -275,7 +275,8 @@ #ifdef CONFIG_XFRM
 		       ct->tuplehash[!dir].tuple.src.u.all
 #endif
 		    )
-			return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+			if (ip_route_me_harder(pskb, RTN_UNSPEC))
+				ret = NF_DROP;
 	}
 	return ret;
 }
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 4e7998b..f7b8906 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -157,7 +157,8 @@ #ifdef CONFIG_IP_ROUTE_FWMARK
 		|| (*pskb)->nfmark != nfmark
 #endif
 		|| (*pskb)->nh.iph->tos != tos))
-		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+		if (ip_route_me_harder(pskb, RTN_UNSPEC))
+			ret = NF_DROP;
 
 	return ret;
 }
