From: Sven Schnelle <sschnelle@astaro.com>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Tue, 02 Oct 2007 16:09:16 +0200
Message-ID: <87lkal1ucz.fsf@begreifnix.intranet.astaro.de>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
	<46FD1798.2020302@trash.net>
	<87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vpn.astaro.de ([213.144.15.3]:32897 "EHLO vpn.astaro.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbXJBOhz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:37:55 -0400
Received: from MailerDaemon by vpn.astaro.de with local-bsmtp (Exim 4.63)
	(envelope-from <sschnelle@astaro.com>)
	id 1IciR4-0002Sk-Et
	for netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 16:09:18 +0200
In-Reply-To: <87tzpd266j.fsf@begreifnix.intranet.astaro.de> (Sven Schnelle's message of "Sat\, 29 Sep 2007 11\:04\:52 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sven Schnelle <svens@bitebene.org> writes:

> As i'm currently travelling, i can't test the code above - will do the
> end of next week, and resubmit.

Ok, i've cleaned up the code and followed the suggestions here. I've
also added the possibility to strip more than one option from the Headers.

Signed-off-by: Sven Schnelle <svens@bitebene.org>

xtables part:

diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
new file mode 100644
index 0000000..384a33f
--- /dev/null
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,11 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define OPTION_IS_SET(p, bit) (p)[(bit) >> 3] & 1 << ((bit) & 0x07)
+#define SET_OPTION(p, bit) (p)[(bit) >> 3] |= 1 << ((bit) & 0x07)
+
+struct xt_tcpoptstrip_info {
+	unsigned char tcpoptions[32];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3599770..44c6e17 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -411,6 +411,13 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support'
+	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)
+	---help---
+	  This option adds a `TCPOPTSTRIP' target, which allows you to strip
+	  tcp option(s) from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0c054bf..fe5ac6e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
new file mode 100644
index 0000000..ec86ac9
--- /dev/null
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,157 @@
+/*
+ * This is a module which is used for stripping a specific tcp option 
+ * from TCP packets.
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
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>");
+MODULE_DESCRIPTION("x_tables TCPOPTSTRIP module");
+MODULE_ALIAS("ipt_TCPOPTSTRIP");
+MODULE_ALIAS("ip6t_TCPOPTSTRIP");
+
+static inline unsigned int xt_tcpoptstrip_optlen(const u_int8_t *opt,
+					      unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+static int xt_tcpoptstrip_mangle_packet(struct sk_buff **pskb, const void *info,
+				     unsigned int tcphoff, unsigned int minlen)
+{
+    struct xt_tcpoptstrip_info *tinfo = (struct xt_tcpoptstrip_info *)info;
+    struct tcphdr *tcph;
+    unsigned int optl, i,j;
+    u8 *opt;
+    u16 n, o;
+
+    if (!skb_make_writable(pskb, (*pskb)->len))
+	return XT_CONTINUE;
+
+    tcph = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
+
+    opt = (u_int8_t *)tcph;
+
+    /* Walk through all TCP options - if we find some option to
+       remove, set all octets to TCPTOPT_NOP and adjust checksum */
+
+    for(i = sizeof(struct tcphdr); i < tcph->doff*4; i += optl) {
+	optl = xt_tcpoptstrip_optlen(opt, i);
+
+	if(optl + i > tcph->doff*4)
+	    break;
+
+	if (OPTION_IS_SET(tinfo->tcpoptions, opt[i])) {
+	    for(j = 0; j < optl; j++) {
+		    o = opt[i+j];
+		    n = TCPOPT_NOP;
+		    if ((i + j) % 2 == 0) {
+			o <<= 8;
+			n <<= 8;
+		    }
+		    nf_proto_csum_replace2(&tcph->check, *pskb, htons(o), 
+					   htons(n), 0);
+	    }
+	    memset(opt+i, TCPOPT_NOP, optl);
+	}
+    }
+    return XT_CONTINUE;
+}
+
+static unsigned int xt_tcpoptstrip_target4(struct sk_buff **pskb,
+					   const struct net_device *in,
+					   const struct net_device *out,
+					   unsigned int hooknum,
+					   const struct xt_target *target,
+					   const void *targinfo)
+{
+    struct iphdr *iph = ip_hdr(*pskb);
+
+
+    return xt_tcpoptstrip_mangle_packet(pskb, targinfo, iph->ihl * 4,
+				     sizeof(*iph) + sizeof(struct tcphdr));
+}
+
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static unsigned int xt_tcpoptstrip_target6(struct sk_buff **pskb, 
+					   const struct net_device *in,
+					   const struct net_device *out,
+					   unsigned int hooknum,
+					   const struct xt_target *target,
+					   const void *targinfo)
+{
+    struct ipv6hdr *ipv6h = ipv6_hdr(*pskb);
+    u8 nexthdr;
+    int tcphoff;
+
+    nexthdr = ipv6h->nexthdr;
+    tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
+    if (tcphoff < 0) {
+	WARN_ON(1);
+	return NF_DROP;
+    }
+
+    return xt_tcpoptstrip_mangle_packet(pskb, targinfo, tcphoff,
+				     sizeof(*ipv6h) + sizeof(struct tcphdr));
+}
+#endif
+
+static struct xt_target xt_tcpoptstrip_reg[] __read_mostly = {
+    {
+	.family		= AF_INET,
+	.name		= "TCPOPTSTRIP",
+	.target		= xt_tcpoptstrip_target4,
+	.targetsize	= sizeof(struct xt_tcpoptstrip_info),
+	.proto		= IPPROTO_TCP,
+	.table          = "mangle",
+	.me		= THIS_MODULE,
+    },
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+    {
+	.family		= AF_INET6,
+	.name		= "TCPOPTSTRIP",
+	.target		= xt_tcpoptstrip_target6,
+	.targetsize	= sizeof(struct xt_tcpoptstrip_info),
+	.proto		= IPPROTO_TCP,
+	.table          = "mangle",
+	.me		= THIS_MODULE,
+    },
+#endif
+};
+
+static int __init xt_tcpoptstrip_init(void)
+{
+    return xt_register_targets(xt_tcpoptstrip_reg,
+			       ARRAY_SIZE(xt_tcpoptstrip_reg));
+}
+
+static void __exit xt_tcpoptstrip_fini(void)
+{
+    xt_unregister_targets(xt_tcpoptstrip_reg,
+			  ARRAY_SIZE(xt_tcpoptstrip_reg));
+}
+
+module_init(xt_tcpoptstrip_init);
+module_exit(xt_tcpoptstrip_fini);
