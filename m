From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] fix various things in ipt_MIRROR
Date: Tue, 22 Apr 2003 12:54:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA51F72.7030402@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030904090209060908080908"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------030904090209060908080908
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes a couple of things in the MIRROR target:

- check ttl before rewriting so icmp_send gets clean packet
- skb_copy_expand skb, for tcpdump and asym. routing
- inline some functions
- remove unecessary "struct in_device" declaration/RTO_CONN

Best regards,
Patrick


--------------030904090209060908080908
Content-Type: text/plain;
 name="02-mirror-fixes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-mirror-fixes.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1102  -> 1.1103 
#	net/ipv4/netfilter/ipt_MIRROR.c	1.3     -> 1.4    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/21	kaber@trash.net	1.1103
# - check ttl before rewriting so icmp_send gets clean packet
# - skb_copy_expand skb, for tcpdump and asym. routing
# - inline some functions
# - remove unecessary "struct in_device" declaration
# - remove RTO_CONN
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_MIRROR.c b/net/ipv4/netfilter/ipt_MIRROR.c
--- a/net/ipv4/netfilter/ipt_MIRROR.c	Mon Apr 21 21:26:42 2003
+++ b/net/ipv4/netfilter/ipt_MIRROR.c	Mon Apr 21 21:26:42 2003
@@ -32,7 +32,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netdevice.h>
 #include <linux/route.h>
-struct in_device;
 #include <net/route.h>
 
 #if 0
@@ -41,31 +40,20 @@
 #define DEBUGP(format, args...)
 #endif
 
-static int route_mirror(struct sk_buff *skb)
+static inline struct rtable *route_mirror(struct sk_buff *skb)
 {
         struct iphdr *iph = skb->nh.iph;
 	struct rtable *rt;
 
 	/* Backwards */
 	if (ip_route_output(&rt, iph->saddr, iph->daddr,
-			    RT_TOS(iph->tos) | RTO_CONN,
-			    0)) {
-		return 0;
-	}
+			    RT_TOS(iph->tos), 0))
+		return NULL;
 
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
@@ -105,32 +93,48 @@
 				      const void *targinfo,
 				      void *userinfo)
 {
-	if (((*pskb)->dst != NULL) &&
-	    route_mirror(*pskb)) {
-
-		ip_rewrite(*pskb);
+	struct rtable *rt;
+	struct sk_buff *nskb;
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
+		struct iphdr *iph = (*pskb)->nh.iph;
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
+	if ((rt = route_mirror(*pskb)) == NULL)
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
+	/* Don't let conntrack code see this packet:
+           it will think we are starting a new
+           connection! --RR */
+	ip_direct_send(nskb);
+
 	return NF_DROP;
 }
 

--------------030904090209060908080908--
