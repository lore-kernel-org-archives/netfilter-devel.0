From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3] netfilter: nf_tables: add hash expression
Date: Wed, 10 Aug 2016 11:43:36 +0200
Message-ID: <20160810094333.GA28920@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36760 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbcHJSkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:40:13 -0400
Received: by mail-wm0-f68.google.com with SMTP id i138so11222297wmf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 11:40:12 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id qe2sm42145114wjc.28.2016.08.10.02.43.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 02:43:38 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new hash expression, this provides jhash support but
this can be extended to support for other hash functions.

The modulus and seed already comes embedded into this new expression.

Use case example:
meta mark set hash ip saddr mod 10

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in V3:
	- Add null checks in init()
	- Include registers load validation

 include/uapi/linux/netfilter/nf_tables.h |  20 +++++
 net/netfilter/Kconfig                    |   6 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_hash.c                 | 141 +++++++++++++++++++++++++++++++
 4 files changed, 168 insertions(+)
 create mode 100644 net/netfilter/nft_hash.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0e7928e..1399946 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -724,6 +724,26 @@ enum nft_meta_keys {
 };
 
 /**
+ * enum nft_hash_attributes - nf_tables hash expression netlink attributes
+ *
+ * @NFTA_HASH_SREG: source register (NLA_U32)
+ * @NFTA_HASH_DREG: destination register (NLA_U32)
+ * @NFTA_HASH_LEN: source data length (NLA_U32)
+ * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
+ * @NFTA_HASH_SEED: seed value (NLA_U32)
+ */
+enum nft_hash_attributes {
+	NFTA_HASH_UNSPEC,
+	NFTA_HASH_SREG,
+	NFTA_HASH_DREG,
+	NFTA_HASH_LEN,
+	NFTA_HASH_MODULUS,
+	NFTA_HASH_SEED,
+	__NFTA_HASH_MAX,
+};
+#define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
+
+/**
  * enum nft_meta_attributes - nf_tables meta expression netlink attributes
  *
  * @NFTA_META_DREG: destination register (NLA_U32)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a2e4cf6..1074700 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -569,6 +569,12 @@ config NFT_COMPAT
 	  x_tables match/target extensions over the nf_tables
 	  framework.
 
+config NFT_HASH
+	tristate "Netfilter nf_tables hash module"
+	help
+	  This option adds the "hash" expression that you can use to perform
+	  a hash operation on registers.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 441a3c0..faa277e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
 obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
+obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
new file mode 100644
index 0000000..d0069eb
--- /dev/null
+++ b/net/netfilter/nft_hash.c
@@ -0,0 +1,141 @@
+/*
+ * Copyright (c) 2016 Laura Garcia <nevola@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <linux/jhash.h>
+
+struct nft_hash {
+	enum nft_registers      sreg:8;
+	enum nft_registers      dreg:8;
+	u8			len;
+	u32			modulus;
+	u32			seed;
+};
+
+static void nft_hash_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
+{
+	struct nft_hash *priv = nft_expr_priv(expr);
+	const void *data = &regs->data[priv->sreg];
+	u32 h;
+
+	h = reciprocal_scale(jhash(data, priv->len, priv->seed), priv->modulus);
+
+	regs->data[priv->dreg] = h;
+}
+
+const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
+	[NFTA_HASH_SREG]		= { .type = NLA_U32 },
+	[NFTA_HASH_DREG]		= { .type = NLA_U32 },
+	[NFTA_HASH_LEN]			= { .type = NLA_U32 },
+	[NFTA_HASH_MODULUS]		= { .type = NLA_U32 },
+	[NFTA_HASH_SEED]		= { .type = NLA_U32 },
+};
+
+static int nft_hash_init(const struct nft_ctx *ctx,
+			 const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_hash *priv = nft_expr_priv(expr);
+	u32 len;
+	u32 seed = 0;
+
+	if (!tb[NFTA_HASH_SREG] ||
+	    !tb[NFTA_HASH_DREG] ||
+	    !tb[NFTA_HASH_LEN]  ||
+	    !tb[NFTA_HASH_MODULUS])
+		return -EINVAL;
+
+	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
+	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
+
+	len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));
+	if (len == 0 || len > U8_MAX)
+		return -EINVAL;
+
+	priv->len = len;
+
+	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
+	if (priv->modulus <= 1)
+		return -EINVAL;
+
+	if (tb[NFTA_HASH_LEN])
+		seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
+
+	priv->seed = seed;
+
+	return nft_validate_register_store(ctx, priv->sreg, NULL,
+					   NFT_DATA_VALUE, len) &&
+		nft_validate_register_store(ctx, priv->dreg, NULL,
+					    NFT_DATA_VALUE, sizeof(u32));
+}
+
+static int nft_hash_dump(struct sk_buff *skb,
+			 const struct nft_expr *expr)
+{
+	const struct nft_hash *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_HASH_SREG, priv->sreg))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_HASH_DREG, priv->dreg))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_HASH_LEN, priv->len))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_HASH_MODULUS, priv->modulus))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_HASH_SEED, priv->seed))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_hash_type;
+static const struct nft_expr_ops nft_hash_ops = {
+	.type		= &nft_hash_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_hash)),
+	.eval		= nft_hash_eval,
+	.init		= nft_hash_init,
+	.dump		= nft_hash_dump,
+};
+
+static struct nft_expr_type nft_hash_type __read_mostly = {
+	.name		= "hash",
+	.ops		= &nft_hash_ops,
+	.policy		= nft_hash_policy,
+	.maxattr	= NFTA_HASH_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_hash_module_init(void)
+{
+	return nft_register_expr(&nft_hash_type);
+}
+
+static void __exit nft_hash_module_exit(void)
+{
+	nft_unregister_expr(&nft_hash_type);
+}
+
+module_init(nft_hash_module_init);
+module_exit(nft_hash_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
+MODULE_ALIAS_NFT_EXPR("hash");
-- 
2.8.1

