From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Sun, 01 Feb 2004 15:52:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <401D12B6.5030707@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090304080202010903000104"
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Willy Tarreau <willy@w.ods.org>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040128103000.GP11761@sunbeam.de.gnumonks.org>
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
--------------090304080202010903000104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I've hacked together a working version, it's a ugly hack but
it shows what parts are required for getting NAT working.
Comments are welcome.

The patch is split into three parts: 01-hooks.diff, 02-nat-original.diff 
  and 03-nat-reply.diff. I'm going to discuss each part seperately.

01-hooks.diff:
This patch adds the required hooks. Locally generated and forwarded
packets pass through POST_ROUTING before beeing encypted and pass
through LOCAL_OUT afterwards. This is currently not consistent with
input packets which pass through PRE_ROUTING and LOCAL_IN encrypted
and then again after beeing decapsulated from a tunnel-mode
encapsulation. This means packets from nested tunnels will pass
multiple times, packets from transport-mode connections won't pass
the hook after decryption at all.

02-nat-original.diff:
This patch adds policy lookups to ip_route_me_harder and changes
ip_nat_standalone to reroute in both LOCAL_OUT and POST_ROUTING
if the routing key or the key used for policy lookups changed.
This allows to NAT packets and have the correct policy applied
to them afterwards.

Since the POST_ROUTING hook is called with ip_finish_output2 as outfn
the packets which have a transformer-dst_entry after ip_route_me_harder
are manually confirmed (conntrack) and passed to dst_output. These
packets will be passed through LOCAL_OUT after encryption has been done.
There is a danger of loops, the encrypted packets could be natted in
LOCAL_OUT and POST_ROUTING again and again match a policy.

The packets matching a policy after rerouting in LOCAL_OUT don't need
this kind of special handling, LOCAL_OUT is called with dst_output
as outfn. They are currently not passwd through POST_ROUTING before
encryption, which I just noticed while writing this mail.

03-nat-reply.diff:
This patch changes xfrm_policy_check to lookup the correct policy
for input packets after NAT has been applied. Unfortunately some
policy checks are performed after skb->nfct has been released so
I had to introduce a leak.

To summarize the problems:
- Not completely consistens picture wrt. hooks passed and ordering.
Should be easily fixable.
- loop danger. suggestions ?
- nat information required at socket receive time for policy checks,
currently achieved by introducing a leak. possible solution is to
store the required data in new skb fields, it's only 6 bytes ..

What is currently working is the following:
- Filter traffic before/after encryption (more or less)
- SNAT/DNAT packets and have correct policies applied, including none
- Have policy checks find correct policy for SNAT/DNAT/SNAT+DNATed
packets


Regards,
Patrick

--------------090304080202010903000104
Content-Type: text/plain;
 name="01-hooks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-hooks.diff"

===== net/ipv4/ah4.c 1.29 vs edited =====
--- 1.29/net/ipv4/ah4.c	Sat Jan 24 19:08:48 2004
+++ edited/net/ipv4/ah4.c	Sat Jan 31 16:26:44 2004
@@ -6,6 +6,8 @@
 #include <net/ah.h>
 #include <linux/crypto.h>
 #include <linux/pfkeyv2.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <net/icmp.h>
 #include <asm/scatterlist.h>
 
@@ -54,6 +56,11 @@
 	return 0;
 }
 
+static inline int ah_finish_output(struct sk_buff *skb)
+{
+	return NET_XMIT_BYPASS;
+}
+
 static int ah_output(struct sk_buff *skb)
 {
 	int err;
@@ -144,6 +151,18 @@
 	if ((skb->dst = dst_pop(dst)) == NULL) {
 		err = -EHOSTUNREACH;
 		goto error_nolock;
+	}
+	/* final packet goes through LOCAL_OUT hook */
+	if (skb->dst->xfrm == NULL) {
+#ifdef CONFIG_NETFILTER
+		nf_conntrack_put(skb->nfct);
+		skb->nfct = NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+		skb->nf_debug = 0;
+#endif
+#endif
+		return NF_HOOK(AF_INET, NF_IP_LOCAL_OUT, skb, NULL,
+		               skb->dst->dev, ah_finish_output);
 	}
 	return NET_XMIT_BYPASS;
 
===== net/ipv4/esp4.c 1.35 vs edited =====
--- 1.35/net/ipv4/esp4.c	Mon Aug 18 13:14:38 2003
+++ edited/net/ipv4/esp4.c	Sat Jan 31 16:26:33 2004
@@ -8,6 +8,8 @@
 #include <linux/crypto.h>
 #include <linux/pfkeyv2.h>
 #include <linux/random.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <net/icmp.h>
 #include <net/udp.h>
 
@@ -20,6 +22,11 @@
 	__u8		proto;
 };
 
+static inline int esp_finish_output(struct sk_buff *skb)
+{
+	return NET_XMIT_BYPASS;
+}
+
 int esp_output(struct sk_buff *skb)
 {
 	int err;
@@ -198,6 +205,18 @@
 	if ((skb->dst = dst_pop(dst)) == NULL) {
 		err = -EHOSTUNREACH;
 		goto error_nolock;
+	}
+	/* final packet goes through LOCAL_OUT hook */
+	if (skb->dst->xfrm == NULL) {
+#ifdef CONFIG_NETFILTER
+		nf_conntrack_put(skb->nfct);
+		skb->nfct = NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+		skb->nf_debug = 0;
+#endif
+#endif
+		return NF_HOOK(AF_INET, NF_IP_LOCAL_OUT, skb, NULL,
+		               skb->dst->dev, esp_finish_output);
 	}
 	return NET_XMIT_BYPASS;
 
===== net/ipv4/ip_forward.c 1.9 vs edited =====
--- 1.9/net/ipv4/ip_forward.c	Sun Mar 23 11:21:28 2003
+++ edited/net/ipv4/ip_forward.c	Sat Jan 31 16:27:11 2004
@@ -51,6 +51,10 @@
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
+	if (skb->dst->xfrm != NULL)
+		return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL, skb->dst->dev,
+		               dst_output);
+
 	return dst_output(skb);
 }
 
===== net/ipv4/ip_output.c 1.48 vs edited =====
--- 1.48/net/ipv4/ip_output.c	Wed Dec 17 21:06:18 2003
+++ edited/net/ipv4/ip_output.c	Sat Jan 31 16:27:22 2004
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
@@ -386,7 +394,7 @@
 	skb->priority = sk->sk_priority;
 
 	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		       dst_output);
+		       ip_dst_output);
 
 no_route:
 	IP_INC_STATS(IpOutNoRoutes);
@@ -1164,7 +1172,7 @@
 
 	/* Netfilter gets whole the not fragmented skb. */
 	err = NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, 
-		      skb->dst->dev, dst_output);
+		      skb->dst->dev, ip_dst_output);
 	if (err) {
 		if (err > 0)
 			err = inet->recverr ? net_xmit_errno(err) : 0;
===== net/ipv4/xfrm4_input.c 1.9 vs edited =====
--- 1.9/net/ipv4/xfrm4_input.c	Fri Aug  8 06:17:15 2003
+++ edited/net/ipv4/xfrm4_input.c	Sat Jan 31 14:23:52 2004
@@ -130,6 +130,13 @@
 			dst_release(skb->dst);
 			skb->dst = NULL;
 		}
+#ifdef CONFIG_NETFILTER
+		nf_conntrack_put(skb->nfct);
+		skb->nfct = NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+		skb->nf_debug = 0;
+#endif
+#endif
 		netif_rx(skb);
 		return 0;
 	} else {

--------------090304080202010903000104
Content-Type: text/plain;
 name="02-nat-original.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-nat-original.diff"

===== net/core/netfilter.c 1.26 vs edited =====
--- 1.26/net/core/netfilter.c	Sun Sep 28 18:34:18 2003
+++ edited/net/core/netfilter.c	Sun Feb  1 14:39:46 2004
@@ -25,6 +25,7 @@
 #include <linux/icmp.h>
 #include <net/sock.h>
 #include <net/route.h>
+#include <net/xfrm.h>
 #include <linux/ip.h>
 
 #define __KERNEL_SYSCALLS__
@@ -627,6 +628,9 @@
 	struct flowi fl = {};
 	struct dst_entry *odst;
 	unsigned int hh_len;
+#ifdef CONFIG_XFRM
+	struct xfrm_policy_afinfo *afinfo;
+#endif
 
 	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
 	 * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
@@ -665,6 +669,16 @@
 	if ((*pskb)->dst->error)
 		return -1;
 
+#ifdef CONFIG_XFRM
+	afinfo = xfrm_policy_get_afinfo(AF_INET);
+	if (afinfo != NULL) {
+		afinfo->decode_session(*pskb, &fl);
+		xfrm_policy_put_afinfo(afinfo);
+		if (xfrm_lookup(&(*pskb)->dst, &fl, (*pskb)->sk, 1) != 0)
+			return -1;
+	}
+#endif
+
 	/* Change in oif may mean change in hh_len. */
 	hh_len = (*pskb)->dst->dev->hard_header_len;
 	if (skb_headroom(*pskb) < hh_len) {
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.23 vs edited =====
--- 1.23/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Dec  5 21:30:11 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Sat Jan 31 14:37:49 2004
@@ -481,6 +481,7 @@
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(ip_conntrack_get);
+EXPORT_SYMBOL(__ip_conntrack_confirm);
 EXPORT_SYMBOL(need_ip_conntrack);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
===== net/ipv4/netfilter/ip_nat_standalone.c 1.28 vs edited =====
--- 1.28/net/ipv4/netfilter/ip_nat_standalone.c	Fri Oct  3 08:26:55 2003
+++ edited/net/ipv4/netfilter/ip_nat_standalone.c	Sun Feb  1 11:21:29 2004
@@ -160,6 +160,46 @@
 	return do_bindings(ct, ctinfo, info, hooknum, pskb);
 }
 
+struct flow_key
+{
+	u_int32_t addr;
+#ifdef CONFIG_XFRM
+	u_int16_t port;
+#endif
+};
+
+static inline void
+flow_key_get(struct sk_buff *skb, struct flow_key *key, int which)
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
+flow_key_compare(struct sk_buff *skb, struct flow_key *key, int which)
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
+	return 0;
+}
+
 static unsigned int
 ip_nat_out(unsigned int hooknum,
 	   struct sk_buff **pskb,
@@ -167,6 +207,9 @@
 	   const struct net_device *out,
 	   int (*okfn)(struct sk_buff *))
 {
+	struct flow_key k;
+	unsigned int ret;
+
 	/* root is playing with raw sockets. */
 	if ((*pskb)->len < sizeof(struct iphdr)
 	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
@@ -189,7 +232,25 @@
 			return NF_STOLEN;
 	}
 
-	return ip_nat_fn(hooknum, pskb, in, out, okfn);
+	flow_key_get(*pskb, &k, 0);
+	ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
+
+	if (ret != NF_DROP && ret != NF_STOLEN
+	    && flow_key_compare(*pskb, &k, 0)) {
+		if (ip_route_me_harder(pskb) != 0)
+			ret = NF_DROP;
+		else if ((*pskb)->dst->xfrm != NULL) {
+			/* packet matches policy after ip_route_me_harder -
+			 * need to manually direct packet to transformers */
+			/* WARNING: loop danger */
+			ret = ip_conntrack_confirm(*pskb);
+			if (ret != NF_DROP) {
+				dst_output(*pskb);
+				ret = NF_STOLEN;
+			}
+		}
+	}
+	return ret;
 }
 
 #ifdef CONFIG_IP_NF_NAT_LOCAL
@@ -200,7 +261,7 @@
 		const struct net_device *out,
 		int (*okfn)(struct sk_buff *))
 {
-	u_int32_t saddr, daddr;
+	struct flow_key k;
 	unsigned int ret;
 
 	/* root is playing with raw sockets. */
@@ -208,14 +269,14 @@
 	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
 		return NF_ACCEPT;
 
-	saddr = (*pskb)->nh.iph->saddr;
-	daddr = (*pskb)->nh.iph->daddr;
-
+	flow_key_get(*pskb, &k, 1);
 	ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
+
 	if (ret != NF_DROP && ret != NF_STOLEN
-	    && ((*pskb)->nh.iph->saddr != saddr
-		|| (*pskb)->nh.iph->daddr != daddr))
-		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+	    && flow_key_compare(*pskb, &k, 1)) {
+		if (ip_route_me_harder(pskb) != 0)
+			ret = NF_DROP;
+	}
 	return ret;
 }
 #endif

--------------090304080202010903000104
Content-Type: text/plain;
 name="03-nat-reply.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-nat-reply.diff"

===== include/linux/netfilter.h 1.6 vs edited =====
--- 1.6/include/linux/netfilter.h	Wed Jun 25 00:36:10 2003
+++ edited/include/linux/netfilter.h	Sun Feb  1 14:39:16 2004
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
+#define nf_nat_decode_session(skb, fl, family)
+#endif /* CONFIG_IP_NF_NAT_NEEDED */
+#endif /* CONFIG_XFRM */
+
 #endif /*__KERNEL__*/
 #endif /*__LINUX_NETFILTER_H*/
===== net/core/netfilter.c 1.26 vs edited =====
--- 1.26/net/core/netfilter.c	Sun Sep 28 18:34:18 2003
+++ edited/net/core/netfilter.c	Sun Feb  1 14:39:46 2004
@@ -681,6 +695,49 @@
 
 	return 0;
 }
+
+#if defined(CONFIG_IP_NF_NAT_NEEDED) && defined(CONFIG_XFRM)
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+
+void nf_nat_decode_session4(struct sk_buff *skb, struct flowi *fl)
+{
+	struct ip_conntrack *ct;
+	struct ip_nat_info_manip *m;
+	struct ip_conntrack_tuple *tuple;
+	unsigned int i;
+
+	if (skb->nfct == NULL)
+		return;
+	ct = (struct ip_conntrack *)skb->nfct->master;
+
+	for (i = 0; i < ct->nat.info.num_manips; i++) {
+		m = &ct->nat.info.manips[i];
+		if (m->direction != IP_CT_DIR_REPLY)
+			continue;
+		tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+		if (m->hooknum == NF_IP_PRE_ROUTING &&
+		    m->maniptype == IP_NAT_MANIP_DST) {
+			/* SNAT rule reply mangling */
+			fl->fl4_dst = tuple->dst.ip;
+			if (tuple->dst.protonum == IPPROTO_TCP ||
+			    tuple->dst.protonum == IPPROTO_UDP)
+				fl->fl_ip_dport = tuple->dst.u.tcp.port;
+		}
+#ifdef CONFIG_IP_NF_NAT_LOCAL
+		else if (m->hooknum == NF_IP_LOCAL_IN &&
+		         m->maniptype == IP_NAT_MANIP_SRC) {
+			/* DNAT rule reply mangling */
+			fl->fl4_src = tuple->src.ip;
+			if (tuple->dst.protonum == IPPROTO_TCP ||
+			    tuple->dst.protonum == IPPROTO_UDP)
+				fl->fl_ip_sport = tuple->src.u.tcp.port;
+		}
+#endif
+	}
+}
+#endif /* CONFIG_IP_NF_NAT_NEEDED && CONFIG_XFRM */
 
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
===== net/ipv4/ip_input.c 1.20 vs edited =====
--- 1.20/net/ipv4/ip_input.c	Mon Sep 29 04:05:42 2003
+++ edited/net/ipv4/ip_input.c	Sat Jan 31 21:30:52 2004
@@ -207,12 +207,14 @@
 
 	__skb_pull(skb, ihl);
 
+#if 0
 #ifdef CONFIG_NETFILTER
 	/* Free reference early: we don't need it any more, and it may
            hold ip_conntrack module loaded indefinitely. */
 	nf_conntrack_put(skb->nfct);
 	skb->nfct = NULL;
 #endif /*CONFIG_NETFILTER*/
+#endif
 
         /* Point into the IP datagram, just past the header. */
         skb->h.raw = skb->data;
===== net/xfrm/xfrm_policy.c 1.47 vs edited =====
--- 1.47/net/xfrm/xfrm_policy.c	Wed Jan 14 08:30:19 2004
+++ edited/net/xfrm/xfrm_policy.c	Sun Feb  1 13:57:09 2004
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

--------------090304080202010903000104--
