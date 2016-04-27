From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 5/7] netlink_delinearize: support parsing statements not contained within a rule
Date: Wed, 27 Apr 2016 12:29:48 +0100
Message-ID: <1461756590-22880-6-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33534 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbcD0LaD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:30:03 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Return the parsed statement instead of adding it to the rule in order to
parse statements contained in the flow statement.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h         |  2 +-
 src/netlink_delinearize.c | 70 ++++++++++++++++++++++++++++-------------------
 2 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 80b7c60..6ea017c 100644
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
index 84f94fc..d046d1f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -31,6 +31,7 @@ struct netlink_parse_ctx {
 	struct list_head	*msgs;
 	struct table		*table;
 	struct rule		*rule;
+	struct stmt		*stmt;
 	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
 };
 
@@ -168,7 +169,6 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 {
 	struct nft_data_delinearize nld;
 	enum nft_registers dreg;
-	struct stmt *stmt;
 	struct expr *expr;
 
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_VERDICT)) {
@@ -184,10 +184,9 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
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
 
@@ -218,7 +217,6 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	struct nft_data_delinearize nld;
 	enum nft_registers sreg;
 	struct expr *expr, *left, *right;
-	struct stmt *stmt;
 	enum ops op;
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CMP_SREG);
@@ -247,8 +245,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	}
 
 	expr = relational_expr_alloc(loc, op, left, right);
-	stmt = expr_stmt_alloc(loc, expr);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
 static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
@@ -257,7 +254,6 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 {
 	enum nft_registers sreg, dreg;
 	const char *name;
-	struct stmt *stmt;
 	struct expr *expr, *left, *right;
 	struct set *set;
 
@@ -291,8 +287,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		expr = relational_expr_alloc(loc, OP_LOOKUP, left, right);
 	}
 
-	stmt = expr_stmt_alloc(loc, expr);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
 static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
@@ -503,7 +498,7 @@ static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 	stmt = meta_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
@@ -532,7 +527,7 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	stmt = ct_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
@@ -573,7 +568,8 @@ static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 	stmt = counter_stmt_alloc(loc);
 	stmt->counter.packets = nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_PACKETS);
 	stmt->counter.bytes   = nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_BYTES);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_log(struct netlink_parse_ctx *ctx,
@@ -608,7 +604,8 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			nftnl_expr_get_u32(nle, NFTNL_EXPR_LOG_LEVEL);
 		stmt->log.flags |= STMT_LOG_LEVEL;
 	}
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
@@ -623,7 +620,8 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	stmt->limit.type = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_TYPE);
 	stmt->limit.burst = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_BURST);
 	stmt->limit.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_FLAGS);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
@@ -640,7 +638,7 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	stmt->reject.expr = constant_expr_alloc(loc, &integer_type,
 						BYTEORDER_HOST_ENDIAN, 8,
 						&icmp_code);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
@@ -720,7 +718,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.proto = proto;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
@@ -762,7 +760,7 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 		stmt->masq.proto = proto;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
@@ -808,7 +806,7 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 		stmt->redir.proto = proto;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
@@ -854,7 +852,7 @@ static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
 			stmt->dup.dev = dev;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_fwd(struct netlink_parse_ctx *ctx,
@@ -878,7 +876,7 @@ static void netlink_parse_fwd(struct netlink_parse_ctx *ctx,
 		stmt->fwd.to = dev;
 	}
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
@@ -904,7 +902,8 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 	stmt = queue_stmt_alloc(loc);
 	stmt->queue.queue = expr;
 	stmt->queue.flags = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_FLAGS);
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+
+	ctx->stmt = stmt;
 }
 
 static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
@@ -944,7 +943,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	stmt->set.op  = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
 	stmt->set.key = expr;
 
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	ctx->stmt = stmt;
 }
 
 static const struct {
@@ -975,10 +974,10 @@ static const struct {
 	{ .name = "fwd",	.parse = netlink_parse_fwd },
 };
 
-static int netlink_parse_expr(struct nftnl_expr *nle, void *arg)
+static int netlink_parse_expr(const struct nftnl_expr *nle,
+			      struct netlink_parse_ctx *ctx)
 {
 	const char *type = nftnl_expr_get_str(nle, NFTNL_EXPR_NAME);
-	struct netlink_parse_ctx *ctx = arg;
 	struct location loc;
 	unsigned int i;
 
@@ -994,6 +993,21 @@ static int netlink_parse_expr(struct nftnl_expr *nle, void *arg)
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
 
@@ -1729,7 +1743,7 @@ static char *udata_get_comment(const void *data, uint32_t data_len)
 }
 
 struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
-				      const struct nftnl_rule *nlr)
+				      struct nftnl_rule *nlr)
 {
 	struct netlink_parse_ctx _ctx, *pctx = &_ctx;
 	struct handle h;
@@ -1758,7 +1772,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 		pctx->rule->comment = udata_get_comment(data, len);
 	}
 
-	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx);
+	nftnl_expr_foreach(nlr, netlink_parse_rule_expr, pctx);
 
 	rule_parse_postprocess(pctx, pctx->rule);
 	netlink_release_registers(pctx);
-- 
2.5.5

