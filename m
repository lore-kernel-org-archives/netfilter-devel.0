From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ipt_ROUTE fix for 2.6 kernels [was: IPROUTE compilation
	problem]
Date: Fri, 14 May 2004 09:38:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084520305.1841.16.camel@descartes.info.ucl.ac.be>
References: <87ad0cj9tq.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-G69FDMYGQfsJU0k/AqIt"
Cc: "Daniel 'NebuchadnezzaR' Dehennin" <nebuchadnezzar@nerim.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <87ad0cj9tq.fsf@thorr.asgardr.info>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-G69FDMYGQfsJU0k/AqIt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id i4E7bO1m020485

Le jeu 13/05/2004 =E0 23:28, Daniel 'NebuchadnezzaR' Dehennin a =E9crit :
> The IPROUTE patch failed to build (latest CVS + 2.6.6):

Yes, I know. The ROUTE target is not yet converted to kernel 2.6 series.
Here is a patch that updates it.
Changes include :
 - conversion from struct rt_key to struct flowi
 - checksum fix from Rickard Molin

Please apply ;)

Thanks,

Cedric



--=-G69FDMYGQfsJU0k/AqIt
Content-Disposition: attachment; filename=ipt_ROUTE-kernel2.6.patch
Content-Type: text/x-patch; name=ipt_ROUTE-kernel2.6.patch; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

--- patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c.orig	2004-05-05 18:57:43.000000000 +0200
+++ patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-05-14 09:22:45.000000000 +0200
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
  *
- * v 1.8 2003/07/25
+ * v 1.9 2004/05/14
  *
  * This software is distributed under GNU GPL v2, 1991
  */
@@ -19,6 +19,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/icmp.h>
+#include <net/checksum.h>
 
 #if 0
 #define DEBUGP printk
@@ -28,6 +29,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Cedric de Launois <delaunois@info.ucl.ac.be>");
+MODULE_DESCRIPTION("iptables ROUTE target module");
 
 /* Try to route the packet according to the routing keys specified in
  * route_info. Keys are :
@@ -53,19 +55,24 @@
 	int err;
 	struct rtable *rt;
 	struct iphdr *iph = skb->nh.iph;
-	struct rt_key key = { 
-		dst:iph->daddr,
-		src:0,
-		oif:ifindex, 
-		tos:RT_TOS(iph->tos) 
+	struct flowi fl = {
+		.oif = ifindex,
+		.nl_u = {
+			.ip4_u = {
+				.daddr = iph->daddr,
+				.saddr = 0,
+				.tos = RT_TOS(iph->tos),
+				.scope = RT_SCOPE_UNIVERSE,
+			}
+		} 
 	};
 	
 	/* The destination address may be overloaded by the target */
 	if (route_info->gw)
-		key.dst = route_info->gw;
+		fl.fld_dst = route_info->gw;
 	
 	/* Trying to route the packet using the standard routing table. */
-	if ((err = ip_route_output_key(&rt, &key))) {
+	if ((err = ip_route_output_key(&rt, &fl))) {
 		if (net_ratelimit()) 
 			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
 		return -1;
@@ -217,7 +224,7 @@
 	skb->dev = dev_in;
 	dst_release(skb->dst);
 	skb->dst = NULL;
-		
+
 	netif_rx(skb);
 	dev_put(dev_in);
 	return NF_STOLEN;
@@ -258,10 +265,21 @@
 
 		if (iph->ttl <= 1) {
 			struct rtable *rt;
+			struct flowi fl = {
+				.oif = 0,
+				.nl_u = {
+					.ip4_u = {
+						.daddr = iph->daddr,
+						.saddr = iph->saddr,
+						.tos = RT_TOS(iph->tos),
+						.scope = ((iph->tos & RTO_ONLINK) ?
+							  RT_SCOPE_LINK :
+							  RT_SCOPE_UNIVERSE)
+					}
+				} 
+			};
 
-			if (ip_route_output(&rt, iph->saddr, iph->daddr,
-					    RT_TOS(iph->tos) | RTO_CONN,
-					    0)) {
+			if (ip_route_output_key(&rt, &fl)) {
 				return NF_DROP;
 			}
 
@@ -279,7 +297,17 @@
 			return NF_DROP;
 		}
 
-		ip_decrease_ttl(iph);
+		/*
+		 * If we are at INPUT the checksum must be recalculated since
+		 * the length could change as the result of a defragmentation.
+		 */
+		if(hooknum == NF_IP_LOCAL_IN) {
+			iph->ttl = iph->ttl - 1;
+			iph->check = 0;
+			iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
+		} else {
+			ip_decrease_ttl(iph);
+		}
 	}
 
 	/* Tell conntrack to forget this packet since it may get confused 

--=-G69FDMYGQfsJU0k/AqIt--
