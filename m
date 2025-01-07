Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DA61F4E4E;
	Tue,  7 Jan 2025 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275675; cv=none; b=BbIUQKnC53QIvYRCKxkF/f5i9PKjagH+E/+c579HJo7H0b0UlbHZlVoU5w7mGn/kBWU90I9t17kS2EXTf0yA8OUhptTPsi5JCi8aszwoGlsjGpRIlhZigisDSrikTzGKAjG/sjwro9aqsNy+j/OOZYdF8sDYQkyGelmhyinJGRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275675; c=relaxed/simple;
	bh=34xHcBkLP9MKWpkTwOCkiWSWE0s0AkGmcWIvkDXzZ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFtos75tOe1A5VZM1pZbnVeeESnSbr9AbqN0zWZAcrrcL93GdcM8LDohTDKyIqw6OXI3GOFXyTVtiMGW0E3iWV9kPIzwOAZem3gnGAaYgUMkf8uNcmAabrBrpZtkEdV4l2DXT4msVs9x0WzuY+As+/N73bUM2W2nGVDV1R23iE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=evWGOg9Q reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="evWGOg9Q"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKmj60cKz10G1;
	Tue, 07 Jan 2025 19:47:49 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 2/6] netfilter: x_tables: Merge xt_DSCP.c to xt_dscp.c
Date: Tue,  7 Jan 2025 19:47:20 +0100
Message-ID: <20250107184724.56223-3-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107184724.56223-1-egyszeregy@freemail.hu>
References: <20250107184724.56223-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275670;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=13621; bh=NAW8pR1PhSSuLmU+nt2z8zBJ/Rj8N54lH9MUySmdUnc=;
	b=evWGOg9Qrq/Sr/+cyJEGzmTFYEkaxRPEKhw9FEVQRWHNpbKWdGIhZErkVGBQrljg
	0hBxtgZ+AWMw5ZDjGVOY1Lu32iN2hrKFH6TfHli3gxdFYTlob6vroQ5+HoST535xMEh
	2KwmPJyn2H9S0VUBr6aEA82BjUVmqbozxSfPETeigNIL1PAkMSnM4VNYMr86wSu6Un2
	V9Uog3Pona8DOIrks3nWSyFloyZ3RFqWZhAMwwID+yNz9pGw+GpESN7YNl7BMNji2xW
	ZB8eQDTMIDS0VenDUbiN3N92XamcSdtEdO3BRuejSb/AYwCs1Mfhe7hN9eitbm62Gkw
	tiwrVvW1fg==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_DSCP.c to xt_dscp.c file and remove xt_DSCP.c.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/Kconfig   |  21 ++++++
 net/netfilter/Makefile  |   3 +-
 net/netfilter/xt_DSCP.c | 160 ----------------------------------------
 net/netfilter/xt_dscp.c | 155 ++++++++++++++++++++++++++++++++++++--
 4 files changed, 170 insertions(+), 169 deletions(-)
 delete mode 100644 net/netfilter/xt_DSCP.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df2dc21304ef..ae0c30641cec 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -802,6 +802,17 @@ config NETFILTER_XT_SET
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_DSCP
+	tristate '"DSCP" and "TOS" target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "DSCP" target and "dscp" match.
+
+	  Netfilter dscp matching which allows you to match against the
+	  IPv4/IPv6 header DSCP field (differentiated services codepoint).
+	  The target allows you to manipulate the IPv4/IPv6
+	  header DSCP field (differentiated services codepoint).
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
@@ -882,6 +893,7 @@ config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_DSCP
 	help
 	  This option adds a `DSCP' target, which allows you to manipulate
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -892,6 +904,10 @@ config NETFILTER_XT_TARGET_DSCP
 	  the "mangle" table which alter the Type Of Service field of an IPv4
 	  or the Priority field of an IPv6 packet, prior to routing.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_DSCP (combined dscp/DSCP module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_HL
@@ -1301,6 +1317,7 @@ config NETFILTER_XT_MATCH_DEVGROUP
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"dscp" and "tos" match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_DSCP
 	help
 	  This option adds a `DSCP' match, which allows you to match against
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -1311,6 +1328,10 @@ config NETFILTER_XT_MATCH_DSCP
 	  based on the Type Of Service fields of the IPv4 packet (which share
 	  the same bits as DSCP).
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_DSCP (combined dscp/DSCP module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_ECN
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f0aa4d7ef499..5f9927563b35 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -160,6 +160,7 @@ obj-$(CONFIG_NETFILTER_XT_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
 obj-$(CONFIG_NETFILTER_XT_NAT) += xt_nat.o
+obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o
 
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
@@ -167,7 +168,6 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_CHECKSUM.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HMARK) += xt_HMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
@@ -198,7 +198,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CPU) += xt_cpu.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DEVGROUP) += xt_devgroup.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ECN) += xt_ecn.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
deleted file mode 100644
index a76701fd31ab..000000000000
--- a/net/netfilter/xt_DSCP.c
+++ /dev/null
@@ -1,160 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
- *
- * (C) 2002 by Harald Welte <laforge@netfilter.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- *
- * See RFC2474 for a description of the DSCP field within the IP Header.
-*/
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/dsfield.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_dscp.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_DSCP");
-MODULE_ALIAS("ip6t_DSCP");
-MODULE_ALIAS("ipt_TOS");
-MODULE_ALIAS("ip6t_TOS");
-
-#define XT_DSCP_ECN_MASK	3u
-
-static unsigned int
-dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	if (dscp != dinfo->dscp) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-
-		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
-				    dinfo->dscp << XT_DSCP_SHIFT);
-	}
-	return XT_CONTINUE;
-}
-
-static unsigned int
-dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	if (dscp != dinfo->dscp) {
-		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
-			return NF_DROP;
-
-		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
-				    dinfo->dscp << XT_DSCP_SHIFT);
-	}
-	return XT_CONTINUE;
-}
-
-static int dscp_tg_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_DSCP_info *info = par->targinfo;
-
-	if (info->dscp > XT_DSCP_MAX)
-		return -EDOM;
-	return 0;
-}
-
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_tos_target_info *info = par->targinfo;
-	struct iphdr *iph = ip_hdr(skb);
-	u8 orig, nv;
-
-	orig = ipv4_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-
-	if (orig != nv) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ip_hdr(skb);
-		ipv4_change_dsfield(iph, 0, nv);
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_tos_target_info *info = par->targinfo;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-	u8 orig, nv;
-
-	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-
-	if (orig != nv) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ipv6_hdr(skb);
-		ipv6_change_dsfield(iph, 0, nv);
-	}
-
-	return XT_CONTINUE;
-}
-
-static struct xt_target dscp_tg_reg[] __read_mostly = {
-	{
-		.name		= "DSCP",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= dscp_tg_check,
-		.target		= dscp_tg,
-		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "DSCP",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= dscp_tg_check,
-		.target		= dscp_tg6,
-		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TOS",
-		.revision	= 1,
-		.family		= NFPROTO_IPV4,
-		.table		= "mangle",
-		.target		= tos_tg,
-		.targetsize	= sizeof(struct xt_tos_target_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TOS",
-		.revision	= 1,
-		.family		= NFPROTO_IPV6,
-		.table		= "mangle",
-		.target		= tos_tg6,
-		.targetsize	= sizeof(struct xt_tos_target_info),
-		.me		= THIS_MODULE,
-	},
-};
-
-static int __init dscp_tg_init(void)
-{
-	return xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
-}
-
-static void __exit dscp_tg_exit(void)
-{
-	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
-}
-
-module_init(dscp_tg_init);
-module_exit(dscp_tg_exit);
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f9bb..bdd67b0458ab 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* IP tables module for matching the value of the IPv4/IPv6 DSCP field
+/* x_tables module for matching/modifying the value of the IPv4/IPv6 DSCP field
  *
  * (C) 2002 by Harald Welte <laforge@netfilter.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
@@ -14,12 +17,19 @@
 #include <linux/netfilter/xt_dscp.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field match");
+MODULE_DESCRIPTION("Xtables: DSCP/TOS field match and target modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 MODULE_ALIAS("ipt_tos");
 MODULE_ALIAS("ip6t_tos");
+MODULE_ALIAS("ipt_DSCP");
+MODULE_ALIAS("ip6t_DSCP");
+MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
+MODULE_ALIAS("xt_DSCP");
+
+#define XT_DSCP_ECN_MASK	3u
 
 static bool
 dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -96,15 +106,146 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init dscp_mt_init(void)
+static unsigned int
+dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_DSCP_info *dinfo = par->targinfo;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static unsigned int
+dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	const struct xt_DSCP_info *dinfo = par->targinfo;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
+			return NF_DROP;
+
+		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static int dscp_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_DSCP_info *info = par->targinfo;
+
+	if (info->dscp > XT_DSCP_MAX)
+		return -EDOM;
+	return 0;
+}
+
+static unsigned int
+tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u8 orig, nv;
+
+	orig = ipv4_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ip_hdr(skb);
+		ipv4_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	u8 orig, nv;
+
+	orig = ipv6_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ipv6_hdr(skb);
+		ipv6_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target dscp_tg_reg[] __read_mostly = {
+	{
+		.name		= "DSCP",
+		.family		= NFPROTO_IPV4,
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "DSCP",
+		.family		= NFPROTO_IPV6,
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg6,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= NFPROTO_IPV4,
+		.table		= "mangle",
+		.target		= tos_tg,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= NFPROTO_IPV6,
+		.table		= "mangle",
+		.target		= tos_tg6,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init dscp_init(void)
+{
+	int ret;
+
+	ret = xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit dscp_mt_exit(void)
+static void __exit dscp_exit(void)
 {
 	xt_unregister_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
 }
 
-module_init(dscp_mt_init);
-module_exit(dscp_mt_exit);
+module_init(dscp_init);
+module_exit(dscp_exit);
-- 
2.43.5

