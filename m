From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 3/6] netlink_delinearize: support parsing individual expressions not embedded in rules
Date: Fri,  6 Nov 2015 18:34:20 +0000
Message-ID: <1446834863-18610-4-git-send-email-kaber@trash.net>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47972 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbbKFSe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:28 -0500
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flow statement contains a statement within the statement, in order to
parse it we need to return the parsed statement instead of adding it to
the rule list unconditionally.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h         |  2 +-
 src/netlink_delinearize.c | 64 +++++++++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 8444742..c1def09 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -84,7 +84,7 @@ extern void netlink_linearize_rule(struct netlink_ctx *ctx,
 				   struct nftnl_rule *nlr,
 				   const struct rule *rule);
 extern struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
-					     const struct nftnl_rule *r);
+					     struct nftnl_rule *r);
 
 extern int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct rule *rule, uint32_t flags);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3584de7..97ac3ec 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -30,6 +30,7 @@ struct netlink_parse_ctx {
 	struct list_head	*msgs;
 	struct table		*table;
 	struct rule		*rule;
+	struct stmt		*stmt;
 	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
 };
 
@@ -167,7 +168,6 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 {
 	struct nft_data_delinearize nld;
 	enum nft_registers dreg;
-	struct stmt *stmt;
 	struct expr *expr;
 
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_VERDICT)) {
@@ -183,10 +183,9 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_IMM_DREG);
 
 	expr = netlink_alloc_data(loc, &nld, dreg);
-	if (dreg == NFT_REG_VERDICT) {
-		stmt = verdict_stmt_alloc(loc, expr);
-		list_add_tail(&stmt->list, &ctx->rule->stmts);
-	} else
+	if (dreg == NFT_REG_VERDICT)
+		ctx->stmt = verdict_stmt_alloc(loc, expr);
+	else
 		netlink_set_register(ctx, dreg, expr);
 }
 
@@ -217,7 +216,6 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	struct nft_data_delinearize nld;
 	enum nft_registers sreg;
 	struct expr *expr, *left, *right;
-	struct stmt *stmt;
 	enum ops op;
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CMP_SREG);
@@ -246,8 +244,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	}
 
 	expr = relational_expr_alloc(loc, op, left, right);
-	stmt = expr_stmt_alloc(loc, expr);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
 static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
@@ -256,7 +253,6 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 {
 	enum nft_registers sreg, dreg;
 	const char *name;
-	struct stmt *stmt;
 	struct expr *expr, *left, *right;
 	struct set *set;
 
@@ -290,8 +286,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		expr = relational_expr_alloc(loc, OP_LOOKUP, left, right);
 	}
 
-	stmt = expr_stmt_alloc(loc, expr);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
 static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
@@ -467,7 +462,7 @@ static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 	stmt = meta_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
@@ -496,7 +491,7 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	stmt = ct_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
@@ -535,7 +530,8 @@ static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 		nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_PACKETS);
 	stmt->counter.bytes   =
 		nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_BYTES);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_log(struct netlink_parse_ctx *ctx,
@@ -571,7 +567,8 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			nftnl_expr_get_u32(nle, NFTNL_EXPR_LOG_LEVEL);
 		stmt->log.flags |= STMT_LOG_LEVEL;
 	}
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
@@ -585,7 +582,8 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	stmt->limit.unit = nftnl_expr_get_u64(nle, NFTNL_EXPR_LIMIT_UNIT);
 	stmt->limit.type = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_TYPE);
 	stmt->limit.burst = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_BURST);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
@@ -602,7 +600,7 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	stmt->reject.expr = constant_expr_alloc(loc, &integer_type,
 						BYTEORDER_HOST_ENDIAN, 8,
 						&icmp_code);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
@@ -683,7 +681,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.proto = proto;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
@@ -700,7 +698,7 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 	stmt = masq_stmt_alloc(loc);
 	stmt->masq.flags = flags;
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
@@ -746,7 +744,7 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 		stmt->redir.proto = proto;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
@@ -792,7 +790,7 @@ static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
 			stmt->dup.dev = dev;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
@@ -818,7 +816,8 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 	stmt = queue_stmt_alloc(loc);
 	stmt->queue.queue = expr;
 	stmt->queue.flags = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_FLAGS);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
@@ -858,7 +857,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	stmt->set.op  = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
 	stmt->set.key = expr;
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static const struct {
@@ -907,6 +906,21 @@ static int netlink_parse_expr(struct nftnl_expr *nle, void *arg)
 	}
 
 	netlink_error(ctx, &loc, "unknown expression type '%s'", type);
+	return -1;
+}
+
+static int netlink_parse_rule_expr(struct nftnl_expr *nle, void *arg)
+{
+	struct netlink_parse_ctx *ctx = arg;
+	int err;
+
+	err = netlink_parse_expr(nle, ctx);
+	if (err < 0)
+		return err;
+	if (ctx->stmt != NULL) {
+		list_add_tail(&ctx->stmt->list, &ctx->rule->stmts);
+		ctx->stmt = NULL;
+	}
 	return 0;
 }
 
@@ -1592,7 +1606,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 }
 
 struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
-				      const struct nftnl_rule *nlr)
+				      struct nftnl_rule *nlr)
 {
 	struct netlink_parse_ctx _ctx, *pctx = &_ctx;
 	struct handle h;
@@ -1622,7 +1636,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	pctx->rule = rule_alloc(&netlink_location, &h);
 	pctx->table = table_lookup(&h);
 	assert(pctx->table != NULL);
-	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx);
+	nftnl_expr_foreach(nlr, netlink_parse_rule_expr, pctx);
 
 	rule_parse_postprocess(pctx, pctx->rule);
 	netlink_release_registers(pctx);
-- 
2.4.3

