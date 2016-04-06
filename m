From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nf-next 2/3] netfilter: nf_tables: support for named expression reference
Date: Wed,  6 Apr 2016 18:51:32 +0200
Message-ID: <1459961493-7494-3-git-send-email-pablo@netfilter.org>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42808 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcDFQvt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 12:51:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3F4C1C9EE1
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 29BB6DA385
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6911EDA394
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:41 +0200 (CEST)
In-Reply-To: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the 'nexpr' expression, this expression allows us to
refer to existing named expressions. This generic expression can be used
from rules and set elements.

This patch also adds nft_nexpr_lookup() to the core, as this new
expression requires this function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   4 ++
 include/uapi/linux/netfilter/nf_tables.h |  14 ++++
 net/netfilter/Kconfig                    |   6 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_api.c            |  24 +++++--
 net/netfilter/nft_nexpr.c                | 112 +++++++++++++++++++++++++++++++
 6 files changed, 154 insertions(+), 7 deletions(-)
 create mode 100644 net/netfilter/nft_nexpr.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0ba91ac..a84f787 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -669,6 +669,10 @@ struct nft_nexpr {
 	struct nft_expr			*expr;
 };
 
+struct nft_nexpr *nft_nexpr_lookup(const struct nft_table *table,
+				   const struct nlattr * const nla_name,
+				   const struct nlattr * const nla_type);
+
 static inline void *nft_expr_priv(const struct nft_expr *expr)
 {
 	return (void *)expr->data;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c1e19c3..f07b384 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1025,6 +1025,20 @@ enum nft_fwd_attributes {
 #define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
 
 /**
+ * enum nft_nexpr_ref_attributes - nf_tables named expression reference netlink attributes
+ *
+ * @NFTA_NEXPR_REF_NAME: name of this named expression (NLA_STRING)
+ * @NFTA_NEXPR_REF_TYPE: type of this named expression (NLA_STRING)
+ */
+enum nft_nexpr_ref_attributes {
+	NFTA_NEXPR_REF_UNSPEC,
+	NFTA_NEXPR_REF_NAME,
+	NFTA_NEXPR_REF_TYPE,
+	__NFTA_NEXPR_REF_MAX
+};
+#define NFTA_NEXPR_REF_MAX	(__NFTA_NEXPR_REF_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 95e757c..251f9d2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -535,6 +535,12 @@ config NFT_NAT
 	  This option adds the "nat" expression that you can use to perform
 	  typical Network Address Translation (NAT) packet transformations.
 
+config NFT_NEXPR
+	tristate "Netfilter nf_tables named expression module"
+	help
+	  This option adds the "named" expression that you can use to
+	  refer an existing named expression.
+
 config NFT_QUEUE
 	depends on NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter nf_tables queue module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6913454..2ba1388 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
+obj-$(CONFIG_NFT_NEXPR)		+= nft_nexpr.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b542d20..e506dca 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3800,11 +3800,25 @@ err:
 	return err;
 }
 
+struct nft_nexpr *nft_nexpr_lookup(const struct nft_table *table,
+				   const struct nlattr * const nla_name,
+				   const struct nlattr * const nla_type)
+{
+	struct nft_nexpr *nexpr;
+
+	list_for_each_entry(nexpr, &table->nexprs, list) {
+		if (!nla_strcmp(nla_name, nexpr->name) &&
+		    !nla_strcmp(nla_type, nexpr->expr->ops->type->name))
+			return nexpr;
+	}
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(nft_nexpr_lookup);
+
 static struct nft_nexpr *nf_tables_nexpr_lookup(const struct nft_table *table,
 						const struct nlattr * const nla[])
 {
 	struct nlattr *tb[NFTA_EXPR_MAX + 1];
-	struct nft_nexpr *nexpr;
 	int err;
 
 	if (!nla[NFTA_NEXPR_NAME] ||
@@ -3819,12 +3833,8 @@ static struct nft_nexpr *nf_tables_nexpr_lookup(const struct nft_table *table,
 	if (!tb[NFTA_EXPR_NAME])
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry(nexpr, &table->nexprs, list) {
-		if (!nla_strcmp(nla[NFTA_NEXPR_NAME], nexpr->name) &&
-		    !nla_strcmp(tb[NFTA_EXPR_NAME], nexpr->expr->ops->type->name))
-			return nexpr;
-	}
-	return ERR_PTR(-ENOENT);
+	return nft_nexpr_lookup(table, nla[NFTA_NEXPR_NAME],
+				tb[NFTA_EXPR_NAME]);
 }
 
 static const struct nla_policy nft_nexpr_policy[NFTA_NEXPR_MAX + 1] = {
diff --git a/net/netfilter/nft_nexpr.c b/net/netfilter/nft_nexpr.c
new file mode 100644
index 0000000..1fe0bee
--- /dev/null
+++ b/net/netfilter/nft_nexpr.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c) 2016 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/seqlock.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_nexpr_priv {
+	struct nft_nexpr *nexpr;
+};
+
+static void nft_nexpr_eval(const struct nft_expr *expr,
+			   struct nft_regs *regs,
+			   const struct nft_pktinfo *pkt)
+{
+	struct nft_nexpr_priv *priv = nft_expr_priv(expr);
+
+	priv->nexpr->expr->ops->eval(priv->nexpr->expr, regs, pkt);
+}
+
+static int nft_nexpr_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_nexpr_priv *priv = nft_expr_priv(expr);
+	const char *type = priv->nexpr->expr->ops->type->name;
+
+	if (nla_put_string(skb, NFTA_NEXPR_REF_NAME, priv->nexpr->name) ||
+	    nla_put_string(skb, NFTA_NEXPR_REF_TYPE, type))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nla_policy nft_nexpr_policy[NFTA_NEXPR_REF_MAX + 1] = {
+	[NFTA_NEXPR_REF_NAME]	= { .type = NLA_STRING },
+	[NFTA_NEXPR_REF_TYPE]	= { .type = NLA_STRING },
+};
+
+static int nft_nexpr_init(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nlattr * const tb[])
+{
+	struct nft_nexpr_priv *priv = nft_expr_priv(expr);
+	struct nft_nexpr *nexpr;
+
+	if (!tb[NFTA_NEXPR_REF_NAME] ||
+	    !tb[NFTA_NEXPR_REF_TYPE])
+		return -EINVAL;
+
+	nexpr = nft_nexpr_lookup(ctx->table, tb[NFTA_NEXPR_REF_NAME],
+				 tb[NFTA_NEXPR_REF_TYPE]);
+	if (IS_ERR(nexpr))
+		return PTR_ERR(nexpr);
+
+	nexpr->use++;
+	priv->nexpr = nexpr;
+	return 0;
+}
+
+static void nft_nexpr_destroy(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr)
+{
+	struct nft_nexpr_priv *priv = nft_expr_priv(expr);
+
+	priv->nexpr->use--;
+}
+
+static struct nft_expr_type nft_nexpr_type;
+static const struct nft_expr_ops nft_nexpr_ops = {
+	.type		= &nft_nexpr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_nexpr_priv)),
+	.eval		= nft_nexpr_eval,
+	.init		= nft_nexpr_init,
+	.destroy	= nft_nexpr_destroy,
+	.dump		= nft_nexpr_dump,
+};
+
+static struct nft_expr_type nft_nexpr_type __read_mostly = {
+	.name		= "nexpr",
+	.ops		= &nft_nexpr_ops,
+	.policy		= nft_nexpr_policy,
+	.maxattr	= NFTA_NEXPR_REF_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_nexpr_module_init(void)
+{
+	return nft_register_expr(&nft_nexpr_type);
+}
+
+static void __exit nft_nexpr_module_exit(void)
+{
+	nft_unregister_expr(&nft_nexpr_type);
+}
+
+module_init(nft_nexpr_module_init);
+module_exit(nft_nexpr_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org");
+MODULE_ALIAS_NFT_EXPR("nexpr");
-- 
2.1.4

