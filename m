From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Sun, 08 Aug 2004 06:05:35 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408072105.GAA23792@toshiba.co.jp>
References: <410D23AB.2070203@trash.net>
	<20040801181150.GI14539@sunbeam2>
	<200408020405.NAA27078@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Sun_Aug__8_06:05:35_2004_137)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200408020405.NAA27078@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Sun_Aug__8_06:05:35_2004_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, all

I rewrote the codes which partially linearize skb before executing hook
functions. This solves some new issues. And I got good results with ordinary
situations.

The details are following. sorry for long message.

1. Changes

The changes are following.
	- If hook function rearranges skb, skb may be fragmented. 
	  (e.g. ip_conntrack_defrag()) Then I introduce the flag
	  NF_LIN_MAY_FRAG. If this flag is set on nf_hook_ops->lin_flag,
	  check and linearization are tried once more.
	- ip_linearize_headers(), which partially linearizes skb up to the
	  transport header, doesn't linearize if IPv4 packet is fragmented
	  and isn't 1st fragment.
	- deleted writable mode because I'm not sure it's efficient or not.
	- My understanding about pskb_may_pull() was wrong in the previous
	  patch. In this patch, skb is copied if skb_shared() is true.
	  Otherwise, pskb_may_pull() is used.

2. Tests
 I tested in 2 situations with 1st and 2nd patches attached to this mail.

2.1 On router
 I applied the patches to kernel on a router, inserted 2000 non-matching rules
for tcp destination port to FORWARD chain on it, and pass 500MB stream from
one side to another. The result is

$ iperf -c 192.168.1.2 -n 500M
------------------------------------------------------------
Client connecting to 192.168.1.2, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.2 port 32830 connected with 192.168.1.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-130.9 sec   500 MBytes  32.0 Mbits/sec

In the case of vanilla kernel, 

$ iperf -c 192.168.1.2 -n 500M
------------------------------------------------------------
Client connecting to 192.168.1.2, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.2 port 32834 connected with 192.168.1.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-199.1 sec   500 MBytes  21.1 Mbits/sec

The parformance is improbed in this case.


2.2 On host
 I applied the patches to kernel on a host, inserted 1000 non-matching rules
for tcp destination port to INPUT chain on it, and pass 500MB data from one
host to another. These hosts are on same link. The result is

$ iperf -c 192.168.1.1 -n 500M
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.2 port 32770 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-117.6 sec   500 MBytes  35.7 Mbits/sec

In the case of vanilla kernel,

$ iperf -c 192.168.1.1 -n 500M
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.2 port 32773 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-132.2 sec   500 MBytes  31.7 Mbits/sec

The parformance is improbed in this case, too.

3. Debugging

At least, I saw this patch works well with skb which is ...
	- fragmented at TCP header.
	- already linearized up to required header (and may be cloned or
	  shared).
	- fragmented IPv4 packet.

and __calc_lin_max_layer(), which calculates the highest layer header required
to linearize, works well in the case that ip_conntrack.ko and iptable_filter.ko
are inserted to kernel. But I didn't test with SMP machine.

4. Issues

4.1 some elimination
In the current, the header required to linearize is only transport header.
How about the other layer ? If we need only transport header, we can eliminate
	- some "if" from ip_linearize_headers()
	- calculation of the highest header to linearize

4.2 writable mode
"writable mode" is useful ? In the current, the linearization assures that
skb is readable but not writable. If nat/mangle modules decide to mangle
packet but skb isn't writable, skb will be copied by skb_make_writable().
But I don't know part of skb may be copied twice or not.
Various situations are needed to test.


Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sun_Aug__8_06:05:35_2004_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="linearize.patch"

diff -X dontdiff -Nurp linux-2.6.8-rc3/include/linux/netfilter.h linux-2.6.8-rc3-linearize/include/linux/netfilter.h
--- linux-2.6.8-rc3/include/linux/netfilter.h	2004-08-04 20:25:13.000000000 +0900
+++ linux-2.6.8-rc3-linearize/include/linux/netfilter.h	2004-08-08 02:01:07.973534136 +0900
@@ -46,6 +46,9 @@ typedef unsigned int nf_hookfn(unsigned 
 struct nf_hook_ops
 {
 	struct list_head list;
+	/* max protocol header required to linearize before executing hook
+	   functions. */
+	unsigned int max_lin_layer;
 
 	/* User fills in from here down. */
 	nf_hookfn *hook;
@@ -54,8 +57,14 @@ struct nf_hook_ops
 	int hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int priority;
+	/* protocol header required to linearize */
+	unsigned int lin_layer;
+	unsigned int lin_flags;
 };
 
+/* for lin_flags */
+#define NF_LIN_MAY_FRAG	0x0001 /* skb may be fragmented after executing hook */
+
 struct nf_sockopt_ops
 {
 	struct list_head list;
@@ -187,6 +196,8 @@ extern void nf_dump_skb(int pf, struct s
 /* FIXME: Before cache is ever used, this must be implemented for real. */
 extern void nf_invalidate_cache(int pf);
 
+extern int skb_make_readable(struct sk_buff **pskb, unsigned int readable_len);
+
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
 #endif /*CONFIG_NETFILTER*/
diff -X dontdiff -Nurp linux-2.6.8-rc3/include/linux/netfilter_ipv4.h linux-2.6.8-rc3-linearize/include/linux/netfilter_ipv4.h
--- linux-2.6.8-rc3/include/linux/netfilter_ipv4.h	2004-06-16 14:19:52.000000000 +0900
+++ linux-2.6.8-rc3-linearize/include/linux/netfilter_ipv4.h	2004-08-08 02:01:07.973534136 +0900
@@ -85,6 +85,15 @@ extern int ip_route_me_harder(struct sk_
    Returns true or false. */
 extern int skb_ip_make_writable(struct sk_buff **pskb,
 				unsigned int writable_len);
+
+/* Header required to linearize */
+/* Network protocol header */
+#define NF_IP_LIN_NET	100
+/* Transport protocol header */
+#define NF_IP_LIN_TRANS	200
+/* Whole of packet */
+#define NF_IP_LIN_ALL	UINT_MAX
+
 #endif /*__KERNEL__*/
 
 #endif /*__LINUX_IP_NETFILTER_H*/
diff -X dontdiff -Nurp linux-2.6.8-rc3/net/core/netfilter.c linux-2.6.8-rc3-linearize/net/core/netfilter.c
--- linux-2.6.8-rc3/net/core/netfilter.c	2004-06-16 14:19:22.000000000 +0900
+++ linux-2.6.8-rc3-linearize/net/core/netfilter.c	2004-08-08 02:01:07.974533984 +0900
@@ -49,6 +49,8 @@ struct list_head nf_hooks[NPROTO][NF_MAX
 static LIST_HEAD(nf_sockopts);
 static spinlock_t nf_hook_lock = SPIN_LOCK_UNLOCKED;
 
+int (*nf_linearize[NPROTO])(struct sk_buff **pskb, unsigned int layer);
+
 /* 
  * A queue handler may be registered for each protocol.  Each is protected by
  * long term mutex.  The handler must provide an an outfn() to accept packets
@@ -60,16 +62,42 @@ static struct nf_queue_handler_t {
 } queue_handler[NPROTO];
 static rwlock_t queue_handler_lock = RW_LOCK_UNLOCKED;
 
+/* Calculate highest protocol header required to linearize before executing
+   hook functions. locking is needed. */
+static void __calc_lin_layer(int pf, int hooknum)
+{
+	struct nf_hook_ops *elem = NULL;
+	unsigned int max_lin_layer = 0;
+
+	list_for_each_entry_reverse(elem, &nf_hooks[pf][hooknum], list) {
+		/* The 1st condition means that skb may be rearranged by this
+		   element. In this case, linearizing is needed one more after
+		   this. Then it's not needed to linearize the higher layer
+		   this element doesn't require */
+		if ((elem->lin_flags & NF_LIN_MAY_FRAG) ||
+		    (max_lin_layer < elem->lin_layer))
+			max_lin_layer = elem->lin_layer;
+
+		elem->max_lin_layer = max_lin_layer;
+	}
+}
+
 int nf_register_hook(struct nf_hook_ops *reg)
 {
 	struct list_head *i;
 
+	if (reg->lin_layer != 0 && nf_linearize[reg->pf] == NULL)
+		return -1;
+
+	reg->max_lin_layer = reg->lin_layer;
+
 	spin_lock_bh(&nf_hook_lock);
 	list_for_each(i, &nf_hooks[reg->pf][reg->hooknum]) {
 		if (reg->priority < ((struct nf_hook_ops *)i)->priority)
 			break;
 	}
 	list_add_rcu(&reg->list, i->prev);
+	__calc_lin_layer(reg->pf, reg->hooknum);
 	spin_unlock_bh(&nf_hook_lock);
 
 	synchronize_net();
@@ -80,6 +108,7 @@ void nf_unregister_hook(struct nf_hook_o
 {
 	spin_lock_bh(&nf_hook_lock);
 	list_del_rcu(&reg->list);
+	__calc_lin_layer(reg->pf, reg->hooknum);
 	spin_unlock_bh(&nf_hook_lock);
 
 	synchronize_net();
@@ -349,6 +378,8 @@ static unsigned int nf_iterate(struct li
 			       int (*okfn)(struct sk_buff *),
 			       int hook_thresh)
 {
+	unsigned int max_lin_layer = 0;
+
 	/*
 	 * The caller must not block between calls to this
 	 * function because of risk of continuing from deleted element.
@@ -359,6 +390,23 @@ static unsigned int nf_iterate(struct li
 		if (hook_thresh > elem->priority)
 			continue;
 
+		/* Ordinarily linearizing is required only once. But may be
+		   required if a element is added/deleted during the iteration
+		   or the previous element rearranges skb. */
+		if (max_lin_layer < elem->max_lin_layer) {
+			max_lin_layer = elem->max_lin_layer;
+			if(!nf_linearize[elem->pf](skb, max_lin_layer)) {
+				if(net_ratelimit())
+					printk("failed to partially linearize "
+					       "skb. dropping...\n");
+
+				return NF_DROP;
+			}
+
+			if (elem->lin_flags & NF_LIN_MAY_FRAG)
+				max_lin_layer = 0;
+		}
+
 		/* Optimization: we don't need to hold module
                    reference here, since function can't sleep. --RR */
 		switch (elem->hook(hook, skb, indev, outdev, okfn)) {
@@ -735,6 +783,27 @@ pull_skb:
 EXPORT_SYMBOL(skb_ip_make_writable);
 #endif /*CONFIG_INET*/
 
+int skb_make_readable(struct sk_buff **pskb, unsigned int readable_len)
+{
+	if (likely(readable_len <= skb_headlen(*pskb)))
+		return 1;
+
+	if (unlikely(readable_len > (*pskb)->len))
+		return 0;
+
+	if (skb_shared(*pskb)) {
+		struct sk_buff *n;
+
+		n = skb_copy(*pskb, GFP_ATOMIC);
+		if (!n)
+			return 0;
+		*pskb = n;
+	} else if (!pskb_may_pull(*pskb, readable_len))
+		return 0;
+
+	return 1;
+}
+
 /* Internal logging interface, which relies on the real 
    LOG target modules */
 
@@ -808,10 +877,17 @@ EXPORT_SYMBOL(nf_log_packet);
    with it. */
 void (*ip_ct_attach)(struct sk_buff *, struct nf_ct_info *);
 
+#ifdef CONFIG_INET
+extern int ip_linearize_headers(struct sk_buff **pskb, unsigned int layer);
+#endif
+
 void __init netfilter_init(void)
 {
 	int i, h;
 
+#ifdef CONFIG_INET
+	nf_linearize[PF_INET] = ip_linearize_headers;
+#endif
 	for (i = 0; i < NPROTO; i++) {
 		for (h = 0; h < NF_MAX_HOOKS; h++)
 			INIT_LIST_HEAD(&nf_hooks[i][h]);
diff -X dontdiff -Nurp linux-2.6.8-rc3/net/ipv4/netfilter/Makefile linux-2.6.8-rc3-linearize/net/ipv4/netfilter/Makefile
--- linux-2.6.8-rc3/net/ipv4/netfilter/Makefile	2004-08-04 20:25:16.000000000 +0900
+++ linux-2.6.8-rc3-linearize/net/ipv4/netfilter/Makefile	2004-08-08 02:01:07.974533984 +0900
@@ -98,3 +98,5 @@ obj-$(CONFIG_IP_NF_COMPAT_IPCHAINS) += i
 obj-$(CONFIG_IP_NF_COMPAT_IPFWADM) += ipfwadm.o
 
 obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
+
+obj-y += ip_linearize.o
diff -X dontdiff -Nurp linux-2.6.8-rc3/net/ipv4/netfilter/ip_linearize.c linux-2.6.8-rc3-linearize/net/ipv4/netfilter/ip_linearize.c
--- linux-2.6.8-rc3/net/ipv4/netfilter/ip_linearize.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.8-rc3-linearize/net/ipv4/netfilter/ip_linearize.c	2004-08-08 02:01:07.975533832 +0900
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C)2004 USAGI/WIDE Project
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Authors:
+ *	Yasuyuki Kozakai	<yasuyuki.kozakai@toshiba.co.jp>
+ */
+
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/icmp.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+
+#include <net/ip.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/*
+ * linearize skb up to specified layer. If packet is too short, whole of skb is 
+ * linearized. NOTICE: skb is readable but may not writable because of being
+ * shared or cloned. If you want to mangle the contents of skb, please use
+ * ip_make_writable().
+ */
+int ip_linearize_headers(struct sk_buff **pskb, unsigned int layer)
+{
+	unsigned int totlen;
+
+	if (layer <= NF_IP_LIN_NET)
+		return 1;
+
+	totlen = (*pskb)->nh.iph->ihl*4;
+
+	if (layer == NF_IP_LIN_TRANS) {
+		if (ntohs((*pskb)->nh.iph->frag_off) & IP_OFFSET)
+			return 1;
+
+		switch ((*pskb)->nh.iph->protocol) {
+		case IPPROTO_TCP: {
+			struct tcphdr hdr;
+			int ret;
+
+			/* truncated */
+			if ((*pskb)->len - totlen < sizeof(hdr)) {
+				totlen = (*pskb)->len;
+				break;
+			}
+
+			ret = skb_copy_bits(*pskb, (*pskb)->nh.iph->ihl*4,
+					    &hdr, sizeof(hdr));
+			if (ret) {
+				DEBUGP("ip_linearize: failed to copy bits.\n");
+				return 0;
+			}
+
+			totlen += max_t(unsigned int, sizeof(hdr), hdr.doff*4);
+			break;
+		}
+		case IPPROTO_UDP:
+			totlen += sizeof(struct udphdr);
+			break;
+		case IPPROTO_ICMP:
+			totlen += sizeof(struct icmphdr);
+			break;
+		/* Insert other cases here as desired */
+		}
+	} else if (layer == NF_IP_LIN_ALL)
+		totlen = (*pskb)->len;
+	else {
+		/* unknown layer */
+		DEBUGP("ip_linearize: unknown layer\n");
+		return 0;
+	}
+
+	if (totlen > (*pskb)->len)
+		totlen = (*pskb)->len;
+
+	return skb_make_readable(pskb, totlen);
+}
+
+EXPORT_SYMBOL(ip_linearize_headers);

----Next_Part(Sun_Aug__8_06:05:35_2004_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="linearize-filter.patch"

diff -X dontdiff -Nurp linux-2.6.8-rc3/net/ipv4/netfilter/ip_tables.c linux-2.6.8-rc3-linearize/net/ipv4/netfilter/ip_tables.c
--- linux-2.6.8-rc3/net/ipv4/netfilter/ip_tables.c	2004-08-04 20:25:16.000000000 +0900
+++ linux-2.6.8-rc3-linearize/net/ipv4/netfilter/ip_tables.c	2004-08-08 02:01:07.975533832 +0900
@@ -1458,17 +1458,19 @@ tcp_find_option(u_int8_t option,
 		int *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	u_int8_t opt[60 - sizeof(struct tcphdr)];
+	u_int8_t *opt;
 	unsigned int i;
+	unsigned int optoff = skb->nh.iph->ihl*4 + sizeof(struct tcphdr);
 
 	duprintf("tcp_match: finding option\n");
 	/* If we don't have the whole header, drop packet. */
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4 + sizeof(struct tcphdr),
-			  opt, optlen) < 0) {
+	if (skb->len < optoff + optlen) {
 		*hotdrop = 1;
 		return 0;
 	}
 
+	opt = skb->data + optoff;
+
 	for (i = 0; i < optlen; ) {
 		if (opt[i] == option) return !invert;
 		if (opt[i] < 2) i++;
@@ -1486,7 +1488,7 @@ tcp_match(const struct sk_buff *skb,
 	  int offset,
 	  int *hotdrop)
 {
-	struct tcphdr tcph;
+	struct tcphdr *tcp;
 	const struct ipt_tcp *tcpinfo = matchinfo;
 
 	if (offset) {
@@ -1506,7 +1508,7 @@ tcp_match(const struct sk_buff *skb,
 
 #define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
 
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &tcph, sizeof(tcph)) < 0) {
+	if (skb->len < skb->nh.iph->ihl*4 + sizeof(struct tcphdr)) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
@@ -1514,24 +1516,26 @@ tcp_match(const struct sk_buff *skb,
 		return 0;
 	}
 
+	tcp = (struct tcphdr *)(skb->data + skb->nh.iph->ihl*4);
+
 	if (!port_match(tcpinfo->spts[0], tcpinfo->spts[1],
-			ntohs(tcph.source),
+			ntohs(tcp->source),
 			!!(tcpinfo->invflags & IPT_TCP_INV_SRCPT)))
 		return 0;
 	if (!port_match(tcpinfo->dpts[0], tcpinfo->dpts[1],
-			ntohs(tcph.dest),
+			ntohs(tcp->dest),
 			!!(tcpinfo->invflags & IPT_TCP_INV_DSTPT)))
 		return 0;
-	if (!FWINVTCP((((unsigned char *)&tcph)[13] & tcpinfo->flg_mask)
+	if (!FWINVTCP((((unsigned char *)tcp)[13] & tcpinfo->flg_mask)
 		      == tcpinfo->flg_cmp,
 		      IPT_TCP_INV_FLAGS))
 		return 0;
 	if (tcpinfo->option) {
-		if (tcph.doff * 4 < sizeof(tcph)) {
+		if (tcp->doff * 4 < sizeof(struct tcphdr)) {
 			*hotdrop = 1;
 			return 0;
 		}
-		if (!tcp_find_option(tcpinfo->option, skb, tcph.doff*4 - sizeof(tcph),
+		if (!tcp_find_option(tcpinfo->option, skb, tcp->doff*4 - sizeof(struct tcphdr),
 				     tcpinfo->invflags & IPT_TCP_INV_OPTION,
 				     hotdrop))
 			return 0;
@@ -1564,14 +1568,14 @@ udp_match(const struct sk_buff *skb,
 	  int offset,
 	  int *hotdrop)
 {
-	struct udphdr udph;
+	struct udphdr *udp;
 	const struct ipt_udp *udpinfo = matchinfo;
 
 	/* Must not be a fragment. */
 	if (offset)
 		return 0;
 
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &udph, sizeof(udph)) < 0) {
+	if (skb->len < skb->nh.iph->ihl*4 + sizeof(struct udphdr)) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
@@ -1579,11 +1583,13 @@ udp_match(const struct sk_buff *skb,
 		return 0;
 	}
 
+	udp = (struct udphdr *)(skb->data + skb->nh.iph->ihl*4);
+
 	return port_match(udpinfo->spts[0], udpinfo->spts[1],
-			  ntohs(udph.source),
+			  ntohs(udp->source),
 			  !!(udpinfo->invflags & IPT_UDP_INV_SRCPT))
 		&& port_match(udpinfo->dpts[0], udpinfo->dpts[1],
-			      ntohs(udph.dest),
+			      ntohs(udp->dest),
 			      !!(udpinfo->invflags & IPT_UDP_INV_DSTPT));
 }
 
@@ -1635,14 +1641,14 @@ icmp_match(const struct sk_buff *skb,
 	   int offset,
 	   int *hotdrop)
 {
-	struct icmphdr icmph;
+	struct icmphdr *icmp;
 	const struct ipt_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
 	if (offset)
 		return 0;
 
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &icmph, sizeof(icmph)) < 0){
+	if (skb->len < skb->nh.iph->ihl*4 + sizeof(struct icmphdr) < 0) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil ICMP tinygram.\n");
@@ -1650,10 +1656,12 @@ icmp_match(const struct sk_buff *skb,
 		return 0;
 	}
 
+	icmp = (struct icmphdr *)(skb->data + sizeof(struct icmphdr));
+
 	return icmp_type_code_match(icmpinfo->type,
 				    icmpinfo->code[0],
 				    icmpinfo->code[1],
-				    icmph.type, icmph.code,
+				    icmp->type, icmp->code,
 				    !!(icmpinfo->invflags&IPT_ICMP_INV));
 }
 
diff -X dontdiff -Nurp linux-2.6.8-rc3/net/ipv4/netfilter/iptable_filter.c linux-2.6.8-rc3-linearize/net/ipv4/netfilter/iptable_filter.c
--- linux-2.6.8-rc3/net/ipv4/netfilter/iptable_filter.c	2004-06-16 14:19:13.000000000 +0900
+++ linux-2.6.8-rc3-linearize/net/ipv4/netfilter/iptable_filter.c	2004-08-08 02:01:07.975533832 +0900
@@ -136,6 +136,7 @@ static struct nf_hook_ops ipt_ops[] = {
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_LOCAL_IN,
 		.priority	= NF_IP_PRI_FILTER,
+		.lin_layer	= NF_IP_LIN_TRANS,
 	},
 	{
 		.hook		= ipt_hook,
@@ -143,6 +144,7 @@ static struct nf_hook_ops ipt_ops[] = {
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
+		.lin_layer	= NF_IP_LIN_TRANS,
 	},
 	{
 		.hook		= ipt_local_out_hook,
@@ -150,6 +152,7 @@ static struct nf_hook_ops ipt_ops[] = {
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_LOCAL_OUT,
 		.priority	= NF_IP_PRI_FILTER,
+		.lin_layer	= NF_IP_LIN_TRANS,
 	},
 };
 

----Next_Part(Sun_Aug__8_06:05:35_2004_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="linearize-conntrack.patch"

--- linux-2.6.8-rc3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-08 02:06:18.000000000 +0900
+++ linux-2.6.8-rc3-linearize/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-08 05:28:23.768084752 +0900
@@ -263,6 +263,7 @@
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_PRE_ROUTING,
 	.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
+	.lin_flags	= NF_LIN_MAY_FRAG,
 };
 
 static struct nf_hook_ops ip_conntrack_in_ops = {
@@ -271,6 +272,7 @@
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_PRE_ROUTING,
 	.priority	= NF_IP_PRI_CONNTRACK,
+	.lin_layer	= NF_IP_LIN_TRANS,
 };
 
 static struct nf_hook_ops ip_conntrack_defrag_local_out_ops = {
@@ -279,6 +281,7 @@
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_OUT,
 	.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
+	.lin_flags	= NF_LIN_MAY_FRAG,
 };
 
 static struct nf_hook_ops ip_conntrack_local_out_ops = {
@@ -287,6 +290,7 @@
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_OUT,
 	.priority	= NF_IP_PRI_CONNTRACK,
+	.lin_layer	= NF_IP_LIN_TRANS,
 };
 
 /* Refragmenter; last chance. */
@@ -296,6 +300,7 @@
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
 	.priority	= NF_IP_PRI_LAST,
+	.lin_flags	= NF_LIN_MAY_FRAG,
 };
 
 static struct nf_hook_ops ip_conntrack_local_in_ops = {

----Next_Part(Sun_Aug__8_06:05:35_2004_137)----
