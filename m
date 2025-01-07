Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C2A1F540C;
	Tue,  7 Jan 2025 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275682; cv=none; b=YKLQu+3bBw2FV1FVKUuitk2/8iOaGDBCHRJ8C4NH6ictTuy6LzJLLMf8J5NjgAbxs8N3VhKx/hu75fwYSuaPg1gN6ObpQUmxizKxliKVZqT2nTrFThW9p65v40wYo7ok8pNd2A16/z2zBdc2hRI6IM0gGEmbcHuanIV/OpyRFf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275682; c=relaxed/simple;
	bh=V+fr7GIVrQQm4X9la1BlNUmLzdE6qO65HNVNNQpfauo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QxDWOOmMYeNi1zccaaMZ9hUA2kdMOf8auqNLyWobYGYd05xbMH/2VJvdJ0jSCDBBLtLUTymWERrvSCrVk4QgWxIVmcKgG8IUY2aZPxCsm3XGnuJA42LYp1JqmChQIchMdVXN5CUxOPJR/XkdSdNH1OqI/+1Pvvw2oHWPuJO9UB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=eopd5hRB reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="eopd5hRB"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKmr2zCjz10rx;
	Tue, 07 Jan 2025 19:47:56 +0100 (CET)
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
Subject: [PATCH 3/6] netfilter: x_tables: Merge xt_HL.c to xt_hl.c
Date: Tue,  7 Jan 2025 19:47:21 +0100
Message-ID: <20250107184724.56223-4-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275677;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=12858; bh=5SeJleRUlf06zufvMo4YMnypeY+NN0xgQggiV9ZGVG0=;
	b=eopd5hRBMyjC4vOa4trwKO+yExNdkCMToZgP3uS6hiHTA1zTlnITnn/sYg22grYj
	z6/kf3KmjiknqneZFOeGJyXOQnpbBOckQhi2s5sXx3htIXygk0geP1Bhf9BT921rkZI
	tluT4jls6AOhoUE4AZb5NEqGWAGCIXa3YCWz9RPpHvSLCJSqsRlPu2t5j+TwjtMhEfc
	tybqkAxnWfXfSLrQV4s+SI5DvMN4akR6x176avv3h24D+gdZcdQvYLpMaux7fXbz4dI
	2TcLKqTcr2bKi8pRwkGjX6UWVOGhBust2bMubx9draMrO7KsxMRqBh8qZdLlICHiNac
	QlKbFsGJWA==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_HL.c to xt_hl.c file and remove xt_HL.c.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/Kconfig  |  22 ++++++
 net/netfilter/Makefile |   3 +-
 net/netfilter/xt_HL.c  | 158 ---------------------------------------
 net/netfilter/xt_hl.c  | 163 ++++++++++++++++++++++++++++++++++++++---
 4 files changed, 175 insertions(+), 171 deletions(-)
 delete mode 100644 net/netfilter/xt_HL.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ae0c30641cec..ca293f9a1db5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -813,6 +813,18 @@ config NETFILTER_XT_DSCP
 	  The target allows you to manipulate the IPv4/IPv6
 	  header DSCP field (differentiated services codepoint).
 
+config NETFILTER_XT_HL
+	tristate '"HL" hoplimit target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "HL" target and "hl" match.
+
+	  Netfilter hl matching allows you to match packets based on
+	  the hoplimit in the IPv6 header, or the time-to-live field in
+	  the IPv4 header of the packet.
+	  The target allows you to change the hoplimit/time-to-live
+	  value of the IP header.
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
@@ -914,6 +926,7 @@ config NETFILTER_XT_TARGET_HL
 	tristate '"HL" hoplimit target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_HL
 	help
 	This option adds the "HL" (for IPv6) and "TTL" (for IPv4)
 	targets, which enable the user to change the
@@ -925,6 +938,10 @@ config NETFILTER_XT_TARGET_HL
 	since you can easily create immortal packets that loop
 	forever on the network.
 
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_HL (combined hl/HL module).
+
 config NETFILTER_XT_TARGET_HMARK
 	tristate '"HMARK" target support'
 	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
@@ -1380,11 +1397,16 @@ config NETFILTER_XT_MATCH_HELPER
 config NETFILTER_XT_MATCH_HL
 	tristate '"hl" hoplimit/TTL match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_HL
 	help
 	HL matching allows you to match packets based on the hoplimit
 	in the IPv6 header, or the time-to-live field in the IPv4
 	header of the packet.
 
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_HL (combined hl/HL module).
+
 config NETFILTER_XT_MATCH_IPCOMP
 	tristate '"ipcomp" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5f9927563b35..381a18ce84d0 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -161,6 +161,7 @@ obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
 obj-$(CONFIG_NETFILTER_XT_NAT) += xt_nat.o
 obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o
+obj-$(CONFIG_NETFILTER_XT_HL) += xt_hl.o
 
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
@@ -168,7 +169,6 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_CHECKSUM.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HMARK) += xt_HMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LOG) += xt_LOG.o
@@ -202,7 +202,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_ECN) += xt_ecn.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_HL) += xt_hl.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPCOMP) += xt_ipcomp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPRANGE) += xt_iprange.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPVS) += xt_ipvs.o
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
deleted file mode 100644
index 1e1b30b27fef..000000000000
--- a/net/netfilter/xt_HL.c
+++ /dev/null
@@ -1,158 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * TTL modification target for IP tables
- * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
- *
- * Hop Limit modification target for ip6tables
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_ttl.h>
-#include <linux/netfilter_ipv6/ip6t_hl.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL Limit field modification target");
-MODULE_LICENSE("GPL");
-
-static unsigned int
-ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct iphdr *iph;
-	const struct ipt_TTL_info *info = par->targinfo;
-	int new_ttl;
-
-	if (skb_ensure_writable(skb, sizeof(*iph)))
-		return NF_DROP;
-
-	iph = ip_hdr(skb);
-
-	switch (info->mode) {
-	case IPT_TTL_SET:
-		new_ttl = info->ttl;
-		break;
-	case IPT_TTL_INC:
-		new_ttl = iph->ttl + info->ttl;
-		if (new_ttl > 255)
-			new_ttl = 255;
-		break;
-	case IPT_TTL_DEC:
-		new_ttl = iph->ttl - info->ttl;
-		if (new_ttl < 0)
-			new_ttl = 0;
-		break;
-	default:
-		new_ttl = iph->ttl;
-		break;
-	}
-
-	if (new_ttl != iph->ttl) {
-		csum_replace2(&iph->check, htons(iph->ttl << 8), htons(new_ttl << 8));
-		iph->ttl = new_ttl;
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct ipv6hdr *ip6h;
-	const struct ip6t_HL_info *info = par->targinfo;
-	int new_hl;
-
-	if (skb_ensure_writable(skb, sizeof(*ip6h)))
-		return NF_DROP;
-
-	ip6h = ipv6_hdr(skb);
-
-	switch (info->mode) {
-	case IP6T_HL_SET:
-		new_hl = info->hop_limit;
-		break;
-	case IP6T_HL_INC:
-		new_hl = ip6h->hop_limit + info->hop_limit;
-		if (new_hl > 255)
-			new_hl = 255;
-		break;
-	case IP6T_HL_DEC:
-		new_hl = ip6h->hop_limit - info->hop_limit;
-		if (new_hl < 0)
-			new_hl = 0;
-		break;
-	default:
-		new_hl = ip6h->hop_limit;
-		break;
-	}
-
-	ip6h->hop_limit = new_hl;
-
-	return XT_CONTINUE;
-}
-
-static int ttl_tg_check(const struct xt_tgchk_param *par)
-{
-	const struct ipt_TTL_info *info = par->targinfo;
-
-	if (info->mode > IPT_TTL_MAXMODE)
-		return -EINVAL;
-	if (info->mode != IPT_TTL_SET && info->ttl == 0)
-		return -EINVAL;
-	return 0;
-}
-
-static int hl_tg6_check(const struct xt_tgchk_param *par)
-{
-	const struct ip6t_HL_info *info = par->targinfo;
-
-	if (info->mode > IP6T_HL_MAXMODE)
-		return -EINVAL;
-	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
-		return -EINVAL;
-	return 0;
-}
-
-static struct xt_target hl_tg_reg[] __read_mostly = {
-	{
-		.name       = "TTL",
-		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = ttl_tg,
-		.targetsize = sizeof(struct ipt_TTL_info),
-		.table      = "mangle",
-		.checkentry = ttl_tg_check,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "HL",
-		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = hl_tg6,
-		.targetsize = sizeof(struct ip6t_HL_info),
-		.table      = "mangle",
-		.checkentry = hl_tg6_check,
-		.me         = THIS_MODULE,
-	},
-};
-
-static int __init hl_tg_init(void)
-{
-	return xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
-}
-
-static void __exit hl_tg_exit(void)
-{
-	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
-}
-
-module_init(hl_tg_init);
-module_exit(hl_tg_exit);
-MODULE_ALIAS("ipt_TTL");
-MODULE_ALIAS("ip6t_HL");
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0441..330951c0dfe2 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -1,26 +1,36 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * IP tables module for matching the value of the TTL
+/* IP tables module for matching/modifying the value of the TTL
  * (C) 2000,2001 by Harald Welte <laforge@netfilter.org>
  *
  * Hop Limit matching module
  * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ *
+ * TTL modification target for IP tables
+ * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * Hop Limit modification target for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
-
-#include <linux/ip.h>
-#include <linux/ipv6.h>
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match");
+MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match and modification target");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_ttl");
 MODULE_ALIAS("ip6t_hl");
+MODULE_ALIAS("ipt_TTL");
+MODULE_ALIAS("ip6t_HL");
+MODULE_ALIAS("xt_HL");
 
 static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -79,15 +89,146 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init hl_mt_init(void)
+static unsigned int
+ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph;
+	const struct ipt_TTL_info *info = par->targinfo;
+	int new_ttl;
+
+	if (skb_ensure_writable(skb, sizeof(*iph)))
+		return NF_DROP;
+
+	iph = ip_hdr(skb);
+
+	switch (info->mode) {
+	case IPT_TTL_SET:
+		new_ttl = info->ttl;
+		break;
+	case IPT_TTL_INC:
+		new_ttl = iph->ttl + info->ttl;
+		if (new_ttl > 255)
+			new_ttl = 255;
+		break;
+	case IPT_TTL_DEC:
+		new_ttl = iph->ttl - info->ttl;
+		if (new_ttl < 0)
+			new_ttl = 0;
+		break;
+	default:
+		new_ttl = iph->ttl;
+		break;
+	}
+
+	if (new_ttl != iph->ttl) {
+		csum_replace2(&iph->check, htons(iph->ttl << 8), htons(new_ttl << 8));
+		iph->ttl = new_ttl;
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ip6h;
+	const struct ip6t_HL_info *info = par->targinfo;
+	int new_hl;
+
+	if (skb_ensure_writable(skb, sizeof(*ip6h)))
+		return NF_DROP;
+
+	ip6h = ipv6_hdr(skb);
+
+	switch (info->mode) {
+	case IP6T_HL_SET:
+		new_hl = info->hop_limit;
+		break;
+	case IP6T_HL_INC:
+		new_hl = ip6h->hop_limit + info->hop_limit;
+		if (new_hl > 255)
+			new_hl = 255;
+		break;
+	case IP6T_HL_DEC:
+		new_hl = ip6h->hop_limit - info->hop_limit;
+		if (new_hl < 0)
+			new_hl = 0;
+		break;
+	default:
+		new_hl = ip6h->hop_limit;
+		break;
+	}
+
+	ip6h->hop_limit = new_hl;
+
+	return XT_CONTINUE;
+}
+
+static int ttl_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct ipt_TTL_info *info = par->targinfo;
+
+	if (info->mode > IPT_TTL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IPT_TTL_SET && info->ttl == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int hl_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct ip6t_HL_info *info = par->targinfo;
+
+	if (info->mode > IP6T_HL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static struct xt_target hl_tg_reg[] __read_mostly = {
+	{
+		.name       = "TTL",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.target     = ttl_tg,
+		.targetsize = sizeof(struct ipt_TTL_info),
+		.table      = "mangle",
+		.checkentry = ttl_tg_check,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "HL",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.target     = hl_tg6,
+		.targetsize = sizeof(struct ip6t_HL_info),
+		.table      = "mangle",
+		.checkentry = hl_tg6_check,
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init hl_init(void)
 {
-	return xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	int ret;
+
+	ret = xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit hl_mt_exit(void)
+static void __exit hl_exit(void)
 {
 	xt_unregister_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
 }
 
-module_init(hl_mt_init);
-module_exit(hl_mt_exit);
+module_init(hl_init);
+module_exit(hl_exit);
-- 
2.43.5

