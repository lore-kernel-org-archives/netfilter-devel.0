From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] various fixes for MIRROR target
Date: Wed, 16 Apr 2003 02:31:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9CA467.7060607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060707090300050108060808"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060707090300050108060808
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes a few of bugs in the mirror target.
It's quite intrusive so i'll explain why each change was made.

route_mirror:
- similar changes like those for reject target, before it only
  worked in LOCAL_IN chain and leaked memory in case
  of asym. routing.
ip_rewrite:
- inline
ipt_mirror_target:
- move ttl checks before ip_rewrite, otherwise icmp_send() gets
  already mangled ip header.
- copy_expand skb like in reject target, for asym. routing and
  tcpdump

I've verified it works in INPUT and FORWARD chain now.

Patrick

--------------060707090300050108060808
Content-Type: text/plain;
 name="ipt_MIRROR-fixes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_MIRROR-fixes.diff"

diff -Nru a/net/ipv4/netfilter/ipt_MIRROR.c b/net/ipv4/netfilter/ipt_MIRROR.c
--- a/net/ipv4/netfilter/ipt_MIRROR.c	Wed Apr 16 02:15:13 2003
+++ b/net/ipv4/netfilter/ipt_MIRROR.c	Wed Apr 16 02:15:13 2003
@@ -9,6 +9,8 @@
   Changes:
 	25 Aug 2001 Harald Welte <laforge@gnumonks.org>
 		- decrement and check TTL if not called from FORWARD hook
+	15 Apr 2003 Patrick McHardy <kaber@trash.net>
+		- routing and other fixes
 
   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
@@ -32,7 +34,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netdevice.h>
 #include <linux/route.h>
-struct in_device;
 #include <net/route.h>
 
 #if 0
@@ -41,31 +42,37 @@
 #define DEBUGP(format, args...)
 #endif
 
-static int route_mirror(struct sk_buff *skb)
+/* get route in reverse direction */
+static struct rtable *route_mirror(struct sk_buff *skb, int local)
 {
         struct iphdr *iph = skb->nh.iph;
+	struct dst_entry *odst;
 	struct rtable *rt;
 
-	/* Backwards */
-	if (ip_route_output(&rt, iph->saddr, iph->daddr,
-			    RT_TOS(iph->tos) | RTO_CONN,
-			    0)) {
-		return 0;
+	if (local) {
+		if (ip_route_output(&rt, iph->saddr, iph->daddr,
+		                    RT_TOS(iph->tos), 0) != 0)
+			return NULL;
+	} else {
+		/* get interface where daddr may have entered (rp-filter) */
+		if (ip_route_output(&rt, iph->daddr, 0, 0, 0) != 0)
+			return NULL;
+		/* get route */
+		odst = skb->dst;
+		if (ip_route_input(skb, iph->saddr, iph->daddr,
+		                   RT_TOS(iph->tos), rt->u.dst.dev) != 0) {
+			dst_release(&rt->u.dst);
+			return NULL;
+		}
+		dst_release(&rt->u.dst);
+		rt = (struct rtable *)skb->dst;
+		skb->dst = odst;
 	}
 
-	/* check if the interface we are leaving by is the same as the
-           one we arrived on */
-	if (skb->dev == rt->u.dst.dev) {
-		/* Drop old route. */
-		dst_release(skb->dst);
-		skb->dst = &rt->u.dst;
-		return 1;
-	}
-	return 0;
+	return rt;
 }
 
-static void
-ip_rewrite(struct sk_buff *skb)
+static inline void ip_rewrite(struct sk_buff *skb)
 {
 	struct iphdr *iph = skb->nh.iph;
 	u32 odaddr = iph->saddr;
@@ -105,32 +112,49 @@
 				      const void *targinfo,
 				      void *userinfo)
 {
-	if (((*pskb)->dst != NULL) &&
-	    route_mirror(*pskb)) {
-
-		ip_rewrite(*pskb);
+	struct iphdr *iph = (*pskb)->nh.iph;
+	struct sk_buff *nskb;
+	struct rtable *rt;
+	unsigned int hh_len;
 
-		/* If we are not at FORWARD hook (INPUT/PREROUTING),
-		 * the TTL isn't decreased by the IP stack */
-		if (hooknum != NF_IP_FORWARD) {
-			struct iphdr *iph = (*pskb)->nh.iph;
-			if (iph->ttl <= 1) {
-				/* this will traverse normal stack, and 
-				 * thus call conntrack on the icmp packet */
-				icmp_send(*pskb, ICMP_TIME_EXCEEDED, 
-					  ICMP_EXC_TTL, 0);
-				return NF_DROP;
-			}
-			ip_decrease_ttl(iph);
+	/* If we are not at FORWARD hook (INPUT/PREROUTING),
+	 * the TTL isn't decreased by the IP stack */
+	if (hooknum != NF_IP_FORWARD) {
+		if (iph->ttl <= 1) {
+			/* this will traverse normal stack, and 
+			 * thus call conntrack on the icmp packet */
+			icmp_send(*pskb, ICMP_TIME_EXCEEDED, 
+				  ICMP_EXC_TTL, 0);
+			return NF_DROP;
 		}
+		ip_decrease_ttl(iph);
+	}
 
-		/* Don't let conntrack code see this packet:
-                   it will think we are starting a new
-                   connection! --RR */
-		ip_direct_send(*pskb);
+	if ((rt = route_mirror(*pskb, hooknum == NF_IP_LOCAL_IN)) == NULL)
+		return NF_DROP;
 
-		return NF_STOLEN;
+	hh_len = (rt->u.dst.dev->hard_header_len + 15) & ~15;
+
+	/* Copy skb (even if skb is about to be dropped, we can't just
+	 * clone it because there may be other things, such as tcpdump,
+	 * interested in it). We also need to expand headroom in case
+	 * hh_len of incoming interface < hh_len of outgoing interface */
+	nskb = skb_copy_expand(*pskb, hh_len, skb_tailroom(*pskb), GFP_ATOMIC);
+	if (nskb == NULL) {
+		dst_release(&rt->u.dst);
+		return NF_DROP;
 	}
+
+	dst_release(nskb->dst);
+	nskb->dst = &rt->u.dst;
+
+	ip_rewrite(nskb);
+
+	/* Don't let conntrack code see this packet:
+           it will think we are starting a new
+           connection! --RR */
+	ip_direct_send(nskb);
+
 	return NF_DROP;
 }
 

--------------060707090300050108060808--
