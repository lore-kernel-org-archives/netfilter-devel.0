From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: latest netfilter+ipsec patches
Date: Thu, 04 Mar 2004 23:30:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4047AE0E.1080003@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060704090701060106030300"
Cc: Willy Tarreau <willy@w.ods.org>, Harald Welte <laforge@netfilter.org>,
 Henrik Nordstrom <hno@marasystems.com>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 alex@samad.com.au,  guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40356624.6050209@trash.net>
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
--------------060704090701060106030300
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

(long CC list, if anyone doesn't want to be on it anymore please say so)

This is the latest version of the netfilter+ipsec patches, I will check
them in in a couple of days after some minor changes.

(Noteworthy) changes since last version:

- hook-traversal on input is symetrical to output now. This means
packets will traverse PRE_ROUTING/LOCAL_IN before decryption and
PRE_REROUTING/LOCAL_IN or PRE_ROUTING/FORWARD afterwards.

The encrypted packets go through the stack, including the hooks,
the usual way. Packets reposted into the stack (tunnel-mode SAs)
skip the hooks until we know decryption is finished. If after
input-routing one of these packets has a non-local destination,
we know decyption is finished. The function nf_postxfrm_nonlocal()
which passes them to PRE_ROUTING is called for these packets.
Packets with local-destination are handled in
ip_local_deliver_finish(), if the ip-protocol handler is not marked
as xfrm_prot (all ipsec-transformers), decryption is finished and
packets go to nf_postxfrm_input() where they will traverse the
PRE_ROUTING hook, potentially be rerouted or traverse the LOCAL_IN
hook, before beeing delivered to the ip-protocol handler. Packets
from transport-mode SAs are handled exactly like local-packets
from tunnel-mode SAs.

The only problem with this approach I'm currently aware of is that
one of the ip-protocol handlers marked with xfrm_prot
(xfrm4_tunnel.c) is also responsible for dispatching packets to
ipip.c; the encapsulated packets heading for a ipip-tunnel won't
traverse the netfilter hooks on input.

- new match "policy" for matching the policy that was used during
decapsulation (well, the used SAs, policy checks come later), and the
policy that will be used for encapsulation.

I had some examples but I accidentally killed X before sending, for
now I have just attached the test-script I used, if there are
questions just ask.


Regards
Patrick

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="01-nf_reset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-nf_reset.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/22 14:27:46+01:00 kaber@trash.net 
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv6/sit.c
#   2004/02/22 14:27:39+01:00 kaber@trash.net +2 -14
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv6/ip6_tunnel.c
#   2004/02/22 14:27:39+01:00 kaber@trash.net +1 -7
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv4/ipip.c
#   2004/02/22 14:27:39+01:00 kaber@trash.net +2 -14
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv4/ip_input.c
#   2004/02/22 14:27:39+01:00 kaber@trash.net +1 -5
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# net/ipv4/ip_gre.c
#   2004/02/22 14:27:39+01:00 kaber@trash.net +2 -14
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
# include/linux/skbuff.h
#   2004/02/22 14:27:39+01:00 kaber@trash.net +12 -3
#   Add new function 'nf_reset' to reset netfilter related skb-fields
# 
diff -Nru a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h	Sun Feb 22 14:35:04 2004
+++ b/include/linux/skbuff.h	Sun Feb 22 14:35:04 2004
@@ -1204,6 +1204,14 @@
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
@@ -1216,9 +1224,10 @@
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
--- a/net/ipv4/ip_gre.c	Sun Feb 22 14:35:04 2004
+++ b/net/ipv4/ip_gre.c	Sun Feb 22 14:35:04 2004
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
--- a/net/ipv4/ip_input.c	Sun Feb 22 14:35:04 2004
+++ b/net/ipv4/ip_input.c	Sun Feb 22 14:35:04 2004
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
--- a/net/ipv4/ipip.c	Sun Feb 22 14:35:04 2004
+++ b/net/ipv4/ipip.c	Sun Feb 22 14:35:04 2004
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
--- a/net/ipv6/ip6_tunnel.c	Sun Feb 22 14:35:04 2004
+++ b/net/ipv6/ip6_tunnel.c	Sun Feb 22 14:35:04 2004
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
--- a/net/ipv6/sit.c	Sun Feb 22 14:35:04 2004
+++ b/net/ipv6/sit.c	Sun Feb 22 14:35:04 2004
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

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="02-output_hooks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-output_hooks.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/22 14:29:05+01:00 kaber@trash.net 
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# net/ipv4/xfrm4_tunnel.c
#   2004/02/22 14:28:58+01:00 kaber@trash.net +1 -0
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# net/ipv4/ipcomp.c
#   2004/02/22 14:28:58+01:00 kaber@trash.net +1 -0
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# net/ipv4/ip_output.c
#   2004/02/22 14:28:58+01:00 kaber@trash.net +20 -4
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# net/ipv4/ip_forward.c
#   2004/02/22 14:28:58+01:00 kaber@trash.net +2 -1
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# net/ipv4/esp4.c
#   2004/02/22 14:28:58+01:00 kaber@trash.net +1 -0
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# net/ipv4/ah4.c
#   2004/02/22 14:28:58+01:00 kaber@trash.net +1 -0
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# include/net/ip.h
#   2004/02/22 14:28:58+01:00 kaber@trash.net +1 -0
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
# include/linux/netfilter.h
#   2004/02/22 14:28:58+01:00 kaber@trash.net +9 -4
#   Pass packets to POST_ROUTING hook before encryption and LOCAL_OUT afterwards
# 
diff -Nru a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h	Sun Feb 22 14:35:13 2004
+++ b/include/linux/netfilter.h	Sun Feb 22 14:35:13 2004
@@ -119,12 +119,14 @@
 /* This is gross, but inline doesn't cut it for avoiding the function
    call in fast path: gcc doesn't inline (needs value tracking?). --RR */
 #ifdef CONFIG_NETFILTER_DEBUG
-#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
- nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn), INT_MIN)
+#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)		\
+(!(cond)									\
+ ? (okfn)(skb) 								\
+ : nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn), INT_MIN))
 #define NF_HOOK_THRESH nf_hook_slow
 #else
-#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
-(list_empty(&nf_hooks[(pf)][(hook)])					\
+#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)		\
+(!(cond) || list_empty(&nf_hooks[(pf)][(hook)])				\
  ? (okfn)(skb)								\
  : nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn), INT_MIN))
 #define NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, thresh)	\
@@ -132,6 +134,8 @@
  ? (okfn)(skb)								\
  : nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn), (thresh)))
 #endif
+#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
+ NF_HOOK_COND((pf), (hook), (skb), (indev), (outdev), (okfn), 1)
 
 int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
@@ -164,6 +168,7 @@
 
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
+#define NF_HOOK_COND NF_HOOK
 #endif /*CONFIG_NETFILTER*/
 
 #endif /*__KERNEL__*/
diff -Nru a/include/net/ip.h b/include/net/ip.h
--- a/include/net/ip.h	Sun Feb 22 14:35:13 2004
+++ b/include/net/ip.h	Sun Feb 22 14:35:13 2004
@@ -48,6 +48,7 @@
 #define IPSKB_TRANSLATED	2
 #define IPSKB_FORWARDED		4
 #define IPSKB_XFRM_TUNNEL_SIZE	8
+#define IPSKB_XFRM_TRANSFORMED	16
 };
 
 struct ipcm_cookie
diff -Nru a/net/ipv4/ah4.c b/net/ipv4/ah4.c
--- a/net/ipv4/ah4.c	Sun Feb 22 14:35:13 2004
+++ b/net/ipv4/ah4.c	Sun Feb 22 14:35:13 2004
@@ -145,6 +145,7 @@
 		err = -EHOSTUNREACH;
 		goto error_nolock;
 	}
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 	return NET_XMIT_BYPASS;
 
 error:
diff -Nru a/net/ipv4/esp4.c b/net/ipv4/esp4.c
--- a/net/ipv4/esp4.c	Sun Feb 22 14:35:13 2004
+++ b/net/ipv4/esp4.c	Sun Feb 22 14:35:13 2004
@@ -199,6 +199,7 @@
 		err = -EHOSTUNREACH;
 		goto error_nolock;
 	}
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 	return NET_XMIT_BYPASS;
 
 error:
diff -Nru a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
--- a/net/ipv4/ip_forward.c	Sun Feb 22 14:35:13 2004
+++ b/net/ipv4/ip_forward.c	Sun Feb 22 14:35:13 2004
@@ -51,7 +51,8 @@
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
-	return dst_output(skb);
+	return NF_HOOK_COND(PF_INET, NF_IP_POST_ROUTING, skb, NULL,
+	                    skb->dst->dev, dst_output, skb->dst->xfrm != NULL);
 }
 
 int ip_forward(struct sk_buff *skb)
diff -Nru a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c	Sun Feb 22 14:35:13 2004
+++ b/net/ipv4/ip_output.c	Sun Feb 22 14:35:13 2004
@@ -122,6 +122,12 @@
 	return ttl;
 }
 
+static inline int ip_dst_output(struct sk_buff *skb)
+{
+	return NF_HOOK_COND(PF_INET, NF_IP_POST_ROUTING, skb, NULL,
+	                    skb->dst->dev, dst_output, skb->dst->xfrm != NULL);
+}
+
 /* 
  *		Add an ip header to a skbuff and send it out.
  *
@@ -164,7 +170,7 @@
 
 	/* Send it out. */
 	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		       dst_output);
+		       ip_dst_output);
 }
 
 static inline int ip_finish_output2(struct sk_buff *skb)
@@ -282,7 +288,7 @@
 		return ip_finish_output(skb);
 }
 
-int ip_output(struct sk_buff *skb)
+static inline int ip_output2(struct sk_buff *skb)
 {
 	IP_INC_STATS(IpOutRequests);
 
@@ -293,6 +299,16 @@
 		return ip_finish_output(skb);
 }
 
+int ip_output(struct sk_buff *skb)
+{
+	int transformed = IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED;
+
+	if (transformed)
+		nf_reset(skb);
+	return NF_HOOK_COND(PF_INET, NF_IP_LOCAL_OUT, skb, NULL,
+	                    skb->dst->dev, ip_output2, transformed);
+}
+
 int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 {
 	struct sock *sk = skb->sk;
@@ -386,7 +402,7 @@
 	skb->priority = sk->sk_priority;
 
 	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		       dst_output);
+		       ip_dst_output);
 
 no_route:
 	IP_INC_STATS(IpOutNoRoutes);
@@ -1165,7 +1181,7 @@
 
 	/* Netfilter gets whole the not fragmented skb. */
 	err = NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, 
-		      skb->dst->dev, dst_output);
+		      skb->dst->dev, ip_dst_output);
 	if (err) {
 		if (err > 0)
 			err = inet->recverr ? net_xmit_errno(err) : 0;
diff -Nru a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
--- a/net/ipv4/ipcomp.c	Sun Feb 22 14:35:13 2004
+++ b/net/ipv4/ipcomp.c	Sun Feb 22 14:35:13 2004
@@ -231,6 +231,7 @@
 		err = -EHOSTUNREACH;
 		goto error_nolock;
 	}
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 	err = NET_XMIT_BYPASS;
 
 out_exit:
diff -Nru a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
--- a/net/ipv4/xfrm4_tunnel.c	Sun Feb 22 14:35:13 2004
+++ b/net/ipv4/xfrm4_tunnel.c	Sun Feb 22 14:35:13 2004
@@ -76,6 +76,7 @@
 		err = -EHOSTUNREACH;
 		goto error_nolock;
 	}
+	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
 	return NET_XMIT_BYPASS;
 
 error_nolock:

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="03-input-hooks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-input-hooks.diff"

===== include/linux/netfilter_ipv4.h 1.6 vs edited =====
--- 1.6/include/linux/netfilter_ipv4.h	Wed Jan  7 06:38:33 2004
+++ edited/include/linux/netfilter_ipv4.h	Sun Feb 22 19:25:19 2004
@@ -83,6 +83,21 @@
    Returns true or false. */
 extern int skb_ip_make_writable(struct sk_buff **pskb,
 				unsigned int writable_len);
+
+#ifdef CONFIG_XFRM
+extern int nf_postxfrm_input(struct sk_buff *skb);
+extern int nf_postxfrm_nonlocal(struct sk_buff *skb);
+#else /* CONFIG_XFRM */
+static inline int nf_postxfrm_input(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_postxfrm_nonlocal(struct sk_buff *skb)
+{
+	return 0;
+}
+#endif /* CONFIG_XFRM */
 #endif /*__KERNEL__*/
 
 #endif /*__LINUX_IP_NETFILTER_H*/
===== include/net/protocol.h 1.10 vs edited =====
--- 1.10/include/net/protocol.h	Sat May 10 14:25:34 2003
+++ edited/include/net/protocol.h	Sun Feb 22 19:25:08 2004
@@ -39,6 +39,7 @@
 	int			(*handler)(struct sk_buff *skb);
 	void			(*err_handler)(struct sk_buff *skb, u32 info);
 	int			no_policy;
+	int			xfrm_prot;
 };
 
 #if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
===== net/core/netfilter.c 1.26 vs edited =====
--- 1.26/net/core/netfilter.c	Sun Sep 28 18:34:18 2003
+++ edited/net/core/netfilter.c	Sun Feb 22 19:25:19 2004
@@ -11,6 +11,7 @@
  */
 #include <linux/config.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <net/protocol.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
@@ -25,6 +26,7 @@
 #include <linux/icmp.h>
 #include <net/sock.h>
 #include <net/route.h>
+#include <net/xfrm.h>
 #include <linux/ip.h>
 
 #define __KERNEL_SYSCALLS__
@@ -628,9 +630,6 @@
 	struct dst_entry *odst;
 	unsigned int hh_len;
 
-	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
-	 * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
-	 */
 	if (inet_addr_type(iph->saddr) == RTN_LOCAL) {
 		fl.nl_u.ip4_u.daddr = iph->daddr;
 		fl.nl_u.ip4_u.saddr = iph->saddr;
@@ -681,6 +680,54 @@
 
 	return 0;
 }
+
+#ifdef CONFIG_XFRM
+static inline int nf_postxfrm_done(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_postxfrm_input2(struct sk_buff *skb)
+{
+	if (inet_addr_type(skb->nh.iph->daddr) != RTN_LOCAL) {
+		if (ip_route_me_harder(&skb) == 0)
+			dst_input(skb);
+		else
+			kfree_skb(skb);
+		return -1;
+	}
+
+	return NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+	               nf_postxfrm_done);
+}
+
+int nf_postxfrm_input(struct sk_buff *skb)
+{
+	int off = skb->data - skb->nh.raw;
+
+	__skb_push(skb, off);
+	/* Fix header len and checksum if last xfrm was transport mode */
+	if (!skb->sp->x[skb->sp->len - 1].xvec->props.mode) {
+		skb->nh.iph->tot_len = htons(skb->len);
+		ip_send_check(skb->nh.iph);
+	}
+
+	nf_reset(skb);
+	if (NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, skb->dev, NULL,
+	            nf_postxfrm_input2) != 0)
+		return -1;
+
+	__skb_pull(skb, off);
+	return 0;
+}
+
+int nf_postxfrm_nonlocal(struct sk_buff *skb)
+{
+	nf_reset(skb);
+	return NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, skb->dev, NULL,
+	               nf_postxfrm_done);
+}
+#endif /* CONFIG_XFRM */
 
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
===== net/ipv4/ah4.c 1.30 vs edited =====
--- 1.30/net/ipv4/ah4.c	Sun Feb 22 14:28:58 2004
+++ edited/net/ipv4/ah4.c	Sun Feb 22 19:25:08 2004
@@ -344,6 +344,7 @@
 	.handler	=	xfrm4_rcv,
 	.err_handler	=	ah4_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init ah4_init(void)
===== net/ipv4/esp4.c 1.36 vs edited =====
--- 1.36/net/ipv4/esp4.c	Sun Feb 22 14:28:58 2004
+++ edited/net/ipv4/esp4.c	Sun Feb 22 19:25:09 2004
@@ -575,6 +575,7 @@
 	.handler	=	xfrm4_rcv,
 	.err_handler	=	esp4_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init esp4_init(void)
===== net/ipv4/ip_input.c 1.21 vs edited =====
--- 1.21/net/ipv4/ip_input.c	Sun Feb 22 14:27:39 2004
+++ edited/net/ipv4/ip_input.c	Sun Feb 22 21:20:47 2004
@@ -224,6 +224,12 @@
 	resubmit:
 		hash = protocol & (MAX_INET_PROTOS - 1);
 		raw_sk = sk_head(&raw_v4_htable[hash]);
+		ipprot = inet_protos[hash];
+		smp_read_barrier_depends();
+
+		if (skb->sp && !ipprot->xfrm_prot)
+			if (nf_postxfrm_input(skb))
+				goto out;
 
 		/* If there maybe a raw socket we must check - if not we
 		 * don't care less
@@ -231,10 +237,9 @@
 		if (raw_sk)
 			raw_v4_input(skb, skb->nh.iph, hash);
 
-		if ((ipprot = inet_protos[hash]) != NULL) {
+		if (ipprot != NULL) {
 			int ret;
 
-			smp_read_barrier_depends();
 			if (!ipprot->no_policy &&
 			    !xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 				kfree_skb(skb);
@@ -279,8 +284,8 @@
 			return 0;
 	}
 
-	return NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
-		       ip_local_deliver_finish);
+	return NF_HOOK_COND(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+	                    ip_local_deliver_finish, !skb->sp);
 }
 
 static inline int ip_rcv_finish(struct sk_buff *skb)
@@ -346,6 +351,10 @@
 		}
 	}
 
+	if (skb->sp && !(((struct rtable *)skb->dst)->rt_flags&RTCF_LOCAL))
+		if (nf_postxfrm_nonlocal(skb))
+			goto drop;
+
 	return dst_input(skb);
 
 inhdr_error:
@@ -418,8 +427,8 @@
 		}
 	}
 
-	return NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
-		       ip_rcv_finish);
+	return NF_HOOK_COND(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
+	                    ip_rcv_finish, !skb->sp);
 
 inhdr_error:
 	IP_INC_STATS_BH(IpInHdrErrors);
===== net/ipv4/ipcomp.c 1.19 vs edited =====
--- 1.19/net/ipv4/ipcomp.c	Sun Feb 22 14:28:58 2004
+++ edited/net/ipv4/ipcomp.c	Sun Feb 22 19:25:09 2004
@@ -408,6 +408,7 @@
 	.handler	=	xfrm4_rcv,
 	.err_handler	=	ipcomp4_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init ipcomp4_init(void)
===== net/ipv4/xfrm4_tunnel.c 1.10 vs edited =====
--- 1.10/net/ipv4/xfrm4_tunnel.c	Sun Feb 22 14:28:58 2004
+++ edited/net/ipv4/xfrm4_tunnel.c	Sun Feb 22 19:25:10 2004
@@ -171,6 +171,7 @@
 	.handler	=	ipip_rcv,
 	.err_handler	=	ipip_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init ipip_init(void)

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="04-nat-policy_lookup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-nat-policy_lookup.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/22 14:31:33+01:00 kaber@trash.net 
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any change
#   in route/policy key
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/02/22 14:31:26+01:00 kaber@trash.net +72 -8
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any change
#   in route/policy key
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/02/22 14:31:26+01:00 kaber@trash.net +1 -0
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any change
#   in route/policy key
# 
# net/core/netfilter.c
#   2004/02/22 14:31:26+01:00 kaber@trash.net +15 -0
#   Add policy lookups to ip_route_me_harder, make NAT reroute for any change
#   in route/policy key
# 
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	Sun Feb 22 14:35:30 2004
+++ b/net/core/netfilter.c	Sun Feb 22 14:35:30 2004
@@ -27,6 +27,7 @@
 #include <net/sock.h>
 #include <net/route.h>
 #include <net/xfrm.h>
+#include <net/ip.h>
 #include <linux/ip.h>
 
 #define __KERNEL_SYSCALLS__
@@ -663,6 +664,20 @@
 	
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
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	Sun Feb 22 14:35:30 2004
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	Sun Feb 22 14:35:30 2004
@@ -489,6 +489,7 @@
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(ip_conntrack_get);
+EXPORT_SYMBOL(__ip_conntrack_confirm);
 EXPORT_SYMBOL(need_ip_conntrack);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	Sun Feb 22 14:35:30 2004
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	Sun Feb 22 14:35:30 2004
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

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="05-nat-policy_checks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-nat-policy_checks.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/22 14:33:14+01:00 kaber@trash.net 
#   Make policy checks find correct policy after NAT
# 
# net/xfrm/xfrm_policy.c
#   2004/02/22 14:33:07+01:00 kaber@trash.net +2 -0
#   Make policy checks find correct policy after NAT
# 
# net/ipv4/udp.c
#   2004/02/22 14:33:07+01:00 kaber@trash.net +2 -0
#   Make policy checks find correct policy after NAT
# 
# net/ipv4/tcp_ipv4.c
#   2004/02/22 14:33:07+01:00 kaber@trash.net +1 -0
#   Make policy checks find correct policy after NAT
# 
# net/ipv4/raw.c
#   2004/02/22 14:33:07+01:00 kaber@trash.net +1 -0
#   Make policy checks find correct policy after NAT
# 
# net/ipv4/ip_input.c
#   2004/02/22 14:33:07+01:00 kaber@trash.net +6 -8
#   Make policy checks find correct policy after NAT
# 
# net/core/netfilter.c
#   2004/02/22 14:33:07+01:00 kaber@trash.net +43 -0
#   Make policy checks find correct policy after NAT
# 
# include/linux/netfilter.h
#   2004/02/22 14:33:07+01:00 kaber@trash.net +16 -0
#   Make policy checks find correct policy after NAT
# 
diff -Nru a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h	Sun Feb 22 14:35:36 2004
+++ b/include/linux/netfilter.h	Sun Feb 22 14:35:36 2004
@@ -171,5 +171,21 @@
 #define NF_HOOK_COND NF_HOOK
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
--- a/net/core/netfilter.c	Sun Feb 22 14:35:36 2004
+++ b/net/core/netfilter.c	Sun Feb 22 14:35:36 2004
@@ -747,6 +747,49 @@
 	return NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, skb->dev, NULL,
 	               nf_postxfrm_done);
 }
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
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
+#endif /* CONFIG_IP_NF_NAT_NEEDED */
 #endif /* CONFIG_XFRM */
 
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
diff -Nru a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c	Sun Feb 22 14:35:36 2004
+++ b/net/ipv4/ip_input.c	Sun Feb 22 14:35:36 2004
@@ -206,10 +206,6 @@
 
 	__skb_pull(skb, ihl);
 
-	/* Free reference early: we don't need it any more, and it may
-           hold ip_conntrack module loaded indefinitely. */
-	nf_reset(skb);
-
         /* Point into the IP datagram, just past the header. */
         skb->h.raw = skb->data;
 
@@ -240,10 +236,12 @@
 		if (ipprot != NULL) {
 			int ret;
 
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
--- a/net/ipv4/raw.c	Sun Feb 22 14:35:36 2004
+++ b/net/ipv4/raw.c	Sun Feb 22 14:35:36 2004
@@ -249,6 +249,7 @@
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset(skb);
 
 	skb_push(skb, skb->data - skb->nh.raw);
 
diff -Nru a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c	Sun Feb 22 14:35:36 2004
+++ b/net/ipv4/tcp_ipv4.c	Sun Feb 22 14:35:36 2004
@@ -1785,6 +1785,7 @@
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset(skb);
 
 	if (sk_filter(sk, skb, 0))
 		goto discard_and_relse;
diff -Nru a/net/ipv4/udp.c b/net/ipv4/udp.c
--- a/net/ipv4/udp.c	Sun Feb 22 14:35:36 2004
+++ b/net/ipv4/udp.c	Sun Feb 22 14:35:36 2004
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
--- a/net/xfrm/xfrm_policy.c	Sun Feb 22 14:35:36 2004
+++ b/net/xfrm/xfrm_policy.c	Sun Feb 22 14:35:36 2004
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

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="06-policy-match.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-policy-match.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/03/02 06:08:55+01:00 kaber@trash.net 
#   Add policy match
# 
# net/ipv4/netfilter/ipt_policy.c
#   2004/03/02 06:08:46+01:00 kaber@trash.net +176 -0
# 
# include/linux/netfilter_ipv4/ipt_policy.h
#   2004/03/02 06:08:46+01:00 kaber@trash.net +52 -0
# 
# net/ipv4/netfilter/ipt_policy.c
#   2004/03/02 06:08:46+01:00 kaber@trash.net +0 -0
#   BitKeeper file /home/kaber/src/nf/ipsec/linux-2.6/net/ipv4/netfilter/ipt_policy.c
# 
# net/ipv4/netfilter/Makefile
#   2004/03/02 06:08:46+01:00 kaber@trash.net +1 -0
#   Add policy match
# 
# net/ipv4/netfilter/Kconfig
#   2004/03/02 06:08:46+01:00 kaber@trash.net +10 -0
#   Add policy match
# 
# include/linux/netfilter_ipv4/ipt_policy.h
#   2004/03/02 06:08:46+01:00 kaber@trash.net +0 -0
#   BitKeeper file /home/kaber/src/nf/ipsec/linux-2.6/include/linux/netfilter_ipv4/ipt_policy.h
# 
diff -Nru a/include/linux/netfilter_ipv4/ipt_policy.h b/include/linux/netfilter_ipv4/ipt_policy.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/linux/netfilter_ipv4/ipt_policy.h	Tue Mar  2 06:53:14 2004
@@ -0,0 +1,52 @@
+#ifndef _IPT_POLICY_H
+#define _IPT_POLICY_H
+
+#define POLICY_MAX_ELEM	4
+
+enum ipt_policy_flags
+{
+	POLICY_MATCH_IN		= 0x1,
+	POLICY_MATCH_OUT	= 0x2,
+	POLICY_MATCH_NONE	= 0x4,
+	POLICY_MATCH_STRICT	= 0x8,
+};
+
+enum ipt_policy_modes
+{
+	POLICY_MODE_TRANSPORT,
+	POLICY_MODE_TUNNEL
+};
+
+struct ipt_policy_spec
+{
+	u_int8_t	saddr:1,
+			daddr:1,
+			proto:1,
+			mode:1,
+			spi:1,
+			reqid:1;
+};
+
+struct ipt_policy_elem
+{
+	u_int32_t	saddr;
+	u_int32_t	smask;
+	u_int32_t	daddr;
+	u_int32_t	dmask;
+	u_int32_t	spi;
+	u_int32_t	reqid;
+	u_int8_t	proto;
+	u_int8_t	mode;
+
+	struct ipt_policy_spec	match;
+	struct ipt_policy_spec	invert;
+};
+
+struct ipt_policy_info
+{
+	struct ipt_policy_elem pol[POLICY_MAX_ELEM];
+	u_int16_t flags;
+	u_int16_t len;
+};
+
+#endif /* _IPT_POLICY_H */
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	Tue Mar  2 06:53:14 2004
+++ b/net/ipv4/netfilter/Kconfig	Tue Mar  2 06:53:14 2004
@@ -127,6 +127,16 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_MATCH_POLICY
+	tristate "IPsec policy match support"
+	depends on IP_NF_IPTABLES && XFRM
+	help
+	  Policy matching allows you to match packets based on the
+	  IPsec policy that was used during decapsulation/will
+	  be used during encapsulation.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_MATCH_MARK
 	tristate "netfilter MARK match support"
 	depends on IP_NF_IPTABLES
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	Tue Mar  2 06:53:14 2004
+++ b/net/ipv4/netfilter/Makefile	Tue Mar  2 06:53:14 2004
@@ -65,6 +65,7 @@
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
 
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
+obj-$(CONFIG_IP_NF_MATCH_POLICY) += ipt_policy.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Nru a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/net/ipv4/netfilter/ipt_policy.c	Tue Mar  2 06:53:14 2004
@@ -0,0 +1,176 @@
+/* IP tables module for matching IPsec policy
+ *
+ * Copyright (c) 2004 Patrick McHardy, <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <net/xfrm.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ipt_policy.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("IPtables IPsec policy matching module");
+MODULE_LICENSE("GPL");
+
+
+static inline int
+match_xfrm_state(struct xfrm_state *x, const struct ipt_policy_elem *e)
+{
+#define MISMATCH(x,y)	(e->match.x && ((e->x != (y)) ^ e->invert.x))
+
+	if (MISMATCH(saddr, x->props.saddr.a4 & e->smask) ||
+	    MISMATCH(daddr, x->id.daddr.a4 & e->dmask) ||
+	    MISMATCH(proto, x->id.proto) ||
+	    MISMATCH(mode, x->props.mode) ||
+	    MISMATCH(spi, x->id.spi) ||
+	    MISMATCH(reqid, x->props.reqid))
+		return 0;
+	return 1;
+}
+
+static int
+match_policy_in(const struct sk_buff *skb, const struct ipt_policy_info *info)
+{
+	const struct ipt_policy_elem *e;
+	struct sec_path *sp = skb->sp;
+	int strict = info->flags & POLICY_MATCH_STRICT;
+	int i, pos;
+
+	if (sp == NULL)
+		return -1;
+	if (strict && info->len != sp->len)
+		return 0;
+
+	for (i = sp->len - 1; i >= 0; i--) {
+		pos = strict ? i - sp->len + 1 : 0;
+		if (pos >= info->len)
+			return 0;
+		e = &info->pol[pos];
+
+		if (match_xfrm_state(sp->x[i].xvec, e)) {
+			if (!strict)
+				return 1;
+		} else if (strict)
+			return 0;
+	}
+
+	return strict ? 1 : 0;
+}
+
+static int
+match_policy_out(const struct sk_buff *skb, const struct ipt_policy_info *info)
+{
+	const struct ipt_policy_elem *e;
+	struct dst_entry *dst = skb->dst;
+	int strict = info->flags & POLICY_MATCH_STRICT;
+	int i, pos;
+
+	if (dst->xfrm == NULL)
+		return -1;
+
+	for (i = 0; dst && dst->xfrm; dst = dst->child, i++) {
+		pos = strict ? i : 0;
+		if (pos >= info->len)
+			return 0;
+		e = &info->pol[pos];
+
+		if (match_xfrm_state(dst->xfrm, e)) {
+			if (!strict)
+				return 1;
+		} else if (strict)
+			return 0;
+	}
+
+	return strict ? 1 : 0;
+}
+
+static int match(const struct sk_buff *skb,
+                 const struct net_device *in,
+                 const struct net_device *out,
+                 const void *matchinfo, int offset, int *hotdrop)
+{
+	const struct ipt_policy_info *info = matchinfo;
+	int ret;
+
+	if (info->flags & POLICY_MATCH_IN)
+		ret = match_policy_in(skb, info);
+	else
+		ret = match_policy_out(skb, info);
+
+	if (ret < 0) {
+		if (info->flags & POLICY_MATCH_NONE)
+			ret = 1;
+		else
+			ret = 0;
+	} else if (info->flags & POLICY_MATCH_NONE)
+		ret = 0;
+
+	return ret;
+}
+
+static int checkentry(const char *tablename, const struct ipt_ip *ip,
+                      void *matchinfo, unsigned int matchsize,
+                      unsigned int hook_mask)
+{
+	struct ipt_policy_info *info = matchinfo;
+
+	if (matchsize != IPT_ALIGN(sizeof(*info))) {
+		printk(KERN_ERR "ipt_policy: matchsize %u != %u\n",
+		       matchsize, IPT_ALIGN(sizeof(*info)));
+		return 0;
+	}
+	if (!(info->flags & (POLICY_MATCH_IN|POLICY_MATCH_OUT))) {
+		printk(KERN_ERR "ipt_policy: neither incoming nor "
+		                "outgoing policy selected\n");
+		return 0;
+	}
+	if (hook_mask & (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_LOCAL_IN)
+	    && info->flags & POLICY_MATCH_OUT) {
+		printk(KERN_ERR "ipt_policy: output policy not valid in "
+		                "PRE_ROUTING and INPUT\n");
+		return 0;
+	}
+	if (hook_mask & (1 << NF_IP_POST_ROUTING | 1 << NF_IP_LOCAL_OUT)
+	    && info->flags & POLICY_MATCH_IN) {
+		printk(KERN_ERR "ipt_policy: input policy not valid in "
+		                "POST_ROUTING and OUTPUT\n");
+		return 0;
+	}
+	if (info->len > POLICY_MAX_ELEM) {
+		printk(KERN_ERR "ipt_policy: too many policy elements\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_match policy_match =
+{
+	.name		= "policy",
+	.match		= match,
+	.checkentry 	= checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&policy_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&policy_match);
+}
+
+module_init(init);
+module_exit(fini);

--------------060704090701060106030300
Content-Type: text/x-patch;
 name="libipt_policy.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_policy.diff"

diff -urN a/extensions/.policy-test b/extensions/.policy-test
--- a/extensions/.policy-test	2004-02-23 20:39:37.000000000 +0100
+++ b/extensions/.policy-test	2004-03-04 21:41:39.000000000 +0100
@@ -1,2 +1,3 @@
 #!/bin/sh
-[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_policy.c -a -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_policy.h ] && echo policy
+#
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_policy.h ] && echo policy
diff -urN a/extensions/libipt_policy.c b/extensions/libipt_policy.c
--- a/extensions/libipt_policy.c	2004-02-23 20:38:37.000000000 +0100
+++ b/extensions/libipt_policy.c	2004-03-04 21:41:32.000000000 +0100
@@ -1,3 +1,4 @@
+/* Shared library add-on to iptables to add policy support. */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -14,72 +15,82 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_policy.h>
 
+/* 
+ * HACK: global pointer to current matchinfo for making
+ * final checks and adjustments in final_check.
+ */
+static struct ipt_policy_info *policy_info;
+
 static void help(void)
 {
 	printf(
 "policy v%s options:\n"
-"[!] --reqid reqid		Match reqid\n"
-"[!] --spi spi			Match SPI\n"
-"[!] --proto proto		Match protocol (ah/esp/ipcomp)\n"
-"[!] --mode mode 		Match mode (transport/tunnel)\n"
-"[!] --local addr/mask		Match local tunnel endpoint\n"
-"[!] --remote addr/mask		Match remote tunnel endpoint\n"
-"  --path 			Match path instead of single element at\n"
-"				any position\n"
-"  --next 			Begin next element in path\n",
+"  --dir in|out			match policy applied during decapsulation/\n"
+"				policy to be applied during encapsulation\n"
+"  --pol none|ipsec		match policy\n"
+"  --strict 			match entire policy instead of single element\n"
+"				at any position\n"
+"[!] --reqid reqid		match reqid\n"
+"[!] --spi spi			match SPI\n"
+"[!] --proto proto		match protocol (ah/esp/ipcomp)\n"
+"[!] --mode mode 		match mode (transport/tunnel)\n"
+"[!] --tunnel-src addr/mask	match tunnel source\n"
+"[!] --tunnel-dst addr/mask	match tunnel destination\n"
+"  --next 			begin next element in policy\n",
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static struct option opts[] =
+{
 	{
-		.name		= "reqid",
+		.name		= "dir",
 		.has_arg	= 1,
-		.flag		= 0,
 		.val		= '1',
 	},
 	{
-		.name		= "spi",
+		.name		= "pol",
 		.has_arg	= 1,
-		.flag		= 0,
-		.val		= '2'
+		.val		= '2',
 	},
 	{
-		.name		= "local",
-		.has_arg	= 1,
-		.flag		= 0,
+		.name		= "strict",
 		.val		= '3'
 	},
 	{
-		.name		= "remote",
+		.name		= "reqid",
 		.has_arg	= 1,
-		.flag		= 0,
-		.val		= '4'
+		.val		= '4',
 	},
 	{
-		.name		= "proto",
+		.name		= "spi",
 		.has_arg	= 1,
-		.flag		= 0,
 		.val		= '5'
 	},
 	{
-		.name		= "mode",
+		.name		= "tunnel-src",
 		.has_arg	= 1,
-		.flag		= 0,
 		.val		= '6'
 	},
 	{
-		.name		= "path",
-		.has_arg	= 0,
-		.flag		= 0,
+		.name		= "tunnel-dst",
+		.has_arg	= 1,
 		.val		= '7'
 	},
 	{
-		.name		= "next",
-		.has_arg	= 0,
-		.flag		= 0,
+		.name		= "proto",
+		.has_arg	= 1,
 		.val		= '8'
 	},
-	{ 0 }
+	{
+		.name		= "mode",
+		.has_arg	= 1,
+		.val		= '9'
+	},
+	{
+		.name		= "next",
+		.val		= 'a'
+	},
+	{ }
 };
 
 static void init(struct ipt_entry_match *m, unsigned int *nfcache)
@@ -87,154 +98,201 @@
 	*nfcache |= NFC_UNKNOWN;
 }
 
+static int parse_direction(char *s)
+{
+	if (strcmp(s, "in") == 0)
+		return POLICY_MATCH_IN;
+	if (strcmp(s, "out") == 0)
+		return POLICY_MATCH_OUT;
+	exit_error(PARAMETER_PROBLEM, "policy_match: invalid dir `%s'", s);
+}
+
+static int parse_policy(char *s)
+{
+	if (strcmp(s, "none") == 0)
+		return POLICY_MATCH_NONE;
+	if (strcmp(s, "ipsec") == 0)
+		return 0;
+	exit_error(PARAMETER_PROBLEM, "policy match: invalid policy `%s'", s);
+}
+
 static int parse_mode(char *s)
 {
 	if (strcmp(s, "transport") == 0)
-		return SECPATH_MODE_TRANSPORT;
+		return POLICY_MODE_TRANSPORT;
 	if (strcmp(s, "tunnel") == 0)
-		return SECPATH_MODE_TUNNEL;
-	return -EINVAL;
+		return POLICY_MODE_TUNNEL;
+	exit_error(PARAMETER_PROBLEM, "policy match: invalid mode `%s'", s);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *i,
+static int parse(int c, char **argv, int invert, unsigned int *flags,
                  const struct ipt_entry *entry,
                  unsigned int *nfcache,
                  struct ipt_entry_match **match)
 {
 	struct ipt_policy_info *info = (void *)(*match)->data;
-	struct ipt_policy_elem *e = &info->path[*i];
+	struct ipt_policy_elem *e = &info->pol[info->len];
 	struct in_addr *addr = NULL, mask;
-	struct protoent *p;
 	unsigned int naddr = 0;
-	int mode, proto;
+	int mode;
 
 	check_inverse(optarg, &invert, &optind, 0);
 
 	switch (c) {
 	case '1':
+		if (info->flags & (POLICY_MATCH_IN|POLICY_MATCH_OUT))
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --dir option");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --dir option");
+
+		info->flags |= parse_direction(argv[optind-1]);
+		break;
+	case '2':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --policy option");
+
+		info->flags |= parse_policy(argv[optind-1]);
+		break;
+	case '3':
+		if (info->flags & POLICY_MATCH_STRICT)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --strict option");
+
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --strict option");
+
+		info->flags |= POLICY_MATCH_STRICT;
+		break;
+	case '4':
 		if (e->match.reqid)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --reqid twice");
+			           "policy match: double --reqid option");
 
 		e->match.reqid = 1;
 		e->invert.reqid = invert;
 		e->reqid = strtol(argv[optind-1], NULL, 10);
 		break;
-	case '2':
+	case '5':
 		if (e->match.spi)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --spi twice");
+			           "policy match: double --spi option");
 		
 		e->match.spi = 1;
 		e->invert.spi = invert;
 		e->spi = strtol(argv[optind-1], NULL, 0x10);
 		break;
-	case '3':
-		if (e->match.daddr)
-			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --local twice");
-		
-		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
-		if (naddr > 1)
-			exit_error(PARAMETER_PROBLEM,
-			           "Multiple IP addresses are not allowed");
-
-		e->match.daddr = 1;
-		e->invert.daddr = invert;
-		e->daddr = addr[0].s_addr;
-		e->dmask = mask.s_addr;
-		break;
-	case '4':
+	case '6':
 		if (e->match.saddr)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --remote twice");
+			           "policy match: double --tunnel-src option");
 
 		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
-			           "Multiple IP addresses are not allowed");
+			           "policy match: name resolves to multiple IPs");
 
 		e->match.saddr = 1;
 		e->invert.saddr = invert;
 		e->saddr = addr[0].s_addr;
 		e->smask = mask.s_addr;
                 break;
-	case '5':
-		if (e->match.proto)
+	case '7':
+		if (e->match.daddr)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --tunnel-dst option");
+
+		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --proto twice");
+			           "policy match: name resolves to multiple IPs");
 
-		p = getprotobyname(argv[optind-1]);
-		if (p != NULL)
-			proto = p->p_proto;
-		else if (!(proto = atoi(argv[optind-1])))
+		e->match.daddr = 1;
+		e->invert.daddr = invert;
+		e->daddr = addr[0].s_addr;
+		e->dmask = mask.s_addr;
+		break;
+	case '8':
+		if (e->match.proto)
 			exit_error(PARAMETER_PROBLEM,
-			           "Unknown protocol `%s'\n",
-			           argv[optind-1]);
+			           "policy match: double --proto option");
 
+		e->proto = parse_protocol(argv[optind-1]);
+		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
+		    e->proto != IPPROTO_COMP)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: protocol must ah/esp/ipcomp");
 		e->match.proto = 1;
 		e->invert.proto = invert;
-		e->proto = proto;
 		break;
-	case '6':
+	case '9':
 		if (e->match.mode)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --mode twice");
+			           "policy match: double --mode option");
 		
 		mode = parse_mode(argv[optind-1]);
-		if (mode < 0)
-			exit_error(PARAMETER_PROBLEM,
-			           "Unknown mode `%s'\n",
-			           argv[optind-1]);
-
 		e->match.mode = 1;
 		e->invert.mode = invert;
 		e->mode = mode;
 		break;
-	case '7':
-		if (info->flags & MATCH_PATH)
-			exit_error(PARAMETER_PROBLEM,
-			           "Can't specify --path twice");
-
+	case 'a':
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't invert `--path' option");
+			           "policy match: can't invert --next option");
 
-		info->flags |= MATCH_PATH;
-		break;
-	case '8':
-		if (invert)
+		if (++info->len == POLICY_MAX_ELEM)
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't invert `--next' option");
-
-		if (++(*i) == SECPATH_MAX_DEPTH)
-			exit_error(PARAMETER_PROBLEM,
-			           "Maximum path depth reached");
-
+			           "policy match: maximum policy depth reached");
 		break;
 	default:
 		return 0;
 	}
 
-	info->len = *i + 1;
+	policy_info = info;
 	return 1;
 }
 
 static void final_check(unsigned int flags)
 {
-	return;
-}
+	struct ipt_policy_info *info = policy_info;
+	struct ipt_policy_elem *e;
+	int i;
 
-static void print_proto(char *prefix, u_int8_t proto, int numeric)
-{
-	struct protoent *p = NULL;
+	if (info == NULL)
+		exit_error(PARAMETER_PROBLEM,
+		           "policy match: no parameters given");
 
-	if (!numeric)
-		p = getprotobynumber(proto);
-	if (p == NULL)
-		printf("%sproto %u ", prefix, proto);
-	else
-		printf("%sproto %s ", prefix, p->p_name);
+	if (!(info->flags & (POLICY_MATCH_IN|POLICY_MATCH_OUT)))
+		exit_error(PARAMETER_PROBLEM,
+		           "policy match: neither --in nor --out specified");
+
+	if (info->flags & POLICY_MATCH_NONE) {
+		if (info->flags & POLICY_MATCH_STRICT)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: policy none but --strict given");
+
+		if (info->len != 0)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: policy none but policy given");
+	} else
+		info->len++;	/* increase len by 1, no --next after last element */
+
+	if (!(info->flags & POLICY_MATCH_STRICT) && info->len > 1)
+		exit_error(PARAMETER_PROBLEM,
+		           "policy match: multiple elements but no --strict");
+
+	for (i = 0; i < info->len; i++) {
+		e = &info->pol[i];
+		if ((e->match.saddr || e->match.daddr)
+		    && ((e->mode == POLICY_MODE_TUNNEL && e->invert.mode) ||
+		        (e->mode == POLICY_MODE_TRANSPORT && !e->invert.mode)))
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: --tunnel-src/--tunnel-dst "
+			           "is only valid in tunnel mode");
+	}
 }
 
 static void print_mode(char *prefix, u_int8_t mode, int numeric)
@@ -242,10 +300,10 @@
 	printf("%smode ", prefix);
 
 	switch (mode) {
-	case SECPATH_MODE_TRANSPORT:
+	case POLICY_MODE_TRANSPORT:
 		printf("transport ");
 		break;
-	case SECPATH_MODE_TUNNEL:
+	case POLICY_MODE_TUNNEL:
 		printf("tunnel ");
 		break;
 	default:
@@ -273,7 +331,7 @@
 	}
 	if (e->match.proto) {
 		PRINT_INVERT(e->invert.proto);
-		print_proto(prefix, e->proto, numeric);
+		printf("%sproto %s ", prefix, proto_to_name(e->proto, numeric));
 	}
 	if (e->match.mode) {
 		PRINT_INVERT(e->invert.mode);
@@ -281,18 +339,34 @@
 	}
 	if (e->match.daddr) {
 		PRINT_INVERT(e->invert.daddr);
-		printf("%slocal %s%s ", prefix,
+		printf("%stunnel-dst %s%s ", prefix,
 		       addr_to_dotted((struct in_addr *)&e->daddr),
 		       mask_to_dotted((struct in_addr *)&e->dmask));
 	}
 	if (e->match.saddr) {
 		PRINT_INVERT(e->invert.saddr);
-		printf("%sremote %s%s ", prefix,
+		printf("%stunnel-src %s%s ", prefix,
 		       addr_to_dotted((struct in_addr *)&e->saddr),
 		       mask_to_dotted((struct in_addr *)&e->smask));
 	}
 }
 
+static void print_flags(char *prefix, const struct ipt_policy_info *info)
+{
+	if (info->flags & POLICY_MATCH_IN)
+		printf("%sdir in ", prefix);
+	else
+		printf("%sdir out ", prefix);
+
+	if (info->flags & POLICY_MATCH_NONE)
+		printf("%spol none ", prefix);
+	else
+		printf("%spol ipsec ", prefix);
+
+	if (info->flags & POLICY_MATCH_STRICT)
+		printf("%sstrict ", prefix);
+}
+
 static void print(const struct ipt_ip *ip,
                   const struct ipt_entry_match *match,
 		  int numeric)
@@ -300,14 +374,12 @@
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
 
-	printf ("policy match ");
-	if (info->flags & MATCH_PATH)
-		printf("path ");
-
+	printf("policy match ");
+	print_flags("", info);
 	for (i = 0; i < info->len; i++) {
 		if (info->len > 1)
 			printf("[%u] ", i);
-		print_entry("", &info->path[i], numeric);
+		print_entry("", &info->pol[i], numeric);
 	}
 
 	printf("\n");
@@ -318,11 +390,9 @@
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
 
-	if (info->flags & MATCH_PATH)
-		printf("--path ");
-
+	print_flags("--", info);
 	for (i = 0; i < info->len; i++) {
-		print_entry("--", &info->path[i], 0);
+		print_entry("--", &info->pol[i], 0);
 		if (i + 1 < info->len)
 			printf("--next ");
 	}
@@ -332,18 +402,17 @@
 
 struct iptables_match policy =
 {
-	NULL,
-	"policy",
-	IPTABLES_VERSION,
-	IPT_ALIGN(sizeof(struct ipt_policy_info)),
-	IPT_ALIGN(sizeof(struct ipt_policy_info)),
-	&help,
-	&init,
-	&parse,
-	&final_check,
-	&print,
-	&save,
-	opts
+	.name		= "policy",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_policy_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_policy_info)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts
 };
 
 void _init(void)
diff -urN a/include/iptables.h b/include/iptables.h
--- a/include/iptables.h	2004-03-04 21:37:40.000000000 +0100
+++ b/include/iptables.h	2004-03-04 21:38:36.000000000 +0100
@@ -122,6 +122,7 @@
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
+extern char *proto_to_name(u_int8_t proto, int nolookup);
 extern struct in_addr *dotted_to_addr(const char *dotted);
 extern char *addr_to_dotted(const struct in_addr *addrp);
 extern char *addr_to_anyname(const struct in_addr *addr);
diff -urN a/iptables.c b/iptables.c
--- a/iptables.c	2004-02-24 18:28:50.000000000 +0100
+++ b/iptables.c	2004-03-04 21:39:18.000000000 +0100
@@ -235,11 +235,12 @@
 	{ "icmp", IPPROTO_ICMP },
 	{ "esp", IPPROTO_ESP },
 	{ "ah", IPPROTO_AH },
+	{ "ipcomp", IPPROTO_COMP },
 	{ "sctp", IPPROTO_SCTP },
 	{ "all", 0 },
 };
 
-static char *
+char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
 	unsigned int i;

--------------060704090701060106030300
Content-Type: text/plain;
 name="policy-test"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="policy-test"

#! /bin/bash

PATH="/usr/local/sbin"

iptables -F


iptables -A INPUT -m policy --dir in --pol none
iptables -A INPUT -m policy --dir in --pol ipsec
iptables -A INPUT -m policy --dir in --pol ipsec --mode tunnel
iptables -A INPUT -m policy --dir in --pol ipsec --mode transport
iptables -A INPUT -m policy --dir in --pol ipsec --proto ah
iptables -A INPUT -m policy --dir in --pol ipsec --proto esp
iptables -A INPUT -m policy --dir in --pol ipsec --strict --mode tunnel
iptables -A INPUT -m policy --dir in --pol ipsec --strict --mode transport
iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto ah
iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp
iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp --next --proto ah
iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp --mode tunnel --tunnel-src 192.168.0.1 --next --proto ah --mode transport
iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp --mode tunnel --tunnel-src 192.168.0.1 --tunnel-dst 192.168.0.23 --next --proto ah --mode transport


iptables -A OUTPUT -m policy --dir out --pol none
iptables -A OUTPUT -m policy --dir out --pol ipsec
iptables -A OUTPUT -m policy --dir out --pol ipsec --mode tunnel
iptables -A OUTPUT -m policy --dir out --pol ipsec --mode transport
iptables -A OUTPUT -m policy --dir out --pol ipsec --proto ah
iptables -A OUTPUT -m policy --dir out --pol ipsec --proto esp
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --mode tunnel
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --mode transport
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto ah
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp --next --proto ah
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-dst 192.168.0.0/24 --next --proto ah
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-dst ! 192.168.0.0/24 --next --proto ah
iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-dst 192.168.0.1 --next --proto ah --mode transport


--------------060704090701060106030300--
