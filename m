From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/5] ct: add support for directional keys
Date: Fri, 18 Dec 2015 22:07:59 +0100
Message-ID: <1450472883-19743-2-git-send-email-fw@strlen.de>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40516 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965331AbbLRVMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:12:00 -0500
In-Reply-To: <1450472883-19743-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A few keys in the ct expression are directional, i.e.
we need to tell kernel if it should fetch REPLY or ORIGINAL direction.

Split ct_keys into ct_keys & ct_keys_dir, the latter are those keys
that the kernel rejects unless also given a direction.

During postprocessing we also need to invoke ct_expr_update_type,
problem is that e.g. ct saddr can be any family (ip, ipv6) so we need
to update the expected data type based on the network base.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/ct.h              |  2 +-
 include/expression.h      |  1 +
 src/ct.c                  | 35 ++++++++++++++++++++++++++++++++---
 src/evaluate.c            | 14 ++++++++++++++
 src/netlink_delinearize.c | 24 +++++++++++++++++++++---
 src/netlink_linearize.c   |  4 ++++
 src/parser_bison.y        | 22 ++++++++++++++++------
 7 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 64366ab..c04b3bb 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -24,7 +24,7 @@ struct ct_template {
 }
 
 extern struct expr *ct_expr_alloc(const struct location *loc,
-				  enum nft_ct_keys key);
+				  enum nft_ct_keys key, struct expr *expr);
 extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 #endif /* NFTABLES_CT_H */
diff --git a/include/expression.h b/include/expression.h
index 010cb95..130cc1f 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -273,6 +273,7 @@ struct expr {
 		struct {
 			/* EXPR_CT */
 			enum nft_ct_keys	key;
+			struct expr		*dir_expr;
 		} ct;
 	};
 };
diff --git a/src/ct.c b/src/ct.c
index aa80138..c705838 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -208,16 +208,38 @@ static const struct ct_template ct_templates[] = {
 static void ct_expr_print(const struct expr *expr)
 {
 	printf("ct %s", ct_templates[expr->ct.key].token);
+	if (expr->ct.dir_expr) {
+		printf(" ");
+		expr_print(expr->ct.dir_expr);
+	}
 }
 
 static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
-	return e1->ct.key == e2->ct.key;
+	if (e1->ct.key != e2->ct.key)
+		return false;
+
+	e1 = e1->ct.dir_expr;
+	e2 = e2->ct.dir_expr;
+
+	if (!e1)
+		return e2 == NULL;
+	if (!e2)
+		return false;
+
+	return expr_cmp(e1, e2);
 }
 
 static void ct_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->ct.key = expr->ct.key;
+	new->ct = expr->ct;
+	if (expr->ct.dir_expr)
+		new->ct.dir_expr = expr_clone(expr->ct.dir_expr);
+}
+
+static void ct_expr_destroy(struct expr *expr)
+{
+	expr_free(expr->ct.dir_expr);
 }
 
 static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
@@ -246,10 +268,12 @@ static const struct expr_ops ct_expr_ops = {
 	.print		= ct_expr_print,
 	.cmp		= ct_expr_cmp,
 	.clone		= ct_expr_clone,
+	.destroy	= ct_expr_destroy,
 	.pctx_update	= ct_expr_pctx_update,
 };
 
-struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key)
+struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
+			   struct expr *dir_expr)
 {
 	const struct ct_template *tmpl = &ct_templates[key];
 	struct expr *expr;
@@ -258,6 +282,11 @@ struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key)
 			  tmpl->byteorder, tmpl->len);
 	expr->ct.key = key;
 
+	if (dir_expr) {
+		expr_set_type(dir_expr, &ct_dir_type, BYTEORDER_INVALID);
+		expr->ct.dir_expr = dir_expr;
+	}
+
 	switch (key) {
 	case NFT_CT_PROTOCOL:
 		expr->flags = EXPR_F_PROTOCOL;
diff --git a/src/evaluate.c b/src/evaluate.c
index 7aab6aa..8dd1373 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -471,10 +471,24 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
  */
 static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 {
+	struct expr *direction = NULL;
+	struct error_record *erec;
 	struct expr *ct = *expr;
 
 	ct_expr_update_type(&ctx->pctx, ct);
 
+	if (ct->ct.dir_expr &&
+	    ct->ct.dir_expr->ops->type == EXPR_SYMBOL) {
+		erec = symbol_parse(ct->ct.dir_expr, &direction);
+		if (erec != NULL) {
+			erec_queue(erec, ctx->msgs);
+			return -1;
+		}
+
+		expr_free(ct->ct.dir_expr);
+		ct->ct.dir_expr = direction;
+	}
+
 	return expr_evaluate_primary(ctx, expr);
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f68fca0..306d1b8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -536,12 +536,19 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nftnl_expr *nle)
 {
+	struct expr *expr = NULL;
 	enum nft_registers dreg;
 	uint32_t key;
-	struct expr *expr;
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_CT_DIR)) {
+		uint8_t dir = nftnl_expr_get_u8(nle, NFTNL_EXPR_CT_DIR);
+
+		expr = constant_expr_alloc(loc, &integer_type,
+					   BYTEORDER_HOST_ENDIAN, 8, &dir);
+	}
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
-	expr = ct_expr_alloc(loc, key);
+	expr = ct_expr_alloc(loc, key, expr);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_CT_DREG);
 	netlink_set_register(ctx, dreg, expr);
@@ -1117,6 +1124,12 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
+static void ct_match_postprocess(struct rule_pp_ctx *ctx,
+				 const struct expr *expr)
+{
+	return meta_match_postprocess(ctx, expr);
+}
+
 /* Convert a bitmask to a prefix length */
 static unsigned int expr_mask_to_prefix(const struct expr *expr)
 {
@@ -1394,6 +1407,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->right);
 
 		switch (expr->left->ops->type) {
+		case EXPR_CT:
+			ct_match_postprocess(ctx, expr);
+			break;
 		case EXPR_META:
 			meta_match_postprocess(ctx, expr);
 			break;
@@ -1431,9 +1447,11 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_SET_REF:
 	case EXPR_EXTHDR:
 	case EXPR_META:
-	case EXPR_CT:
 	case EXPR_VERDICT:
 		break;
+	case EXPR_CT:
+		ct_expr_update_type(&ctx->pctx, expr);
+		break;
 	default:
 		BUG("unknown expression type %s\n", expr->ops->name);
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 131c3f9..81fe754 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -209,6 +209,10 @@ static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("ct");
 	netlink_put_register(nle, NFTNL_EXPR_CT_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CT_KEY, expr->ct.key);
+	if (expr->ct.dir_expr)
+		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
+			mpz_get_uint8(expr->ct.dir_expr->value));
+
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fbfe7ea..93fa7d3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -555,7 +555,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
-%type <val>			ct_key
+%type <val>			ct_key		ct_key_dir
 
 %type <val>			export_format
 %type <string>			monitor_event
@@ -2037,9 +2037,18 @@ meta_stmt		:	META	meta_key	SET	expr
 			}
 			;
 
-ct_expr			:	CT	ct_key
+ct_expr			: 	CT	ct_key
 			{
-				$$ = ct_expr_alloc(&@$, $2);
+				$$ = ct_expr_alloc(&@$, $2, NULL);
+			}
+			|	CT	ct_key_dir 	STRING
+			{
+				struct expr *e = NULL;
+
+				e = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+							       current_scope(state), $3);
+
+				$$ = ct_expr_alloc(&@$, $2, e);
 			}
 			;
 
@@ -2049,13 +2058,14 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	MARK		{ $$ = NFT_CT_MARK; }
 			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
 			|	HELPER		{ $$ = NFT_CT_HELPER; }
-			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
-			|	SADDR		{ $$ = NFT_CT_SRC; }
+			|	LABEL		{ $$ = NFT_CT_LABELS; }
+			;
+ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	DADDR		{ $$ = NFT_CT_DST; }
+			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
-			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			;
 
 ct_stmt			:	CT	ct_key		SET	expr
-- 
2.4.10

