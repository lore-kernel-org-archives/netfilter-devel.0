Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094ABC7EE2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 15:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbjEKPmO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 11:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238792AbjEKPmL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 11:42:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F2FA5B9F;
        Thu, 11 May 2023 08:42:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 5/6] netfilter: nf_tables: bogus EBUSY when deleting set after flush
Date:   Thu, 11 May 2023 17:41:42 +0200
Message-Id: <20230511154143.52469-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230511154143.52469-1-pablo@netfilter.org>
References: <20230511154143.52469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ backport for 4.14 of 273fe3f1006ea5ebc63d6729e43e8e45e32b256a ]

Set deletion after flush coming in the same batch results in EBUSY. Add
set use counter to track the number of references to this set from
rules. We cannot rely on the list of bindings for this since such list
is still populated from the preparation phase.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nf_tables_api.c     | 28 +++++++++++++++++++++++++++-
 net/netfilter/nft_dynset.c        | 13 +++++++++----
 net/netfilter/nft_lookup.c        | 13 +++++++++----
 net/netfilter/nft_objref.c        | 13 +++++++++----
 5 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ca82f32d10cd..fe56b2f825b4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -383,6 +383,7 @@ void nft_unregister_set(struct nft_set_type *type);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
  * 	@size: maximum set size
+ *	@use: number of rules references to this set
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
  *	@timeout: default timeout value in jiffies
@@ -405,6 +406,7 @@ struct nft_set {
 	u32				dtype;
 	u32				objtype;
 	u32				size;
+	u32				use;
 	atomic_t			nelems;
 	u32				ndeact;
 	u64				timeout;
@@ -459,6 +461,10 @@ struct nft_set_binding {
 	u32				flags;
 };
 
+enum nft_trans_phase;
+void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding,
+			      enum nft_trans_phase phase);
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e9e3e7680a14..2f5b5d563e4d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3309,6 +3309,9 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 static void nft_set_destroy(struct nft_set *set)
 {
+	if (WARN_ON(set->use > 0))
+		return;
+
 	set->ops->destroy(set);
 	module_put(set->ops->type->owner);
 	kfree(set->name);
@@ -3339,7 +3342,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (!list_empty(&set->bindings) ||
+	if (set->use ||
 	    (nlh->nlmsg_flags & NLM_F_NONREC && atomic_read(&set->nelems) > 0))
 		return -EBUSY;
 
@@ -3367,6 +3370,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *i;
 	struct nft_set_iter iter;
 
+	if (set->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
 		return -EBUSY;
 
@@ -3394,6 +3400,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	binding->chain = ctx->chain;
 	list_add_tail_rcu(&binding->list, &set->bindings);
 	nft_set_trans_bind(ctx, set);
+	set->use++;
 
 	return 0;
 }
@@ -3413,6 +3420,25 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding,
+			      enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+		set->use--;
+		return;
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		set->use--;
+		/* fall through */
+	default:
+		nf_tables_unbind_set(ctx, set, binding,
+				     phase == NFT_TRANS_COMMIT);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
+
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 7e0a20343740..a20f1668328d 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -229,11 +229,15 @@ static void nft_dynset_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_dynset_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
@@ -281,6 +285,7 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
+	.activate	= nft_dynset_activate,
 	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 7dd35245222c..453f84c57166 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -124,11 +124,15 @@ static void nft_lookup_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
@@ -164,6 +168,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
 	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index f72aeff93efa..7e628f4f02b9 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -160,11 +160,15 @@ static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
@@ -181,6 +185,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
-- 
2.30.2

