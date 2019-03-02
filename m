Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A96C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 436EE20838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfCBShl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:41 -0500
Received: from mail.us.es ([193.147.175.20]:36478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbfCBShj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A5A521361B8
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8394ADA797
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79124DA864; Sat,  2 Mar 2019 19:37:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0432DA85D;
        Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 80B8D4265A2F;
        Sat,  2 Mar 2019 19:37:33 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 28/29] netfilter: nf_tables: nat: merge nft_masq protocol specific modules
Date:   Sat,  2 Mar 2019 19:37:19 +0100
Message-Id: <20190302183720.3220-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The family specific masq modules are way too small to warrant
an extra module, just place all of them in nft_masq.

before:
  text	   data	    bss	    dec	    hex	filename
   1001	    832	      0	   1833	    729	nft_masq.ko
    766	    896	      0	   1662	    67e	nft_masq_ipv4.ko
    764	    896	      0	   1660	    67c	nft_masq_ipv6.ko

after:
   2010	    960	      0	   2970	    b9a	nft_masq.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_masq.h   |  22 -----
 net/ipv4/netfilter/Kconfig         |   9 --
 net/ipv4/netfilter/Makefile        |   1 -
 net/ipv4/netfilter/nft_masq_ipv4.c |  90 -------------------
 net/ipv6/netfilter/Kconfig         |   9 --
 net/ipv6/netfilter/Makefile        |   1 -
 net/ipv6/netfilter/nft_masq_ipv6.c |  91 -------------------
 net/netfilter/Kconfig              |   1 +
 net/netfilter/nft_masq.c           | 180 ++++++++++++++++++++++++++++++++++---
 9 files changed, 168 insertions(+), 236 deletions(-)
 delete mode 100644 include/net/netfilter/nft_masq.h
 delete mode 100644 net/ipv4/netfilter/nft_masq_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nft_masq_ipv6.c

diff --git a/include/net/netfilter/nft_masq.h b/include/net/netfilter/nft_masq.h
deleted file mode 100644
index e51ab3815797..000000000000
--- a/include/net/netfilter/nft_masq.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NFT_MASQ_H_
-#define _NFT_MASQ_H_
-
-struct nft_masq {
-	u32			flags;
-	enum nft_registers      sreg_proto_min:8;
-	enum nft_registers      sreg_proto_max:8;
-};
-
-extern const struct nla_policy nft_masq_policy[];
-
-int nft_masq_init(const struct nft_ctx *ctx,
-		  const struct nft_expr *expr,
-		  const struct nlattr * const tb[]);
-
-int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr);
-
-int nft_masq_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		      const struct nft_data **data);
-
-#endif /* _NFT_MASQ_H_ */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 12cc3f7d7733..71c291a86245 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -106,15 +106,6 @@ config NFT_CHAIN_NAT_IPV4
 	  packet transformations such as the source, destination address and
 	  source and destination ports.
 
-config NFT_MASQ_IPV4
-	tristate "IPv4 masquerading support for nf_tables"
-	depends on NF_TABLES_IPV4
-	depends on NFT_MASQ
-	select NF_NAT_MASQUERADE
-	help
-	  This is the expression that provides IPv4 masquerading support for
-	  nf_tables.
-
 endif # NF_TABLES
 
 config NF_NAT_SNMP_BASIC
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 5558caf92578..1ae24d71d3cc 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
-obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 
 # flow table support
diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
deleted file mode 100644
index 6847de1d1db8..000000000000
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ /dev/null
@@ -1,90 +0,0 @@
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
-#include <net/netfilter/nft_masq.h>
-#include <net/netfilter/ipv4/nf_nat_masquerade.h>
-
-static void nft_masq_ipv4_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
-{
-	struct nft_masq *priv = nft_expr_priv(expr);
-	struct nf_nat_range2 range;
-
-	memset(&range, 0, sizeof(range));
-	range.flags = priv->flags;
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-	}
-	regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, nft_hook(pkt),
-						    &range, nft_out(pkt));
-}
-
-static void
-nft_masq_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
-{
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
-}
-
-static struct nft_expr_type nft_masq_ipv4_type;
-static const struct nft_expr_ops nft_masq_ipv4_ops = {
-	.type		= &nft_masq_ipv4_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
-	.eval		= nft_masq_ipv4_eval,
-	.init		= nft_masq_init,
-	.destroy	= nft_masq_ipv4_destroy,
-	.dump		= nft_masq_dump,
-	.validate	= nft_masq_validate,
-};
-
-static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
-	.family		= NFPROTO_IPV4,
-	.name		= "masq",
-	.ops		= &nft_masq_ipv4_ops,
-	.policy		= nft_masq_policy,
-	.maxattr	= NFTA_MASQ_MAX,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nft_masq_ipv4_module_init(void)
-{
-	int ret;
-
-	ret = nft_register_expr(&nft_masq_ipv4_type);
-	if (ret < 0)
-		return ret;
-
-	ret = nf_nat_masquerade_ipv4_register_notifier();
-	if (ret)
-		nft_unregister_expr(&nft_masq_ipv4_type);
-
-	return ret;
-}
-
-static void __exit nft_masq_ipv4_module_exit(void)
-{
-	nft_unregister_expr(&nft_masq_ipv4_type);
-	nf_nat_masquerade_ipv4_unregister_notifier();
-}
-
-module_init(nft_masq_ipv4_module_init);
-module_exit(nft_masq_ipv4_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 7e7cc411003a..b95351a5cb83 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -40,15 +40,6 @@ config NFT_CHAIN_NAT_IPV6
 	  chain type is used to perform Network Address Translation (NAT)
 	  packet transformations such as the source, destination address and
 	  source and destination ports.
-
-config NFT_MASQ_IPV6
-	tristate "IPv6 masquerade support for nf_tables"
-	depends on NFT_MASQ
-	select NF_NAT_MASQUERADE
-	help
-	  This is the expression that provides IPv4 masquerading support for
-	  nf_tables.
-
 endif # NF_NAT
 
 config NFT_REJECT_IPV6
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 42a80d03245a..06c1829f8ffc 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -30,7 +30,6 @@ obj-$(CONFIG_NF_DUP_IPV6) += nf_dup_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
-obj-$(CONFIG_NFT_MASQ_IPV6) += nft_masq_ipv6.o
 obj-$(CONFIG_NFT_DUP_IPV6) += nft_dup_ipv6.o
 obj-$(CONFIG_NFT_FIB_IPV6) += nft_fib_ipv6.o
 
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
deleted file mode 100644
index e06c82e9dfcd..000000000000
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ /dev/null
@@ -1,91 +0,0 @@
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
-#include <net/netfilter/nft_masq.h>
-#include <net/netfilter/ipv6/nf_nat_masquerade.h>
-
-static void nft_masq_ipv6_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
-{
-	struct nft_masq *priv = nft_expr_priv(expr);
-	struct nf_nat_range2 range;
-
-	memset(&range, 0, sizeof(range));
-	range.flags = priv->flags;
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-	}
-	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range,
-						    nft_out(pkt));
-}
-
-static void
-nft_masq_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
-{
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
-}
-
-static struct nft_expr_type nft_masq_ipv6_type;
-static const struct nft_expr_ops nft_masq_ipv6_ops = {
-	.type		= &nft_masq_ipv6_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
-	.eval		= nft_masq_ipv6_eval,
-	.init		= nft_masq_init,
-	.destroy	= nft_masq_ipv6_destroy,
-	.dump		= nft_masq_dump,
-	.validate	= nft_masq_validate,
-};
-
-static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
-	.family		= NFPROTO_IPV6,
-	.name		= "masq",
-	.ops		= &nft_masq_ipv6_ops,
-	.policy		= nft_masq_policy,
-	.maxattr	= NFTA_MASQ_MAX,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nft_masq_ipv6_module_init(void)
-{
-	int ret;
-
-	ret = nft_register_expr(&nft_masq_ipv6_type);
-	if (ret < 0)
-		return ret;
-
-	ret = nf_nat_masquerade_ipv6_register_notifier();
-	if (ret)
-		nft_unregister_expr(&nft_masq_ipv6_type);
-
-	return ret;
-}
-
-static void __exit nft_masq_ipv6_module_exit(void)
-{
-	nft_unregister_expr(&nft_masq_ipv6_type);
-	nf_nat_masquerade_ipv6_unregister_notifier();
-}
-
-module_init(nft_masq_ipv6_module_init);
-module_exit(nft_masq_ipv6_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 73857f9fdb25..537f23a8ed52 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -532,6 +532,7 @@ config NFT_LIMIT
 config NFT_MASQ
 	depends on NF_CONNTRACK
 	depends on NF_NAT
+	select NF_NAT_MASQUERADE
 	tristate "Netfilter nf_tables masquerade support"
 	help
 	  This option adds the "masquerade" expression that you can use
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9d8655bc1bea..bee156eaa400 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -14,18 +14,24 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nft_masq.h>
+#include <net/netfilter/ipv4/nf_nat_masquerade.h>
+#include <net/netfilter/ipv6/nf_nat_masquerade.h>
 
-const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
+struct nft_masq {
+	u32			flags;
+	enum nft_registers      sreg_proto_min:8;
+	enum nft_registers      sreg_proto_max:8;
+};
+
+static const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
 	[NFTA_MASQ_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_MASQ_REG_PROTO_MIN]	= { .type = NLA_U32 },
 	[NFTA_MASQ_REG_PROTO_MAX]	= { .type = NLA_U32 },
 };
-EXPORT_SYMBOL_GPL(nft_masq_policy);
 
-int nft_masq_validate(const struct nft_ctx *ctx,
-		      const struct nft_expr *expr,
-		      const struct nft_data **data)
+static int nft_masq_validate(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nft_data **data)
 {
 	int err;
 
@@ -36,11 +42,10 @@ int nft_masq_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain,
 				        (1 << NF_INET_POST_ROUTING));
 }
-EXPORT_SYMBOL_GPL(nft_masq_validate);
 
-int nft_masq_init(const struct nft_ctx *ctx,
-		  const struct nft_expr *expr,
-		  const struct nlattr * const tb[])
+static int nft_masq_init(const struct nft_ctx *ctx,
+			 const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
 {
 	u32 plen = FIELD_SIZEOF(struct nf_nat_range, min_addr.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
@@ -75,9 +80,8 @@ int nft_masq_init(const struct nft_ctx *ctx,
 
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
-EXPORT_SYMBOL_GPL(nft_masq_init);
 
-int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_masq *priv = nft_expr_priv(expr);
 
@@ -98,7 +102,157 @@ int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr)
 nla_put_failure:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(nft_masq_dump);
+
+static void nft_masq_ipv4_eval(const struct nft_expr *expr,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_masq *priv = nft_expr_priv(expr);
+	struct nf_nat_range2 range;
+
+	memset(&range, 0, sizeof(range));
+	range.flags = priv->flags;
+	if (priv->sreg_proto_min) {
+		range.min_proto.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_min]);
+		range.max_proto.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_max]);
+	}
+	regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, nft_hook(pkt),
+						    &range, nft_out(pkt));
+}
+
+static void
+nft_masq_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
+}
+
+static struct nft_expr_type nft_masq_ipv4_type;
+static const struct nft_expr_ops nft_masq_ipv4_ops = {
+	.type		= &nft_masq_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
+	.eval		= nft_masq_ipv4_eval,
+	.init		= nft_masq_init,
+	.destroy	= nft_masq_ipv4_destroy,
+	.dump		= nft_masq_dump,
+	.validate	= nft_masq_validate,
+};
+
+static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "masq",
+	.ops		= &nft_masq_ipv4_ops,
+	.policy		= nft_masq_policy,
+	.maxattr	= NFTA_MASQ_MAX,
+	.owner		= THIS_MODULE,
+};
+
+#ifdef CONFIG_NF_TABLES_IPV6
+static void nft_masq_ipv6_eval(const struct nft_expr *expr,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_masq *priv = nft_expr_priv(expr);
+	struct nf_nat_range2 range;
+
+	memset(&range, 0, sizeof(range));
+	range.flags = priv->flags;
+	if (priv->sreg_proto_min) {
+		range.min_proto.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_min]);
+		range.max_proto.all = (__force __be16)nft_reg_load16(
+			&regs->data[priv->sreg_proto_max]);
+	}
+	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range,
+						    nft_out(pkt));
+}
+
+static void
+nft_masq_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
+}
+
+static struct nft_expr_type nft_masq_ipv6_type;
+static const struct nft_expr_ops nft_masq_ipv6_ops = {
+	.type		= &nft_masq_ipv6_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
+	.eval		= nft_masq_ipv6_eval,
+	.init		= nft_masq_init,
+	.destroy	= nft_masq_ipv6_destroy,
+	.dump		= nft_masq_dump,
+	.validate	= nft_masq_validate,
+};
+
+static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name		= "masq",
+	.ops		= &nft_masq_ipv6_ops,
+	.policy		= nft_masq_policy,
+	.maxattr	= NFTA_MASQ_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_masq_module_init_ipv6(void)
+{
+	int ret = nft_register_expr(&nft_masq_ipv6_type);
+
+	if (ret)
+		return ret;
+
+	ret = nf_nat_masquerade_ipv6_register_notifier();
+	if (ret < 0)
+		nft_unregister_expr(&nft_masq_ipv6_type);
+
+	return ret;
+}
+
+static void nft_masq_module_exit_ipv6(void)
+{
+	nft_unregister_expr(&nft_masq_ipv6_type);
+	nf_nat_masquerade_ipv6_unregister_notifier();
+}
+#else
+static inline int nft_masq_module_init_ipv6(void) { return 0; }
+static inline void nft_masq_module_exit_ipv6(void) {}
+#endif
+
+static int __init nft_masq_module_init(void)
+{
+	int ret;
+
+	ret = nft_masq_module_init_ipv6();
+	if (ret < 0)
+		return ret;
+
+	ret = nft_register_expr(&nft_masq_ipv4_type);
+	if (ret < 0) {
+		nft_masq_module_exit_ipv6();
+		return ret;
+	}
+
+	ret = nf_nat_masquerade_ipv4_register_notifier();
+	if (ret < 0) {
+		nft_masq_module_exit_ipv6();
+		nft_unregister_expr(&nft_masq_ipv4_type);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit nft_masq_module_exit(void)
+{
+	nft_masq_module_exit_ipv6();
+	nft_unregister_expr(&nft_masq_ipv4_type);
+	nf_nat_masquerade_ipv4_unregister_notifier();
+}
+
+module_init(nft_masq_module_init);
+module_exit(nft_masq_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
-- 
2.11.0


