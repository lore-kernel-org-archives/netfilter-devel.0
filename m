From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Mon, 16 Feb 2004 02:19:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40301AB2.2030103@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090205070002090707010205"
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Willy Tarreau <willy@w.ods.org>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <401D12B6.5030707@trash.net>
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
--------------090205070002090707010205
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I've continued to work on the IPSEC+NAT issue, this is the
current status. The hooks for pre/post-ipsec are now entirely
contained in ip_output.c. The transformers mark transformed
packets with a new flag in the control buffer, this is used
for directing ipsec packets to LOCAL_OUT in ip_output(). It
also solves the loop danger when redirecting packets in
ip_nat_out after rerouting, ip_route_me_harder only looks up
a policy for untransformed packets. Redirected packets are
manually confirmed, should this be changed to just mark
them for redirection and do the actual redirecting in the
conntrack hook ? The policy check part is fine now, the
conntrack reference is kept as long as required for the
ip protocol handlers that do policy checks, but it should be
dropped on all paths before packets are queued to the socket.
The nf_nat_decode_packet function now handles all cases of NAT
which affect policy lookups, the last patches didn't handle
DNAT rules in PREROUTING. The last big problem is the input
side, I don't know how to make hook ordering symetric to
output. Suggestions are very welcome.


There are 4 patches:

01-nf_reset.diff
     Move common nf_conntrack_put/nfct=NULL/nf_debug=0 code to
     new inline function nf_reset.

02-hooks.diff
     Make packets to be encrypted visible on POST_ROUTING hook
     and encrypted packets on LOCAL_OUT. Reset nfct etc. before
     reposting the packet into the stack on reception.

03-nat-policy-lookup.diff
     Add policy lookups to ip_route_me_harder and change NAT to
     reroute for any change that affects routing or policy lookups

04-nat-policy-checks.diff
     Make xfrm_policy_check find correct policy for NATed packets


Best regards,
Patrick

--------------090205070002090707010205
Content-Type: text/x-patch;
 name="01-nf_reset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-nf_reset.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/16 00:43:03+01:00 kaber@trash.net 
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv6/sit.c
#   2004/02/16 00:41:03+01:00 kaber@trash.net +2 -14
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv6/ip6_tunnel.c
#   2004/02/16 00:41:03+01:00 kaber@trash.net +1 -7
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv4/ipip.c
#   2004/02/16 00:41:03+01:00 kaber@trash.net +2 -14
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv4/ip_input.c
#   2004/02/16 00:41:03+01:00 kaber@trash.net +1 -5
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv4/ip_gre.c
#   2004/02/16 00:41:03+01:00 kaber@trash.net +2 -14
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# include/linux/skbuff.h
#   2004/02/16 00:41:03+01:00 kaber@trash.net +12 -3
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
diff -Nru a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h	Mon Feb 16 02:12:55 2004
+++ b/include/linux/skbuff.h	Mon Feb 16 02:12:55 2004
@@ -1201,6 +1201,14 @@
 	if (nfct)
 		atomic_inc(&nfct->master->use);
 }
+static inline void nf_reset(struct sk_buff *skb)
+{
+	nf_conntrack_put(skb->nfct);
+	skb->nfct = NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug = 0;
+#endif
+}
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 static inline void nf_bridge_put(struct nf_bridge_info *nf_bridge)
@@ -1213,9 +1221,10 @@
 	if (nf_bridge)
 		atomic_inc(&nf_bridge->use);
 }
-#endif
-
-#endif
+#endif /* CONFIG_BRIDGE_NETFILTER */
+#else /* CONFIG_NETFILTER */
+static inline void nf_reset(struct sk_buff *skb) {}
+#endif /* CONFIG_NETFILTER */
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff -Nru a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
--- a/net/ipv4/ip_gre.c	Mon Feb 16 02:12:55 2004
+++ b/net/ipv4/ip_gre.c	Mon Feb 16 02:12:55 2004
@@ -643,13 +643,7 @@
 		skb->dev = tunnel->dev;
 		dst_release(skb->dst);
 		skb->dst = NULL;
-#ifdef CONFIG_NETFILTER
-		nf_conntrack_put(skb->nfct);
-		skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug = 0;
-#endif
-#endif
+		nf_reset(skb);
 		ipgre_ecn_decapsulate(iph, skb);
 		netif_rx(skb);
 		read_unlock(&ipgre_lock);
@@ -877,13 +871,7 @@
 		}
 	}
 
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
-#endif
+	nf_reset(skb);
 
 	IPTUNNEL_XMIT();
 	tunnel->recursion--;
diff -Nru a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c	Mon Feb 16 02:12:55 2004
+++ b/net/ipv4/ip_input.c	Mon Feb 16 02:12:55 2004
@@ -202,17 +202,13 @@
 
 #ifdef CONFIG_NETFILTER_DEBUG
 	nf_debug_ip_local_deliver(skb);
-	skb->nf_debug = 0;
 #endif /*CONFIG_NETFILTER_DEBUG*/
 
 	__skb_pull(skb, ihl);
 
-#ifdef CONFIG_NETFILTER
 	/* Free reference early: we don't need it any more, and it may
            hold ip_conntrack module loaded indefinitely. */
-	nf_conntrack_put(skb->nfct);
-	skb->nfct = NULL;
-#endif /*CONFIG_NETFILTER*/
+	nf_reset(skb);
 
         /* Point into the IP datagram, just past the header. */
         skb->h.raw = skb->data;
diff -Nru a/net/ipv4/ipip.c b/net/ipv4/ipip.c
--- a/net/ipv4/ipip.c	Mon Feb 16 02:12:55 2004
+++ b/net/ipv4/ipip.c	Mon Feb 16 02:12:55 2004
@@ -496,13 +496,7 @@
 		skb->dev = tunnel->dev;
 		dst_release(skb->dst);
 		skb->dst = NULL;
-#ifdef CONFIG_NETFILTER
-		nf_conntrack_put(skb->nfct);
-		skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug = 0;
-#endif
-#endif
+		nf_reset(skb);
 		ipip_ecn_decapsulate(iph, skb);
 		netif_rx(skb);
 		read_unlock(&ipip_lock);
@@ -647,13 +641,7 @@
 	if ((iph->ttl = tiph->ttl) == 0)
 		iph->ttl	=	old_iph->ttl;
 
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
-#endif
+	nf_reset(skb);
 
 	IPTUNNEL_XMIT();
 	tunnel->recursion--;
diff -Nru a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
--- a/net/ipv6/ip6_tunnel.c	Mon Feb 16 02:12:55 2004
+++ b/net/ipv6/ip6_tunnel.c	Mon Feb 16 02:12:55 2004
@@ -715,13 +715,7 @@
 	ipv6h->nexthdr = proto;
 	ipv6_addr_copy(&ipv6h->saddr, &fl.fl6_src);
 	ipv6_addr_copy(&ipv6h->daddr, &fl.fl6_dst);
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
-#endif
+	nf_reset(skb);
 	pkt_len = skb->len;
 	err = NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, skb, NULL, 
 		      skb->dst->dev, dst_output);
diff -Nru a/net/ipv6/sit.c b/net/ipv6/sit.c
--- a/net/ipv6/sit.c	Mon Feb 16 02:12:55 2004
+++ b/net/ipv6/sit.c	Mon Feb 16 02:12:55 2004
@@ -388,13 +388,7 @@
 		skb->dev = tunnel->dev;
 		dst_release(skb->dst);
 		skb->dst = NULL;
-#ifdef CONFIG_NETFILTER
-		nf_conntrack_put(skb->nfct);
-		skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug = 0;
-#endif
-#endif
+		nf_reset(skb);
 		ipip6_ecn_decapsulate(iph, skb);
 		netif_rx(skb);
 		read_unlock(&ipip6_lock);
@@ -580,13 +574,7 @@
 	if ((iph->ttl = tiph->ttl) == 0)
 		iph->ttl	=	iph6->hop_limit;
 
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
-#endif
+	nf_reset(skb);
 
 	IPTUNNEL_XMIT();
 	tunnel->recursion--;

--------------090205070002090707010205
Content-Type: text/x-patch;
 name="02-hooks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-hooks.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/16 00:50:24+01:00 kaber@trash.net 
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/xfrm4_tunnel.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +1 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/xfrm4_input.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +1 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/ipcomp.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +1 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/ip_output.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +22 -4
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/ip_forward.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +4 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/esp4.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +1 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# net/ipv4/ah4.c
#   2004/02/16 00:50:18+01:00 kaber@trash.net +1 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
# include/net/ip.h
#   2004/02/16 00:50:18+01:00 kaber@trash.net +1 -0
#   Make packets visible to POST_ROUTING before encryption and LOCAL_OUT
#   afterwards, reset netfilter fields before re-posting packet into the
#   stack on reception.
# 
diff -Nru a/include/net/ip.h b/include/net/ip.h
--- a/include/net/ip.h	Mon Feb 16 02:13:07 2004
+++ b/include/net/ip.h	Mon Feb 16 02:13:07 2004
@@ -48,6 +48,7 @@
 #define IPSKB_TRANSLATED	2
 #define IPSKB_FORWARDED		4
 #define IPSKB_XFRM_TUNNEL_SIZE	8
+#define IPSKB_XFRM_TRANSFORMED	16
 };
 
 struct ipcm_cookie
diff -Nru a/net/ipv4/ah4.c b/net/ipv4/ah4.c
--- a/net/ipv4/ah4.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/ah4.c	Mon Feb 16 02:13:07 2004
@@ -137,6 +137,7 @@
 	ip_send_check(top_iph);
 
 	skb->nh.raw = skb->data;
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 
 	x->curlft.bytes += skb->len;
 	x->curlft.packets++;
diff -Nru a/net/ipv4/esp4.c b/net/ipv4/esp4.c
--- a/net/ipv4/esp4.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/esp4.c	Mon Feb 16 02:13:07 2004
@@ -191,6 +191,7 @@
 	ip_send_check(top_iph);
 
 	skb->nh.raw = skb->data;
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 
 	x->curlft.bytes += skb->len;
 	x->curlft.packets++;
diff -Nru a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
--- a/net/ipv4/ip_forward.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/ip_forward.c	Mon Feb 16 02:13:07 2004
@@ -51,6 +51,10 @@
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
+	if (skb->dst->xfrm != NULL)
+		return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL,
+		               skb->dst->dev, dst_output);
+
 	return dst_output(skb);
 }
 
diff -Nru a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/ip_output.c	Mon Feb 16 02:13:07 2004
@@ -122,6 +122,14 @@
 	return ttl;
 }
 
+static inline int ip_dst_output(struct sk_buff *skb)
+{
+	if (skb->dst->xfrm != NULL)
+		return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL,
+		               skb->dst->dev, dst_output);
+	return dst_output(skb);
+}
+
 /* 
  *		Add an ip header to a skbuff and send it out.
  *
@@ -164,7 +172,7 @@
 
 	/* Send it out. */
 	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		       dst_output);
+		       ip_dst_output);
 }
 
 static inline int ip_finish_output2(struct sk_buff *skb)
@@ -282,7 +290,7 @@
 		return ip_finish_output(skb);
 }
 
-int ip_output(struct sk_buff *skb)
+static inline int ip_output2(struct sk_buff *skb)
 {
 	IP_INC_STATS(IpOutRequests);
 
@@ -293,6 +301,16 @@
 		return ip_finish_output(skb);
 }
 
+int ip_output(struct sk_buff *skb)
+{
+	if (IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) {
+		nf_reset(skb);
+		return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL,
+		               skb->dst->dev, ip_output2);
+	}
+	return ip_output2(skb);
+}
+
 int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 {
 	struct sock *sk = skb->sk;
@@ -386,7 +404,7 @@
 	skb->priority = sk->sk_priority;
 
 	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		       dst_output);
+		       ip_dst_output);
 
 no_route:
 	IP_INC_STATS(IpOutNoRoutes);
@@ -1165,7 +1183,7 @@
 
 	/* Netfilter gets whole the not fragmented skb. */
 	err = NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, 
-		      skb->dst->dev, dst_output);
+		      skb->dst->dev, ip_dst_output);
 	if (err) {
 		if (err > 0)
 			err = inet->recverr ? net_xmit_errno(err) : 0;
diff -Nru a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
--- a/net/ipv4/ipcomp.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/ipcomp.c	Mon Feb 16 02:13:07 2004
@@ -223,6 +223,7 @@
 	skb->nh.raw = skb->data;
 
 out_ok:
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 	x->curlft.bytes += skb->len;
 	x->curlft.packets++;
 	spin_unlock_bh(&x->lock);
diff -Nru a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
--- a/net/ipv4/xfrm4_input.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/xfrm4_input.c	Mon Feb 16 02:13:07 2004
@@ -130,6 +130,7 @@
 			dst_release(skb->dst);
 			skb->dst = NULL;
 		}
+		nf_reset(skb);
 		netif_rx(skb);
 		return 0;
 	} else {
diff -Nru a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
--- a/net/ipv4/xfrm4_tunnel.c	Mon Feb 16 02:13:07 2004
+++ b/net/ipv4/xfrm4_tunnel.c	Mon Feb 16 02:13:07 2004
@@ -66,6 +66,7 @@
 	ip_send_check(top_iph);
 
 	skb->nh.raw = skb->data;
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 	x->curlft.bytes += skb->len;
 	x->curlft.packets++;
 

--------------090205070002090707010205
Content-Type: text/x-patch;
 name="03-nat-policy-lookup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-nat-policy-lookup.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/16 00:51:09+01:00 kaber@trash.net 
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any
#   change in route/policy key
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/02/16 00:51:03+01:00 kaber@trash.net +72 -8
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any
#   change in route/policy key
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/02/16 00:51:03+01:00 kaber@trash.net +1 -0
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any
#   change in route/policy key
# 
# net/core/netfilter.c
#   2004/02/16 00:51:03+01:00 kaber@trash.net +16 -0
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any
#   change in route/policy key
# 
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	Mon Feb 16 02:13:24 2004
+++ b/net/core/netfilter.c	Mon Feb 16 02:13:24 2004
@@ -25,6 +25,8 @@
 #include <linux/icmp.h>
 #include <net/sock.h>
 #include <net/route.h>
+#include <net/xfrm.h>
+#include <net/ip.h>
 #include <linux/ip.h>
 
 #define __KERNEL_SYSCALLS__
@@ -664,6 +666,20 @@
 	
 	if ((*pskb)->dst->error)
 		return -1;
+
+#ifdef CONFIG_XFRM
+	if (!(IPCB(*pskb)->flags & IPSKB_XFRM_TRANSFORMED)) {
+		struct xfrm_policy_afinfo *afinfo;
+
+		afinfo = xfrm_policy_get_afinfo(AF_INET);
+		if (afinfo != NULL) {
+			afinfo->decode_session(*pskb, &fl);
+			xfrm_policy_put_afinfo(afinfo);
+			if (xfrm_lookup(&(*pskb)->dst, &fl, (*pskb)->sk, 0) != 0)
+				return -1;
+		}
+	}
+#endif
 
 	/* Change in oif may mean change in hh_len. */
 	hh_len = (*pskb)->dst->dev->hard_header_len;
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Feb 16 02:13:24 2004
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Feb 16 02:13:24 2004
@@ -489,6 +489,7 @@
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(ip_conntrack_get);
+EXPORT_SYMBOL(__ip_conntrack_confirm);
 EXPORT_SYMBOL(need_ip_conntrack);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	Mon Feb 16 02:13:24 2004
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	Mon Feb 16 02:13:24 2004
@@ -166,6 +166,45 @@
 	return do_bindings(ct, ctinfo, info, hooknum, pskb);
 }
 
+struct nat_route_key
+{
+	u_int32_t addr;
+#ifdef CONFIG_XFRM
+	u_int16_t port;
+#endif
+};
+
+static inline void
+nat_route_key_get(struct sk_buff *skb, struct nat_route_key *key, int which)
+{
+	struct iphdr *iph = skb->nh.iph;
+
+	key->addr = which ? iph->daddr : iph->saddr;
+#ifdef CONFIG_XFRM
+	key->port = 0;
+	if (iph->protocol == IPPROTO_TCP || iph->protocol == IPPROTO_UDP) {
+		u_int16_t *ports = (u_int16_t *)(skb->nh.raw + iph->ihl*4);
+		key->port = ports[which];
+	}
+#endif
+}
+
+static inline int
+nat_route_key_compare(struct sk_buff *skb, struct nat_route_key *key, int which)
+{
+	struct iphdr *iph = skb->nh.iph;
+
+	if (key->addr != (which ? iph->daddr : iph->saddr))
+		return 1;
+#ifdef CONFIG_XFRM
+	if (iph->protocol == IPPROTO_TCP || iph->protocol == IPPROTO_UDP) {
+		u_int16_t *ports = (u_int16_t *)(skb->nh.raw + iph->ihl*4);
+		if (key->port != ports[which])
+			return 1;
+	}
+#endif
+}
+
 static unsigned int
 ip_nat_out(unsigned int hooknum,
 	   struct sk_buff **pskb,
@@ -173,6 +212,9 @@
 	   const struct net_device *out,
 	   int (*okfn)(struct sk_buff *))
 {
+	struct nat_route_key key;
+	unsigned int ret;
+
 	/* root is playing with raw sockets. */
 	if ((*pskb)->len < sizeof(struct iphdr)
 	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
@@ -195,7 +237,29 @@
 			return NF_STOLEN;
 	}
 
-	return ip_nat_fn(hooknum, pskb, in, out, okfn);
+	nat_route_key_get(*pskb, &key, 0);
+	ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
+
+	if (ret != NF_DROP && ret != NF_STOLEN
+	    && nat_route_key_compare(*pskb, &key, 0)) {
+		if (ip_route_me_harder(pskb) != 0)
+			ret = NF_DROP;
+#ifdef CONFIG_XFRM
+		/*
+		 * POST_ROUTING hook is called with fixed outfn, we need
+		 * to manually confirm the packet and direct it to the
+		 * transformers if a policy matches.
+		 */
+		else if ((*pskb)->dst->xfrm != NULL) {
+			ret = ip_conntrack_confirm(*pskb);
+			if (ret != NF_DROP) {
+				dst_output(*pskb);
+				ret = NF_STOLEN;
+			}
+		}
+#endif
+	}
+	return ret;
 }
 
 #ifdef CONFIG_IP_NF_NAT_LOCAL
@@ -206,7 +270,7 @@
 		const struct net_device *out,
 		int (*okfn)(struct sk_buff *))
 {
-	u_int32_t saddr, daddr;
+	struct nat_route_key key;
 	unsigned int ret;
 
 	/* root is playing with raw sockets. */
@@ -214,14 +278,14 @@
 	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
 		return NF_ACCEPT;
 
-	saddr = (*pskb)->nh.iph->saddr;
-	daddr = (*pskb)->nh.iph->daddr;
-
+	nat_route_key_get(*pskb, &key, 1);
 	ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
+
 	if (ret != NF_DROP && ret != NF_STOLEN
-	    && ((*pskb)->nh.iph->saddr != saddr
-		|| (*pskb)->nh.iph->daddr != daddr))
-		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+	    && nat_route_key_compare(*pskb, &key, 1)) {
+		if (ip_route_me_harder(pskb) != 0)
+			ret = NF_DROP;
+	}
 	return ret;
 }
 #endif

--------------090205070002090707010205
Content-Type: text/x-patch;
 name="04-nat-policy-check.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-nat-policy-check.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/16 00:54:30+01:00 kaber@trash.net 
#   Make policy checks work with NAT
# 
# net/xfrm/xfrm_policy.c
#   2004/02/16 00:54:24+01:00 kaber@trash.net +2 -0
#   Make policy checks work with NAT
# 
# net/ipv4/udp.c
#   2004/02/16 00:54:24+01:00 kaber@trash.net +2 -0
#   Make policy checks work with NAT
# 
# net/ipv4/tcp_ipv4.c
#   2004/02/16 00:54:24+01:00 kaber@trash.net +1 -0
#   Make policy checks work with NAT
# 
# net/ipv4/raw.c
#   2004/02/16 00:54:24+01:00 kaber@trash.net +1 -0
#   Make policy checks work with NAT
# 
# net/ipv4/ip_input.c
#   2004/02/16 00:54:23+01:00 kaber@trash.net +6 -8
#   Make policy checks work with NAT
# 
# net/core/netfilter.c
#   2004/02/16 00:54:23+01:00 kaber@trash.net +43 -0
#   Make policy checks work with NAT
# 
# include/linux/netfilter.h
#   2004/02/16 00:54:23+01:00 kaber@trash.net +16 -0
#   Make policy checks work with NAT
# 
diff -Nru a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h	Mon Feb 16 02:13:39 2004
+++ b/include/linux/netfilter.h	Mon Feb 16 02:13:39 2004
@@ -166,5 +166,21 @@
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
 #endif /*CONFIG_NETFILTER*/
 
+#ifdef CONFIG_XFRM
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+struct flowi;
+extern void nf_nat_decode_session4(struct sk_buff *skb, struct flowi *fl);
+
+static inline void
+nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family)
+{
+	if (family == AF_INET)
+		nf_nat_decode_session4(skb, fl);
+}
+#else /* CONFIG_IP_NF_NAT_NEEDED */
+#define nf_nat_decode_session(skb,fl,family)
+#endif /* CONFIG_IP_NF_NAT_NEEDED */
+#endif /* CONFIG_XFRM */
+
 #endif /*__KERNEL__*/
 #endif /*__LINUX_NETFILTER_H*/
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	Mon Feb 16 02:13:39 2004
+++ b/net/core/netfilter.c	Mon Feb 16 02:13:39 2004
@@ -698,6 +698,49 @@
 	return 0;
 }
 
+#if defined(CONFIG_IP_NF_NAT_NEEDED) && defined(CONFIG_XFRM)
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+
+void nf_nat_decode_session4(struct sk_buff *skb, struct flowi *fl)
+{
+	struct ip_conntrack *ct;
+	struct ip_conntrack_tuple *t;
+	struct ip_nat_info_manip *m;
+	unsigned int i;
+
+	if (skb->nfct == NULL)
+		return;
+	ct = (struct ip_conntrack *)skb->nfct->master;
+
+	for (i = 0; i < ct->nat.info.num_manips; i++) {
+		m = &ct->nat.info.manips[i];
+		t = &ct->tuplehash[m->direction].tuple;
+
+		switch (m->hooknum) {
+		case NF_IP_PRE_ROUTING:
+			if (m->maniptype != IP_NAT_MANIP_DST)
+				break;
+			fl->fl4_dst = t->dst.ip;
+			if (t->dst.protonum == IPPROTO_TCP ||
+			    t->dst.protonum == IPPROTO_UDP)
+				fl->fl_ip_dport = t->dst.u.tcp.port;
+			break;
+#ifdef CONFIG_IP_NF_NAT_LOCAL
+		case NF_IP_LOCAL_IN:
+			if (m->maniptype != IP_NAT_MANIP_SRC)
+				break;
+			fl->fl4_src = t->src.ip;
+			if (t->dst.protonum == IPPROTO_TCP ||
+			    t->dst.protonum == IPPROTO_UDP)
+				fl->fl_ip_sport = t->src.u.tcp.port;
+			break;
+#endif
+		}
+	}
+}
+#endif /* CONFIG_IP_NF_NAT_NEEDED && CONFIG_XFRM */
+
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
 	struct sk_buff *nskb;
diff -Nru a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c	Mon Feb 16 02:13:39 2004
+++ b/net/ipv4/ip_input.c	Mon Feb 16 02:13:39 2004
@@ -206,10 +206,6 @@
 
 	__skb_pull(skb, ihl);
 
-	/* Free reference early: we don't need it any more, and it may
-           hold ip_conntrack module loaded indefinitely. */
-	nf_reset(skb);
-
         /* Point into the IP datagram, just past the header. */
         skb->h.raw = skb->data;
 
@@ -235,10 +231,12 @@
 			int ret;
 
 			smp_read_barrier_depends();
-			if (!ipprot->no_policy &&
-			    !xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
-				kfree_skb(skb);
-				goto out;
+			if (!ipprot->no_policy) {
+				if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+					kfree_skb(skb);
+					goto out;
+				}
+				nf_reset(skb);
 			}
 			ret = ipprot->handler(skb);
 			if (ret < 0) {
diff -Nru a/net/ipv4/raw.c b/net/ipv4/raw.c
--- a/net/ipv4/raw.c	Mon Feb 16 02:13:39 2004
+++ b/net/ipv4/raw.c	Mon Feb 16 02:13:39 2004
@@ -249,6 +249,7 @@
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset(skb);
 
 	skb_push(skb, skb->data - skb->nh.raw);
 
diff -Nru a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c	Mon Feb 16 02:13:39 2004
+++ b/net/ipv4/tcp_ipv4.c	Mon Feb 16 02:13:39 2004
@@ -1785,6 +1785,7 @@
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset(skb);
 
 	if (sk_filter(sk, skb, 0))
 		goto discard_and_relse;
diff -Nru a/net/ipv4/udp.c b/net/ipv4/udp.c
--- a/net/ipv4/udp.c	Mon Feb 16 02:13:39 2004
+++ b/net/ipv4/udp.c	Mon Feb 16 02:13:39 2004
@@ -1027,6 +1027,7 @@
 		kfree_skb(skb);
 		return -1;
 	}
+	nf_reset(skb);
 
 	if (up->encap_type) {
 		/*
@@ -1192,6 +1193,7 @@
 
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto drop;
+	nf_reset(skb);
 
 	/* No socket. Drop packet silently, if checksum is wrong */
 	if (udp_checksum_complete(skb))
diff -Nru a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
--- a/net/xfrm/xfrm_policy.c	Mon Feb 16 02:13:39 2004
+++ b/net/xfrm/xfrm_policy.c	Mon Feb 16 02:13:39 2004
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netfilter.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 
@@ -908,6 +909,7 @@
 
 	if (_decode_session(skb, &fl, family) < 0)
 		return 0;
+	nf_nat_decode_session(skb, &fl, family);
 
 	/* First, check used SA against their selectors. */
 	if (skb->sp) {

--------------090205070002090707010205--
