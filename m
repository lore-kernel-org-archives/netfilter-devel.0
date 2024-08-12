Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19659176FC5;
	Mon, 12 Aug 2024 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458573; cv=none; b=Y1b8xrciER10Wg8tPg5/HeCiQyxy//dK9PFiQrC/w1aVaWaQzCIry3jxIgmDC48OARsuvyStZKYm4GBpNa2vLp+l7Lu77nq+y2kEPCkxYkC2St3tPGdWfBbHulAtTt2lPTdQYZ5/9yd1G/YNJcq7RJZRlW0YTwowhqJ+jGlMzNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458573; c=relaxed/simple;
	bh=I62CxZ40dmwRMBoKSaGxFWW09Zv1Nv5YxEMy3riuO6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pB4ESk5/ynqd5K7R9v6nQNohxfwz9von/8sjVcWtSUB4QnisRhvvZlG4qqW16P+V4Q2bI9K7tFkg7nx7QezHEYOY7WVJkB98LHOe9ElPEY56PNsR2XLmSASXIxkB4HIbJvKWSCjcZJhV37S4hGPyOp2hH3xjJHSeJxDktTCWmJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 3/3] netfilter: nf_tables: prefer nft_chain_validate
Date: Mon, 12 Aug 2024 12:29:25 +0200
Message-Id: <20240812102925.394733-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102925.394733-1-pablo@netfilter.org>
References: <20240812102925.394733-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit cff3bd012a9512ac5ed858d38e6ed65f6391008c upstream

nft_chain_validate already performs loop detection because a cycle will
result in a call stack overflow (ctx->level >= NFT_JUMP_STACK_SIZE).

It also follows maps via ->validate callback in nft_lookup, so there
appears no reason to iterate the maps again.

nf_tables_check_loops() and all its helper functions can be removed.
This improves ruleset load time significantly, from 23s down to 12s.

This also fixes a crash bug. Old loop detection code can result in
unbounded recursion:

BUG: TASK stack guard page was hit at ....
Oops: stack guard page: 0000 [#1] PREEMPT SMP KASAN
CPU: 4 PID: 1539 Comm: nft Not tainted 6.10.0-rc5+ #1
[..]

with a suitable ruleset during validation of register stores.

I can't see any actual reason to attempt to check for this from
nft_validate_register_store(), at this point the transaction is still in
progress, so we don't have a full picture of the rule graph.

For nf-next it might make sense to either remove it or make this depend
on table->validate_state in case we could catch an error earlier
(for improved error reporting to userspace).

Fixes: 20a69341f2d0 ("netfilter: nf_tables: add netlink set API")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 114 ++++------------------------------
 1 file changed, 13 insertions(+), 101 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c8a1f3f14384..a033c9baf58a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2698,6 +2698,15 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx,
 	nf_tables_rule_destroy(ctx, rule);
 }
 
+/** nft_chain_validate - loop detection and hook validation
+ *
+ * @ctx: context containing call depth and base chain
+ * @chain: chain to validate
+ *
+ * Walk through the rules of the given chain and chase all jumps/gotos
+ * and set lookups until either the jump limit is hit or all reachable
+ * chains have been validated.
+ */
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
@@ -2716,6 +2725,9 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			if (!expr->ops->validate)
 				continue;
 
+			/* This may call nft_chain_validate() recursively,
+			 * callers that do so must increment ctx->level.
+			 */
 			err = expr->ops->validate(ctx, expr, &data);
 			if (err < 0)
 				return err;
@@ -7418,106 +7430,6 @@ int nft_chain_validate_hooks(const struct nft_chain *chain,
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate_hooks);
 
-/*
- * Loop detection - walk through the ruleset beginning at the destination chain
- * of a new jump until either the source chain is reached (loop) or all
- * reachable chains have been traversed.
- *
- * The loop check is performed whenever a new jump verdict is added to an
- * expression or verdict map or a verdict map is bound to a new chain.
- */
-
-static int nf_tables_check_loops(const struct nft_ctx *ctx,
-				 const struct nft_chain *chain);
-
-static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
-					struct nft_set *set,
-					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	const struct nft_data *data;
-
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
-	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
-		return 0;
-
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		return nf_tables_check_loops(ctx, data->verdict.chain);
-	default:
-		return 0;
-	}
-}
-
-static int nf_tables_check_loops(const struct nft_ctx *ctx,
-				 const struct nft_chain *chain)
-{
-	const struct nft_rule *rule;
-	const struct nft_expr *expr, *last;
-	struct nft_set *set;
-	struct nft_set_binding *binding;
-	struct nft_set_iter iter;
-
-	if (ctx->chain == chain)
-		return -ELOOP;
-
-	list_for_each_entry(rule, &chain->rules, list) {
-		nft_rule_for_each_expr(expr, last, rule) {
-			struct nft_immediate_expr *priv;
-			const struct nft_data *data;
-			int err;
-
-			if (strcmp(expr->ops->type->name, "immediate"))
-				continue;
-
-			priv = nft_expr_priv(expr);
-			if (priv->dreg != NFT_REG_VERDICT)
-				continue;
-
-			data = &priv->data;
-			switch (data->verdict.code) {
-			case NFT_JUMP:
-			case NFT_GOTO:
-				err = nf_tables_check_loops(ctx,
-							data->verdict.chain);
-				if (err < 0)
-					return err;
-			default:
-				break;
-			}
-		}
-	}
-
-	list_for_each_entry(set, &ctx->table->sets, list) {
-		if (!nft_is_active_next(ctx->net, set))
-			continue;
-		if (!(set->flags & NFT_SET_MAP) ||
-		    set->dtype != NFT_DATA_VERDICT)
-			continue;
-
-		list_for_each_entry(binding, &set->bindings, list) {
-			if (!(binding->flags & NFT_SET_MAP) ||
-			    binding->chain != chain)
-				continue;
-
-			iter.genmask	= nft_genmask_next(ctx->net);
-			iter.skip 	= 0;
-			iter.count	= 0;
-			iter.err	= 0;
-			iter.fn		= nf_tables_loop_check_setelem;
-
-			set->ops->walk(ctx, set, &iter);
-			if (iter.err < 0)
-				return iter.err;
-		}
-	}
-
-	return 0;
-}
-
 /**
  *	nft_parse_u32_check - fetch u32 attribute and check for maximum value
  *
@@ -7653,7 +7565,7 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		if (data != NULL &&
 		    (data->verdict.code == NFT_GOTO ||
 		     data->verdict.code == NFT_JUMP)) {
-			err = nf_tables_check_loops(ctx, data->verdict.chain);
+			err = nft_chain_validate(ctx, data->verdict.chain);
 			if (err < 0)
 				return err;
 		}
-- 
2.30.2

