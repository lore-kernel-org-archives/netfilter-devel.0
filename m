From: Patrick McHardy <kaber@trash.net>
Subject: Netfilter, IPsec & nf_queue
Date: Mon, 05 Apr 2004 16:44:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407170E7.6030608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020102050909050409030307"
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
--------------020102050909050409030307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

While continuing work on the input patch for Netfilter+IPsec, I noticed
two problems. The input-patch adds the nf_postxfrm_input and
nf_postxfrm_nonlocal functions which pass packets to the hooks after
decapsulation and return drop/continue to the caller. The NF_HOOK macro
can't be used, at least in ip_local_deliver_finish, because the function
can't be split up in an immediate part and an outfn-part. The 
nf_postxfrm_* functions pass a dummy-outfn to NF_HOOK and use the the
return code to decide what to do with the packet.

The first problem is that if the packet is replaced within a hook, it is
only visible to the dummy-outfn, not to the caller. This could be fixed
in multiple ways, for example by using a special nf_hook_slow function
which takes a struct sk_buff **, or by using per-cpu skb-pointers to
preserve the new skb in the dummy-outfn for the caller.

The second problem arises when packets are queued and reinjected from a
hook, nf_reinject will continue hook traversal and call the dummy-outfn
if everything is ok. The dummy-outfn will just return and leak the
packet.

I can't think of a way to fix the nf_reinject problem while retaining
the nf_postxfrm_* functions, and unfortunately (otherwise I would have
never added them) I also can't think of a way to do it without them.

Ideas ?

Regards
Patrick


--------------020102050909050409030307
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== include/linux/netfilter_ipv4.h 1.6 vs edited =====
--- 1.6/include/linux/netfilter_ipv4.h	Wed Jan  7 06:38:33 2004
+++ edited/include/linux/netfilter_ipv4.h	Mon Apr  5 02:54:11 2004
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
+++ edited/include/net/protocol.h	Mon Apr  5 02:54:12 2004
@@ -39,6 +39,7 @@
 	int			(*handler)(struct sk_buff *skb);
 	void			(*err_handler)(struct sk_buff *skb, u32 info);
 	int			no_policy;
+	int			xfrm_prot;
 };
 
 #if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
===== net/core/netfilter.c 1.28 vs edited =====
--- 1.28/net/core/netfilter.c	Mon Mar  8 20:55:24 2004
+++ edited/net/core/netfilter.c	Mon Apr  5 06:25:59 2004
@@ -11,6 +11,7 @@
  */
 #include <linux/config.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <net/protocol.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
@@ -25,6 +26,8 @@
 #include <linux/icmp.h>
 #include <net/sock.h>
 #include <net/route.h>
+#include <net/xfrm.h>
+#include <net/ip.h>
 #include <linux/ip.h>
 
 /* In this code, we can be waiting indefinitely for userspace to
@@ -625,9 +628,6 @@
 	struct dst_entry *odst;
 	unsigned int hh_len;
 
-	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
-	 * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
-	 */
 	if (inet_addr_type(iph->saddr) == RTN_LOCAL) {
 		fl.nl_u.ip4_u.daddr = iph->daddr;
 		fl.nl_u.ip4_u.saddr = iph->saddr;
@@ -679,6 +679,79 @@
 
 	return 0;
 }
+
+#ifdef CONFIG_XFRM
+static inline int nf_postxfrm_done(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_postxfrm_local_in(struct sk_buff *skb)
+{
+	return NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+	               nf_postxfrm_done);
+}
+
+static int nf_postxfrm_pre_routing(struct sk_buff *skb)
+{
+	struct dst_entry *dst;
+	struct iphdr *iph = skb->nh.iph;
+	u_int32_t saddr = iph->saddr;
+	u_int32_t daddr = iph->daddr;
+	u_int8_t tos = iph->tos;
+
+	nf_reset(skb);
+	if (NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, skb->dev, NULL,
+	            nf_postxfrm_done) != 0)
+		return -1;
+
+	iph = skb->nh.iph;
+	if (saddr == iph->saddr && daddr == iph->daddr && tos == iph->tos)
+		return 0;
+	dst = skb->dst;
+	if (ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, skb->dev)) {
+		kfree_skb(skb);
+		return -1;
+	}
+	dst_release(dst);
+	return 0;
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
+	if (!(IPCB(skb)->flags & 64)) {
+		if (nf_postxfrm_pre_routing(skb) != 0)
+			return -1;
+		if (!(((struct rtable *)skb->dst)->rt_flags&RTCF_LOCAL)) {
+			dst_input(skb);
+			return -1;
+		}
+	}
+	if (nf_postxfrm_local_in(skb) != 0)
+		return -1;
+
+	__skb_pull(skb, off);
+	return 0;
+}
+
+int nf_postxfrm_nonlocal(struct sk_buff *skb)
+{
+	if (nf_postxfrm_pre_routing(skb) != 0)
+		return -1;
+	if (((struct rtable *)skb->dst)->rt_flags&RTCF_LOCAL)
+		IPCB(skb)->flags |= 64;
+	return 0;
+}
+#endif /* CONFIG_XFRM */
 
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
===== net/ipv4/ah4.c 1.30 vs edited =====
--- 1.30/net/ipv4/ah4.c	Mon Apr  5 02:53:14 2004
+++ edited/net/ipv4/ah4.c	Mon Apr  5 02:54:12 2004
@@ -344,6 +344,7 @@
 	.handler	=	xfrm4_rcv,
 	.err_handler	=	ah4_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init ah4_init(void)
===== net/ipv4/esp4.c 1.37 vs edited =====
--- 1.37/net/ipv4/esp4.c	Mon Apr  5 02:53:14 2004
+++ edited/net/ipv4/esp4.c	Mon Apr  5 02:54:12 2004
@@ -577,6 +577,7 @@
 	.handler	=	xfrm4_rcv,
 	.err_handler	=	esp4_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init esp4_init(void)
===== net/ipv4/ip_input.c 1.21 vs edited =====
--- 1.21/net/ipv4/ip_input.c	Sun Apr  4 23:17:06 2004
+++ edited/net/ipv4/ip_input.c	Mon Apr  5 05:32:25 2004
@@ -224,6 +224,12 @@
 	resubmit:
 		hash = protocol & (MAX_INET_PROTOS - 1);
 		raw_sk = sk_head(&raw_v4_htable[hash]);
+		ipprot = inet_protos[hash];
+		smp_read_barrier_depends();
+
+		if (skb->sp && (!ipprot || !ipprot->xfrm_prot))
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
@@ -296,6 +301,10 @@
 		if (ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))
 			goto drop; 
 	}
+	if (skb->sp && !(((struct rtable *)skb->dst)->rt_flags&RTCF_LOCAL))
+		if (nf_postxfrm_nonlocal(skb))
+			goto out;
+
 
 #ifdef CONFIG_NET_CLS_ROUTE
 	if (skb->dst->tclassid) {
@@ -352,6 +361,7 @@
 	IP_INC_STATS_BH(IpInHdrErrors);
 drop:
         kfree_skb(skb);
+out:
         return NET_RX_DROP;
 }
 
@@ -418,8 +428,8 @@
 		}
 	}
 
-	return NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
-		       ip_rcv_finish);
+	return NF_HOOK_COND(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
+	                    ip_rcv_finish, !skb->sp);
 
 inhdr_error:
 	IP_INC_STATS_BH(IpInHdrErrors);
===== net/ipv4/ipcomp.c 1.19 vs edited =====
--- 1.19/net/ipv4/ipcomp.c	Mon Apr  5 02:53:14 2004
+++ edited/net/ipv4/ipcomp.c	Mon Apr  5 02:54:12 2004
@@ -408,6 +408,7 @@
 	.handler	=	xfrm4_rcv,
 	.err_handler	=	ipcomp4_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init ipcomp4_init(void)
===== net/ipv4/xfrm4_tunnel.c 1.10 vs edited =====
--- 1.10/net/ipv4/xfrm4_tunnel.c	Mon Apr  5 02:53:14 2004
+++ edited/net/ipv4/xfrm4_tunnel.c	Mon Apr  5 02:54:13 2004
@@ -171,6 +171,7 @@
 	.handler	=	ipip_rcv,
 	.err_handler	=	ipip_err,
 	.no_policy	=	1,
+	.xfrm_prot	=	1,
 };
 
 static int __init ipip_init(void)

--------------020102050909050409030307--
