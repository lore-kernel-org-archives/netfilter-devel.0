From: Patrick Schaaf <bof@bof.de>
Subject: [PATCH] ROUTE --tee target extension
Date: Tue, 23 Nov 2004 09:59:12 +0100
Message-ID: <20041123085911.GB13622@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Cc: delaunois@info.ucl.ac.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello all,

independant of the two ROUTE target patches I sent earlier, here is
something new for all to consider.

The appended patches, made against the SVN repository as of 2004/11/20,
extend the ROUTE target with a new option, called --tee.  This option
is used like --continue (and mutually exclusive with --continue).
When --tee is used, a COPY of the skb is made, and it is this copy
which is routed to the given --gw destination. The original packet
continues to traverse the chains unmodified, it is NOT rerouted.

This extension of the ROUTE target can be used to selectively copy
packets to a sniffer box in an adjacent LAN, without the overhead
of going through userlevel.

I have tested this extension for IPv4 with 2.4.27 and 2.6.10-rc1 kernels.
The IPv6 parts are tested to compile, but not tested to work, as I have
no usable IPv6 setup to test on.

Please review this extension. I would especially like to have comments
on the recursion avoidance approach, which I stole from raw/NOTRACK;
maybe there is a nicer way to do that, which would not depend on
conntrack structure?

best regards
  Patrick

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pom.ROUTE.tee.20041123.patch"

diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/help patch-o-matic-ng/ROUTE/help
--- svn-20041120-patch-o-matic-ng/ROUTE/help	Sat Nov 20 11:28:27 2004
+++ patch-o-matic-ng/ROUTE/help	Tue Nov 23 08:09:45 2004
@@ -13,8 +13,10 @@
   --iif   ifname    Change the packet's incoming interface to `ifname'.
   --gw    ip        Route the packet via this gateway.
   --continue        Route the packet and continue traversing the rules.
+  --tee             Route a copy of the packet, but continue traversing
+                    the rules with the original packet, undisturbed.
 
-  Note that --iif and --continue can't be used together.
+  Note that --iif, --continue, and --tee, are mutually exclusive.
 
   Examples :
 
@@ -32,4 +34,9 @@
   # To change the incoming network interface from eth0 to eth1 for all icmp
   # packets (final target) :
   iptables -A PREROUTING -t mangle -p icmp -i eth0 -j ROUTE --iif eth1
+
+  # To copy (duplicate) all traffic from and to a local ECHO server
+  # to a second box (nonfinal target)
+  iptables -A PREROUTING -t mangle -p tcp --dport 7 -j ROUTE --gw 1.2.3.4 --tee
+  iptables -A POSTROUTING -t mangle -p tcp --sport 7 -j ROUTE --gw 1.2.3.4 --tee
 
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- svn-20041120-patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Sat Nov 20 11:28:24 2004
+++ patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Tue Nov 23 08:10:37 2004
@@ -18,5 +18,6 @@
 
 /* Values for "flags" field */
 #define IPT_ROUTE_CONTINUE        0x01
+#define IPT_ROUTE_TEE             0x02
 
 #endif /*_IPT_ROUTE_H_target*/
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h
--- svn-20041120-patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h	Sat Nov 20 11:28:24 2004
+++ patch-o-matic-ng/ROUTE/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h	Tue Nov 23 08:11:17 2004
@@ -18,5 +18,6 @@
 
 /* Values for "flags" field */
 #define IP6T_ROUTE_CONTINUE        0x01
+#define IP6T_ROUTE_TEE             0x02
 
 #endif /*_IP6T_ROUTE_H_target*/
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c
--- svn-20041120-patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	Sat Nov 20 11:28:24 2004
+++ patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	Tue Nov 23 08:16:28 2004
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
  *
- * v 1.8 2003/07/25
+ * v 1.11 2004/11/23
  *
  * This software is distributed under GNU GPL v2, 1991
  */
@@ -13,6 +13,7 @@
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ipt_ROUTE.h>
 #include <linux/netdevice.h>
 #include <linux/route.h>
@@ -236,6 +237,13 @@
 	return NF_STOLEN;
 }
 
+/* To detect and deter routed packet loopback when using the --tee option,
+ * we take a page out of the raw.patch book: on the copied skb, we set up
+ * a fake ->nfct entry, pointing to the local &route_tee_track. We skip
+ * routing packets when we see they already have that ->nfct.
+ */
+
+static struct ip_conntrack route_tee_track;
 
 static unsigned int ipt_route_target(struct sk_buff **pskb,
 				     unsigned int hooknum,
@@ -246,6 +254,7 @@
 {
 	const struct ipt_route_target_info *route_info = targinfo;
 	struct sk_buff *skb = *pskb;
+	unsigned int res;
 
 	/* If we are at PREROUTING or INPUT hook
 	 * the TTL isn't decreased by the IP stack
@@ -292,32 +301,54 @@
 		}
 	}
 
+	if ((route_info->flags & IPT_ROUTE_TEE)) {
+		/*
+		 * Copy the *pskb, and route the copy. Will later return
+		 * IPT_CONTINUE for the original skb, which should continue
+		 * on its way as if nothing happened. The copy should be
+		 * independantly delivered to the ROUTE --gw.
+		 */
+		skb = skb_copy(*pskb, GFP_ATOMIC);
+		if (!skb) {
+			if (net_ratelimit()) 
+				DEBUGP(KERN_DEBUG "ipt_ROUTE: copy failed!\n");
+			return IPT_CONTINUE;
+		}
+	}
+
 	/* Tell conntrack to forget this packet since it may get confused 
 	 * when a packet is leaving with dst address == our address.
 	 * Good idea ? Dunno. Need advice.
+	 *
+	 * NEW: mark the skb with our &route_tee_track, so we avoid looping
+	 * on any already routed packet.
 	 */
 	if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
 		nf_conntrack_put(skb->nfct);
-		skb->nfct = NULL;
+		skb->nfct = &route_tee_track.infos[IP_CT_NEW];
+		nf_conntrack_get(skb->nfct);
 		skb->nfcache = 0;
 #ifdef CONFIG_NETFILTER_DEBUG
 		skb->nf_debug = 0;
 #endif
 	}
 
-	if (route_info->oif[0] != '\0') 
-		return route_oif(route_info, *pskb);
-	
-	if (route_info->iif[0] != '\0') 
-		return route_iif(route_info, *pskb);
-
-	if (route_info->gw) 
-		return route_gw(route_info, *pskb);
+	if (route_info->oif[0]) {
+		res = route_oif(route_info, skb);
+	} else if (route_info->iif[0]) {
+		res = route_iif(route_info, skb);
+	} else if (route_info->gw) {
+		res = route_gw(route_info, skb);
+	} else {
+		if (net_ratelimit()) 
+			DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
+		res = IPT_CONTINUE;
+	}
 
-	if (net_ratelimit()) 
-		DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
+	if ((route_info->flags & IPT_ROUTE_TEE))
+		res = IPT_CONTINUE;
 
-	return IPT_CONTINUE;
+	return res;
 }
 
 
@@ -360,6 +391,20 @@
 
 static int __init init(void)
 {
+	/* Set up fake conntrack (stolen from raw.patch):
+	    - to never be deleted, not in any hashes */
+	atomic_set(&route_tee_track.ct_general.use, 1);
+	/*  - and look it like as a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
+	/*  - and prepare the ctinfo field for REJECT/NAT. */
+	route_tee_track.infos[IP_CT_NEW].master = 
+	route_tee_track.infos[IP_CT_RELATED].master = 
+	route_tee_track.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master = 
+		&route_tee_track.ct_general;
+	/* Initialize fake conntrack so that NAT will skip it */
+	route_tee_track.nat.info.initialized |= 
+		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+
 	if (ipt_register_target(&ipt_route_reg))
 		return -EINVAL;
 
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter/ip6t_ROUTE.c patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter/ip6t_ROUTE.c
--- svn-20041120-patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter/ip6t_ROUTE.c	Sat Nov 20 11:28:25 2004
+++ patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter/ip6t_ROUTE.c	Tue Nov 23 09:30:16 2004
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
  *
- * v 1.0 2003/08/05
+ * v 1.1 2004/11/23
  *
  * This software is distributed under GNU GPL v2, 1991
  */
@@ -198,6 +198,7 @@
 	const struct ip6t_route_target_info *route_info = targinfo;
 	struct sk_buff *skb = *pskb;
 	struct in6_addr *gw = (struct in6_addr*)&route_info->gw;
+	unsigned int res;
 
 	if (route_info->flags & IP6T_ROUTE_CONTINUE)
 		goto do_it;
@@ -223,18 +224,36 @@
 		ipv6h->hop_limit--;
 	}
 
+	if ((route_info->flags & IP6T_ROUTE_TEE)) {
+		/*
+		 * Copy the *pskb, and route the copy. Will later return
+		 * IP6T_CONTINUE for the original skb, which should continue
+		 * on its way as if nothing happened. The copy should be
+		 * independantly delivered to the ROUTE --gw.
+		 */
+		skb = skb_copy(*pskb, GFP_ATOMIC);
+		if (!skb) {
+			if (net_ratelimit()) 
+				DEBUGP(KERN_DEBUG "ip6t_ROUTE: copy failed!\n");
+			return IP6T_CONTINUE;
+		}
+	}
 
- do_it:
-	if (route_info->oif[0]) 
-		return route6_oif(route_info, *pskb);
-	
-	if (!ipv6_addr_any(gw))
-		return route6_gw(route_info, *pskb);
+do_it:
+	if (route_info->oif[0]) {
+		res = route6_oif(route_info, skb);
+	} else if (!ipv6_addr_any(gw)) {
+		res = route6_gw(route_info, skb);
+	} else {
+		if (net_ratelimit()) 
+			DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
+		res = IP6T_CONTINUE;
+	}
 
-	if (net_ratelimit()) 
-		DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
+	if ((route_info->flags & IP6T_ROUTE_TEE))
+		res = IP6T_CONTINUE;
 
-	return IP6T_CONTINUE;
+	return res;
 }
 
 
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h	Sat Nov 20 11:28:26 2004
+++ patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h	Tue Nov 23 08:09:45 2004
@@ -18,5 +18,6 @@
 
 /* Values for "flags" field */
 #define IPT_ROUTE_CONTINUE        0x01
+#define IPT_ROUTE_TEE             0x02
 
 #endif /*_IPT_ROUTE_H_target*/
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h
--- svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h	Sat Nov 20 11:28:25 2004
+++ patch-o-matic-ng/ROUTE/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h	Tue Nov 23 08:09:45 2004
@@ -18,5 +18,6 @@
 
 /* Values for "flags" field */
 #define IP6T_ROUTE_CONTINUE        0x01
+#define IP6T_ROUTE_TEE             0x02
 
 #endif /*_IP6T_ROUTE_H_target*/
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c
--- svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	Sat Nov 20 11:28:27 2004
+++ patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	Tue Nov 23 08:21:38 2004
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
  *
- * v 1.10 2004/11/10
+ * v 1.11 2004/11/23
  *
  * This software is distributed under GNU GPL v2, 1991
  */
@@ -13,6 +13,7 @@
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ipt_ROUTE.h>
 #include <linux/netdevice.h>
 #include <linux/route.h>
@@ -245,6 +246,14 @@
 }
 
 
+/* To detect and deter routed packet loopback when using the --tee option,
+ * we take a page out of the raw.patch book: on the copied skb, we set up
+ * a fake ->nfct entry, pointing to the local &route_tee_track. We skip
+ * routing packets when we see they already have that ->nfct.
+ */
+
+static struct ip_conntrack route_tee_track;
+
 static unsigned int ipt_route_target(struct sk_buff **pskb,
 				     const struct net_device *in,
 				     const struct net_device *out,
@@ -254,6 +263,16 @@
 {
 	const struct ipt_route_target_info *route_info = targinfo;
 	struct sk_buff *skb = *pskb;
+	unsigned int res;
+
+	if (skb->nfct == &route_tee_track.ct_general) {
+		/* Loopback - a packet we already routed, is to be
+		 * routed another time. Avoid that, now.
+		 */
+		if (net_ratelimit()) 
+			DEBUGP(KERN_DEBUG "ipt_ROUTE: loopback - DROP!\n");
+		return NF_DROP;
+	}
 
 	/* If we are at PREROUTING or INPUT hook
 	 * the TTL isn't decreased by the IP stack
@@ -310,32 +329,55 @@
 		}
 	}
 
+	if ((route_info->flags & IPT_ROUTE_TEE)) {
+		/*
+		 * Copy the *pskb, and route the copy. Will later return
+		 * IPT_CONTINUE for the original skb, which should continue
+		 * on its way as if nothing happened. The copy should be
+		 * independantly delivered to the ROUTE --gw.
+		 */
+		skb = skb_copy(*pskb, GFP_ATOMIC);
+		if (!skb) {
+			if (net_ratelimit()) 
+				DEBUGP(KERN_DEBUG "ipt_ROUTE: copy failed!\n");
+			return IPT_CONTINUE;
+		}
+	}
+
 	/* Tell conntrack to forget this packet since it may get confused 
 	 * when a packet is leaving with dst address == our address.
 	 * Good idea ? Dunno. Need advice.
+	 *
+	 * NEW: mark the skb with our &route_tee_track, so we avoid looping
+	 * on any already routed packet.
 	 */
 	if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
 		nf_conntrack_put(skb->nfct);
-		skb->nfct = NULL;
+		skb->nfct = &route_tee_track.ct_general;
+		skb->nfctinfo = IP_CT_NEW;
+		nf_conntrack_get(skb->nfct);
 		skb->nfcache = 0;
 #ifdef CONFIG_NETFILTER_DEBUG
 		skb->nf_debug = 0;
 #endif
 	}
 
-	if (route_info->oif[0] != '\0') 
-		return route_oif(route_info, *pskb);
-	
-	if (route_info->iif[0] != '\0') 
-		return route_iif(route_info, *pskb);
-
-	if (route_info->gw) 
-		return route_gw(route_info, *pskb);
+	if (route_info->oif[0] != '\0') {
+		res = route_oif(route_info, skb);
+	} else if (route_info->iif[0] != '\0') {
+		res = route_iif(route_info, skb);
+	} else if (route_info->gw) {
+		res = route_gw(route_info, skb);
+	} else {
+		if (net_ratelimit()) 
+			DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
+		res = IPT_CONTINUE;
+	}
 
-	if (net_ratelimit()) 
-		DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
+	if ((route_info->flags & IPT_ROUTE_TEE))
+		res = IPT_CONTINUE;
 
-	return IPT_CONTINUE;
+	return res;
 }
 
 
@@ -380,6 +422,15 @@
 
 static int __init init(void)
 {
+	/* Set up fake conntrack (stolen from raw.patch):
+	    - to never be deleted, not in any hashes */
+	atomic_set(&route_tee_track.ct_general.use, 1);
+	/*  - and look it like as a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
+	/* Initialize fake conntrack so that NAT will skip it */
+	route_tee_track.nat.info.initialized |= 
+		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+
 	return ipt_register_target(&ipt_route_reg);
 }
 
diff --exclude=CVS --exclude=.svn -urN svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c patch-o-matic-ng/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c
--- svn-20041120-patch-o-matic-ng/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c	Sat Nov 20 11:28:27 2004
+++ patch-o-matic-ng/ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c	Tue Nov 23 08:41:18 2004
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
  *
- * v 1.0 2003/08/05
+ * v 1.1 2004/11/23
  *
  * This software is distributed under GNU GPL v2, 1991
  */
@@ -198,6 +198,7 @@
 	const struct ip6t_route_target_info *route_info = targinfo;
 	struct sk_buff *skb = *pskb;
 	struct in6_addr *gw = (struct in6_addr*)&route_info->gw;
+	unsigned int res;
 
 	if (route_info->flags & IP6T_ROUTE_CONTINUE)
 		goto do_it;
@@ -223,18 +224,36 @@
 		ipv6h->hop_limit--;
 	}
 
+	if ((route_info->flags & IP6T_ROUTE_TEE)) {
+		/*
+		 * Copy the *pskb, and route the copy. Will later return
+		 * IP6T_CONTINUE for the original skb, which should continue
+		 * on its way as if nothing happened. The copy should be
+		 * independantly delivered to the ROUTE --gw.
+		 */
+		skb = skb_copy(*pskb, GFP_ATOMIC);
+		if (!skb) {
+			if (net_ratelimit()) 
+				DEBUGP(KERN_DEBUG "ip6t_ROUTE: copy failed!\n");
+			return IP6T_CONTINUE;
+		}
+	}
 
- do_it:
-	if (route_info->oif[0]) 
-		return route6_oif(route_info, *pskb);
-	
-	if (!ipv6_addr_any(gw))
-		return route6_gw(route_info, *pskb);
+do_it:
+	if (route_info->oif[0]) {
+		res = route6_oif(route_info, skb);
+	} else if (!ipv6_addr_any(gw)) {
+		res = route6_gw(route_info, skb);
+	} else {
+		if (net_ratelimit()) 
+			DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
+		res = IP6T_CONTINUE;
+	}
 
-	if (net_ratelimit()) 
-		DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
+	if ((route_info->flags & IP6T_ROUTE_TEE))
+		res = IP6T_CONTINUE;
 
-	return IP6T_CONTINUE;
+	return res;
 }
 
 

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables.ROUTE.tee.20041123.patch"

diff --exclude=CVS --exclude=.svn -urN svn-20041120-iptables/extensions/libip6t_ROUTE.c iptables/extensions/libip6t_ROUTE.c
--- svn-20041120-iptables/extensions/libip6t_ROUTE.c	Sat Nov 20 11:24:12 2004
+++ iptables/extensions/libip6t_ROUTE.c	Tue Nov 23 08:39:27 2004
@@ -1,6 +1,6 @@
 /* Shared library add-on to iptables to add ROUTE v6 target support.
  * Author : Cedric de Launois, <delaunois@info.ucl.ac.be>
- * v 1.0 2003/06/24
+ * v 1.1 2004/11/23
  */
 
 #include <stdio.h>
@@ -15,6 +15,11 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_ROUTE.h>
 
+/* compile IP6T_ROUTE_TEE support even if kernel headers are unpatched */
+#ifndef IP6T_ROUTE_TEE
+#define IP6T_ROUTE_TEE		0x02
+#endif
+
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -23,9 +28,13 @@
 "ROUTE target v%s options:\n"
 "    --oif   \tifname \t\tRoute the packet through `ifname' network interface\n"
 "    --gw    \tip     \t\tRoute the packet via this gateway\n"
-"    --continue\t     \t\tRoute the packet and continue traversing the rules.\n"
+"    --continue\t     \t\tRoute packet and continue traversing the\n"
+"            \t       \t\trules. Not valid with --iif or --tee.\n"
+"    --tee\t  \t\tDuplicate packet, route the duplicate,\n"
+"            \t       \t\tcontinue traversing with original packet.\n"
+"            \t       \t\tNot valid with --iif or --continue.\n"
 "\n",
-"1.0");
+"1.1");
 }
 
 static struct option opts[] = {
@@ -33,6 +42,7 @@
 	{ "iif", 1, 0, '2' },
 	{ "gw", 1, 0, '3' },
 	{ "continue", 0, 0, '4' },
+	{ "tee", 0, 0, '5' },
 	{ 0 }
 };
 
@@ -57,6 +67,7 @@
 #define IP6T_ROUTE_OPT_IIF      0x02
 #define IP6T_ROUTE_OPT_GW       0x04
 #define IP6T_ROUTE_OPT_CONTINUE 0x08
+#define IP6T_ROUTE_OPT_TEE      0x10
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -114,12 +125,28 @@
 		if (*flags & IP6T_ROUTE_OPT_CONTINUE)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --continue twice");
+		if (*flags & IP6T_ROUTE_OPT_TEE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --continue AND --tee");
 
 		route_info->flags |= IP6T_ROUTE_CONTINUE;
 		*flags |= IP6T_ROUTE_OPT_CONTINUE;
 
 		break;
 
+	case '5':
+		if (*flags & IP6T_ROUTE_OPT_TEE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --tee twice");
+		if (*flags & IP6T_ROUTE_OPT_CONTINUE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --tee AND --continue");
+
+		route_info->flags |= IP6T_ROUTE_TEE;
+		*flags |= IP6T_ROUTE_OPT_TEE;
+
+		break;
+
 	default:
 		return 0;
 	}
@@ -162,6 +189,9 @@
 	if (route_info->flags & IP6T_ROUTE_CONTINUE)
 		printf("continue");
 
+	if (route_info->flags & IP6T_ROUTE_TEE)
+		printf("tee");
+
 }
 
 
@@ -184,6 +214,9 @@
 
 	if (route_info->flags & IP6T_ROUTE_CONTINUE)
 		printf("--continue ");
+
+	if (route_info->flags & IP6T_ROUTE_TEE)
+		printf("--tee ");
 }
 
 
diff --exclude=CVS --exclude=.svn -urN svn-20041120-iptables/extensions/libip6t_ROUTE.man iptables/extensions/libip6t_ROUTE.man
--- svn-20041120-iptables/extensions/libip6t_ROUTE.man	Sat Nov 20 11:24:04 2004
+++ iptables/extensions/libip6t_ROUTE.man	Tue Nov 23 08:38:08 2004
@@ -9,4 +9,7 @@
 Route the packet via this gateway
 .TP
 .BI "--continue "
-Behave like a non-terminating target and continue traversing the rules
+Behave like a non-terminating target and continue traversing the rules. Not valid in combination with `--tee'
+.TP
+.BI "--tee "
+Make a copy of the packet, and route that copy to the given destination. For the original, uncopied packet, behave like a non-terminating target and continue traversing the rules.  Not valid in combination with `--continue'
diff --exclude=CVS --exclude=.svn -urN svn-20041120-iptables/extensions/libipt_ROUTE.c iptables/extensions/libipt_ROUTE.c
--- svn-20041120-iptables/extensions/libipt_ROUTE.c	Sat Nov 20 11:23:48 2004
+++ iptables/extensions/libipt_ROUTE.c	Tue Nov 23 08:32:18 2004
@@ -1,6 +1,6 @@
 /* Shared library add-on to iptables to add ROUTE target support.
  * Author : Cedric de Launois, <delaunois@info.ucl.ac.be>
- * v 1.8 2003/06/24
+ * v 1.11 2004/11/23
  */
 
 #include <stdio.h>
@@ -15,19 +15,27 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ROUTE.h>
 
+/* compile IPT_ROUTE_TEE support even if kernel headers are unpatched */
+#ifndef IPT_ROUTE_TEE
+#define IPT_ROUTE_TEE		0x02
+#endif
+
 /* Function which prints out usage message. */
 static void
 help(void)
 {
 	printf(
 "ROUTE target v%s options:\n"
-"    --oif   \tifname \t\tRoute the packet through `ifname' network interface\n"
-"    --iif   \tifname \t\tChange the packet's incoming interface to `ifname'\n"
-"    --gw    \tip     \t\tRoute the packet via this gateway\n"
-"    --continue\t     \t\tRoute the packet and continue traversing the\n"
-"            \t       \t\trules. Not valid with --iif.\n"
+"    --oif   \tifname \t\tRoute packet through `ifname' network interface\n"
+"    --iif   \tifname \t\tChange packet's incoming interface to `ifname'\n"
+"    --gw    \tip     \t\tRoute packet via this gateway `ip'\n"
+"    --continue\t     \t\tRoute packet and continue traversing the\n"
+"            \t       \t\trules. Not valid with --iif or --tee.\n"
+"    --tee\t  \t\tDuplicate packet, route the duplicate,\n"
+"            \t       \t\tcontinue traversing with original packet.\n"
+"            \t       \t\tNot valid with --iif or --continue.\n"
 "\n",
-"1.8");
+"1.11");
 }
 
 static struct option opts[] = {
@@ -35,6 +43,7 @@
 	{ "iif", 1, 0, '2' },
 	{ "gw", 1, 0, '3' },
 	{ "continue", 0, 0, '4' },
+	{ "tee", 0, 0, '5' },
 	{ 0 }
 };
 
@@ -56,6 +65,7 @@
 #define IPT_ROUTE_OPT_IIF      0x02
 #define IPT_ROUTE_OPT_GW       0x04
 #define IPT_ROUTE_OPT_CONTINUE 0x08
+#define IPT_ROUTE_OPT_TEE      0x10
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -134,12 +144,28 @@
 		if (*flags & IPT_ROUTE_OPT_CONTINUE)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --continue twice");
+		if (*flags & IPT_ROUTE_OPT_TEE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --continue AND --tee");
 
 		route_info->flags |= IPT_ROUTE_CONTINUE;
 		*flags |= IPT_ROUTE_OPT_CONTINUE;
 
 		break;
 
+	case '5':
+		if (*flags & IPT_ROUTE_OPT_TEE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --tee twice");
+		if (*flags & IPT_ROUTE_OPT_CONTINUE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --tee AND --continue");
+
+		route_info->flags |= IPT_ROUTE_TEE;
+		*flags |= IPT_ROUTE_OPT_TEE;
+
+		break;
+
 	default:
 		return 0;
 	}
@@ -155,7 +181,7 @@
 		exit_error(PARAMETER_PROBLEM,
 		           "ROUTE target: oif, iif or gw option required");
 
-	if ((flags & IPT_ROUTE_OPT_CONTINUE) && (flags & IPT_ROUTE_OPT_IIF))
+	if ((flags & (IPT_ROUTE_OPT_CONTINUE|IPT_ROUTE_OPT_TEE)) && (flags & IPT_ROUTE_OPT_IIF))
 		exit_error(PARAMETER_PROBLEM,
 			   "ROUTE target: can't continue traversing the rules with iif option");
 }
@@ -186,6 +212,9 @@
 	if (route_info->flags & IPT_ROUTE_CONTINUE)
 		printf("continue");
 
+	if (route_info->flags & IPT_ROUTE_TEE)
+		printf("tee");
+
 }
 
 
@@ -208,6 +237,9 @@
 
 	if (route_info->flags & IPT_ROUTE_CONTINUE)
 		printf("--continue ");
+
+	if (route_info->flags & IPT_ROUTE_TEE)
+		printf("--tee ");
 }
 
 
diff --exclude=CVS --exclude=.svn -urN svn-20041120-iptables/extensions/libipt_ROUTE.man iptables/extensions/libipt_ROUTE.man
--- svn-20041120-iptables/extensions/libipt_ROUTE.man	Sat Nov 20 11:23:52 2004
+++ iptables/extensions/libipt_ROUTE.man	Tue Nov 23 08:37:30 2004
@@ -12,4 +12,7 @@
 Route the packet via this gateway
 .TP
 .BI "--continue "
-Behave like a non-terminating target and continue traversing the rules.  Not valid in combination with `--iif'
+Behave like a non-terminating target and continue traversing the rules.  Not valid in combination with `--iif' or `--tee'
+.TP
+.BI "--tee "
+Make a copy of the packet, and route that copy to the given destination. For the original, uncopied packet, behave like a non-terminating target and continue traversing the rules.  Not valid in combination with `--iif' or `--continue'
diff --exclude=CVS --exclude=.svn -urN svn-20041120-iptables/extensions/xxx iptables/extensions/xxx
--- svn-20041120-iptables/extensions/xxx	Thu Jan  1 01:00:00 1970
+++ iptables/extensions/xxx	Tue Nov 23 08:36:14 2004
@@ -0,0 +1,15 @@
+This is used to explicitly override the core network stack's routing decision.
+.B mangle
+table.
+.TP
+.BI "--oif " "ifname"
+Route the packet through `ifname' network interface
+.TP
+.BI "--iif " "ifname"
+Change the packet's incoming interface to `ifname'
+.TP
+.BI "--gw " "IP_address"
+Route the packet via this gateway
+.TP
+.BI "--continue "
+Behave like a non-terminating target and continue traversing the rules.  Not valid in combination with `--iif'

--GvXjxJ+pjyke8COw--
