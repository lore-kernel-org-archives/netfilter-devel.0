From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target (netfilter)
Date: Tue, 2 Oct 2007 19:32:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710021612590.7130@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87lkal1ucz.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Sven Schnelle <sschnelle@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41465 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbXJBRcS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:32:18 -0400
In-Reply-To: <87lkal1ucz.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 2 2007 16:09, Sven Schnelle wrote:
>Sven Schnelle <svens@bitebene.org> writes:
>
>> As i'm currently travelling, i can't test the code above - will do the
>> end of next week, and resubmit.
>
>Ok, i've cleaned up the code and followed the suggestions here. I've
>also added the possibility to strip more than one option from the Headers.

Would be great if we could work on one patch :) [see below]

>+#ifndef _XT_TCPOPTSTRIP_H
>+#define _XT_TCPOPTSTRIP_H
>+
>+#define OPTION_IS_SET(p, bit) (p)[(bit) >> 3] & 1 << ((bit) & 0x07)
>+#define SET_OPTION(p, bit) (p)[(bit) >> 3] |= 1 << ((bit) & 0x07)

You should probably use <linux/bitmap.h>.

>+struct xt_tcpoptstrip_info {
>+	unsigned char tcpoptions[32];
>+};

And u_int8_t. Better is uint32_t[8], because that is what the linux 
bitops work with. (And, unfortunately, it's buggy so we end up 
continuing to use own macros.)

>+static inline unsigned int xt_tcpoptstrip_optlen(const u_int8_t *opt,
>+					      unsigned int offset)
>+{
>+	/* Beware zero-length options: make finite progress */
>+	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
>+		return 1;
>+	else
>+		return opt[offset+1];
>+}
>+
>+static int xt_tcpoptstrip_mangle_packet(struct sk_buff **pskb, const void *info,
>+				     unsigned int tcphoff, unsigned int minlen)
>+{
>+    struct xt_tcpoptstrip_info *tinfo = (struct xt_tcpoptstrip_info *)info;

Redundant wrong cast. Just pass in const struct xt_TCPOPTSTRIP_info
and you are done.

>+    if (!skb_make_writable(pskb, (*pskb)->len))
>+	return XT_CONTINUE;

This was NF_DROP previously. Is this really ok to let it pass?

>+
>+    tcph = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
>+
>+    opt = (u_int8_t *)tcph;
>+
>+    /* Walk through all TCP options - if we find some option to
>+       remove, set all octets to TCPTOPT_NOP and adjust checksum */
>+
>+    for(i = sizeof(struct tcphdr); i < tcph->doff*4; i += optl) {
>+	optl = xt_tcpoptstrip_optlen(opt, i);
>+
>+	if(optl + i > tcph->doff*4)
>+	    break;

This check looks redundant (given that the break conditions is already 
given in the for() line) -- though it is not as far as my math skills 
can see. But can't it be done a bit nicer?
	
>+	    for(j = 0; j < optl; j++) {
>+		    o = opt[i+j];
>+		    n = TCPOPT_NOP;
>+		    if ((i + j) % 2 == 0) {
>+			o <<= 8;
>+			n <<= 8;
>+		    }
>+		    nf_proto_csum_replace2(&tcph->check, *pskb, htons(o), 
>+					   htons(n), 0);
>+	    }
>+	    memset(opt+i, TCPOPT_NOP, optl);

Can we modify the option field while moving through it, and update the 
checksum after the loop?

>+static unsigned int xt_tcpoptstrip_target4(struct sk_buff **pskb,
>+					   const struct net_device *in,
>+					   const struct net_device *out,
>+					   unsigned int hooknum,
>+					   const struct xt_target *target,
>+					   const void *targinfo)
>+{
>+    struct iphdr *iph = ip_hdr(*pskb);
>+
>+
>+    return xt_tcpoptstrip_mangle_packet(pskb, targinfo, iph->ihl * 4,
>+				     sizeof(*iph) + sizeof(struct tcphdr));
>+}

iph is redundant.

>+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)

This does not seem necessary.

>+    nexthdr = ipv6h->nexthdr;
>+    tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
>+    if (tcphoff < 0) {
>+	WARN_ON(1);

Should not spew useless warning when someone sends a forged packet.


Find updated xt_TCPOPTSTRIP below, and libxt_TCPOPTSTRIP in its thread.

=== Patch begins here ===

Adds xt_TCPOPTSTRIP.

---
 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 ++
 net/netfilter/Kconfig                    |    7 +
 net/netfilter/Makefile                   |    1 
 net/netfilter/xt_TCPOPTSTRIP.c           |  140 +++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+)

Index: linux-2.6.23/include/linux/netfilter/xt_TCPOPTSTRIP.h
===================================================================
--- /dev/null
+++ linux-2.6.23/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |= 1UL << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) != 0)
+
+struct xt_tcpoptstrip_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
Index: linux-2.6.23/net/netfilter/Kconfig
===================================================================
--- linux-2.6.23.orig/net/netfilter/Kconfig
+++ linux-2.6.23/net/netfilter/Kconfig
@@ -411,6 +411,13 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
+	  TCP options from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6.23/net/netfilter/Makefile
===================================================================
--- linux-2.6.23.orig/net/netfilter/Makefile
+++ linux-2.6.23/net/netfilter/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) 
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
Index: linux-2.6.23/net/netfilter/xt_TCPOPTSTRIP.c
===================================================================
--- /dev/null
+++ linux-2.6.23/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,140 @@
+/*
+ * A module for stripping a specific TCP option from TCP packets.
+ *
+ * Copyright (C) 2007 Sven Schnelle <svens@bitebene.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+static unsigned int
+tcpoptstrip_mangle_packet(struct sk_buff **pskb,
+                          const struct xt_tcpoptstrip_info *info,
+                          unsigned int tcphoff, unsigned int minlen)
+{
+	unsigned int optl, i, j;
+	struct tcphdr *tcph;
+	u_int16_t n, o;
+	u_int8_t *opt;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		/* hmm... NF_DROP? */
+		return XT_CONTINUE;
+
+	tcph = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
+	opt  = (u_int8_t *)tcph;
+
+	/*
+	 * Walk through all TCP options - if we find some option to remove,
+	 * set all octets to %TCPOPT_NOP and adjust checksum.
+	 */
+	for (i = sizeof(struct tcphdr); i < 4 * tcph->doff; i += optl) {
+		optl = optlen(opt, i);
+
+		if (i + optl > 4 * tcph->doff)
+			break;
+
+		if (!tcpoptstrip_test_bit(info->strip_bmap, opt[i]))
+			continue;
+
+		for (j = 0; j < optl; ++j) {
+			o = opt[i+j];
+			n = TCPOPT_NOP;
+			if ((i + j) % 2 == 0) {
+				o <<= 8;
+				n <<= 8;
+			}
+			nf_proto_csum_replace2(&tcph->check, *pskb, htons(o),
+			                       htons(n), 0);
+		}
+		memset(opt + i, TCPOPT_NOP, optl);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+xt_tcpoptstrip_target4(struct sk_buff **pskb, const struct net_device *in,
+                       const struct net_device *out, unsigned int hooknum,
+                       const struct xt_target *target, const void *targinfo)
+{
+	return tcpoptstrip_mangle_packet(pskb, targinfo, ip_hdrlen(*pskb),
+	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+}
+
+static unsigned int
+xt_tcpoptstrip_target6(struct sk_buff **pskb, const struct net_device *in,
+                       const struct net_device *out, unsigned int hooknum,
+                       const struct xt_target *target, const void *targinfo)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(*pskb);
+	unsigned int tcphoff;
+	u_int8_t nexthdr;
+
+	nexthdr = ipv6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
+	if (tcphoff < 0)
+		return NF_DROP;
+
+	return tcpoptstrip_mangle_packet(pskb, targinfo, tcphoff,
+	       sizeof(*ipv6h) + sizeof(struct tcphdr));
+}
+
+static struct xt_target tcpoptstrip_reg[] __read_mostly = {
+	{
+		.name       = "TCPOPTSTRIP",
+		.family     = AF_INET,
+		.table      = "mangle",
+		.proto      = IPPROTO_TCP,
+		.target     = xt_tcpoptstrip_target4,
+		.targetsize = sizeof(struct xt_tcpoptstrip_info),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "TCPOPTSTRIP",
+		.family     = AF_INET6,
+		.table      = "mangle",
+		.proto      = IPPROTO_TCP,
+		.target     = xt_tcpoptstrip_target6,
+		.targetsize = sizeof(struct xt_tcpoptstrip_info),
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init xt_tcpoptstrip_init(void)
+{
+	return xt_register_targets(tcpoptstrip_reg, ARRAY_SIZE(tcpoptstrip_reg));
+}
+
+static void __exit xt_tcpoptstrip_exit(void)
+{
+	xt_unregister_targets(tcpoptstrip_reg, ARRAY_SIZE(tcpoptstrip_reg));
+}
+
+module_init(xt_tcpoptstrip_init);
+module_exit(xt_tcpoptstrip_exit);
+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>");
+MODULE_DESCRIPTION("x_tables TCPOPTSTRIP module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TCPOPTSTRIP");
+MODULE_ALIAS("ip6t_TCPOPTSTRIP");
