From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] policy routing fixes
Date: Tue, 22 Apr 2003 13:01:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA520F1.5080302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000905060705060305010809"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
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
--------------000905060705060305010809
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch corrects routing in REJECT, MIRROR and ip_route_me_harder.
Currently netfilter does not obey rules like "from x.x.x.x/x lookup x" 
because
it src=0 when doing routing lookups for non-local addresses. With this 
patch,
netfilter uses ip_route_input if source if non-local. Also 
route_me_harder doesn't
return the exact error anymore, noone seemed to care about it. i also 
removed
the printks, i think a missing route is nothing so abnormal it justifies 
confusing
the user, and almost everyone i know has asked me at least once "what 
the hell
is ip_route_me_harder" ;). This patch is incremental to the two i sent 
before.

Best regards,
Patrick


--------------000905060705060305010809
Content-Type: text/plain;
 name="03-netfilter-policy-routing.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-netfilter-policy-routing.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1103  -> 1.1104 
#	net/ipv4/netfilter/ipt_REJECT.c	1.11    -> 1.12   
#	net/core/netfilter.c	1.7     -> 1.8    
#	net/ipv4/netfilter/ipt_MIRROR.c	1.4     -> 1.5    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/22	kaber@trash.net	1.1104
# [NETFILTER] make netfilter policy-routing aware
# --------------------------------------------
#
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	Tue Apr 22 01:07:31 2003
+++ b/net/core/netfilter.c	Tue Apr 22 01:07:31 2003
@@ -563,64 +563,62 @@
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct rtable *rt;
-	struct rt_key key = { dst:iph->daddr,
-			      src:iph->saddr,
-			      oif:(*pskb)->sk ? (*pskb)->sk->bound_dev_if : 0,
-			      tos:RT_TOS(iph->tos)|RTO_CONN,
+	struct rt_key key = {};
+	struct dst_entry *odst;
+	unsigned int hh_len;
+
+	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
+	 * packets with foreign saddr to be appear on the NF_IP_LOCAL_OUT hook.
+	 */
+	if (inet_addr_type(iph->saddr) == RTN_LOCAL) {
+		key.dst = iph->daddr;
+		key.src = iph->saddr;
+		key.oif = (*pskb)->sk ? (*pskb)->sk->bound_dev_if : 0;
+		key.tos = RT_TOS(iph->tos);
 #ifdef CONFIG_IP_ROUTE_FWMARK
-			      fwmark:(*pskb)->nfmark
+		key.fwmark = (*pskb)->nfmark;
 #endif
-			    };
-	struct net_device *dev_src = NULL;
-	int err;
-
-	/* accomodate ip_route_output_slow(), which expects the key src to be
-	   0 or a local address; however some non-standard hacks like
-	   ipt_REJECT.c:send_reset() can cause packets with foreign
-           saddr to be appear on the NF_IP_LOCAL_OUT hook -MB */
-	if(key.src && !(dev_src = ip_dev_find(key.src)))
-		key.src = 0;
-
-	if ((err=ip_route_output_key(&rt, &key)) != 0) {
-		printk("route_me_harder: ip_route_output_key(dst=%u.%u.%u.%u, src=%u.%u.%u.%u, oif=%d, tos=0x%x, fwmark=0x%lx) error %d\n",
-			NIPQUAD(iph->daddr), NIPQUAD(iph->saddr),
-			(*pskb)->sk ? (*pskb)->sk->bound_dev_if : 0,
-			RT_TOS(iph->tos)|RTO_CONN,
-#ifdef CONFIG_IP_ROUTE_FWMARK
-			(*pskb)->nfmark,
-#else
-			0UL,
-#endif
-			err);
-		goto out;
-	}
-
-	/* Drop old route. */
-	dst_release((*pskb)->dst);
+		if (ip_route_output_key(&rt, &key) != 0)
+			return -1;
 
-	(*pskb)->dst = &rt->u.dst;
+		/* Drop old route. */
+		dst_release((*pskb)->dst);
+		(*pskb)->dst = &rt->u.dst;
+	} else {
+		/* non-local src, find valid iif to satisfy
+		 * rp-filter when calling ip_route_input. */
+		key.dst = iph->saddr;
+		if (ip_route_output_key(&rt, &key) != 0)
+			return -1;
+
+		odst = (*pskb)->dst;
+		if (ip_route_input(*pskb, iph->daddr, iph->saddr,
+		                   RT_TOS(iph->tos), rt->u.dst.dev) != 0) {
+			dst_release(&rt->u.dst);
+			return -1;
+		}
+		dst_release(&rt->u.dst);
+		dst_release(odst);
+	}
+	
+	if ((*pskb)->dst->error)
+		return -1;
 
 	/* Change in oif may mean change in hh_len. */
-	if (skb_headroom(*pskb) < (*pskb)->dst->dev->hard_header_len) {
+	hh_len = (*pskb)->dst->dev->hard_header_len;
+	if (skb_headroom(*pskb) < hh_len) {
 		struct sk_buff *nskb;
 
-		nskb = skb_realloc_headroom(*pskb,
-					    (*pskb)->dst->dev->hard_header_len);
-		if (!nskb) {
-			err = -ENOMEM;
-			goto out;
-		}
+		nskb = skb_realloc_headroom(*pskb, hh_len);
+		if (!nskb)
+			return -1;
 		if ((*pskb)->sk)
 			skb_set_owner_w(nskb, (*pskb)->sk);
 		kfree_skb(*pskb);
 		*pskb = nskb;
 	}
 
-out:
-	if (dev_src)
-		dev_put(dev_src);
-
-	return err;
+	return 0;
 }
 #endif /*CONFIG_INET*/
 
diff -Nru a/net/ipv4/netfilter/ipt_MIRROR.c b/net/ipv4/netfilter/ipt_MIRROR.c
--- a/net/ipv4/netfilter/ipt_MIRROR.c	Tue Apr 22 01:07:31 2003
+++ b/net/ipv4/netfilter/ipt_MIRROR.c	Tue Apr 22 01:07:31 2003
@@ -40,15 +40,42 @@
 #define DEBUGP(format, args...)
 #endif
 
-static inline struct rtable *route_mirror(struct sk_buff *skb)
+static inline struct rtable *route_mirror(struct sk_buff *skb, int local)
 {
         struct iphdr *iph = skb->nh.iph;
+	struct dst_entry *odst;
+	struct rt_key key = {};
 	struct rtable *rt;
 
-	/* Backwards */
-	if (ip_route_output(&rt, iph->saddr, iph->daddr,
-			    RT_TOS(iph->tos), 0))
-		return NULL;
+	if (local) {
+		key.dst = iph->saddr;
+		key.src = iph->daddr;
+		key.tos = RT_TOS(iph->tos);
+
+		if (ip_route_output_key(&rt, &key) != 0)
+			return NULL;
+	} else {
+		/* non-local src, find valid iif to satisfy
+		 * rp-filter when calling ip_route_input. */
+		key.dst = iph->daddr;
+		if (ip_route_output_key(&rt, &key) != 0)
+			return NULL;
+
+		odst = skb->dst;
+		if (ip_route_input(skb, iph->saddr, iph->daddr,
+		                   RT_TOS(iph->tos), rt->u.dst.dev) != 0) {
+			dst_release(&rt->u.dst);
+			return NULL;
+		}
+		dst_release(&rt->u.dst);
+		rt = (struct rtable *)skb->dst;
+		skb->dst = odst;
+	}
+
+	if (rt->u.dst.error) {
+		dst_release(&rt->u.dst);
+		rt = NULL;
+	}
 
 	return rt;
 }
@@ -111,7 +138,7 @@
 		ip_decrease_ttl(iph);
 	}
 
-	if ((rt = route_mirror(*pskb)) == NULL)
+	if ((rt = route_mirror(*pskb, hooknum == NF_IP_LOCAL_IN)) == NULL)
 		return NF_DROP;
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15) & ~15;
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	Tue Apr 22 01:07:31 2003
+++ b/net/ipv4/netfilter/ipt_REJECT.c	Tue Apr 22 01:07:31 2003
@@ -33,6 +33,46 @@
 		attach(new_skb, nfct);
 }
 
+static inline struct rtable *route_reverse(struct sk_buff *skb, int local)
+{
+	struct iphdr *iph = skb->nh.iph;
+	struct dst_entry *odst;
+	struct rt_key key = {};
+	struct rtable *rt;
+
+	if (local) {
+		key.dst = iph->saddr;
+		key.src = iph->daddr;
+		key.tos = RT_TOS(iph->tos);
+
+		if (ip_route_output_key(&rt, &key) != 0)
+			return NULL;
+	} else {
+		/* non-local src, find valid iif to satisfy
+		 * rp-filter when calling ip_route_input. */
+		key.dst = iph->daddr;
+		if (ip_route_output_key(&rt, &key) != 0)
+			return NULL;
+
+		odst = skb->dst;
+		if (ip_route_input(skb, iph->saddr, iph->daddr,
+		                   RT_TOS(iph->tos), rt->u.dst.dev) != 0) {
+			dst_release(&rt->u.dst);
+			return NULL;
+		}
+		dst_release(&rt->u.dst);
+		rt = (struct rtable *)skb->dst;
+		skb->dst = odst;
+	}
+
+	if (rt->u.dst.error) {
+		dst_release(&rt->u.dst);
+		rt = NULL;
+	}
+
+	return rt;
+}
+
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb, int local)
 {
@@ -63,10 +103,7 @@
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
 		return;
 
-	/* Routing: if not headed for us, route won't like source */
-	if (ip_route_output(&rt, oldskb->nh.iph->saddr,
-			    local ? oldskb->nh.iph->daddr : 0,
-			    RT_TOS(oldskb->nh.iph->tos), 0) != 0)
+	if ((rt = route_reverse(oldskb, local)) == NULL)
 		return;
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;

--------------000905060705060305010809--
