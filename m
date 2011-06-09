From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] netfilter: xtables: move ipt_ecn to xt_ecn
Date: Thu,  9 Jun 2011 22:23:53 +0200
Message-ID: <1307651037-20520-2-git-send-email-jengelh@medozas.de>
References: <1307651037-20520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57115 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1FIUYA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:24:00 -0400
In-Reply-To: <1307651037-20520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_ecn.h       |   35 +++++++++
 include/linux/netfilter_ipv4/ipt_ecn.h |   31 +--------
 net/ipv4/netfilter/Kconfig             |   10 +-
 net/ipv4/netfilter/Makefile            |    1 -
 net/ipv4/netfilter/ipt_ecn.c           |  127 -------------------------------
 net/netfilter/Kconfig                  |    9 ++
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_ecn.c                 |  128 ++++++++++++++++++++++++++++++++
 9 files changed, 180 insertions(+), 163 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ecn.h
 delete mode 100644 net/ipv4/netfilter/ipt_ecn.c
 create mode 100644 net/netfilter/xt_ecn.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index a1b410c..e55dba1 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -40,6 +40,7 @@ header-y += xt_cpu.h
 header-y += xt_dccp.h
 header-y += xt_devgroup.h
 header-y += xt_dscp.h
+header-y += xt_ecn.h
 header-y += xt_esp.h
 header-y += xt_hashlimit.h
 header-y += xt_helper.h
diff --git a/include/linux/netfilter/xt_ecn.h b/include/linux/netfilter/xt_ecn.h
new file mode 100644
index 0000000..065c1a5
--- /dev/null
+++ b/include/linux/netfilter/xt_ecn.h
@@ -0,0 +1,35 @@
+/* iptables module for matching the ECN header in IPv4 and TCP header
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
+*/
+#ifndef _XT_ECN_H
+#define _XT_ECN_H
+
+#include <linux/types.h>
+#include <linux/netfilter/xt_dscp.h>
+
+#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
+
+#define IPT_ECN_OP_MATCH_IP	0x01
+#define IPT_ECN_OP_MATCH_ECE	0x10
+#define IPT_ECN_OP_MATCH_CWR	0x20
+
+#define IPT_ECN_OP_MATCH_MASK	0xce
+
+/* match info */
+struct ipt_ecn_info {
+	__u8 operation;
+	__u8 invert;
+	__u8 ip_ect;
+	union {
+		struct {
+			__u8 ect;
+		} tcp;
+	} proto;
+};
+
+#endif /* _XT_ECN_H */
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
index eabf95f..b1124ec 100644
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/linux/netfilter_ipv4/ipt_ecn.h
@@ -1,35 +1,6 @@
-/* iptables module for matching the ECN header in IPv4 and TCP header
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
-*/
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H
 
-#include <linux/types.h>
-#include <linux/netfilter/xt_dscp.h>
-
-#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
-
-#define IPT_ECN_OP_MATCH_IP	0x01
-#define IPT_ECN_OP_MATCH_ECE	0x10
-#define IPT_ECN_OP_MATCH_CWR	0x20
-
-#define IPT_ECN_OP_MATCH_MASK	0xce
-
-/* match info */
-struct ipt_ecn_info {
-	__u8 operation;
-	__u8 invert;
-	__u8 ip_ect;
-	union {
-		struct {
-			__u8 ect;
-		} tcp;
-	} proto;
-};
+#include <linux/netfilter/xt_ecn.h>
 
 #endif /* _IPT_ECN_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1dfc18a..d91b2e6 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -76,11 +76,11 @@ config IP_NF_MATCH_AH
 config IP_NF_MATCH_ECN
 	tristate '"ecn" match support'
 	depends on NETFILTER_ADVANCED
-	help
-	  This option adds a `ECN' match, which allows you to match against
-	  the IPv4 and TCP header ECN fields.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	select NETFILTER_XT_MATCH_ECN
+	---help---
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_MATCH_ECN.
 
 config IP_NF_MATCH_TTL
 	tristate '"ttl" match support'
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index dca2082..d16c7ec 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -49,7 +49,6 @@ obj-$(CONFIG_IP_NF_SECURITY) += iptable_security.o
 
 # matches
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
-obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
deleted file mode 100644
index 2b57e52..0000000
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ /dev/null
@@ -1,127 +0,0 @@
-/* IP tables module for matching the value of the IPv4 and TCP ECN bits
- *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/in.h>
-#include <linux/ip.h>
-#include <net/ip.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/tcp.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ecn.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag match for IPv4");
-MODULE_LICENSE("GPL");
-
-static inline bool match_ip(const struct sk_buff *skb,
-			    const struct ipt_ecn_info *einfo)
-{
-	return ((ip_hdr(skb)->tos & IPT_ECN_IP_MASK) == einfo->ip_ect) ^
-	       !!(einfo->invert & IPT_ECN_OP_MATCH_IP);
-}
-
-static inline bool match_tcp(const struct sk_buff *skb,
-			     const struct ipt_ecn_info *einfo,
-			     bool *hotdrop)
-{
-	struct tcphdr _tcph;
-	const struct tcphdr *th;
-
-	/* In practice, TCP match does this, so can't fail.  But let's
-	 * be good citizens.
-	 */
-	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_tcph), &_tcph);
-	if (th == NULL) {
-		*hotdrop = false;
-		return false;
-	}
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_ECE) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_ECE) {
-			if (th->ece == 1)
-				return false;
-		} else {
-			if (th->ece == 0)
-				return false;
-		}
-	}
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_CWR) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_CWR) {
-			if (th->cwr == 1)
-				return false;
-		} else {
-			if (th->cwr == 0)
-				return false;
-		}
-	}
-
-	return true;
-}
-
-static bool ecn_mt(const struct sk_buff *skb, struct xt_action_param *par)
-{
-	const struct ipt_ecn_info *info = par->matchinfo;
-
-	if (info->operation & IPT_ECN_OP_MATCH_IP)
-		if (!match_ip(skb, info))
-			return false;
-
-	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
-		if (!match_tcp(skb, info, &par->hotdrop))
-			return false;
-	}
-
-	return true;
-}
-
-static int ecn_mt_check(const struct xt_mtchk_param *par)
-{
-	const struct ipt_ecn_info *info = par->matchinfo;
-	const struct ipt_ip *ip = par->entryinfo;
-
-	if (info->operation & IPT_ECN_OP_MATCH_MASK)
-		return -EINVAL;
-
-	if (info->invert & IPT_ECN_OP_MATCH_MASK)
-		return -EINVAL;
-
-	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR) &&
-	    (ip->proto != IPPROTO_TCP || ip->invflags & IPT_INV_PROTO)) {
-		pr_info("cannot match TCP bits in rule for non-tcp packets\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static struct xt_match ecn_mt_reg __read_mostly = {
-	.name		= "ecn",
-	.family		= NFPROTO_IPV4,
-	.match		= ecn_mt,
-	.matchsize	= sizeof(struct ipt_ecn_info),
-	.checkentry	= ecn_mt_check,
-	.me		= THIS_MODULE,
-};
-
-static int __init ecn_mt_init(void)
-{
-	return xt_register_match(&ecn_mt_reg);
-}
-
-static void __exit ecn_mt_exit(void)
-{
-	xt_unregister_match(&ecn_mt_reg);
-}
-
-module_init(ecn_mt_init);
-module_exit(ecn_mt_exit);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32bff6d..a1dbdc2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -772,6 +772,15 @@ config NETFILTER_XT_MATCH_DSCP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_ECN
+	tristate '"ecn" match support'
+	depends on NETFILTER_ADVANCED
+	---help---
+	This option adds an "ECN" match, which allows you to match against
+	the IPv4 and TCP header ECN fields.
+
+	To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_ESP
 	tristate '"esp" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1a02853..c748722 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CPU) += xt_cpu.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DEVGROUP) += xt_devgroup.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_ECN) += xt_ecn.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
new file mode 100644
index 0000000..2c198f5
--- /dev/null
+++ b/net/netfilter/xt_ecn.c
@@ -0,0 +1,128 @@
+/* IP tables module for matching the value of the IPv4 and TCP ECN bits
+ *
+ * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <net/ip.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/tcp.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_ecn.h>
+
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag match for IPv4");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_ecn");
+
+static inline bool match_ip(const struct sk_buff *skb,
+			    const struct ipt_ecn_info *einfo)
+{
+	return ((ip_hdr(skb)->tos & IPT_ECN_IP_MASK) == einfo->ip_ect) ^
+	       !!(einfo->invert & IPT_ECN_OP_MATCH_IP);
+}
+
+static inline bool match_tcp(const struct sk_buff *skb,
+			     const struct ipt_ecn_info *einfo,
+			     bool *hotdrop)
+{
+	struct tcphdr _tcph;
+	const struct tcphdr *th;
+
+	/* In practice, TCP match does this, so can't fail.  But let's
+	 * be good citizens.
+	 */
+	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_tcph), &_tcph);
+	if (th == NULL) {
+		*hotdrop = false;
+		return false;
+	}
+
+	if (einfo->operation & IPT_ECN_OP_MATCH_ECE) {
+		if (einfo->invert & IPT_ECN_OP_MATCH_ECE) {
+			if (th->ece == 1)
+				return false;
+		} else {
+			if (th->ece == 0)
+				return false;
+		}
+	}
+
+	if (einfo->operation & IPT_ECN_OP_MATCH_CWR) {
+		if (einfo->invert & IPT_ECN_OP_MATCH_CWR) {
+			if (th->cwr == 1)
+				return false;
+		} else {
+			if (th->cwr == 0)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static bool ecn_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct ipt_ecn_info *info = par->matchinfo;
+
+	if (info->operation & IPT_ECN_OP_MATCH_IP)
+		if (!match_ip(skb, info))
+			return false;
+
+	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
+		if (!match_tcp(skb, info, &par->hotdrop))
+			return false;
+	}
+
+	return true;
+}
+
+static int ecn_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct ipt_ecn_info *info = par->matchinfo;
+	const struct ipt_ip *ip = par->entryinfo;
+
+	if (info->operation & IPT_ECN_OP_MATCH_MASK)
+		return -EINVAL;
+
+	if (info->invert & IPT_ECN_OP_MATCH_MASK)
+		return -EINVAL;
+
+	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR) &&
+	    (ip->proto != IPPROTO_TCP || ip->invflags & IPT_INV_PROTO)) {
+		pr_info("cannot match TCP bits in rule for non-tcp packets\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct xt_match ecn_mt_reg __read_mostly = {
+	.name		= "ecn",
+	.family		= NFPROTO_IPV4,
+	.match		= ecn_mt,
+	.matchsize	= sizeof(struct ipt_ecn_info),
+	.checkentry	= ecn_mt_check,
+	.me		= THIS_MODULE,
+};
+
+static int __init ecn_mt_init(void)
+{
+	return xt_register_match(&ecn_mt_reg);
+}
+
+static void __exit ecn_mt_exit(void)
+{
+	xt_unregister_match(&ecn_mt_reg);
+}
+
+module_init(ecn_mt_init);
+module_exit(ecn_mt_exit);
-- 
1.7.3.4

