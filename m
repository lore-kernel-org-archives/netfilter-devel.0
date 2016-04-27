From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 6/7] stmt: support generating stateful statements outside of rule context
Date: Wed, 27 Apr 2016 12:29:49 +0100
Message-ID: <1461756590-22880-7-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33537 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbcD0LaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:30:04 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flow statement contains a stateful per flow statement, which is not
directly part of the rule. Allow generating these statements without adding
them to the rule and mark the supported statements using a new flag
STMT_F_STATEFUL.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/statement.h     |  1 +
 src/netlink_linearize.c | 80 ++++++++++++++++++++++++++++++-------------------
 src/statement.c         | 12 ++++++--
 3 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index e7872b0..a6a86f9 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -197,6 +197,7 @@ struct stmt_ops {
 
 enum stmt_flags {
 	STMT_F_TERMINAL		= 0x1,
+	STMT_F_STATEFUL		= 0x2,
 };
 
 /**
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3263043..28feecf 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -718,14 +718,9 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-static void netlink_gen_verdict_stmt(struct netlink_linearize_ctx *ctx,
-				     const struct stmt *stmt)
-{
-	return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
-}
-
-static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
-				     const struct stmt *stmt)
+static struct nftnl_expr *
+netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
+			 const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 
@@ -738,7 +733,46 @@ static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_BYTES,
 				   stmt->counter.bytes);
 	}
-	nftnl_rule_add_expr(ctx->nlr, nle);
+
+	return nle;
+}
+
+static struct nftnl_expr *
+netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
+		       const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("limit");
+	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_RATE, stmt->limit.rate);
+	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_UNIT, stmt->limit.unit);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_TYPE, stmt->limit.type);
+	if (stmt->limit.burst > 0)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_BURST,
+				   stmt->limit.burst);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_FLAGS, stmt->limit.flags);
+
+	return nle;
+}
+
+static struct nftnl_expr *
+netlink_gen_stmt_stateful(struct netlink_linearize_ctx *ctx,
+			  const struct stmt *stmt)
+{
+	switch (stmt->ops->type) {
+	case STMT_COUNTER:
+		return netlink_gen_counter_stmt(ctx, stmt);
+	case STMT_LIMIT:
+		return netlink_gen_limit_stmt(ctx, stmt);
+	default:
+		BUG("unknown stateful statement type %s\n", stmt->ops->name);
+	}
+}
+
+static void netlink_gen_verdict_stmt(struct netlink_linearize_ctx *ctx,
+				     const struct stmt *stmt)
+{
+	return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 }
 
 static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
@@ -821,23 +855,6 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-static void netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
-				   const struct stmt *stmt)
-{
-	struct nftnl_expr *nle;
-
-	nle = alloc_nft_expr("limit");
-	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_RATE, stmt->limit.rate);
-	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_UNIT, stmt->limit.unit);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_TYPE, stmt->limit.type);
-	if (stmt->limit.burst > 0)
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_BURST,
-				   stmt->limit.burst);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_FLAGS, stmt->limit.flags);
-
-	nftnl_rule_add_expr(ctx->nlr, nle);
-}
-
 static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 				    const struct stmt *stmt)
 {
@@ -1121,21 +1138,19 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
+	struct nftnl_expr *nle;
+
 	switch (stmt->ops->type) {
 	case STMT_EXPRESSION:
 		return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 	case STMT_VERDICT:
 		return netlink_gen_verdict_stmt(ctx, stmt);
-	case STMT_COUNTER:
-		return netlink_gen_counter_stmt(ctx, stmt);
 	case STMT_PAYLOAD:
 		return netlink_gen_payload_stmt(ctx, stmt);
 	case STMT_META:
 		return netlink_gen_meta_stmt(ctx, stmt);
 	case STMT_LOG:
 		return netlink_gen_log_stmt(ctx, stmt);
-	case STMT_LIMIT:
-		return netlink_gen_limit_stmt(ctx, stmt);
 	case STMT_REJECT:
 		return netlink_gen_reject_stmt(ctx, stmt);
 	case STMT_NAT:
@@ -1154,6 +1169,11 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_set_stmt(ctx, stmt);
 	case STMT_FWD:
 		return netlink_gen_fwd_stmt(ctx, stmt);
+	case STMT_COUNTER:
+	case STMT_LIMIT:
+		nle = netlink_gen_stmt_stateful(ctx, stmt);
+		nftnl_rule_add_expr(ctx->nlr, nle);
+		break;
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/statement.c b/src/statement.c
index 2a6f19f..4149841 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -117,7 +117,11 @@ static const struct stmt_ops counter_stmt_ops = {
 
 struct stmt *counter_stmt_alloc(const struct location *loc)
 {
-	return stmt_alloc(loc, &counter_stmt_ops);
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &counter_stmt_ops);
+	stmt->flags |= STMT_F_STATEFUL;
+	return stmt;
 }
 
 static const char *syslog_level[LOG_DEBUG + 1] = {
@@ -249,7 +253,11 @@ static const struct stmt_ops limit_stmt_ops = {
 
 struct stmt *limit_stmt_alloc(const struct location *loc)
 {
-	return stmt_alloc(loc, &limit_stmt_ops);
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &limit_stmt_ops);
+	stmt->flags |= STMT_F_STATEFUL;
+	return stmt;
 }
 
 static void queue_stmt_print(const struct stmt *stmt)
-- 
2.5.5

