Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CC1C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A141720838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfCBShl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:41 -0500
Received: from mail.us.es ([193.147.175.20]:36386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbfCBShk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AA7651361B1
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E155DA867
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 82F82DA84E; Sat,  2 Mar 2019 19:37:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B1C2DA867;
        Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7C55C4265A2F;
        Sat,  2 Mar 2019 19:37:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 27/29] netfilter: nf_tables: nat: merge nft_redir protocol specific modules
Date:   Sat,  2 Mar 2019 19:37:18 +0100
Message-Id: <20190302183720.3220-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

before:
 text	   data	    bss	    dec	    hex	filename
 990	    832	      0	   1822	    71e nft_redir.ko
 697	    896	      0	   1593	    639 nft_redir_ipv4.ko
 713	    896	      0	   1609	    649	nft_redir_ipv6.ko

after:
 text	   data	    bss	    dec	    hex	filename
 1910	    960	      0	   2870	    b36	nft_redir.ko

size is reduced, all helpers from nft_redir.ko can be made static.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_redir.h   |  22 ------
 net/ipv4/netfilter/Kconfig          |   8 --
 net/ipv4/netfilter/Makefile         |   1 -
 net/ipv4/netfilter/nft_redir_ipv4.c |  82 -------------------
 net/ipv6/netfilter/Kconfig          |   8 --
 net/ipv6/netfilter/Makefile         |   1 -
 net/ipv6/netfilter/nft_redir_ipv6.c |  83 -------------------
 net/netfilter/Kconfig               |   1 +
 net/netfilter/nft_redir.c           | 154 +++++++++++++++++++++++++++++++++---
 9 files changed, 143 insertions(+), 217 deletions(-)
 delete mode 100644 include/net/netfilter/nft_redir.h
 delete mode 100644 net/ipv4/netfilter/nft_redir_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nft_redir_ipv6.c

diff --git a/include/net/netfilter/nft_redir.h b/include/net/netfilter/nft_redir.h
deleted file mode 100644
index 4a970737c03c..000000000000
--- a/include/net/netfilter/nft_redir.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NFT_REDIR_H_
-#define _NFT_REDIR_H_
-
-struct nft_redir {
-	enum nft_registers	sreg_proto_min:8;
-	enum nft_registers	sreg_proto_max:8;
-	u16			flags;
-};
-
-extern const struct nla_policy nft_redir_policy[];
-
-int nft_redir_init(const struct nft_ctx *ctx,
-		   const struct nft_expr *expr,
-		   const struct nlattr * const tb[]);
-
-int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr);
-
-int nft_redir_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		       const struct nft_data **data);
-
-#endif /* _NFT_REDIR_H_ */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 8688461ed077..12cc3f7d7733 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -115,14 +115,6 @@ config NFT_MASQ_IPV4
 	  This is the expression that provides IPv4 masquerading support for
 	  nf_tables.
 
-config NFT_REDIR_IPV4
-	tristate "IPv4 redirect support for nf_tables"
-	depends on NF_TABLES_IPV4
-	depends on NFT_REDIR
-	select NF_NAT_REDIRECT
-	help
-	  This is the expression that provides IPv4 redirect support for
-	  nf_tables.
 endif # NF_TABLES
 
 config NF_NAT_SNMP_BASIC
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index b2cdf705fdf1..5558caf92578 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -29,7 +29,6 @@ obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
-obj-$(CONFIG_NFT_REDIR_IPV4) += nft_redir_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 
 # flow table support
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
deleted file mode 100644
index 5120be1d3118..000000000000
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_redirect.h>
-#include <net/netfilter/nft_redir.h>
-
-static void nft_redir_ipv4_eval(const struct nft_expr *expr,
-				struct nft_regs *regs,
-				const struct nft_pktinfo *pkt)
-{
-	struct nft_redir *priv = nft_expr_priv(expr);
-	struct nf_nat_ipv4_multi_range_compat mr;
-
-	memset(&mr, 0, sizeof(mr));
-	if (priv->sreg_proto_min) {
-		mr.range[0].min.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		mr.range[0].max.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-	}
-
-	mr.range[0].flags |= priv->flags;
-
-	regs->verdict.code = nf_nat_redirect_ipv4(pkt->skb, &mr, nft_hook(pkt));
-}
-
-static void
-nft_redir_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
-{
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
-}
-
-static struct nft_expr_type nft_redir_ipv4_type;
-static const struct nft_expr_ops nft_redir_ipv4_ops = {
-	.type		= &nft_redir_ipv4_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
-	.eval		= nft_redir_ipv4_eval,
-	.init		= nft_redir_init,
-	.destroy	= nft_redir_ipv4_destroy,
-	.dump		= nft_redir_dump,
-	.validate	= nft_redir_validate,
-};
-
-static struct nft_expr_type nft_redir_ipv4_type __read_mostly = {
-	.family		= NFPROTO_IPV4,
-	.name		= "redir",
-	.ops		= &nft_redir_ipv4_ops,
-	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_REDIR_MAX,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nft_redir_ipv4_module_init(void)
-{
-	return nft_register_expr(&nft_redir_ipv4_type);
-}
-
-static void __exit nft_redir_ipv4_module_exit(void)
-{
-	nft_unregister_expr(&nft_redir_ipv4_type);
-}
-
-module_init(nft_redir_ipv4_module_init);
-module_exit(nft_redir_ipv4_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index a04a38166d8c..7e7cc411003a 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -49,14 +49,6 @@ config NFT_MASQ_IPV6
 	  This is the expression that provides IPv4 masquerading support for
 	  nf_tables.
 
-config NFT_REDIR_IPV6
-	tristate "IPv6 redirect support for nf_tables"
-	depends on NFT_REDIR
-	select NF_NAT_REDIRECT
-	help
-	  This is the expression that provides IPv4 redirect support for
-	  nf_tables.
-
 endif # NF_NAT
 
 config NFT_REJECT_IPV6
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index afb880427133..42a80d03245a 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -31,7 +31,6 @@ obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_MASQ_IPV6) += nft_masq_ipv6.o
-obj-$(CONFIG_NFT_REDIR_IPV6) += nft_redir_ipv6.o
 obj-$(CONFIG_NFT_DUP_IPV6) += nft_dup_ipv6.o
 obj-$(CONFIG_NFT_FIB_IPV6) += nft_fib_ipv6.o
 
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
deleted file mode 100644
index 74269865acc8..000000000000
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nft_redir.h>
-#include <net/netfilter/nf_nat_redirect.h>
-
-static void nft_redir_ipv6_eval(const struct nft_expr *expr,
-				struct nft_regs *regs,
-				const struct nft_pktinfo *pkt)
-{
-	struct nft_redir *priv = nft_expr_priv(expr);
-	struct nf_nat_range2 range;
-
-	memset(&range, 0, sizeof(range));
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-	}
-
-	range.flags |= priv->flags;
-
-	regs->verdict.code =
-		nf_nat_redirect_ipv6(pkt->skb, &range, nft_hook(pkt));
-}
-
-static void
-nft_redir_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
-{
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
-}
-
-static struct nft_expr_type nft_redir_ipv6_type;
-static const struct nft_expr_ops nft_redir_ipv6_ops = {
-	.type		= &nft_redir_ipv6_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
-	.eval		= nft_redir_ipv6_eval,
-	.init		= nft_redir_init,
-	.destroy	= nft_redir_ipv6_destroy,
-	.dump		= nft_redir_dump,
-	.validate	= nft_redir_validate,
-};
-
-static struct nft_expr_type nft_redir_ipv6_type __read_mostly = {
-	.family		= NFPROTO_IPV6,
-	.name		= "redir",
-	.ops		= &nft_redir_ipv6_ops,
-	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_REDIR_MAX,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nft_redir_ipv6_module_init(void)
-{
-	return nft_register_expr(&nft_redir_ipv6_type);
-}
-
-static void __exit nft_redir_ipv6_module_exit(void)
-{
-	nft_unregister_expr(&nft_redir_ipv6_type);
-}
-
-module_init(nft_redir_ipv6_module_init);
-module_exit(nft_redir_ipv6_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 5beb51d39dc2..73857f9fdb25 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -541,6 +541,7 @@ config NFT_REDIR
 	depends on NF_CONNTRACK
 	depends on NF_NAT
 	tristate "Netfilter nf_tables redirect support"
+	select NF_NAT_REDIRECT
 	help
 	  This options adds the "redirect" expression that you can use
 	  to perform NAT in the redirect flavour.
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index c64cbe78dee7..f8092926f704 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -13,19 +13,24 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_redirect.h>
 #include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nft_redir.h>
 
-const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
+struct nft_redir {
+	enum nft_registers	sreg_proto_min:8;
+	enum nft_registers	sreg_proto_max:8;
+	u16			flags;
+};
+
+static const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
 	[NFTA_REDIR_REG_PROTO_MIN]	= { .type = NLA_U32 },
 	[NFTA_REDIR_REG_PROTO_MAX]	= { .type = NLA_U32 },
 	[NFTA_REDIR_FLAGS]		= { .type = NLA_U32 },
 };
-EXPORT_SYMBOL_GPL(nft_redir_policy);
 
-int nft_redir_validate(const struct nft_ctx *ctx,
-		       const struct nft_expr *expr,
-		       const struct nft_data **data)
+static int nft_redir_validate(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nft_data **data)
 {
 	int err;
 
@@ -37,11 +42,10 @@ int nft_redir_validate(const struct nft_ctx *ctx,
 					(1 << NF_INET_PRE_ROUTING) |
 					(1 << NF_INET_LOCAL_OUT));
 }
-EXPORT_SYMBOL_GPL(nft_redir_validate);
 
-int nft_redir_init(const struct nft_ctx *ctx,
-		   const struct nft_expr *expr,
-		   const struct nlattr * const tb[])
+static int nft_redir_init(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nlattr * const tb[])
 {
 	struct nft_redir *priv = nft_expr_priv(expr);
 	unsigned int plen;
@@ -77,7 +81,6 @@ int nft_redir_init(const struct nft_ctx *ctx,
 
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
-EXPORT_SYMBOL_GPL(nft_redir_init);
 
 int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
@@ -101,7 +104,134 @@ int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
 nla_put_failure:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(nft_redir_dump);
+
+static void nft_redir_ipv4_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_redir *priv = nft_expr_priv(expr);
+	struct nf_nat_ipv4_multi_range_compat mr;
+
+	memset(&mr, 0, sizeof(mr));
+	if (priv->sreg_proto_min) {
+		mr.range[0].min.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_min]);
+		mr.range[0].max.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_max]);
+		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+
+	mr.range[0].flags |= priv->flags;
+
+	regs->verdict.code = nf_nat_redirect_ipv4(pkt->skb, &mr, nft_hook(pkt));
+}
+
+static void
+nft_redir_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
+}
+
+static struct nft_expr_type nft_redir_ipv4_type;
+static const struct nft_expr_ops nft_redir_ipv4_ops = {
+	.type		= &nft_redir_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
+	.eval		= nft_redir_ipv4_eval,
+	.init		= nft_redir_init,
+	.destroy	= nft_redir_ipv4_destroy,
+	.dump		= nft_redir_dump,
+	.validate	= nft_redir_validate,
+};
+
+static struct nft_expr_type nft_redir_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "redir",
+	.ops		= &nft_redir_ipv4_ops,
+	.policy		= nft_redir_policy,
+	.maxattr	= NFTA_REDIR_MAX,
+	.owner		= THIS_MODULE,
+};
+
+#ifdef CONFIG_NF_TABLES_IPV6
+static void nft_redir_ipv6_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_redir *priv = nft_expr_priv(expr);
+	struct nf_nat_range2 range;
+
+	memset(&range, 0, sizeof(range));
+	if (priv->sreg_proto_min) {
+		range.min_proto.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_min]);
+		range.max_proto.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_max]);
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+
+	range.flags |= priv->flags;
+
+	regs->verdict.code =
+		nf_nat_redirect_ipv6(pkt->skb, &range, nft_hook(pkt));
+}
+
+static void
+nft_redir_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
+}
+
+static struct nft_expr_type nft_redir_ipv6_type;
+static const struct nft_expr_ops nft_redir_ipv6_ops = {
+	.type		= &nft_redir_ipv6_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
+	.eval		= nft_redir_ipv6_eval,
+	.init		= nft_redir_init,
+	.destroy	= nft_redir_ipv6_destroy,
+	.dump		= nft_redir_dump,
+	.validate	= nft_redir_validate,
+};
+
+static struct nft_expr_type nft_redir_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name		= "redir",
+	.ops		= &nft_redir_ipv6_ops,
+	.policy		= nft_redir_policy,
+	.maxattr	= NFTA_REDIR_MAX,
+	.owner		= THIS_MODULE,
+};
+#endif
+
+static int __init nft_redir_module_init(void)
+{
+	int ret = nft_register_expr(&nft_redir_ipv4_type);
+
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_NF_TABLES_IPV6
+	ret = nft_register_expr(&nft_redir_ipv6_type);
+	if (ret) {
+		nft_unregister_expr(&nft_redir_ipv4_type);
+		return ret;
+	}
+#endif
+
+	return ret;
+}
+
+static void __exit nft_redir_module_exit(void)
+{
+	nft_unregister_expr(&nft_redir_ipv4_type);
+#ifdef CONFIG_NF_TABLES_IPV6
+	nft_unregister_expr(&nft_redir_ipv6_type);
+#endif
+}
+
+module_init(nft_redir_module_init);
+module_exit(nft_redir_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET4, "redir");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir");
-- 
2.11.0


