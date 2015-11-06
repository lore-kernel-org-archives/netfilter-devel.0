From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 5/6] stmt: allow to generate stateful statements outside of rule context
Date: Fri,  6 Nov 2015 18:34:22 +0000
Message-ID: <1446834863-18610-6-git-send-email-kaber@trash.net>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47976 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751354AbbKFSea (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:30 -0500
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flow statement contains a stateful statement within the statement,
special case stateful statements to return a pointer to the statement
so the caller can decide how to handle them.

Also mark stateful statements for flow statement validation.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/statement.h     |  1 +
 src/netlink_linearize.c | 90 +++++++++++++++++++++++++++++--------------------
 src/statement.c         | 12 +++++--
 3 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 8b035d3..6a1001c 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -176,6 +176,7 @@ struct stmt_ops {
 
 enum stmt_flags {
 	STMT_F_TERMINAL		= 0x1,
+	STMT_F_STATEFUL		= 0x2,
 };
 
 /**
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c9af036..adcc559 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -663,23 +663,6 @@ static void netlink_gen_verdict_stmt(struct netlink_linearize_ctx *ctx,
 	return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 }
 
-static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
-				     const struct stmt *stmt)
-{
-	struct nftnl_expr *nle;
-
-	nle = alloc_nft_expr("counter");
-	if (stmt->counter.packets) {
-		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_PACKETS,
-				      stmt->counter.packets);
-	}
-	if (stmt->counter.bytes) {
-		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_BYTES,
-				      stmt->counter.bytes);
-	}
-	nftnl_rule_add_expr(ctx->nlr, nle);
-}
-
 static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 				  const struct stmt *stmt)
 {
@@ -724,22 +707,6 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
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
-
-	nftnl_rule_add_expr(ctx->nlr, nle);
-}
-
 static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 				    const struct stmt *stmt)
 {
@@ -980,22 +947,73 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static struct nftnl_expr *
+netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
+			 const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("counter");
+	if (stmt->counter.packets)
+		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_PACKETS,
+				   stmt->counter.packets);
+	if (stmt->counter.bytes)
+		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_BYTES,
+				   stmt->counter.bytes);
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
+		BUG("unknown statement type %s\n", stmt->ops->name);
+	}
+}
+
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
 	case STMT_COUNTER:
-		return netlink_gen_counter_stmt(ctx, stmt);
+	case STMT_LIMIT:
+		nle = netlink_gen_stmt_stateful(ctx, stmt);
+		nftnl_rule_add_expr(ctx->nlr, nle);
+		return;
 	case STMT_META:
 		return netlink_gen_meta_stmt(ctx, stmt);
 	case STMT_LOG:
 		return netlink_gen_log_stmt(ctx, stmt);
-	case STMT_LIMIT:
-		return netlink_gen_limit_stmt(ctx, stmt);
 	case STMT_REJECT:
 		return netlink_gen_reject_stmt(ctx, stmt);
 	case STMT_NAT:
diff --git a/src/statement.c b/src/statement.c
index 2d1a3e6..55c9f15 100644
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
@@ -246,7 +250,11 @@ static const struct stmt_ops limit_stmt_ops = {
 
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
2.4.3

