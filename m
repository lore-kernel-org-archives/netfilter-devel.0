From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 16:44:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbXI1Oon (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:44:43 -0400
In-Reply-To: <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since I had nothing better to do, I did a cleanup :)

---
 include/linux/netfilter/xt_TCPOPTSTRIP.h |    8 +
 net/netfilter/Kconfig                    |    7 +
 net/netfilter/Makefile                   |    1 
 net/netfilter/xt_TCPOPTSTRIP.c           |  155 +++++++++++++++++++++++++++++++
 4 files changed, 171 insertions(+)

Index: linux-2.6.23/include/linux/netfilter/xt_TCPOPTSTRIP.h
===================================================================
--- /dev/null
+++ linux-2.6.23/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,8 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+struct xt_tcpoptstrip_info {
+	u_int8_t tcpoption;
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
+	  a specific tcp option from TCP packets.
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
@@ -0,0 +1,155 @@
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
+#include <linux/netfilter/xt_tcpudp.h>
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
+static void fast_csum(__sum16 *csum, const u_int8_t *optr,
+                      const u_int8_t *nptr, const int offset)
+{
+	u_int8_t s[4];
+
+	if (offset & 1) {
+		s[0] = s[2] = 0;
+		s[1] = ~*optr;
+		s[3] = *nptr;
+	} else {
+		s[1] = s[3] = 0;
+		s[0] = ~*optr;
+		s[2] = *nptr;
+	}
+
+	*csum = csum_fold(csum_partial(s, 4, ~csum_unfold(*csum)));
+}
+
+static unsigned int
+tcpoptstrip_mangle_packet(struct sk_buff **pskb,
+                          const struct xt_tcpoptstrip_info *info,
+                          unsigned int tcphoff, unsigned int minlen)
+{
+	const u_int8_t newopt = TCPOPT_NOP;
+	unsigned int optl, tcplen, i, j;
+	struct tcphdr *tcph;
+	u_int8_t *opt;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
+
+	tcplen = (*pskb)->len - tcphoff;
+	tcph   = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
+
+	if (tcplen != 4 * tcph->doff)
+		return NF_DROP;
+
+	opt = (u_int8_t *)tcph;
+
+	for (i = sizeof(struct tcphdr); i < 4 * tcph->doff; i += optl) {
+		optl = optlen(opt, i);
+
+		if (optl + i > tcph->doff*4)
+			break;
+
+		if (opt[i] == info->tcpoption) {
+			for (j = 0; j < optl; j++)
+				fast_csum(&tcph->check, opt + i + j,
+				          &newopt, i + j);
+			if (optl & 1)
+				fast_csum(&tcph->check, &newopt,
+				          &newopt, i + j);
+			memset(opt+i, newopt, optl);
+			break;
+		}
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
