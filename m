From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 04/11] netfilter: nf_tables: add stateful object reference expression
Date: Mon, 28 Nov 2016 01:01:03 +0100
Message-ID: <1480291270-3715-5-git-send-email-pablo@netfilter.org>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753809AbcK1AB1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C94EDD1637
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5B40524C6
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6B9B524CB
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:23 +0100 (CET)
In-Reply-To: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new expression allows us to refer to existing stateful objects from
rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  17 ++++-
 net/netfilter/Kconfig                    |   6 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_objref.c               | 113 +++++++++++++++++++++++++++++++
 4 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nft_objref.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 86affd60b937..e6a458e1d885 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -458,7 +458,8 @@ enum nft_verdict_attributes {
 #define NFT_EXPR_REDIR		27
 #define NFT_EXPR_REJECT		28
 #define NFT_EXPR_RT		29
-#define NFT_EXPR_MAX		30
+#define NFT_EXPR_OBJREF		30
+#define NFT_EXPR_MAX		31
 
 /**
  * enum nft_expr_attributes - nf_tables expression netlink attributes
@@ -1167,6 +1168,20 @@ enum nft_fwd_attributes {
 #define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
 
 /**
+ * enum nft_objref_attributes - nf_tables stateful object expression netlink attributes
+ *
+ * @NFTA_OBJREF_TYPE: source register of output interface (NLA_U32: nft_register)
+ * @NFTA_OBJREF_NAME: source register of output interface (NLA_STRING)
+ */
+enum nft_objref_attributes {
+	NFTA_OBJREF_UNSPEC,
+	NFTA_OBJREF_TYPE,
+	NFTA_OBJREF_NAME,
+	__NFTA_OBJREF_MAX
+};
+#define NFTA_OBJREF_MAX	(__NFTA_OBJREF_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 44410d30d461..44ead64b35da 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -551,6 +551,12 @@ config NFT_NAT
 	  This option adds the "nat" expression that you can use to perform
 	  typical Network Address Translation (NAT) packet transformations.
 
+config NFT_OBJREF
+	tristate "Netfilter nf_tables stateful object reference module"
+	help
+	  This option adds the "objref" expression that allows you to refer to
+	  stateful objects, such as counters and quotas.
+
 config NFT_QUEUE
 	depends on NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter nf_tables queue module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5bbf767672ec..8dbc518324fd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
+obj-$(CONFIG_NFT_OBJREF)	+= nft_objref.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_QUOTA)		+= nft_quota.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
new file mode 100644
index 000000000000..a7078055d564
--- /dev/null
+++ b/net/netfilter/nft_objref.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2012-2016 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+
+#define nft_objref_priv(expr)	*((struct nft_object **)nft_expr_priv(expr))
+
+static void nft_objref_eval(const struct nft_expr *expr,
+			    struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	obj->type->eval(obj->data, regs, pkt);
+}
+
+static int nft_objref_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+	u32 objtype;
+
+	if (!tb[NFTA_OBJREF_NAME] ||
+	    !tb[NFTA_OBJREF_TYPE])
+		return -EINVAL;
+
+	objtype = ntohl(nla_get_be32(tb[NFTA_OBJREF_TYPE]));
+	obj = nf_tables_obj_lookup(ctx->table, tb[NFTA_OBJREF_NAME], objtype,
+				   genmask);
+	if (IS_ERR(obj))
+		return -ENOENT;
+
+	nft_objref_priv(expr) = obj;
+	obj->use++;
+
+	return 0;
+}
+
+static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_object *obj = nft_objref_priv(expr);
+
+	if (nla_put_string(skb, NFTA_OBJREF_NAME, obj->name) ||
+	    nla_put_be32(skb, NFTA_OBJREF_TYPE, htonl(obj->type->type)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static void nft_objref_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	obj->use--;
+}
+
+static struct nft_expr_type nft_objref_type;
+static const struct nft_expr_ops nft_objref_ops = {
+	.type		= &nft_objref_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object *)),
+	.eval		= nft_objref_eval,
+	.init		= nft_objref_init,
+	.destroy	= nft_objref_destroy,
+	.dump		= nft_objref_dump,
+};
+
+static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
+	[NFTA_OBJREF_NAME]	= { .type = NLA_STRING },
+	[NFTA_OBJREF_TYPE]	= { .type = NLA_U32 },
+};
+
+static struct nft_expr_type nft_objref_type __read_mostly = {
+	.name		= "objref",
+	.type		= NFT_EXPR_OBJREF,
+	.ops		= &nft_objref_ops,
+	.policy		= nft_objref_policy,
+	.maxattr	= NFTA_OBJREF_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_objref_module_init(void)
+{
+	return nft_register_expr(&nft_objref_type);
+}
+
+static void __exit nft_objref_module_exit(void)
+{
+	nft_unregister_expr(&nft_objref_type);
+}
+
+module_init(nft_objref_module_init);
+module_exit(nft_objref_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_EXPR("objref", NFT_EXPR_OBJREF);
-- 
2.1.4

