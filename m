From: Christophe Saout <christophe@saout.de>
Subject: [PATCH 4/4] IPSEC policy checks
Date: Thu, 17 Feb 2005 20:13:16 +0100
Message-ID: <1108667597.21912.23.camel@leto.cs.pocnet.net>
References: <1108667319.21912.14.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1108667319.21912.14.camel@leto.cs.pocnet.net>
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

The updated ipsec-04-policy-checks.diff

--- linux-2.6.11-rc4/net/xfrm/xfrm_policy.c	2005-02-16 00:59:44.000000000 +0100
+++ linux-2.6.11-rc4-cs1/net/xfrm/xfrm_policy.c	2005-02-17 19:01:20.688629416 +0100
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netfilter.h>
 #include <linux/module.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
@@ -43,8 +44,8 @@
 	LIST_HEAD_INIT(xfrm_policy_gc_list);
 static DEFINE_SPINLOCK(xfrm_policy_gc_lock);
 
-static struct xfrm_policy_afinfo *xfrm_policy_get_afinfo(unsigned short family);
-static void xfrm_policy_put_afinfo(struct xfrm_policy_afinfo *afinfo);
+struct xfrm_policy_afinfo *xfrm_policy_get_afinfo(unsigned short family);
+void xfrm_policy_put_afinfo(struct xfrm_policy_afinfo *afinfo);
 
 int xfrm_register_type(struct xfrm_type *type, unsigned short family)
 {
@@ -931,6 +932,7 @@
 
 	if (_decode_session(skb, &fl, family) < 0)
 		return 0;
+	nf_nat_decode_session(skb, &fl, family);
 
 	/* First, check used SA against their selectors. */
 	if (skb->sp) {
@@ -1209,7 +1211,7 @@
 }
 EXPORT_SYMBOL(xfrm_policy_unregister_afinfo);
 
-static struct xfrm_policy_afinfo *xfrm_policy_get_afinfo(unsigned short family)
+struct xfrm_policy_afinfo *xfrm_policy_get_afinfo(unsigned short family)
 {
 	struct xfrm_policy_afinfo *afinfo;
 	if (unlikely(family >= NPROTO))
@@ -1222,7 +1224,7 @@
 	return afinfo;
 }
 
-static void xfrm_policy_put_afinfo(struct xfrm_policy_afinfo *afinfo)
+void xfrm_policy_put_afinfo(struct xfrm_policy_afinfo *afinfo)
 {
 	if (unlikely(afinfo == NULL))
 		return;
--- linux-2.6.11-rc4/net/ipv4/udp.c	2005-02-16 00:59:44.000000000 +0100
+++ linux-2.6.11-rc4-cs1/net/ipv4/udp.c	2005-02-17 19:07:01.630927480 +0100
@@ -997,6 +997,7 @@
 		kfree_skb(skb);
 		return -1;
 	}
+	nf_reset(skb);
 
 	if (up->encap_type) {
 		/*
@@ -1162,6 +1163,7 @@
 
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto drop;
+	nf_reset(skb);
 
 	/* No socket. Drop packet silently, if checksum is wrong */
 	if (udp_checksum_complete(skb))
--- linux-2.6.11-rc4/net/ipv4/tcp_ipv4.c	2005-02-16 00:59:44.000000000 +0100
+++ linux-2.6.11-rc4-cs1/net/ipv4/tcp_ipv4.c	2005-02-17 19:07:01.618929304 +0100
@@ -1771,6 +1771,7 @@
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset(skb);
 
 	if (sk_filter(sk, skb, 0))
 		goto discard_and_relse;
--- linux-2.6.11-rc4/net/ipv4/raw.c	2005-02-17 18:11:39.244258088 +0100
+++ linux-2.6.11-rc4-cs1/net/ipv4/raw.c	2005-02-17 19:07:01.601931888 +0100
@@ -252,6 +252,7 @@
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset(skb);
 
 	skb_push(skb, skb->data - skb->nh.raw);
 
--- linux-2.6.11-rc4/net/ipv4/ip_input.c	2005-02-17 18:26:58.334299584 +0100
+++ linux-2.6.11-rc4-cs1/net/ipv4/ip_input.c	2005-02-17 19:07:01.587934016 +0100
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
--- linux-2.6.11-rc4/net/core/netfilter.c	2005-02-17 18:58:17.591212264 +0100
+++ linux-2.6.11-rc4-cs1/net/core/netfilter.c	2005-02-17 19:11:24.041308232 +0100
@@ -711,6 +711,47 @@
 	return nf_rcv_postxfrm_nonlocal(skb);
 }
  
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+
+void nf_nat_decode_session4(struct sk_buff *skb, struct flowi *fl)
+{
+	struct ip_conntrack *ct;
+	struct ip_conntrack_tuple *t;
+	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
+	int known_proto;
+	int statusbit;
+
+	ct = ip_conntrack_get(skb, &ctinfo);
+	if (ct == NULL || !(ct->status & IPS_NAT_MASK))
+		return;
+
+	dir = CTINFO2DIR(ctinfo);
+	t = &ct->tuplehash[dir].tuple;
+	known_proto = t->dst.protonum == IPPROTO_TCP ||
+	              t->dst.protonum == IPPROTO_UDP;
+
+	statusbit = ct->status;
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
+
+	if (statusbit & IPS_DST_NAT) {
+		fl->fl4_dst = t->dst.ip;
+		if (known_proto)
+			fl->fl_ip_dport = t->dst.u.tcp.port;
+	}
+
+	if (statusbit & IPS_SRC_NAT) {
+		fl->fl4_src = t->src.ip;
+		if (known_proto)
+			fl->fl_ip_sport = t->src.u.tcp.port;
+	}
+}
+#endif /* CONFIG_IP_NF_NAT_NEEDED */
+#endif
+
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
 	struct sk_buff *nskb;
--- linux-2.6.11-rc4/include/net/xfrm.h	2005-02-17 18:26:58.436284080 +0100
+++ linux-2.6.11-rc4-cs1/include/net/xfrm.h	2005-02-17 19:07:01.545940400 +0100
@@ -178,6 +178,8 @@
 
 extern int xfrm_policy_register_afinfo(struct xfrm_policy_afinfo *afinfo);
 extern int xfrm_policy_unregister_afinfo(struct xfrm_policy_afinfo *afinfo);
+extern struct xfrm_policy_afinfo *xfrm_policy_get_afinfo(unsigned short family);
+extern void xfrm_policy_put_afinfo(struct xfrm_policy_afinfo *afinfo);
 
 #define XFRM_ACQ_EXPIRES	30
 
--- linux-2.6.11-rc4/include/linux/netfilter.h	2005-02-17 18:11:39.463224800 +0100
+++ linux-2.6.11-rc4-cs1/include/linux/netfilter.h	2005-02-17 19:07:01.542940856 +0100
@@ -188,5 +188,21 @@
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
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
