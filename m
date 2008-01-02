From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 24/27] Merge ipt_REJECT and ip6t_REJECT into xt_REJECT
Date: Wed, 2 Jan 2008 21:33:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022132210.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45545 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbYABUdp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:33:45 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 84d36d4710f680edddb67ce30202818d95dbe32c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 20:14:28 2008 +0100

    [NETFILTER]: Merge ipt_REJECT and ip6t_REJECT into xt_REJECT
    
    Just combine the two into one. It actually brings some savings when
    built as a module, as there is one file less to carry module overhead:
    
    -rw-r--r-- root     11121 Dec 14 23:20 /lib/mod...ilter/ipt_REJECT.ko
    -rw-r--r-- root     12107 Dec 14 23:20 /lib/mod...lter/ip6t_REJECT.ko
    -rw-r--r-- jengelh  14665 Jan  2 16:45 xt_REJECT.ko
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/ipv4/netfilter/Kconfig       |   11 -
 net/ipv4/netfilter/Makefile      |    1 -
 net/ipv4/netfilter/ipt_REJECT.c  |  251 ----------------
 net/ipv6/netfilter/Kconfig       |   11 -
 net/ipv6/netfilter/Makefile      |    1 -
 net/ipv6/netfilter/ip6t_REJECT.c |  260 ----------------
 net/netfilter/Kconfig            |   10 +
 net/netfilter/Makefile           |    1 +
 net/netfilter/xt_REJECT.c        |  484 ++++++++++++++++++++++++++++++
 9 files changed, 495 insertions(+), 535 deletions(-)
 delete mode 100644 net/ipv4/netfilter/ipt_REJECT.c
 delete mode 100644 net/ipv6/netfilter/ip6t_REJECT.c
 create mode 100644 net/netfilter/xt_REJECT.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9d6f617..89522bc 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -123,17 +123,6 @@ config IP_NF_FILTER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_REJECT
-	tristate "REJECT target support"
-	depends on IP_NF_FILTER
-	default m if NETFILTER_ADVANCED=n
-	help
-	  The REJECT target allows a filtering rule to specify that an ICMP
-	  error should be issued in response to an incoming packet, rather
-	  than silently being dropped.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_LOG
 	tristate "LOG target support"
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 0c7dc78..664cc2d 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
-obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
deleted file mode 100644
index a1029ca..0000000
--- a/net/ipv4/netfilter_ipv4/ipt_REJECT.c
+++ /dev/null
# Omitted pure deletion

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index a6b4a9a..5d22177 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -157,17 +157,6 @@ config IP6_NF_TARGET_LOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_TARGET_REJECT
-	tristate "REJECT target support"
-	depends on IP6_NF_FILTER
-	default m if NETFILTER_ADVANCED=n
-	help
-	  The REJECT target allows a filtering rule to specify that an ICMPv6
-	  error should be issued in response to an incoming packet, rather
-	  than silently being dropped.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	depends on IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index fbf2c14..2b47c2f 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -28,4 +28,3 @@ obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 # targets
 obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
-obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
deleted file mode 100644
index 5b92ad5..0000000
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ /dev/null
# Omitted pure deletion

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ac9b9c1..e4cd97d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -385,6 +385,16 @@ config NETFILTER_XT_TARGET_RATEEST
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_REJECT
+	tristate '"REJECT" target support'
+	depends on NETFILTER_XTABLES
+	default m if NETFILTER_ADVANCED=n
+	---help---
+	The REJECT target allows a filtering rule to specify that an ICMP
+	error should be issued in response to an incoming packet, rather
+	than silently being dropped. For TCP, a TCP RST may be generated
+	to forcibly close the connection.
+
 config NETFILTER_XT_TARGET_TRACE
 	tristate  '"TRACE" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index c910cae..255d53b 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_REJECT) += xt_REJECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
diff --git a/net/netfilter/xt_REJECT.c b/net/netfilter/xt_REJECT.c
new file mode 100644
index 0000000..1e40614
--- /dev/null
+++ b/net/netfilter/xt_REJECT.c
@@ -0,0 +1,484 @@
+/*
+ *	xt_REJECT - Netfilter module to reject packets
+ *
+ *	(C) 1999-2001 Paul `Rusty' Russell
+ *	(C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
+ */
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/udp.h>
+#include <net/dst.h>
+#include <net/flow.h>
+#include <net/icmp.h>
+#include <net/ip.h>
+#include <net/ip6_checksum.h>
+#include <net/ip6_fib.h>
+#include <net/ip6_route.h>
+#include <net/ipv6.h>
+#include <net/route.h>
+#include <net/tcp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_REJECT.h>
+#ifdef CONFIG_BRIDGE_NETFILTER
+#	include <linux/netfilter_bridge.h>
+#endif
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#	define WITH_IPV6 1
+#endif
+
+static void reject_send_reset4(struct sk_buff *oldskb, int hook)
+{
+	struct sk_buff *nskb;
+	struct iphdr *niph;
+	struct tcphdr _otcph, *oth, *tcph;
+	__be16 tmp_port;
+	__be32 tmp_addr;
+	int needs_ack;
+	unsigned int addr_type;
+
+	/* IP header checks: fragment. */
+	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
+		return;
+
+	oth = skb_header_pointer(oldskb, ip_hdrlen(oldskb),
+				 sizeof(_otcph), &_otcph);
+	if (oth == NULL)
+		return;
+
+	/* No RST for RST. */
+	if (oth->rst)
+		return;
+
+	/* Check checksum */
+	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), IPPROTO_TCP))
+		return;
+
+	/* We need a linear, writeable skb.  We also need to expand
+	   headroom in case hh_len of incoming interface < hh_len of
+	   outgoing interface */
+	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER, skb_tailroom(oldskb),
+			       GFP_ATOMIC);
+	if (!nskb)
+		return;
+
+	/* This packet will not be the same as the other: clear nf fields */
+	nf_reset(nskb);
+	nskb->mark = 0;
+	skb_init_secmark(nskb);
+
+	skb_shinfo(nskb)->gso_size = 0;
+	skb_shinfo(nskb)->gso_segs = 0;
+	skb_shinfo(nskb)->gso_type = 0;
+
+	tcph = (struct tcphdr *)(skb_network_header(nskb) + ip_hdrlen(nskb));
+
+	/* Swap source and dest */
+	niph = ip_hdr(nskb);
+	tmp_addr = niph->saddr;
+	niph->saddr = niph->daddr;
+	niph->daddr = tmp_addr;
+	tmp_port = tcph->source;
+	tcph->source = tcph->dest;
+	tcph->dest = tmp_port;
+
+	/* Truncate to length (no data) */
+	tcph->doff = sizeof(struct tcphdr)/4;
+	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
+
+	if (tcph->ack) {
+		needs_ack = 0;
+		tcph->seq = oth->ack_seq;
+		tcph->ack_seq = 0;
+	} else {
+		needs_ack = 1;
+		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn + oth->fin +
+				      oldskb->len - ip_hdrlen(oldskb) -
+				      (oth->doff << 2));
+		tcph->seq = 0;
+	}
+
+	/* Reset flags */
+	((u_int8_t *)tcph)[13] = 0;
+	tcph->rst = 1;
+	tcph->ack = needs_ack;
+
+	tcph->window = 0;
+	tcph->urg_ptr = 0;
+
+	/* Adjust TCP checksum */
+	tcph->check = 0;
+	tcph->check = tcp_v4_check(sizeof(struct tcphdr),
+				   niph->saddr, niph->daddr,
+				   csum_partial(tcph,
+						sizeof(struct tcphdr), 0));
+
+	/* Set DF, id = 0 */
+	niph->frag_off = htons(IP_DF);
+	niph->id = 0;
+
+	addr_type = RTN_UNSPEC;
+	if (hook != NF_INET_FORWARD
+#ifdef CONFIG_BRIDGE_NETFILTER
+	    || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
+#endif
+	   )
+		addr_type = RTN_LOCAL;
+
+	if (ip_route_me_harder(nskb, addr_type))
+		goto free_nskb;
+
+	nskb->ip_summed = CHECKSUM_NONE;
+
+	/* Adjust IP TTL */
+	niph->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
+
+	/* "Never happens" */
+	if (nskb->len > dst_mtu(nskb->dst))
+		goto free_nskb;
+
+	nf_ct_attach(nskb, oldskb);
+
+	ip_local_out(nskb);
+	return;
+
+ free_nskb:
+	kfree_skb(nskb);
+}
+
+static inline void reject_send_unreach4(struct sk_buff *skb_in, int code)
+{
+	icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
+}
+
+static unsigned int
+reject_tg(struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, unsigned int hooknum,
+          const struct xt_target *target, const void *targinfo)
+{
+	const struct ipt_reject_info *reject = targinfo;
+
+	/* Our naive response construction doesn't deal with IP
+	   options, and probably shouldn't try. */
+	if (ip_hdrlen(skb) != sizeof(struct iphdr))
+		return NF_DROP;
+
+	/* WARNING: This code causes reentry within iptables.
+	   This means that the iptables jump stack is now crap.  We
+	   must return an absolute verdict. --RR */
+	switch (reject->with) {
+	case IPT_ICMP_NET_UNREACHABLE:
+		reject_send_unreach4(skb, ICMP_NET_UNREACH);
+		break;
+	case IPT_ICMP_HOST_UNREACHABLE:
+		reject_send_unreach4(skb, ICMP_HOST_UNREACH);
+		break;
+	case IPT_ICMP_PROT_UNREACHABLE:
+		reject_send_unreach4(skb, ICMP_PROT_UNREACH);
+		break;
+	case IPT_ICMP_PORT_UNREACHABLE:
+		reject_send_unreach4(skb, ICMP_PORT_UNREACH);
+		break;
+	case IPT_ICMP_NET_PROHIBITED:
+		reject_send_unreach4(skb, ICMP_NET_ANO);
+		break;
+	case IPT_ICMP_HOST_PROHIBITED:
+		reject_send_unreach4(skb, ICMP_HOST_ANO);
+		break;
+	case IPT_ICMP_ADMIN_PROHIBITED:
+		reject_send_unreach4(skb, ICMP_PKT_FILTERED);
+		break;
+	case IPT_TCP_RESET:
+		reject_send_reset4(skb, hooknum);
+	case IPT_ICMP_ECHOREPLY:
+		/* Doesn't happen. */
+		break;
+	}
+
+	return NF_DROP;
+}
+
+static bool
+reject_tg_check(const char *tablename, const void *e_void,
+                const struct xt_target *target, void *targinfo,
+                unsigned int hook_mask)
+{
+	const struct ipt_reject_info *rejinfo = targinfo;
+	const struct ipt_entry *e = e_void;
+
+	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
+		printk("xt_REJECT: ECHOREPLY no longer supported.\n");
+		return false;
+	} else if (rejinfo->with == IPT_TCP_RESET) {
+		/* Must specify that it's a TCP packet */
+		if (e->ip.proto != IPPROTO_TCP ||
+		    (e->ip.invflags & XT_INV_PROTO)) {
+			printk("xt_REJECT: TCP_RESET invalid for non-TCP\n");
+			return false;
+		}
+	}
+	return true;
+}
+
+#ifdef WITH_IPV6
+static void reject_send_reset6(struct sk_buff *oldskb)
+{
+	struct sk_buff *nskb;
+	struct tcphdr otcph, *tcph;
+	unsigned int otcplen, hh_len;
+	int tcphoff, needs_ack;
+	struct ipv6hdr *oip6h = ipv6_hdr(oldskb), *ip6h;
+	struct dst_entry *dst = NULL;
+	u8 proto;
+	struct flowi fl;
+
+	if ((!(ipv6_addr_type(&oip6h->saddr) & IPV6_ADDR_UNICAST)) ||
+	    (!(ipv6_addr_type(&oip6h->daddr) & IPV6_ADDR_UNICAST))) {
+		pr_debug("ip6t_REJECT: addr is not unicast.\n");
+		return;
+	}
+
+	proto = oip6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(oldskb, ((u8*)(oip6h+1) - oldskb->data), &proto);
+
+	if ((tcphoff < 0) || (tcphoff > oldskb->len)) {
+		pr_debug("ip6t_REJECT: Can't get TCP header.\n");
+		return;
+	}
+
+	otcplen = oldskb->len - tcphoff;
+
+	/* IP header checks: fragment, too short. */
+	if (proto != IPPROTO_TCP || otcplen < sizeof(struct tcphdr)) {
+		pr_debug("ip6t_REJECT: proto(%d) != IPPROTO_TCP, "
+			 "or too short. otcplen = %d\n",
+			 proto, otcplen);
+		return;
+	}
+
+	if (skb_copy_bits(oldskb, tcphoff, &otcph, sizeof(struct tcphdr)))
+		BUG();
+
+	/* No RST for RST. */
+	if (otcph.rst) {
+		pr_debug("ip6t_REJECT: RST is set\n");
+		return;
+	}
+
+	/* Check checksum. */
+	if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
+			    skb_checksum(oldskb, tcphoff, otcplen, 0))) {
+		pr_debug("ip6t_REJECT: TCP checksum is invalid\n");
+		return;
+	}
+
+	memset(&fl, 0, sizeof(fl));
+	fl.proto = IPPROTO_TCP;
+	ipv6_addr_copy(&fl.fl6_src, &oip6h->daddr);
+	ipv6_addr_copy(&fl.fl6_dst, &oip6h->saddr);
+	fl.fl_ip_sport = otcph.dest;
+	fl.fl_ip_dport = otcph.source;
+	security_skb_classify_flow(oldskb, &fl);
+	dst = ip6_route_output(NULL, &fl);
+	if (dst == NULL)
+		return;
+	if (dst->error || xfrm_lookup(&dst, &fl, NULL, 0))
+		return;
+
+	hh_len = (dst->dev->hard_header_len + 15)&~15;
+	nskb = alloc_skb(hh_len + 15 + dst->header_len + sizeof(struct ipv6hdr)
+			 + sizeof(struct tcphdr) + dst->trailer_len,
+			 GFP_ATOMIC);
+
+	if (!nskb) {
+		if (net_ratelimit())
+			printk("ip6t_REJECT: Can't alloc skb\n");
+		dst_release(dst);
+		return;
+	}
+
+	nskb->dst = dst;
+
+	skb_reserve(nskb, hh_len + dst->header_len);
+
+	skb_put(nskb, sizeof(struct ipv6hdr));
+	skb_reset_network_header(nskb);
+	ip6h = ipv6_hdr(nskb);
+	ip6h->version = 6;
+	ip6h->hop_limit = dst_metric(dst, RTAX_HOPLIMIT);
+	ip6h->nexthdr = IPPROTO_TCP;
+	ipv6_addr_copy(&ip6h->saddr, &oip6h->daddr);
+	ipv6_addr_copy(&ip6h->daddr, &oip6h->saddr);
+
+	tcph = (struct tcphdr *)skb_put(nskb, sizeof(struct tcphdr));
+	/* Truncate to length (no data) */
+	tcph->doff = sizeof(struct tcphdr)/4;
+	tcph->source = otcph.dest;
+	tcph->dest = otcph.source;
+
+	if (otcph.ack) {
+		needs_ack = 0;
+		tcph->seq = otcph.ack_seq;
+		tcph->ack_seq = 0;
+	} else {
+		needs_ack = 1;
+		tcph->ack_seq = htonl(ntohl(otcph.seq) + otcph.syn + otcph.fin
+				      + otcplen - (otcph.doff<<2));
+		tcph->seq = 0;
+	}
+
+	/* Reset flags */
+	((u_int8_t *)tcph)[13] = 0;
+	tcph->rst = 1;
+	tcph->ack = needs_ack;
+	tcph->window = 0;
+	tcph->urg_ptr = 0;
+	tcph->check = 0;
+
+	/* Adjust TCP checksum */
+	tcph->check = csum_ipv6_magic(&ipv6_hdr(nskb)->saddr,
+				      &ipv6_hdr(nskb)->daddr,
+				      sizeof(struct tcphdr), IPPROTO_TCP,
+				      csum_partial(tcph,
+						   sizeof(struct tcphdr), 0));
+
+	nf_ct_attach(nskb, oldskb);
+
+	ip6_local_out(nskb);
+}
+
+static inline void
+reject_send_unreach6(struct sk_buff *skb_in, unsigned char code,
+                     unsigned int hooknum)
+{
+	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
+		skb_in->dev = init_net.loopback_dev;
+
+	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0, NULL);
+}
+
+static unsigned int
+reject_tg6(struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, unsigned int hooknum,
+           const struct xt_target *target, const void *targinfo)
+{
+	const struct ip6t_reject_info *reject = targinfo;
+
+	pr_debug("%s: medium point\n", __FUNCTION__);
+	/* WARNING: This code causes reentry within ip6tables.
+	   This means that the ip6tables jump stack is now crap.  We
+	   must return an absolute verdict. --RR */
+	switch (reject->with) {
+	case IP6T_ICMP6_NO_ROUTE:
+		reject_send_unreach6(skb, ICMPV6_NOROUTE, hooknum);
+		break;
+	case IP6T_ICMP6_ADM_PROHIBITED:
+		reject_send_unreach6(skb, ICMPV6_ADM_PROHIBITED, hooknum);
+		break;
+	case IP6T_ICMP6_NOT_NEIGHBOUR:
+		reject_send_unreach6(skb, ICMPV6_NOT_NEIGHBOUR, hooknum);
+		break;
+	case IP6T_ICMP6_ADDR_UNREACH:
+		reject_send_unreach6(skb, ICMPV6_ADDR_UNREACH, hooknum);
+		break;
+	case IP6T_ICMP6_PORT_UNREACH:
+		reject_send_unreach6(skb, ICMPV6_PORT_UNREACH, hooknum);
+		break;
+	case IP6T_ICMP6_ECHOREPLY:
+		/* Do nothing */
+		break;
+	case IP6T_TCP_RESET:
+		reject_send_reset6(skb);
+		break;
+	default:
+		if (net_ratelimit())
+			printk(KERN_WARNING "xt_REJECT: case %u not handled "
+			       "yet in IPv6 code\n", reject->with);
+		break;
+	}
+
+	return NF_DROP;
+}
+
+static bool
+reject_tg6_check(const char *tablename, const void *entry,
+                 const struct xt_target *target, void *targinfo,
+                 unsigned int hook_mask)
+{
+	const struct ip6t_reject_info *rejinfo = targinfo;
+	const struct ip6t_entry *e = entry;
+
+	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
+		printk(KERN_WARNING "xt_REJECT: ECHOREPLY is not supported "
+		       "for IPv6.\n");
+		return false;
+	} else if (rejinfo->with == IP6T_TCP_RESET) {
+		/* Must specify that it's a TCP packet */
+		if (e->ipv6.proto != IPPROTO_TCP ||
+		    (e->ipv6.invflags & XT_INV_PROTO)) {
+			printk("xt_REJECT: TCP_RESET illegal for non-TCP\n");
+			return false;
+		}
+	}
+	return true;
+}
+#endif
+
+static struct xt_target reject_tg_reg[] __read_mostly = {
+	{
+		.name       = "REJECT",
+		.revision   = 0,
+		.family     = AF_INET,
+		.target     = reject_tg,
+		.targetsize = sizeof(struct ipt_reject_info),
+		.table      = "filter",
+		.hooks      = (1 << NF_INET_LOCAL_IN) |
+		              (1 << NF_INET_FORWARD) |
+		              (1 << NF_INET_LOCAL_OUT),
+		.checkentry = reject_tg_check,
+		.me         = THIS_MODULE,
+	},
+#ifdef WITH_IPV6
+	{
+		.name       = "REJECT",
+		.revision   = 0,
+		.family     = AF_INET6,
+		.target     = reject_tg6,
+		.targetsize = sizeof(struct ip6t_reject_info),
+		.table      = "filter",
+		.hooks      = (1 << NF_INET_LOCAL_IN) |
+		              (1 << NF_INET_FORWARD) |
+		              (1 << NF_INET_LOCAL_OUT),
+		.checkentry = reject_tg6_check,
+		.me         = THIS_MODULE,
+	},
+#endif
+};
+
+static int __init reject_tg_init(void)
+{
+	return xt_register_targets(reject_tg_reg, ARRAY_SIZE(reject_tg_reg));
+}
+
+static void __exit reject_tg_exit(void)
+{
+	xt_unregister_targets(reject_tg_reg, ARRAY_SIZE(reject_tg_reg));
+}
+
+module_init(reject_tg_init);
+module_exit(reject_tg_exit);
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>");
+MODULE_DESCRIPTION("Netfilter: packet \"rejection\" target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_REJECT");
+MODULE_ALIAS("ip6t_REJECT");
