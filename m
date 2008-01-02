From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 25/27] Merge ipt_ah and ip6t_ah into xt_ah
Date: Wed, 2 Jan 2008 21:34:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022133440.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45549 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbYABUeS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:34:18 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 11c4c687b1df11aeadd9ab76f37c4a89144d9a73
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 20:14:28 2008 +0100

    [NETFILTER]: Merge ipt_ah and ip6t_ah into xt_ah
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/ipv4/netfilter/Kconfig   |   10 --
 net/ipv4/netfilter/Makefile  |    1 -
 net/ipv4/netfilter/ipt_ah.c  |  105 ------------------
 net/ipv6/netfilter/Kconfig   |    9 --
 net/ipv6/netfilter/Makefile  |    1 -
 net/ipv6/netfilter/ip6t_ah.c |  131 -----------------------
 net/netfilter/Kconfig        |    8 ++
 net/netfilter/Makefile       |    1 +
 net/netfilter/xt_ah.c        |  192 ++++++++++++++++++++++++++++++++++
 9 files changed, 201 insertions(+), 257 deletions(-)
 delete mode 100644 net/ipv4/netfilter/ipt_ah.c
 delete mode 100644 net/ipv6/netfilter/ip6t_ah.c
 create mode 100644 net/netfilter/xt_ah.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 89522bc..f5a73b8 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -80,16 +80,6 @@ config IP_NF_MATCH_ECN
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_AH
-	tristate '"ah" match support'
-	depends on IP_NF_IPTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This match extension allows you to match a range of SPIs
-	  inside AH header of IPSec packets.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_TTL
 	tristate '"ttl" match support'
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 664cc2d..8151c11 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
-obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o

diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
deleted file mode 100644
index 46025af..0000000
# Omitted pure deletion

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 5d22177..d119886 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -106,15 +106,6 @@ config IP6_NF_MATCH_IPV6HEADER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_AH
-	tristate '"ah" match support'
-	depends on IP6_NF_IPTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This module allows one to match AH packets.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP6_NF_MATCH_MH
 	tristate '"mh" match support'
 	depends on IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 2b47c2f..6b61224 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -16,7 +16,6 @@ nf_conntrack_ipv6-objs  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o
 
 # matches
-obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
deleted file mode 100644
index 9cc434d..0000000
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ /dev/null
# Omitted pure deletion

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e4cd97d..fc117a2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -466,6 +466,14 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
 	  TCP options from TCP packets.
 
+config NETFILTER_XT_MATCH_AH
+	tristate '"ah" Authentication Header match'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	---help---
+	This match extension allows you to match a range of SPIs inside the
+	AH header of IPsec packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 255d53b..099741d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 
 # matches
+obj-$(CONFIG_NETFILTER_XT_MATCH_AH) += xt_ah.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
diff --git a/net/netfilter/xt_ah.c b/net/netfilter/xt_ah.c
new file mode 100644
index 0000000..c18cc70
--- /dev/null
+++ b/net/netfilter/xt_ah.c
@@ -0,0 +1,192 @@
+/*
+ *	xt_ah - Netfilter module to match AH parameters
+ *
+ *	(C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/checksum.h>
+#include <net/ipv6.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ipt_ah.h>
+#include <linux/netfilter_ipv6/ip6t_ah.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#	define WITH_IPV6 1
+#endif
+
+static inline bool
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
+{
+	bool r;
+
+	pr_debug("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",
+	         invert ? '!' : ' ', min, spi, max);
+	r = (spi >= min && spi <= max) ^ invert;
+	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
+	return r;
+}
+
+static bool
+ah_mt4(const struct sk_buff *skb, const struct net_device *in,
+       const struct net_device *out, const struct xt_match *match,
+       const void *matchinfo, int offset, unsigned int protoff,
+       bool *hotdrop)
+{
+	const struct ipt_ah *ahinfo = matchinfo;
+	const struct ip_auth_hdr *ah;
+	struct ip_auth_hdr ahbuf;
+
+	/* Must not be a fragment. */
+	if (offset != 0)
+		return false;
+
+	ah = skb_header_pointer(skb, protoff, sizeof(ahbuf), &ahbuf);
+	if (ah == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		pr_debug("Dropping evil AH tinygram.\n");
+		*hotdrop = true;
+		return 0;
+	}
+
+	return spi_match(ahinfo->spis[0], ahinfo->spis[1], ntohl(ah->spi),
+	       ahinfo->invflags & IPT_AH_INV_SPI);
+}
+
+static bool
+ah_mt4_check(const char *tablename, const void *ip_void,
+             const struct xt_match *match, void *matchinfo,
+             unsigned int hook_mask)
+{
+	const struct ipt_ah *ahinfo = matchinfo;
+
+	/* Must specify no unknown invflags */
+	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
+		pr_debug("ipt_ah: unknown flags %X\n", ahinfo->invflags);
+		return false;
+	}
+	return true;
+}
+
+#ifdef WITH_IPV6
+static bool
+ah_mt6(const struct sk_buff *skb, const struct net_device *in,
+       const struct net_device *out, const struct xt_match *match,
+       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+{
+	struct ip_auth_hdr ahbuf;
+	const struct ip_auth_hdr *ah;
+	const struct ip6t_ah *ahinfo = matchinfo;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+	int err;
+
+	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			*hotdrop = true;
+		return false;
+	}
+
+	ah = skb_header_pointer(skb, ptr, sizeof(ahbuf), &ahbuf);
+	if (ah == NULL) {
+		*hotdrop = true;
+		return false;
+	}
+
+	hdrlen = (ah->hdrlen + 2) << 2;
+
+	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
+	pr_debug("RES %04X ", ah->reserved);
+	pr_debug("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
+
+	pr_debug("IPv6 AH spi %02X ",
+		 spi_match(ahinfo->spis[0], ahinfo->spis[1],
+			   ntohl(ah->spi),
+			   !!(ahinfo->invflags & IP6T_AH_INV_SPI)));
+	pr_debug("len %02X %04X %02X ",
+		 ahinfo->hdrlen, hdrlen,
+		 (!ahinfo->hdrlen ||
+		  (ahinfo->hdrlen == hdrlen) ^
+		  !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
+	pr_debug("res %02X %04X %02X\n",
+		 ahinfo->hdrres, ah->reserved,
+		 !(ahinfo->hdrres && ah->reserved));
+
+	return (ah != NULL)
+	       &&
+	       spi_match(ahinfo->spis[0], ahinfo->spis[1],
+			 ntohl(ah->spi),
+			 !!(ahinfo->invflags & IP6T_AH_INV_SPI))
+	       &&
+	       (!ahinfo->hdrlen ||
+		(ahinfo->hdrlen == hdrlen) ^
+		!!(ahinfo->invflags & IP6T_AH_INV_LEN))
+	       &&
+	       !(ahinfo->hdrres && ah->reserved);
+}
+
+static bool
+ah_mt6_check(const char *tablename, const void *entry,
+             const struct xt_match *match, void *matchinfo,
+             unsigned int hook_mask)
+{
+	const struct ip6t_ah *ahinfo = matchinfo;
+
+	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
+		pr_debug("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
+		return false;
+	}
+	return true;
+}
+#endif
+
+static struct xt_match ah_mt_reg[] __read_mostly = {
+	{
+		.name       = "ah",
+		.revision   = 0,
+		.family     = AF_INET,
+		.match      = ah_mt4,
+		.matchsize  = sizeof(struct ipt_ah),
+		.checkentry = ah_mt4_check,
+		.me         = THIS_MODULE,
+	},
+#ifdef WITH_IPV6
+	{
+		.name       = "ah",
+		.revision   = 0,
+		.family     = AF_INET6,
+		.match      = ah_mt6,
+		.matchsize  = sizeof(struct ip6t_ah),
+		.checkentry = ah_mt6_check,
+		.me         = THIS_MODULE,
+	},
+#endif
+};
+
+static int __init ah_mt_init(void)
+{
+	return xt_register_matches(ah_mt_reg, ARRAY_SIZE(ah_mt_reg));
+}
+
+static void __exit ah_mt_exit(void)
+{
+	xt_unregister_matches(ah_mt_reg, ARRAY_SIZE(ah_mt_reg));
+}
+
+module_init(ah_mt_init);
+module_exit(ah_mt_exit);
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+MODULE_DESCRIPTION("Netfilter \"ah\" match");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_ah");
+MODULE_ALIAS("ip6t_ah");
