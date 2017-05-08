From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink_delinearize: don't kill dependencies accross statements
Date: Mon,  8 May 2017 10:17:50 +0200
Message-ID: <20170508081750.28093-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38424 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751440AbdEHIRf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 04:17:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft currently translates
ip protocol tcp meta mark set 1 tcp dport 22
to
mark set 0x00000001 tcp dport 22

This is wrong, the latter form is same as

mark set 0x00000001 ip protocol tcp tcp dport 22

and thats not correct (original rule sets mark for tcp packets only).

We need to clear the dependency stack whenever we see a statement other
than stmt_expr, as these will have side effects (counter, payload
mangling, logging and the like).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  2 ++
 src/netlink_delinearize.c | 28 +++++++++++++++++++++++++++-
 src/payload.c             |  5 +++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/payload.h b/include/payload.h
index a3d23095119c..8e357aef461e 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -35,6 +35,8 @@ struct payload_dep_ctx {
 extern bool payload_is_known(const struct expr *expr);
 extern bool payload_is_stacked(const struct proto_desc *desc,
 			       const struct expr *expr);
+
+void payload_dependency_reset(struct payload_dep_ctx *ctx);
 extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4a0b8dcc5651..a65a97da89fb 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2153,6 +2153,27 @@ static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
 	expr_postprocess(ctx, &stmt->payload.val);
 }
 
+/*
+ * We can only remove payload dependencies if they occur without
+ * a statment with side effects in between.
+ *
+ * For instance:
+ * 'ip protocol tcp tcp dport 22 counter' is same as
+ * 'tcp dport 22 counter'.
+ *
+ * 'ip protocol tcp counter tcp dport 22' cannot be written as
+ * 'counter tcp dport 22' (that would be counter ip protocol tcp, but
+ * that counts every packet, not just ip/tcp).
+ */
+static void
+rule_maybe_reset_payload_deps(struct payload_dep_ctx *pdctx, enum stmt_types t)
+{
+	if (t == STMT_EXPRESSION)
+		return;
+
+	payload_dependency_reset(pdctx);
+}
+
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
@@ -2162,9 +2183,11 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	proto_ctx_init(&rctx.pctx, rule->handle.family);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
+		enum stmt_types type = stmt->ops->type;
+
 		rctx.stmt = stmt;
 
-		switch (stmt->ops->type) {
+		switch (type) {
 		case STMT_EXPRESSION:
 			stmt_expr_postprocess(&rctx);
 			break;
@@ -2217,7 +2240,10 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		default:
 			break;
 		}
+
 		rctx.pdctx.prev = rctx.stmt;
+
+		rule_maybe_reset_payload_deps(&rctx.pdctx, type);
 	}
 }
 
diff --git a/src/payload.c b/src/payload.c
index 169954bad207..55128fee1498 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -366,6 +366,11 @@ bool payload_is_stacked(const struct proto_desc *desc, const struct expr *expr)
 	return next && next->base == desc->base;
 }
 
+void payload_dependency_reset(struct payload_dep_ctx *ctx)
+{
+	memset(ctx, 0, sizeof(*ctx));
+}
+
 /**
  * payload_dependency_store - store a possibly redundant protocol match
  *
-- 
2.10.2

