From: Horms <horms@verge.net.au>
Subject: [patch 1/3] add type parameter to ip_route_me_harder
Date: Thu, 21 Sep 2006 18:22:42 +0900
Message-ID: <20060921093021.317073000@tabatha.lab.ultramonkey.org>
References: <20060921092241.441882000@tabatha.lab.ultramonkey.org>
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
	David Black <dave@jamsoft.com>, Joseph Mack NA3T <jmack@wm7d.net>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060921092109.GH17391@verge.net.au>
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

Index: net-2.6.19/include/linux/netfilter_ipv4.h
===================================================================
--- net-2.6.19.orig/include/linux/netfilter_ipv4.h	2006-09-21 17:56:47.000000000 +0900
+++ net-2.6.19/include/linux/netfilter_ipv4.h	2006-09-21 17:56:58.000000000 +0900
@@ -77,7 +77,7 @@
 #define SO_ORIGINAL_DST 80
 
 #ifdef __KERNEL__
-extern int ip_route_me_harder(struct sk_buff **pskb);
+extern int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type);
 extern int ip_xfrm_me_harder(struct sk_buff **pskb);
 extern unsigned int nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 				   unsigned int dataoff, u_int8_t protocol);
Index: net-2.6.19/net/ipv4/netfilter.c
===================================================================
--- net-2.6.19.orig/net/ipv4/netfilter.c	2006-09-21 17:56:47.000000000 +0900
+++ net-2.6.19/net/ipv4/netfilter.c	2006-09-21 18:00:26.000000000 +0900
@@ -8,7 +8,7 @@
 #include <net/ip.h>
 
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
-int ip_route_me_harder(struct sk_buff **pskb)
+int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct rtable *rt;
@@ -16,10 +16,13 @@
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
@@ -156,7 +159,7 @@
 		if (!(iph->tos == rt_info->tos
 		      && iph->daddr == rt_info->daddr
 		      && iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(pskb);
+			return ip_route_me_harder(pskb, RTN_UNSPEC);
 	}
 	return 0;
 }
Index: net-2.6.19/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- net-2.6.19.orig/net/ipv4/netfilter/ip_nat_standalone.c	2006-09-21 17:56:47.000000000 +0900
+++ net-2.6.19/net/ipv4/netfilter/ip_nat_standalone.c	2006-09-21 18:00:45.000000000 +0900
@@ -269,7 +269,8 @@
 		       ct->tuplehash[!dir].tuple.src.u.all
 #endif
 		    )
-			return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+			return ip_route_me_harder(pskb, RTN_UNSPEC) == 0 ?
+				ret : NF_DROP;
 	}
 	return ret;
 }
Index: net-2.6.19/net/ipv4/netfilter/iptable_mangle.c
===================================================================
--- net-2.6.19.orig/net/ipv4/netfilter/iptable_mangle.c	2006-09-21 17:56:47.000000000 +0900
+++ net-2.6.19/net/ipv4/netfilter/iptable_mangle.c	2006-09-21 18:00:58.000000000 +0900
@@ -157,7 +157,8 @@
 		|| (*pskb)->nfmark != nfmark
 #endif
 		|| (*pskb)->nh.iph->tos != tos))
-		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+		return ip_route_me_harder(pskb, RTN_UNSPEC) == 0 ?
+			ret : NF_DROP;
 
 	return ret;
 }

--

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
