From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/7] src: add tcp options set support
Date: Sun, 20 Aug 2017 01:14:10 +0200
Message-ID: <20170819231413.15164-5-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39298 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752274AbdHSXOI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:14:08 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for tcp mss mangling:

nft add rule filter input tcp option maxseg size 1200

Its also possible to change other tcp option fields, but
maxseg is one of the more useful ones to change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/statement.h       | 11 +++++++++++
 include/tcpopt.h          |  2 ++
 src/evaluate.c            | 15 +++++++++++++++
 src/exthdr.c              | 30 ++++++++++++++++++++++++++++++
 src/netlink_delinearize.c | 21 +++++++++++++++++++--
 src/netlink_linearize.c   | 29 +++++++++++++++++++++++++++++
 src/parser_bison.y        |  5 ++++-
 src/tcpopt.c              |  7 +++++++
 8 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 61b5027b97f1..6d8aaa8ba72b 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -24,6 +24,14 @@ struct counter_stmt {
 
 extern struct stmt *counter_stmt_alloc(const struct location *loc);
 
+struct exthdr_stmt {
+	struct expr			*expr;
+	struct expr			*val;
+};
+
+extern struct stmt *exthdr_stmt_alloc(const struct location *loc,
+				      struct expr *payload, struct expr *expr);
+
 struct payload_stmt {
 	struct expr			*expr;
 	struct expr			*val;
@@ -220,6 +228,7 @@ struct xt_stmt {
  * @STMT_QUOTA:		quota statement
  * @STMT_NOTRACK:	notrack statement
  * @STMT_OBJREF:	stateful object reference statement
+ * @STMT_EXTHDR:	extension header statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -244,6 +253,7 @@ enum stmt_types {
 	STMT_QUOTA,
 	STMT_NOTRACK,
 	STMT_OBJREF,
+	STMT_EXTHDR,
 };
 
 /**
@@ -285,6 +295,7 @@ struct stmt {
 
 	union {
 		struct expr		*expr;
+		struct exthdr_stmt	exthdr;
 		struct flow_stmt	flow;
 		struct counter_stmt	counter;
 		struct payload_stmt	payload;
diff --git a/include/tcpopt.h b/include/tcpopt.h
index 42e9cf0506e5..7a5a997041ad 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -3,6 +3,7 @@
 
 #include <proto.h>
 #include <exthdr.h>
+#include <statement.h>
 
 extern struct expr *tcpopt_expr_alloc(const struct location *loc,
 				      uint8_t type, uint8_t field);
@@ -15,6 +16,7 @@ extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
 
 void tcpopt_expr_print(const struct expr *expr, struct output_ctx *octx);
+void tcpopt_stmt_print(const struct stmt *stmt, struct output_ctx *octx);
 
 enum tcpopt_hdr_types {
 	TCPOPTHDR_INVALID,
diff --git a/src/evaluate.c b/src/evaluate.c
index f52a0843a0c0..3989d5e31f56 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1835,6 +1835,19 @@ static bool stmt_evaluate_payload_need_csum(const struct expr *payload)
 	return desc && desc->checksum_key;
 }
 
+static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct expr *exthdr;
+
+	if (__expr_evaluate_exthdr(ctx, &stmt->exthdr.expr) < 0)
+		return -1;
+
+	exthdr = stmt->exthdr.expr;
+	return stmt_evaluate_arg(ctx, stmt, exthdr->dtype, exthdr->len,
+				 BYTEORDER_BIG_ENDIAN,
+				 &stmt->exthdr.val);
+}
+
 static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *binop, *mask, *and, *payload_bytes;
@@ -2700,6 +2713,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_verdict(ctx, stmt);
 	case STMT_PAYLOAD:
 		return stmt_evaluate_payload(ctx, stmt);
+	case STMT_EXTHDR:
+		return stmt_evaluate_exthdr(ctx, stmt);
 	case STMT_FLOW:
 		return stmt_evaluate_flow(ctx, stmt);
 	case STMT_META:
diff --git a/src/exthdr.c b/src/exthdr.c
index 73b2c05836e0..7d13c83c9943 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -21,6 +21,7 @@
 #include <utils.h>
 #include <headers.h>
 #include <expression.h>
+#include <statement.h>
 
 static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
@@ -84,6 +85,35 @@ struct expr *exthdr_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+static void exthdr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	if (stmt->exthdr.expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
+		tcpopt_stmt_print(stmt, octx);
+		return;
+	}
+
+	expr_print(stmt->exthdr.expr, octx);
+	printf(" set ");
+	expr_print(stmt->exthdr.val, octx);
+}
+
+static const struct stmt_ops exthdr_stmt_ops = {
+	.type		= STMT_EXTHDR,
+	.name		= "exthdr",
+	.print		= exthdr_stmt_print,
+};
+
+struct stmt *exthdr_stmt_alloc(const struct location *loc,
+				struct expr *expr, struct expr *val)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &exthdr_stmt_ops);
+	stmt->exthdr.expr = expr;
+	stmt->exthdr.val  = val;
+	return stmt;
+}
+
 static const struct exthdr_desc *exthdr_protocols[IPPROTO_MAX] = {
 	[IPPROTO_HOPOPTS]	= &exthdr_hbh,
 	[IPPROTO_ROUTING]	= &exthdr_rt,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5317a830ac6d..51a61472a0f1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -513,8 +513,25 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 	expr = exthdr_expr_alloc(loc, NULL, 0);
 	exthdr_init_raw(expr, type, offset, len, op, flags);
 
-	dreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_DREG);
-	netlink_set_register(ctx, dreg, expr);
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_EXTHDR_DREG)) {
+		dreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_DREG);
+		netlink_set_register(ctx, dreg, expr);
+	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_EXTHDR_SREG)) {
+		enum nft_registers sreg;
+		struct stmt *stmt;
+		struct expr *val;
+
+		sreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_SREG);
+		val = netlink_get_register(ctx, loc, sreg);
+		if (val == NULL)
+			return netlink_error(ctx, loc,
+					     "exthdr statement has no expression");
+
+		expr_set_type(val, expr->dtype, expr->byteorder);
+
+		stmt = exthdr_stmt_alloc(loc, expr, val);
+		list_add_tail(&stmt->list, &ctx->rule->stmts);
+	}
 }
 
 static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3d684569cabf..c5a47dec7d10 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -816,6 +816,33 @@ static bool payload_needs_l4csum_update_pseudohdr(const struct expr *expr,
 	return false;
 }
 
+static void netlink_gen_exthdr_stmt(struct netlink_linearize_ctx *ctx,
+				    const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+	const struct expr *expr;
+	enum nft_registers sreg;
+	unsigned int offset;
+
+	sreg = get_register(ctx, stmt->exthdr.val);
+	netlink_gen_expr(ctx, stmt->exthdr.val, sreg);
+	release_register(ctx, stmt->exthdr.val);
+
+	expr = stmt->exthdr.expr;
+
+	offset = expr->exthdr.tmpl->offset + expr->exthdr.offset;
+
+	nle = alloc_nft_expr("exthdr");
+	netlink_put_register(nle, NFTNL_EXPR_EXTHDR_SREG, sreg);
+	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_TYPE,
+			  expr->exthdr.desc->type);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
+			   div_round_up(expr->len, BITS_PER_BYTE));
+	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 				     const struct stmt *stmt)
 {
@@ -1239,6 +1266,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_verdict_stmt(ctx, stmt);
 	case STMT_FLOW:
 		return netlink_gen_flow_stmt(ctx, stmt);
+	case STMT_EXTHDR:
+		return netlink_gen_exthdr_stmt(ctx, stmt);
 	case STMT_PAYLOAD:
 		return netlink_gen_payload_stmt(ctx, stmt);
 	case STMT_META:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 783b72f5a343..7898ea3fe7bc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3209,7 +3209,10 @@ ct_stmt			:	CT	ct_key		SET	expr
 
 payload_stmt		:	payload_expr		SET	expr
 			{
-				$$ = payload_stmt_alloc(&@$, $1, $3);
+				if ($1->ops->type == EXPR_EXTHDR)
+					$$ = exthdr_stmt_alloc(&@$, $1, $3);
+				else
+					$$ = payload_stmt_alloc(&@$, $1, $3);
 			}
 			;
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
index a76ad3490f9c..63f0c236c9cf 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -247,6 +247,13 @@ void tcpopt_expr_print(const struct expr *expr, struct output_ctx *octx)
 				     expr->exthdr.tmpl->token);
 }
 
+void tcpopt_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	tcpopt_expr_print(stmt->exthdr.expr, octx);
+	printf(" set ");
+	expr_print(stmt->exthdr.val, octx);
+}
+
 bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 			  unsigned int *shift)
 {
-- 
2.13.0

