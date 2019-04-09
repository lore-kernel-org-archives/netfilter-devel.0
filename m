Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D432C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531C5206C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfDIIqJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:46:09 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51568 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbfDIIqJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 04:46:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hDmOL-0008RV-Ew; Tue, 09 Apr 2019 10:46:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: x_tables: merge ip and ipv6 masquerade modules
Date:   Tue,  9 Apr 2019 10:44:07 +0200
Message-Id: <20190409084408.23730-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190409084408.23730-1-fw@strlen.de>
References: <20190409084408.23730-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to have separate modules for this.
before:
 text    data   bss    dec  filename
 2038    1168     0   3206  net/ipv4/netfilter/ipt_MASQUERADE.ko
 1526    1024     0   2550  net/ipv6/netfilter/ip6t_MASQUERADE.ko
after:
 text    data   bss    dec  filename
 2521    1296     0   3817  net/netfilter/xt_MASQUERADE.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig                    | 12 +--
 net/ipv4/netfilter/Makefile                   |  1 -
 net/ipv6/netfilter/Kconfig                    | 11 +--
 net/ipv6/netfilter/Makefile                   |  1 -
 net/ipv6/netfilter/ip6t_MASQUERADE.c          | 81 -----------------
 net/netfilter/Kconfig                         | 14 +++
 net/netfilter/Makefile                        |  1 +
 .../xt_MASQUERADE.c}                          | 90 ++++++++++++++-----
 8 files changed, 87 insertions(+), 124 deletions(-)
 delete mode 100644 net/ipv6/netfilter/ip6t_MASQUERADE.c
 rename net/{ipv4/netfilter/ipt_MASQUERADE.c => netfilter/xt_MASQUERADE.c} (51%)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ea688832fc4e..1412b029f37f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -224,16 +224,10 @@ if IP_NF_NAT
 
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
-	select NF_NAT_MASQUERADE
-	default m if NETFILTER_ADVANCED=n
+	select NETFILTER_XT_TARGET_MASQUERADE
 	help
-	  Masquerading is a special case of NAT: all outgoing connections are
-	  changed to seem to come from a particular interface's address, and
-	  if the interface goes down, those connections are lost.  This is
-	  only useful for dialup accounts with dynamic IP address (ie. your IP
-	  address will be different on next dialup).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects NETFILTER_XT_TARGET_MASQUERADE.
 
 config IP_NF_TARGET_NETMAP
 	tristate "NETMAP target support"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 2cfdda7b109f..c50e0ec095d2 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -48,7 +48,6 @@ obj-$(CONFIG_IP_NF_MATCH_RPFILTER) += ipt_rpfilter.o
 # targets
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
-obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SYNPROXY) += ipt_SYNPROXY.o
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 3de3adb1a0c9..086fc669279e 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -270,15 +270,10 @@ if IP6_NF_NAT
 
 config IP6_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
-	select NF_NAT_MASQUERADE
+	select NETFILTER_XT_TARGET_MASQUERADE
 	help
-	  Masquerading is a special case of NAT: all outgoing connections are
-	  changed to seem to come from a particular interface's address, and
-	  if the interface goes down, those connections are lost.  This is
-	  only useful for dialup accounts with dynamic IP address (ie. your IP
-	  address will be different on next dialup).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects NETFILTER_XT_TARGET_MASQUERADE.
 
 config IP6_NF_TARGET_NPT
 	tristate "NPT (Network Prefix translation) target support"
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 93aff604b243..731a74c60dca 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 obj-$(CONFIG_IP6_NF_MATCH_SRH) += ip6t_srh.o
 
 # targets
-obj-$(CONFIG_IP6_NF_TARGET_MASQUERADE) += ip6t_MASQUERADE.o
 obj-$(CONFIG_IP6_NF_TARGET_NPT) += ip6t_NPT.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
 obj-$(CONFIG_IP6_NF_TARGET_SYNPROXY) += ip6t_SYNPROXY.o
diff --git a/net/ipv6/netfilter/ip6t_MASQUERADE.c b/net/ipv6/netfilter/ip6t_MASQUERADE.c
deleted file mode 100644
index 4a22343ed67a..000000000000
--- a/net/ipv6/netfilter/ip6t_MASQUERADE.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on Rusty Russell's IPv6 MASQUERADE target. Development of IPv6
- * NAT funded by Astaro.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv6.h>
-#include <linux/netfilter/x_tables.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/addrconf.h>
-#include <net/ipv6.h>
-#include <net/netfilter/nf_nat_masquerade.h>
-
-static unsigned int
-masquerade_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	return nf_nat_masquerade_ipv6(skb, par->targinfo, xt_out(par));
-}
-
-static int masquerade_tg6_checkentry(const struct xt_tgchk_param *par)
-{
-	const struct nf_nat_range2 *range = par->targinfo;
-
-	if (range->flags & NF_NAT_RANGE_MAP_IPS)
-		return -EINVAL;
-	return nf_ct_netns_get(par->net, par->family);
-}
-
-static void masquerade_tg6_destroy(const struct xt_tgdtor_param *par)
-{
-	nf_ct_netns_put(par->net, par->family);
-}
-
-static struct xt_target masquerade_tg6_reg __read_mostly = {
-	.name		= "MASQUERADE",
-	.family		= NFPROTO_IPV6,
-	.checkentry	= masquerade_tg6_checkentry,
-	.destroy	= masquerade_tg6_destroy,
-	.target		= masquerade_tg6,
-	.targetsize	= sizeof(struct nf_nat_range),
-	.table		= "nat",
-	.hooks		= 1 << NF_INET_POST_ROUTING,
-	.me		= THIS_MODULE,
-};
-
-static int __init masquerade_tg6_init(void)
-{
-	int err;
-
-	err = xt_register_target(&masquerade_tg6_reg);
-	if (err)
-		return err;
-
-	err = nf_nat_masquerade_ipv6_register_notifier();
-	if (err)
-		xt_unregister_target(&masquerade_tg6_reg);
-
-	return err;
-}
-static void __exit masquerade_tg6_exit(void)
-{
-	nf_nat_masquerade_ipv6_unregister_notifier();
-	xt_unregister_target(&masquerade_tg6_reg);
-}
-
-module_init(masquerade_tg6_init);
-module_exit(masquerade_tg6_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables: automatic address SNAT");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f4384c096d0d..02b281d3c167 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -997,6 +997,20 @@ config NETFILTER_XT_TARGET_REDIRECT
 
 	To compile it as a module, choose M here. If unsure, say N.
 
+config NETFILTER_XT_TARGET_MASQUERADE
+	tristate "MASQUERADE target support"
+	depends on NF_NAT
+	default m if NETFILTER_ADVANCED=n
+	select NF_NAT_MASQUERADE
+	help
+	  Masquerading is a special case of NAT: all outgoing connections are
+	  changed to seem to come from a particular interface's address, and
+	  if the interface goes down, those connections are lost.  This is
+	  only useful for dialup accounts with dynamic IP address (ie. your IP
+	  address will be different on next dialup).
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_TEE
 	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index afbf475e02b2..72cca6b48960 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -148,6 +148,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/netfilter/xt_MASQUERADE.c
similarity index 51%
rename from net/ipv4/netfilter/ipt_MASQUERADE.c
rename to net/netfilter/xt_MASQUERADE.c
index 0a2bffb6a0ad..96d884718749 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/netfilter/xt_MASQUERADE.c
@@ -9,17 +9,7 @@
  * published by the Free Software Foundation.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/types.h>
-#include <linux/inetdevice.h>
-#include <linux/ip.h>
-#include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
-#include <net/protocol.h>
-#include <net/ip.h>
-#include <net/checksum.h>
-#include <net/route.h>
-#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_masquerade.h>
@@ -64,38 +54,90 @@ static void masquerade_tg_destroy(const struct xt_tgdtor_param *par)
 	nf_ct_netns_put(par->net, par->family);
 }
 
-static struct xt_target masquerade_tg_reg __read_mostly = {
-	.name		= "MASQUERADE",
-	.family		= NFPROTO_IPV4,
-	.target		= masquerade_tg,
-	.targetsize	= sizeof(struct nf_nat_ipv4_multi_range_compat),
-	.table		= "nat",
-	.hooks		= 1 << NF_INET_POST_ROUTING,
-	.checkentry	= masquerade_tg_check,
-	.destroy	= masquerade_tg_destroy,
-	.me		= THIS_MODULE,
+#if IS_ENABLED(CONFIG_IPV6)
+static unsigned int
+masquerade_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	return nf_nat_masquerade_ipv6(skb, par->targinfo, xt_out(par));
+}
+
+static int masquerade_tg6_checkentry(const struct xt_tgchk_param *par)
+{
+	const struct nf_nat_range2 *range = par->targinfo;
+
+	if (range->flags & NF_NAT_RANGE_MAP_IPS)
+		return -EINVAL;
+
+	return nf_ct_netns_get(par->net, par->family);
+}
+#endif
+
+static struct xt_target masquerade_tg_reg[] __read_mostly = {
+	{
+#if IS_ENABLED(CONFIG_IPV6)
+		.name		= "MASQUERADE",
+		.family		= NFPROTO_IPV6,
+		.target		= masquerade_tg6,
+		.targetsize	= sizeof(struct nf_nat_range),
+		.table		= "nat",
+		.hooks		= 1 << NF_INET_POST_ROUTING,
+		.checkentry	= masquerade_tg6_checkentry,
+		.destroy	= masquerade_tg_destroy,
+		.me		= THIS_MODULE,
+	}, {
+#endif
+		.name		= "MASQUERADE",
+		.family		= NFPROTO_IPV4,
+		.target		= masquerade_tg,
+		.targetsize	= sizeof(struct nf_nat_ipv4_multi_range_compat),
+		.table		= "nat",
+		.hooks		= 1 << NF_INET_POST_ROUTING,
+		.checkentry	= masquerade_tg_check,
+		.destroy	= masquerade_tg_destroy,
+		.me		= THIS_MODULE,
+	}
 };
 
 static int __init masquerade_tg_init(void)
 {
 	int ret;
 
-	ret = xt_register_target(&masquerade_tg_reg);
+	ret = xt_register_targets(masquerade_tg_reg,
+				  ARRAY_SIZE(masquerade_tg_reg));
 	if (ret)
 		return ret;
 
 	ret = nf_nat_masquerade_ipv4_register_notifier();
-	if (ret)
-		xt_unregister_target(&masquerade_tg_reg);
+	if (ret) {
+		xt_unregister_targets(masquerade_tg_reg,
+				      ARRAY_SIZE(masquerade_tg_reg));
+		return ret;
+	}
 
+#if IS_ENABLED(CONFIG_IPV6)
+	ret = nf_nat_masquerade_ipv6_register_notifier();
+	if (ret) {
+		xt_unregister_targets(masquerade_tg_reg,
+				      ARRAY_SIZE(masquerade_tg_reg));
+		nf_nat_masquerade_ipv4_unregister_notifier();
+		return ret;
+	}
+#endif
 	return ret;
 }
 
 static void __exit masquerade_tg_exit(void)
 {
-	xt_unregister_target(&masquerade_tg_reg);
+	xt_unregister_targets(masquerade_tg_reg, ARRAY_SIZE(masquerade_tg_reg));
 	nf_nat_masquerade_ipv4_unregister_notifier();
+#if IS_ENABLED(CONFIG_IPV6)
+	nf_nat_masquerade_ipv6_unregister_notifier();
+#endif
 }
 
 module_init(masquerade_tg_init);
 module_exit(masquerade_tg_exit);
+#if IS_ENABLED(CONFIG_IPV6)
+MODULE_ALIAS("ip6t_MASQUERADE");
+#endif
+MODULE_ALIAS("ipt_MASQUERADE");
-- 
2.21.0

