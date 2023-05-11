Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BA6C7EE26
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 15:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238795AbjEKPmF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 11:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbjEKPmD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 11:42:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1650359F2;
        Thu, 11 May 2023 08:42:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 1/6] netfilter: nf_tables: split set destruction in deactivate and destroy phase
Date:   Thu, 11 May 2023 17:41:38 +0200
Message-Id: <20230511154143.52469-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230511154143.52469-1-pablo@netfilter.org>
References: <20230511154143.52469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ backport for 4.14 of cd5125d8f51882279f50506bb9c7e5e89dc9bef3 ]

Splits unbind_set into destroy_set and unbinding operation.

Unbinding removes set from lists (so new transaction would not
find it anymore) but keeps memory allocated (so packet path continues
to work).

Rebind function is added to allow unrolling in case transaction
that wants to remove set is aborted.

Destroy function is added to free the memory, but this could occur
outside of transaction in the future.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  7 +++++-
 net/netfilter/nf_tables_api.c     | 36 +++++++++++++++++++++----------
 net/netfilter/nft_dynset.c        | 21 +++++++++++++++++-
 net/netfilter/nft_lookup.c        | 20 ++++++++++++++++-
 net/netfilter/nft_objref.c        | 20 ++++++++++++++++-
 5 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3107895115c2..59da90bb840d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -463,6 +463,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding);
+void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
+			  struct nft_set_binding *binding);
+void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
 
 /**
  *	enum nft_set_extensions - set extension type IDs
@@ -716,7 +719,9 @@ struct nft_expr_type {
  *	@eval: Expression evaluation function
  *	@size: full expression size, including private data size
  *	@init: initialization function
- *	@destroy: destruction function
+ *	@activate: activate expression in the next generation
+ *	@deactivate: deactivate expression in next generation
+ *	@destroy: destruction function, called after synchronize_rcu
  *	@dump: function to dump parameters
  *	@type: expression type
  *	@validate: validate expression, called during loop detection
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b24c83cf64b9..39416c568d18 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -327,7 +327,7 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
+static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 			     struct nft_set *set)
 {
 	struct nft_trans *trans;
@@ -347,7 +347,7 @@ static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
 	return 0;
 }
 
-static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
+static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
 
@@ -3311,13 +3311,6 @@ static void nft_set_destroy(struct nft_set *set)
 	kvfree(set);
 }
 
-static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
-{
-	list_del_rcu(&set->list);
-	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
-	nft_set_destroy(set);
-}
-
 static int nf_tables_delset(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -3400,17 +3393,38 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
-void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding)
+{
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	    nft_is_active(ctx->net, set))
+		list_add_tail_rcu(&set->list, &ctx->table->sets);
+
+	list_add_tail_rcu(&binding->list, &set->bindings);
+}
+EXPORT_SYMBOL_GPL(nf_tables_rebind_set);
+
+void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+		          struct nft_set_binding *binding)
 {
 	list_del_rcu(&binding->list);
 
 	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
 	    nft_is_active(ctx->net, set))
-		nf_tables_set_destroy(ctx, set);
+		list_del_rcu(&set->list);
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	    nft_is_active(ctx->net, set)) {
+		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
+		nft_set_destroy(set);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
+
 const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_KEY]		= {
 		.align	= __alignof__(u32),
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index f8688f9bf46c..800ca627a457 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -223,14 +223,31 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	return err;
 }
 
+static void nft_dynset_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_dynset_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
 	if (priv->expr != NULL)
 		nft_expr_destroy(ctx, priv->expr);
+
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -267,6 +284,8 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
+	.activate	= nft_dynset_activate,
+	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 44015a151ad6..c34667f4f48a 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -118,12 +118,28 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_lookup_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -151,6 +167,8 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
+	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
 };
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7bcdc48f3d73..d289fa5e4eb9 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -154,12 +154,28 @@ static int nft_objref_map_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 				   const struct nft_expr *expr)
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static struct nft_expr_type nft_objref_type;
@@ -168,6 +184,8 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
+	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
 };
-- 
2.30.2

