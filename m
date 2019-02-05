From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] netfilter: nft_compat: don't use refcount_inc on newly allocated entry
Date: Tue,  5 Feb 2019 20:04:15 +0100
Message-ID: <20190205190415.25041-7-pablo@netfilter.org>
References: <20190205190415.25041-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190205190415.25041-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When I moved the refcount to refcount_t type I missed the fact that
refcount_inc() will result in use-after-free warning with
CONFIG_REFCOUNT_FULL=y builds.

The correct fix would be to init the reference count to 1 at allocation
time, but, unfortunately we cannot do this, as we can't undo that
in case something else fails later in the batch.

So only solution I see is to special-case the 'new entry' condition
and replace refcount_inc() with a "delayed" refcount_set(1) in this case,
as done here.

The .activate callback can be removed to simplify things, we only
need to make sure that deactivate() decrements/unlinks the entry
from the list at end of transaction phase (commit or abort).

Fixes: 12c44aba6618 ("netfilter: nft_compat: use refcnt_t type for nft_xt reference count")
Reported-by: Jordan Glover <Golden_Miller83@protonmail.ch>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 62 +++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 0732a2fc697c..fe64df848365 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -61,6 +61,21 @@ static struct nft_compat_net *nft_compat_pernet(struct net *net)
 	return net_generic(net, nft_compat_net_id);
 }
 
+static void nft_xt_get(struct nft_xt *xt)
+{
+	/* refcount_inc() warns on 0 -> 1 transition, but we can't
+	 * init the reference count to 1 in .select_ops -- we can't
+	 * undo such an increase when another expression inside the same
+	 * rule fails afterwards.
+	 */
+	if (xt->listcnt == 0)
+		refcount_set(&xt->refcnt, 1);
+	else
+		refcount_inc(&xt->refcnt);
+
+	xt->listcnt++;
+}
+
 static bool nft_xt_put(struct nft_xt *xt)
 {
 	if (refcount_dec_and_test(&xt->refcnt)) {
@@ -291,7 +306,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	refcount_inc(&nft_xt->refcnt);
+	nft_xt_get(nft_xt);
 	return 0;
 }
 
@@ -504,7 +519,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return ret;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	refcount_inc(&nft_xt->refcnt);
+	nft_xt_get(nft_xt);
 	return 0;
 }
 
@@ -558,45 +573,16 @@ nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	__nft_match_destroy(ctx, expr, nft_expr_priv(expr));
 }
 
-static void nft_compat_activate(const struct nft_ctx *ctx,
-				const struct nft_expr *expr,
-				struct list_head *h)
-{
-	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
-
-	if (xt->listcnt == 0)
-		list_add(&xt->head, h);
-
-	xt->listcnt++;
-}
-
-static void nft_compat_activate_mt(const struct nft_ctx *ctx,
-				   const struct nft_expr *expr)
-{
-	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
-
-	nft_compat_activate(ctx, expr, &cn->nft_match_list);
-}
-
-static void nft_compat_activate_tg(const struct nft_ctx *ctx,
-				   const struct nft_expr *expr)
-{
-	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
-
-	nft_compat_activate(ctx, expr, &cn->nft_target_list);
-}
-
 static void nft_compat_deactivate(const struct nft_ctx *ctx,
 				  const struct nft_expr *expr,
 				  enum nft_trans_phase phase)
 {
 	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
 
-	if (phase == NFT_TRANS_COMMIT)
-		return;
-
-	if (--xt->listcnt == 0)
-		list_del_init(&xt->head);
+	if (phase == NFT_TRANS_ABORT || phase == NFT_TRANS_COMMIT) {
+		if (--xt->listcnt == 0)
+			list_del_init(&xt->head);
+	}
 }
 
 static void
@@ -852,7 +838,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
-	nft_match->ops.activate = nft_compat_activate_mt;
 	nft_match->ops.deactivate = nft_compat_deactivate;
 	nft_match->ops.dump = nft_match_dump;
 	nft_match->ops.validate = nft_match_validate;
@@ -870,7 +855,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 	nft_match->ops.size = matchsize;
 
-	nft_match->listcnt = 1;
+	nft_match->listcnt = 0;
 	list_add(&nft_match->head, &cn->nft_match_list);
 
 	return &nft_match->ops;
@@ -957,7 +942,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
-	nft_target->ops.activate = nft_compat_activate_tg;
 	nft_target->ops.deactivate = nft_compat_deactivate;
 	nft_target->ops.dump = nft_target_dump;
 	nft_target->ops.validate = nft_target_validate;
@@ -968,7 +952,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	else
 		nft_target->ops.eval = nft_target_eval_xt;
 
-	nft_target->listcnt = 1;
+	nft_target->listcnt = 0;
 	list_add(&nft_target->head, &cn->nft_target_list);
 
 	return &nft_target->ops;
-- 
2.11.0
