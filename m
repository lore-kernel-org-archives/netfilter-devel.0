From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 3/4] xt_TCPOPTSTRIP
Date: Tue, 27 Nov 2007 13:37:13 +0100
Message-ID: <474C0F79.6050105@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr> <474A74C5.8050609@trash.net> <Pine.LNX.4.64.0711261718440.22369@fbirervta.pbzchgretzou.qr> <474AF214.4090301@trash.net> <Pine.LNX.4.64.0711261724100.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080804080504090008080400"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sven Schnelle <svens@bitebene.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57319 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXK0MhV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:37:21 -0500
In-Reply-To: <Pine.LNX.4.64.0711261724100.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080804080504090008080400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Nov 26 2007 17:19, Patrick McHardy wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> If you quilt/stgit, just replace the patch.
>>>       
>> What are the changes?
>>
>>     
> The name unification thing is one thing for sure. A diff would tell.
> As if I know what _you_ have in your tree ;-)
>   

I merged the parts that make sense. This is the patch I have queued now.



--------------080804080504090008080400
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

commit 42e4a1405a2115a5956ca3842573d1afc58f97ce
Author: Sven Schnelle <svens@bitebene.org>
Date:   Mon Nov 26 08:03:57 2007 +0100

    [NETFILTER]: x_tables: add TCPOPTSTRIP target
    
    Signed-off-by: Sven Schnelle <svens@bitebene.org>
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
new file mode 100644
index 0000000..2db5432
--- /dev/null
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |= 1U << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1U << (idx & 31)) & bmap[(idx) >> 5]) != 0)
+
+struct xt_tcpoptstrip_target_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21a9fcc..693f861 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -411,6 +411,14 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support (EXPERIMENTAL)'
+	depends on EXPERIMENTAL && NETFILTER_XTABLES
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	help
+	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
+	  TCP options from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ad0e36e..7763dea 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 
 # matches
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
new file mode 100644
index 0000000..6cc5cb0
--- /dev/null
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,147 @@
+/*
+ * A module for stripping a specific TCP option from TCP packets.
+ *
+ * Copyright (C) 2007 Sven Schnelle <svens@bitebene.org>
+ * Copyright © CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
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
+tcpoptstrip_mangle_packet(struct sk_buff *skb,
+                          const struct xt_tcpoptstrip_target_info *info,
+                          unsigned int tcphoff, unsigned int minlen)
+{
+	unsigned int optl, i, j;
+	struct tcphdr *tcph;
+	u_int16_t n, o;
+	u_int8_t *opt;
+
+	if (!skb_make_writable(skb, skb->len))
+		return NF_DROP;
+
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	opt  = (u_int8_t *)tcph;
+
+	/*
+	 * Walk through all TCP options - if we find some option to remove,
+	 * set all octets to %TCPOPT_NOP and adjust checksum.
+	 */
+	for (i = sizeof(struct tcphdr); i < tcp_hdrlen(skb); i += optl) {
+		optl = optlen(opt, i);
+
+		if (i + optl > tcp_hdrlen(skb))
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
+			nf_proto_csum_replace2(&tcph->check, skb, htons(o),
+			                       htons(n), 0);
+		}
+		memset(opt + i, TCPOPT_NOP, optl);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tcpoptstrip_tg4(struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, unsigned int hooknum,
+                const struct xt_target *target, const void *targinfo)
+{
+	return tcpoptstrip_mangle_packet(skb, targinfo, ip_hdrlen(skb),
+	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+}
+
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static unsigned int
+tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, unsigned int hooknum,
+                const struct xt_target *target, const void *targinfo)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	unsigned int tcphoff;
+	u_int8_t nexthdr;
+
+	nexthdr = ipv6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
+	if (tcphoff < 0)
+		return NF_DROP;
+
+	return tcpoptstrip_mangle_packet(skb, targinfo, tcphoff,
+	       sizeof(*ipv6h) + sizeof(struct tcphdr));
+}
+#endif
+
+static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
+	{
+		.name       = "TCPOPTSTRIP",
+		.family     = AF_INET,
+		.table      = "mangle",
+		.proto      = IPPROTO_TCP,
+		.target     = tcpoptstrip_tg4,
+		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
+		.me         = THIS_MODULE,
+	},
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+	{
+		.name       = "TCPOPTSTRIP",
+		.family     = AF_INET6,
+		.table      = "mangle",
+		.proto      = IPPROTO_TCP,
+		.target     = tcpoptstrip_tg6,
+		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
+		.me         = THIS_MODULE,
+	},
+#endif
+};
+
+static int __init tcpoptstrip_tg_init(void)
+{
+	return xt_register_targets(tcpoptstrip_tg_reg,
+	       ARRAY_SIZE(tcpoptstrip_tg_reg));
+}
+
+static void __exit tcpoptstrip_tg_exit(void)
+{
+	xt_unregister_targets(tcpoptstrip_tg_reg,
+	                      ARRAY_SIZE(tcpoptstrip_tg_reg));
+}
+
+module_init(tcpoptstrip_tg_init);
+module_exit(tcpoptstrip_tg_exit);
+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>, Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_DESCRIPTION("netfilter \"TCPOPTSTRIP\" target module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TCPOPTSTRIP");
+MODULE_ALIAS("ip6t_TCPOPTSTRIP");

--------------080804080504090008080400--
