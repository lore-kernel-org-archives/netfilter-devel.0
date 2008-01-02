From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 22/27] Rename ipt_iprange to xt_iprange
Date: Wed, 2 Jan 2008 21:31:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022131230.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56949 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbYABUbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:31:35 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b9d3db24231f4555d13b348645e6c0b2f6eba3af
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:49:22 2008 +0100

    [NETFILTER]: Rename ipt_iprange to xt_iprange
    
    This patch moves ipt_iprange to xt_iprange, in preparation for adding
    IPv6 support to xt_iprange.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_iprange.h               |   17 +++++++
 include/linux/netfilter_ipv4/ipt_iprange.h         |    6 +--
 net/ipv4/netfilter/Kconfig                         |   10 ----
 net/ipv4/netfilter/Makefile                        |    1 -
 net/netfilter/Kconfig                              |   11 +++++
 net/netfilter/Makefile                             |    1 +
 .../ipt_iprange.c => netfilter/xt_iprange.c}       |   27 ++++++------
 7 files changed, 43 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/netfilter/xt_iprange.h
 rename net/{ipv4/netfilter/ipt_iprange.c => netfilter/xt_iprange.c} (75%)

diff --git a/include/linux/netfilter/xt_iprange.h b/include/linux/netfilter/xt_iprange.h
new file mode 100644
index 0000000..a4299c7
--- /dev/null
+++ b/include/linux/netfilter/xt_iprange.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_NETFILTER_XT_IPRANGE_H
+#define _LINUX_NETFILTER_XT_IPRANGE_H 1
+
+enum {
+	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
+	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
+	IPRANGE_SRC_INV = 1 << 4,	/* negate the condition */
+	IPRANGE_DST_INV = 1 << 5,	/* -"- */
+};
+
+struct xt_iprange_mtinfo {
+	union nf_inet_addr src_min, src_max;
+	union nf_inet_addr dst_min, dst_max;
+	u_int8_t flags;
+};
+
+#endif /* _LINUX_NETFILTER_XT_IPRANGE_H */
diff --git a/include/linux/netfilter_ipv4/ipt_iprange.h b/include/linux/netfilter_ipv4/ipt_iprange.h
index a92fefc..5f1aebd 100644
--- a/include/linux/netfilter_ipv4/ipt_iprange.h
+++ b/include/linux/netfilter_ipv4/ipt_iprange.h
@@ -2,11 +2,7 @@
 #define _IPT_IPRANGE_H
 
 #include <linux/types.h>
-
-#define IPRANGE_SRC		0x01	/* Match source IP address */
-#define IPRANGE_DST		0x02	/* Match destination IP address */
-#define IPRANGE_SRC_INV		0x10	/* Negate the condition */
-#define IPRANGE_DST_INV		0x20	/* Negate the condition */
+#include <linux/netfilter/xt_iprange.h>
 
 struct ipt_iprange {
 	/* Inclusive: network order. */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index cface71..9d6f617 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -57,16 +57,6 @@ config IP_NF_IPTABLES
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The matches.
-config IP_NF_MATCH_IPRANGE
-	tristate '"iprange" match support'
-	depends on IP_NF_IPTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This option makes possible to match IP addresses against IP address
-	  ranges.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_RECENT
 	tristate '"recent" match support'
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index fd7d4a5..0c7dc78 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
-obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 96dbe9f..ac9b9c1 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -566,6 +566,17 @@ config NETFILTER_XT_MATCH_HELPER
 
 	  To compile it as a module, choose M here.  If unsure, say Y.
 
+config NETFILTER_XT_MATCH_IPRANGE
+	tristate '"iprange" address range match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	---help---
+	This option adds a "iprange" match, which allows you to match based on
+	an IP address range. (Normal iptables only matches on single addresses
+	with an optional mask.)
+
+	If unsure, say M.
+
 config NETFILTER_XT_MATCH_LENGTH
 	tristate '"length" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3b9ea8f..c910cae 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_IPRANGE) += xt_iprange.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/netfilter/xt_iprange.c
similarity index 75%
rename from net/ipv4/netfilter/ipt_iprange.c
rename to net/netfilter/xt_iprange.c
index d16cdb4..ff71868 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -1,11 +1,11 @@
 /*
- * iptables module to match IP address ranges
+ *	xt_iprange - Netfilter module to match IP address ranges
  *
- * (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *	(C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -13,15 +13,11 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-MODULE_DESCRIPTION("Netfilter: arbitrary IPv4 range matching");
-
 static bool
-iprange_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+iprange_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *match,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
 {
 	const struct ipt_iprange_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -58,7 +54,7 @@ iprange_mt(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match iprange_mt_reg __read_mostly = {
 	.name		= "iprange",
 	.family		= AF_INET,
-	.match		= iprange_mt,
+	.match		= iprange_mt_v0,
 	.matchsize	= sizeof(struct ipt_iprange_info),
 	.me		= THIS_MODULE
 };
@@ -75,3 +71,6 @@ static void __exit iprange_mt_exit(void)
 
 module_init(iprange_mt_init);
 module_exit(iprange_mt_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_DESCRIPTION("Netfilter: arbitrary IPv4 range matching");
