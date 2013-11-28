From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nftables kernel PATCH] netfilter: nf_tables: fix nft_meta_target
	module
Date: Thu, 28 Nov 2013 12:15:57 +0100
Message-ID: <20131128111557.6154.40370.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43740 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751536Ab3K1LQC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:16:02 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 1EEE051ED7E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 11:15:59 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r6S0scTjYPcy for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Nov 2013 12:15:58 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id E37A551ED74
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 12:15:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds kernel support for the meta_target expression.

This expression indicates that a given packet has to be set with a property,
currently one of mark, priority, nftrace or secmark.

Most of the previous code was invalid, with lots of compilation errors and
warnings.

In case of nftrace, the value is always 1. Such a behaviour is copied
from net/netfilter/xt_TRACE.c

In case of secmark, the intention is to make the translation between the
security_ctx and security_id outside this module, maybe in userspace.
Otherwise, a string is needed to be passed from the userpsace to kernel as
part of the attribute set, breaking the main KEY,VALUE pair approach.
This is different from net/netfilter/xt_SECMARK.c. There, the context
is translated in kernel side.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |   30 ++++++++
 net/netfilter/Kconfig                    |    4 +
 net/netfilter/Makefile                   |    2 -
 net/netfilter/nft_meta_target.c          |  114 +++++++++++++++++-------------
 4 files changed, 100 insertions(+), 50 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index fbfd229..d9f5784 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -563,6 +563,36 @@ enum nft_meta_attributes {
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
 
 /**
+ * enum nft_meta_target_keys - nf_tables meta_target expression keys
+ *
+ * @NFT_META_TARGET_MARK: to stablish packet mark (skb->mark)
+ * @NFT_META_TARGET_PRIORITY: to fix packet priority (skb->priority)
+ * @NFT_META_TARGET_NFTRACE: to put the packet nftrace bit (skb->nf_trace)
+ * @NFT_META_TARGET_SECMARK: to set packet secmark (skb->secmark)
+ */
+enum nft_meta_target_keys {
+	NFT_META_TARGET_MARK,
+	NFT_META_TARGET_PRIORITY,
+	NFT_META_TARGET_NFTRACE,
+	NFT_META_TARGET_SECMARK,
+};
+
+/**
+ * enum nft_meta_target_attributes - nf_tables meta_target expression netlink
+ *				     attributes
+ *
+ * @NFTA_META_TARGET_KEY: meta_target item to be set (NLA_U32: nft_meta_target_keys)
+ * @NFTA_META_TARGET_VALUE: value for the key (NLA_U32)
+ */
+enum nft_meta_target_attributes {
+	NFTA_META_TARGET_UNSPEC,
+	NFTA_META_TARGET_KEY,
+	NFTA_META_TARGET_VALUE,
+	__NFTA_META_TARGET_MAX
+};
+#define NFTA_META_TARGET_MAX		(__NFTA_META_TARGET_MAX - 1)
+
+/**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
  * @NFT_CT_STATE: conntrack state (bitmask of enum ip_conntrack_info)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 48acec1..187ceff 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -425,6 +425,10 @@ config NFT_META
 	depends on NF_TABLES
 	tristate "Netfilter nf_tables meta module"
 
+config NFT_META_TARGET
+	depends on NF_TABLES
+	tristate "Netfilter nf_tables meta target module"
+
 config NFT_CT
 	depends on NF_TABLES
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 394483b..32da2c0 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,7 +76,7 @@ obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
-#nf_tables-objs			+= nft_meta_target.o
+obj-$(CONFIG_NFT_META_TARGET)	+= nft_meta_target.o
 obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
diff --git a/net/netfilter/nft_meta_target.c b/net/netfilter/nft_meta_target.c
index 71177df..cfcec1c 100644
--- a/net/netfilter/nft_meta_target.c
+++ b/net/netfilter/nft_meta_target.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/netlink.h>
@@ -17,32 +18,31 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_meta {
-	enum nft_meta_keys	key;
+struct nft_meta_target {
+	enum nft_meta_target_keys	key:8;
+	u32				value;
 };
 
-static void nft_meta_eval(const struct nft_expr *expr,
-			  struct nft_data *nfres,
-			  struct nft_data *data,
-			  const struct nft_pktinfo *pkt)
+static void nft_meta_target_eval(const struct nft_expr *expr,
+				 struct nft_data data[NFT_REG_MAX + 1],
+				 const struct nft_pktinfo *pkt)
 {
-	const struct nft_meta *meta = nft_expr_priv(expr);
+	const struct nft_meta_target *meta_target = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
-	u32 val = data->data[0];
 
-	switch (meta->key) {
-	case NFT_META_MARK:
-		skb->mark = val;
+	switch (meta_target->key) {
+	case NFT_META_TARGET_MARK:
+		skb->mark = meta_target->value;
 		break;
-	case NFT_META_PRIORITY:
-		skb->priority = val;
+	case NFT_META_TARGET_PRIORITY:
+		skb->priority = meta_target->value;
 		break;
-	case NFT_META_NFTRACE:
-		skb->nf_trace = val;
+	case NFT_META_TARGET_NFTRACE:
+		skb->nf_trace = 1;
 		break;
 #ifdef CONFIG_NETWORK_SECMARK
-	case NFT_META_SECMARK:
-		skb->secmark = val;
+	case NFT_META_TARGET_SECMARK:
+		skb->secmark = meta_target->value;
 		break;
 #endif
 	default:
@@ -50,68 +50,84 @@ static void nft_meta_eval(const struct nft_expr *expr,
 	}
 }
 
-static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
-	[NFTA_META_KEY]		= { .type = NLA_U32 },
+static const struct nla_policy nft_meta_target_policy[NFTA_META_TARGET_MAX + 1] = {
+	[NFTA_META_TARGET_KEY]		= { .type = NLA_U32 },
+	[NFTA_META_TARGET_VALUE]	= { .type = NLA_U32 },
 };
 
-static int nft_meta_init(const struct nft_expr *expr, struct nlattr *tb[])
+static int nft_meta_target_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
 {
-	struct nft_meta *meta = nft_expr_priv(expr);
+	struct nft_meta_target *meta_target = nft_expr_priv(expr);
 
-	if (tb[NFTA_META_KEY] == NULL)
+	if (tb[NFTA_META_TARGET_KEY] == NULL)
 		return -EINVAL;
 
-	meta->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
-	switch (meta->key) {
-	case NFT_META_MARK:
-	case NFT_META_PRIORITY:
-	case NFT_META_NFTRACE:
+	meta_target->key = ntohl(nla_get_be32(tb[NFTA_META_TARGET_KEY]));
+	switch (meta_target->key) {
+	case NFT_META_TARGET_MARK:
+	case NFT_META_TARGET_PRIORITY:
+	case NFT_META_TARGET_NFTRACE:
 #ifdef CONFIG_NETWORK_SECMARK
-	case NFT_META_SECMARK:
+	case NFT_META_TARGET_SECMARK:
 #endif
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (tb[NFTA_META_TARGET_VALUE] == NULL)
+		return -EINVAL;
+
+	meta_target->value = ntohl(nla_get_be32(tb[NFTA_META_TARGET_VALUE]));
+
 	return 0;
 }
 
-static int nft_meta_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_meta_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	struct nft_meta *meta = nft_expr_priv(expr);
+	struct nft_meta_target *meta_target = nft_expr_priv(expr);
 
-	NLA_PUT_BE32(skb, NFTA_META_KEY, htonl(meta->key));
-	return 0;
+	if (nla_put_be32(skb, NFTA_META_TARGET_KEY, htonl(meta_target->key)))
+		return -1;
 
-nla_put_failure:
-	return -1;
+	if (nla_put_be32(skb, NFTA_META_TARGET_VALUE, htonl(meta_target->value)))
+		return -1;
+
+	return 0;
 }
 
-static struct nft_expr_ops meta_target __read_mostly = {
-	.name		= "meta",
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+static struct nft_expr_type nft_meta_target_type;
+static const struct nft_expr_ops nft_meta_target_ops = {
+	.type		= &nft_meta_target_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta_target)),
+	.eval		= nft_meta_target_eval,
+	.init		= nft_meta_target_init,
+	.dump		= nft_meta_target_dump,
+};
+
+static struct nft_expr_type nft_meta_target_type __read_mostly = {
+	.name		= "meta_target",
+	.ops		= &nft_meta_target_ops,
+	.policy		= nft_meta_target_policy,
+	.maxattr	= NFTA_META_TARGET_MAX,
 	.owner		= THIS_MODULE,
-	.eval		= nft_meta_eval,
-	.init		= nft_meta_init,
-	.dump		= nft_meta_dump,
-	.policy		= nft_meta_policy,
-	.maxattr	= NFTA_META_MAX,
 };
 
-static int __init nft_meta_target_init(void)
+static int __init nft_meta_target_module_init(void)
 {
-	return nft_register_expr(&meta_target);
+	return nft_register_expr(&nft_meta_target_type);
 }
 
-static void __exit nft_meta_target_exit(void)
+static void __exit nft_meta_target_module_exit(void)
 {
-	nft_unregister_expr(&meta_target);
+	nft_unregister_expr(&nft_meta_target_type);
 }
 
-module_init(nft_meta_target_init);
-module_exit(nft_meta_target_exit);
+module_init(nft_meta_target_module_init);
+module_exit(nft_meta_target_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("meta");
+MODULE_ALIAS_NFT_EXPR("meta_target");

