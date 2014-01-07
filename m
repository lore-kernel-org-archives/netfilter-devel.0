From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH nftables] Add support for setting ct keys
Date: Tue,  7 Jan 2014 16:15:58 +0100
Message-ID: <1389107758-24360-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45545 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaAGPQG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:16:06 -0500
Received: by mail-ee0-f50.google.com with SMTP id c41so142125eek.9
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2014 07:16:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds the possibility to set ct keys using nft. Currently, the
connection mark is supported. This functionality enables creating rules
performing the same action as iptables -j CONNMARK --save-mark. For example:

table ip filter {
	chain postrouting {
		type filter hook postrouting priority 0;
		ip protocol icmp ip daddr 8.8.8.8 ct mark set meta mark
	}
}

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/statement.h       | 14 ++++++++++++++
 src/ct.c                  | 25 +++++++++++++++++++++++++
 src/evaluate.c            | 11 +++++++++++
 src/netlink_delinearize.c | 37 ++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c   | 18 ++++++++++++++++++
 src/parser.y              |  9 +++++++++
 6 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 14a66df..896b972 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -67,6 +67,17 @@ struct queue_stmt {
 
 extern struct stmt *queue_stmt_alloc(const struct location *loc);
 
+#include <ct.h>
+struct ct_stmt {
+	enum nft_ct_keys		key;
+	const struct ct_template	*tmpl;
+	struct expr			*expr;
+};
+
+extern struct stmt *ct_stmt_alloc(const struct location *loc,
+				  enum nft_ct_keys key,
+				  struct expr *expr);
+
 /**
  * enum stmt_types - statement types
  *
@@ -80,6 +91,7 @@ extern struct stmt *queue_stmt_alloc(const struct location *loc);
  * @STMT_REJECT:	REJECT statement
  * @STMT_NAT:		NAT statement
  * @STMT_QUEUE:		QUEUE statement
+ * @STMT_CT:		conntrack statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -92,6 +104,7 @@ enum stmt_types {
 	STMT_REJECT,
 	STMT_NAT,
 	STMT_QUEUE,
+	STMT_CT,
 };
 
 /**
@@ -138,6 +151,7 @@ struct stmt {
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
 		struct queue_stmt	queue;
+		struct ct_stmt		ct;
 	};
 };
 
diff --git a/src/ct.c b/src/ct.c
index e5ca593..8bbed08 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -24,6 +24,7 @@
 #include <datatype.h>
 #include <ct.h>
 #include <utils.h>
+#include <statement.h>
 
 static const struct symbol_table ct_state_tbl = {
 	.symbols	= {
@@ -157,6 +158,30 @@ struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key)
 	return expr;
 }
 
+static void ct_stmt_print(const struct stmt *stmt)
+{
+	printf("ct %s set ", ct_templates[stmt->ct.key].token);
+	expr_print(stmt->ct.expr);
+}
+
+static const struct stmt_ops ct_stmt_ops = {
+	.type		= STMT_CT,
+	.name		= "ct",
+	.print		= ct_stmt_print,
+};
+
+struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
+			     struct expr *expr)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &ct_stmt_ops);
+	stmt->ct.key	= key;
+	stmt->ct.tmpl	= &ct_templates[key];
+	stmt->ct.expr	= expr;
+	return stmt;
+}
+
 static void __init ct_init(void)
 {
 	datatype_register(&ct_state_type);
diff --git a/src/evaluate.c b/src/evaluate.c
index d4f8339..3549ec7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1149,6 +1149,15 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	expr_set_context(&ctx->ectx, stmt->ct.tmpl->dtype,
+			 stmt->ct.tmpl->len);
+	if (expr_evaluate(ctx, &stmt->ct.expr) < 0)
+		return -1;
+	return 0;
+}
+
 static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
@@ -1176,6 +1185,8 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_nat(ctx, stmt);
 	case STMT_QUEUE:
 		return 0;
+	case STMT_CT:
+		return stmt_evaluate_ct(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b771da5..1b19d00 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -365,9 +365,26 @@ static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
 		netlink_parse_meta_sreg(ctx, loc, nle);
 }
 
-static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
-			     const struct location *loc,
-			     const struct nft_rule_expr *nle)
+static void netlink_parse_ct_sreg(struct netlink_parse_ctx *ctx,
+				  const struct location *loc,
+				  const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+	struct expr *expr;
+
+	expr = netlink_get_register(ctx, loc,
+				    nft_rule_expr_get_u32(nle, NFT_EXPR_CT_SREG));
+	stmt = ct_stmt_alloc(loc,
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY),
+			     expr);
+	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
+static void netlink_parse_ct_dreg(struct netlink_parse_ctx *ctx,
+				  const struct location *loc,
+				  const struct nft_rule_expr *nle)
 {
 	struct expr *expr;
 
@@ -377,6 +394,16 @@ static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
 			     expr);
 }
 
+static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
+			     const struct location *loc,
+			     const struct nft_rule_expr *nle)
+{
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_CT_DREG))
+		netlink_parse_ct_dreg(ctx, loc, nle);
+	else
+		netlink_parse_ct_sreg(ctx, loc, nle);
+}
+
 static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
@@ -832,6 +859,10 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->meta.expr != NULL)
 				expr_postprocess(&rctx, stmt, &stmt->meta.expr);
 			break;
+		case STMT_CT:
+			if (stmt->ct.expr != NULL)
+				expr_postprocess(&rctx, stmt, &stmt->ct.expr);
+			break;
 		case STMT_NAT:
 			if (stmt->nat.addr != NULL)
 				expr_postprocess(&rctx, stmt, &stmt->nat.addr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9ae9bb7..5a65997 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -656,6 +656,22 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
+				  const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+	enum nft_registers sreg;
+
+	sreg = get_register(ctx);
+	netlink_gen_expr(ctx, stmt->ct.expr, sreg);
+	release_register(ctx);
+
+	nle = alloc_nft_expr("ct");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_KEY, stmt->ct.key);
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -678,6 +694,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_nat_stmt(ctx, stmt);
 	case STMT_QUEUE:
 		return netlink_gen_queue_stmt(ctx, stmt);
+	case STMT_CT:
+		return netlink_gen_ct_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser.y b/src/parser.y
index 9320f2d..2781fe2 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -372,6 +372,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc
+%type <stmt>			ct_stmt
+%destructor { stmt_free($$); }	ct_stmt
 %type <stmt>			meta_stmt
 %destructor { stmt_free($$); }	meta_stmt
 %type <stmt>			log_stmt log_stmt_alloc
@@ -937,6 +939,7 @@ stmt			:	verdict_stmt
 			|	reject_stmt
 			|	nat_stmt
 			|	queue_stmt
+			|	ct_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1416,6 +1419,12 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
 			;
 
+ct_stmt			:	CT	ct_key		SET	expr
+			{
+				$$ = ct_stmt_alloc(&@$, $2, $4);
+			}
+			;
+
 payload_expr		:	payload_raw_expr
 			|	eth_hdr_expr
 			|	vlan_hdr_expr
-- 
1.8.3.2

