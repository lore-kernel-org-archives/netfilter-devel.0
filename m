From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/5] netfilter: nf_tables: add AF specific expression support
Date: Wed,  5 Feb 2014 15:03:37 +0000
Message-ID: <1391612619-30347-4-git-send-email-kaber@trash.net>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57608 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaBEPEH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:04:07 -0500
In-Reply-To: <1391612619-30347-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For the reject module, we need to add AF-specific implementations to
get rid of incorrect module dependencies. Try to load an AF-specific
module first and fall back to generic modules.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_tables_api.c     | 22 ++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 57c8ff7..0f68e47 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -252,6 +252,7 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
  *	@owner: module reference
  *	@policy: netlink attribute policy
  *	@maxattr: highest netlink attribute number
+ *	@family: address family for AF-specific types
  */
 struct nft_expr_type {
 	const struct nft_expr_ops	*(*select_ops)(const struct nft_ctx *,
@@ -262,6 +263,7 @@ struct nft_expr_type {
 	struct module			*owner;
 	const struct nla_policy		*policy;
 	unsigned int			maxattr;
+	u8				family;
 };
 
 /**
@@ -529,6 +531,9 @@ void nft_unregister_expr(struct nft_expr_type *);
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
 	MODULE_ALIAS("nft-chain-" __stringify(family) "-" name)
 
+#define MODULE_ALIAS_NFT_AF_EXPR(family, name) \
+	MODULE_ALIAS("nft-expr-" __stringify(family) "-" name)
+
 #define MODULE_ALIAS_NFT_EXPR(name) \
 	MODULE_ALIAS("nft-expr-" name)
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9579aad..f6dca04 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1114,35 +1114,45 @@ void nft_unregister_expr(struct nft_expr_type *type)
 }
 EXPORT_SYMBOL_GPL(nft_unregister_expr);
 
-static const struct nft_expr_type *__nft_expr_type_get(struct nlattr *nla)
+static const struct nft_expr_type *__nft_expr_type_get(u8 family,
+						       struct nlattr *nla)
 {
 	const struct nft_expr_type *type;
 
 	list_for_each_entry(type, &nf_tables_expressions, list) {
-		if (!nla_strcmp(nla, type->name))
+		if (!nla_strcmp(nla, type->name) &&
+		    (!type->family || type->family == family))
 			return type;
 	}
 	return NULL;
 }
 
-static const struct nft_expr_type *nft_expr_type_get(struct nlattr *nla)
+static const struct nft_expr_type *nft_expr_type_get(u8 family,
+						     struct nlattr *nla)
 {
 	const struct nft_expr_type *type;
 
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	type = __nft_expr_type_get(nla);
+	type = __nft_expr_type_get(family, nla);
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+		request_module("nft-expr-%u-%.*s", family,
+			       nla_len(nla), (char *)nla_data(nla));
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
+		if (__nft_expr_type_get(family, nla))
+			return ERR_PTR(-EAGAIN);
+
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-expr-%.*s",
 			       nla_len(nla), (char *)nla_data(nla));
 		nfnl_lock(NFNL_SUBSYS_NFTABLES);
-		if (__nft_expr_type_get(nla))
+		if (__nft_expr_type_get(family, nla))
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -1193,7 +1203,7 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	type = nft_expr_type_get(tb[NFTA_EXPR_NAME]);
+	type = nft_expr_type_get(ctx->afi->family, tb[NFTA_EXPR_NAME]);
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
-- 
1.8.5.3

