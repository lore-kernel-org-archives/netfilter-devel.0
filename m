From: Horms <horms@verge.net.au>
Subject: [patch 1/3] add type parameter to ip_route_me_harder
Date: Tue, 19 Sep 2006 11:45:08 +0900
Message-ID: <20060919025203.458282000@tabatha.lab.ultramonkey.org>
References: <20060919024507.458115000@tabatha.lab.ultramonkey.org>
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
	David Black <dave@jamsoft.com>, Joseph Mack NA3T <jmack@wm7d.net>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=ip_route_me_harder-type.patch
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

By adding a type parameter to ip_route_me_harder() the
expensive call to inet_addr_type() can be avoided in some cases.
A followup patch where ip_route_me_harder() is called from within
ip_vs_out() is one such example.

Signed-Off-By: Simon Horman <horms@verge.net.au>

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
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index f88347d..1d8ae67 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -7,8 +7,14 @@ #include <net/route.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 
+/*
+ * addr_type: 0 - determine automatically
+ *            1 - local
+ *            2 - non-local
+ */
+
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
-int ip_route_me_harder(struct sk_buff **pskb)
+int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct rtable *rt;
@@ -16,10 +22,15 @@ int ip_route_me_harder(struct sk_buff **
 	struct dst_entry *odst;
 	unsigned int hh_len;
 
+	if (addr_type > 2)
+		return -1;
+
 	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
 	 * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
 	 */
-	if (inet_addr_type(iph->saddr) == RTN_LOCAL) {
+	if (addr_type == 0)
+		addr_type = inet_addr_type(iph->saddr) == RTN_LOCAL ? 1 : 2;
+	if (addr_type == 1) {
 		fl.nl_u.ip4_u.daddr = iph->daddr;
 		fl.nl_u.ip4_u.saddr = iph->saddr;
 		fl.nl_u.ip4_u.tos = RT_TOS(iph->tos);
@@ -156,7 +167,7 @@ static int nf_ip_reroute(struct sk_buff 
 		if (!(iph->tos == rt_info->tos
 		      && iph->daddr == rt_info->daddr
 		      && iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(pskb);
+			return ip_route_me_harder(pskb, 0);
 	}
 	return 0;
 }
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index f3b7783..d2e9578 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -269,7 +269,7 @@ #ifdef CONFIG_XFRM
 		       ct->tuplehash[!dir].tuple.src.u.all
 #endif
 		    )
-			return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+			return ip_route_me_harder(pskb, 0) == 0 ? ret : NF_DROP;
 	}
 	return ret;
 }
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 79336cb..24ce30c 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -157,7 +157,7 @@ #ifdef CONFIG_IP_ROUTE_FWMARK
 		|| (*pskb)->nfmark != nfmark
 #endif
 		|| (*pskb)->nh.iph->tos != tos))
-		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+		return ip_route_me_harder(pskb, 0) == 0 ? ret : NF_DROP;
 
 	return ret;
 }

--

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
