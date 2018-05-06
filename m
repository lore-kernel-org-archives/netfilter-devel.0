From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 38/51] netfilter: merge meta_bridge into nft_meta
Date: Mon,  7 May 2018 00:46:56 +0200
Message-ID: <20180506224709.29100-39-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

It overcomplicates things for no reason.
nft_meta_bridge only offers retrieval of bridge port interface name.

Because of this being its own module, we had to export all nft_meta
functions, which we can then make static again (which even reduces
the size of nft_meta -- including bridge port retrieval...):

before:
   text    data     bss     dec     hex filename
   1838     832       0    2670     a6e net/bridge/netfilter/nft_meta_bridge.ko
   6147     936       1    7084    1bac net/netfilter/nft_meta.ko

after:
   5826     936       1    6763    1a6b net/netfilter/nft_meta.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_meta.h       |  44 -----------
 net/bridge/netfilter/Kconfig           |   7 --
 net/bridge/netfilter/Makefile          |   1 -
 net/bridge/netfilter/nft_meta_bridge.c | 135 ---------------------------------
 net/netfilter/nft_meta.c               |  90 ++++++++++++++--------
 5 files changed, 58 insertions(+), 219 deletions(-)
 delete mode 100644 include/net/netfilter/nft_meta.h
 delete mode 100644 net/bridge/netfilter/nft_meta_bridge.c

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
deleted file mode 100644
index 5c69e9b09388..000000000000
--- a/include/net/netfilter/nft_meta.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NFT_META_H_
-#define _NFT_META_H_
-
-struct nft_meta {
-	enum nft_meta_keys	key:8;
-	union {
-		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
-	};
-};
-
-extern const struct nla_policy nft_meta_policy[];
-
-int nft_meta_get_init(const struct nft_ctx *ctx,
-		      const struct nft_expr *expr,
-		      const struct nlattr * const tb[]);
-
-int nft_meta_set_init(const struct nft_ctx *ctx,
-		      const struct nft_expr *expr,
-		      const struct nlattr * const tb[]);
-
-int nft_meta_get_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr);
-
-int nft_meta_set_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr);
-
-void nft_meta_get_eval(const struct nft_expr *expr,
-		       struct nft_regs *regs,
-		       const struct nft_pktinfo *pkt);
-
-void nft_meta_set_eval(const struct nft_expr *expr,
-		       struct nft_regs *regs,
-		       const struct nft_pktinfo *pkt);
-
-void nft_meta_set_destroy(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr);
-
-int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data);
-
-#endif
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f212447794bd..9a0159aebe1a 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -8,13 +8,6 @@ menuconfig NF_TABLES_BRIDGE
 	bool "Ethernet Bridge nf_tables support"
 
 if NF_TABLES_BRIDGE
-
-config NFT_BRIDGE_META
-	tristate "Netfilter nf_table bridge meta support"
-	depends on NFT_META
-	help
-	  Add support for bridge dedicated meta key.
-
 config NFT_BRIDGE_REJECT
 	tristate "Netfilter nf_tables bridge reject support"
 	depends on NFT_REJECT && NFT_REJECT_IPV4 && NFT_REJECT_IPV6
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 4bc758dd4a8c..9b868861f21a 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -3,7 +3,6 @@
 # Makefile for the netfilter modules for Link Layer filtering on a bridge.
 #
 
-obj-$(CONFIG_NFT_BRIDGE_META)  += nft_meta_bridge.o
 obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
 # packet logging
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
deleted file mode 100644
index bb63c9aed55d..000000000000
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * Copyright (c) 2014 Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nft_meta.h>
-
-#include "../br_private.h"
-
-static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
-				     struct nft_regs *regs,
-				     const struct nft_pktinfo *pkt)
-{
-	const struct nft_meta *priv = nft_expr_priv(expr);
-	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
-	u32 *dest = &regs->data[priv->dreg];
-	const struct net_bridge_port *p;
-
-	switch (priv->key) {
-	case NFT_META_BRI_IIFNAME:
-		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
-			goto err;
-		break;
-	case NFT_META_BRI_OIFNAME:
-		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
-			goto err;
-		break;
-	default:
-		goto out;
-	}
-
-	strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
-	return;
-out:
-	return nft_meta_get_eval(expr, regs, pkt);
-err:
-	regs->verdict.code = NFT_BREAK;
-}
-
-static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
-				    const struct nft_expr *expr,
-				    const struct nlattr * const tb[])
-{
-	struct nft_meta *priv = nft_expr_priv(expr);
-	unsigned int len;
-
-	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
-	switch (priv->key) {
-	case NFT_META_BRI_IIFNAME:
-	case NFT_META_BRI_OIFNAME:
-		len = IFNAMSIZ;
-		break;
-	default:
-		return nft_meta_get_init(ctx, expr, tb);
-	}
-
-	priv->dreg = nft_parse_register(tb[NFTA_META_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
-}
-
-static struct nft_expr_type nft_meta_bridge_type;
-static const struct nft_expr_ops nft_meta_bridge_get_ops = {
-	.type		= &nft_meta_bridge_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
-	.eval		= nft_meta_bridge_get_eval,
-	.init		= nft_meta_bridge_get_init,
-	.dump		= nft_meta_get_dump,
-};
-
-static const struct nft_expr_ops nft_meta_bridge_set_ops = {
-	.type		= &nft_meta_bridge_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
-	.eval		= nft_meta_set_eval,
-	.init		= nft_meta_set_init,
-	.destroy	= nft_meta_set_destroy,
-	.dump		= nft_meta_set_dump,
-	.validate	= nft_meta_set_validate,
-};
-
-static const struct nft_expr_ops *
-nft_meta_bridge_select_ops(const struct nft_ctx *ctx,
-			   const struct nlattr * const tb[])
-{
-	if (tb[NFTA_META_KEY] == NULL)
-		return ERR_PTR(-EINVAL);
-
-	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
-		return ERR_PTR(-EINVAL);
-
-	if (tb[NFTA_META_DREG])
-		return &nft_meta_bridge_get_ops;
-
-	if (tb[NFTA_META_SREG])
-		return &nft_meta_bridge_set_ops;
-
-	return ERR_PTR(-EINVAL);
-}
-
-static struct nft_expr_type nft_meta_bridge_type __read_mostly = {
-	.family         = NFPROTO_BRIDGE,
-	.name           = "meta",
-	.select_ops     = nft_meta_bridge_select_ops,
-	.policy         = nft_meta_policy,
-	.maxattr        = NFTA_META_MAX,
-	.owner          = THIS_MODULE,
-};
-
-static int __init nft_meta_bridge_module_init(void)
-{
-	return nft_register_expr(&nft_meta_bridge_type);
-}
-
-static void __exit nft_meta_bridge_module_exit(void)
-{
-	nft_unregister_expr(&nft_meta_bridge_type);
-}
-
-module_init(nft_meta_bridge_module_init);
-module_exit(nft_meta_bridge_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta");
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8fb91940e2e7..6c0b82628117 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -1,5 +1,7 @@
 /*
  * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2014 Intel Corporation
+ * Author: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -24,21 +26,35 @@
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
-#include <net/netfilter/nft_meta.h>
 
 #include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
 
+struct nft_meta {
+	enum nft_meta_keys	key:8;
+	union {
+		enum nft_registers	dreg:8;
+		enum nft_registers	sreg:8;
+	};
+};
+
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
-void nft_meta_get_eval(const struct nft_expr *expr,
-		       struct nft_regs *regs,
-		       const struct nft_pktinfo *pkt)
+#ifdef CONFIG_NF_TABLES_BRIDGE
+#include "../bridge/br_private.h"
+#endif
+
+static void nft_meta_get_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 	struct sock *sk;
 	u32 *dest = &regs->data[priv->dreg];
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	const struct net_bridge_port *p;
+#endif
 
 	switch (priv->key) {
 	case NFT_META_LEN:
@@ -215,6 +231,18 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, !!skb->sp);
 		break;
 #endif
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	case NFT_META_BRI_IIFNAME:
+		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
+			goto err;
+		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
+		return;
+	case NFT_META_BRI_OIFNAME:
+		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
+			goto err;
+		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
+		return;
+#endif
 	default:
 		WARN_ON(1);
 		goto err;
@@ -224,11 +252,10 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 err:
 	regs->verdict.code = NFT_BREAK;
 }
-EXPORT_SYMBOL_GPL(nft_meta_get_eval);
 
-void nft_meta_set_eval(const struct nft_expr *expr,
-		       struct nft_regs *regs,
-		       const struct nft_pktinfo *pkt)
+static void nft_meta_set_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *meta = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
@@ -258,18 +285,16 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		WARN_ON(1);
 	}
 }
-EXPORT_SYMBOL_GPL(nft_meta_set_eval);
 
-const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
+static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
 	[NFTA_META_DREG]	= { .type = NLA_U32 },
 	[NFTA_META_KEY]		= { .type = NLA_U32 },
 	[NFTA_META_SREG]	= { .type = NLA_U32 },
 };
-EXPORT_SYMBOL_GPL(nft_meta_policy);
 
-int nft_meta_get_init(const struct nft_ctx *ctx,
-		      const struct nft_expr *expr,
-		      const struct nlattr * const tb[])
+static int nft_meta_get_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int len;
@@ -318,6 +343,14 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 #endif
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	case NFT_META_BRI_IIFNAME:
+	case NFT_META_BRI_OIFNAME:
+		if (ctx->family != NFPROTO_BRIDGE)
+			return -EOPNOTSUPP;
+		len = IFNAMSIZ;
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -326,7 +359,6 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, len);
 }
-EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
 static int nft_meta_get_validate(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
@@ -360,9 +392,9 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 #endif
 }
 
-int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data)
+static int nft_meta_set_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
@@ -388,11 +420,10 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
-EXPORT_SYMBOL_GPL(nft_meta_set_validate);
 
-int nft_meta_set_init(const struct nft_ctx *ctx,
-		      const struct nft_expr *expr,
-		      const struct nlattr * const tb[])
+static int nft_meta_set_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int len;
@@ -424,10 +455,9 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nft_meta_set_init);
 
-int nft_meta_get_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr)
+static int nft_meta_get_dump(struct sk_buff *skb,
+			     const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -440,10 +470,8 @@ int nft_meta_get_dump(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(nft_meta_get_dump);
 
-int nft_meta_set_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr)
+static int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -457,17 +485,15 @@ int nft_meta_set_dump(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(nft_meta_set_dump);
 
-void nft_meta_set_destroy(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr)
+static void nft_meta_set_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
 	if (priv->key == NFT_META_NFTRACE)
 		static_branch_dec(&nft_trace_enabled);
 }
-EXPORT_SYMBOL_GPL(nft_meta_set_destroy);
 
 static struct nft_expr_type nft_meta_type;
 static const struct nft_expr_ops nft_meta_get_ops = {
-- 
2.11.0
