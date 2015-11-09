From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 2/2] payload: add payload statement
Date: Mon,  9 Nov 2015 14:57:34 +0000
Message-ID: <1447081054-31046-3-git-send-email-kaber@trash.net>
References: <1447081054-31046-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48711 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbbKIO5i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 09:57:38 -0500
In-Reply-To: <1447081054-31046-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for payload mangling using the payload statement. The syntax
is similar to the other data changing statements:

nft filter output tcp dport set 25

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h |  4 ++++
 include/statement.h                 | 11 +++++++++
 src/evaluate.c                      | 10 ++++++++
 src/netlink_delinearize.c           | 46 ++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c             | 37 +++++++++++++++++++++++++++++
 src/parser_bison.y                  |  9 ++++++++
 src/payload.c                       | 24 +++++++++++++++++++
 7 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5ebe3d8..4292e02 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -595,6 +595,8 @@ enum nft_payload_bases {
  * @NFTA_PAYLOAD_BASE: payload base (NLA_U32: nft_payload_bases)
  * @NFTA_PAYLOAD_OFFSET: payload offset relative to base (NLA_U32)
  * @NFTA_PAYLOAD_LEN: payload length (NLA_U32)
+ * @NFTA_PAYLOAD_SREG: source register to load data from (NLA_U32: nft_registers)
+ * @NFTA_PAYLOAD_CSUM_OFFSET: checksum offset relative to base (NLA_U32)
  */
 enum nft_payload_attributes {
 	NFTA_PAYLOAD_UNSPEC,
@@ -602,6 +604,8 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_BASE,
 	NFTA_PAYLOAD_OFFSET,
 	NFTA_PAYLOAD_LEN,
+	NFTA_PAYLOAD_SREG,
+	NFTA_PAYLOAD_CSUM_OFFSET,
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/include/statement.h b/include/statement.h
index 8b035d3..53620ae 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -17,6 +17,14 @@ struct counter_stmt {
 
 extern struct stmt *counter_stmt_alloc(const struct location *loc);
 
+struct payload_stmt {
+	struct expr			*expr;
+	struct expr			*val;
+};
+
+extern struct stmt *payload_stmt_alloc(const struct location *loc,
+				       struct expr *payload, struct expr *expr);
+
 #include <meta.h>
 struct meta_stmt {
 	enum nft_meta_keys		key;
@@ -128,6 +136,7 @@ extern struct stmt *set_stmt_alloc(const struct location *loc);
  * @STMT_EXPRESSION:	expression statement (relational)
  * @STMT_VERDICT:	verdict statement
  * @STMT_COUNTER:	counters
+ * @STMT_PAYLOAD:	payload statement
  * @STMT_META:		meta statement
  * @STMT_LIMIT:		limit statement
  * @STMT_LOG:		log statement
@@ -145,6 +154,7 @@ enum stmt_types {
 	STMT_EXPRESSION,
 	STMT_VERDICT,
 	STMT_COUNTER,
+	STMT_PAYLOAD,
 	STMT_META,
 	STMT_LIMIT,
 	STMT_LOG,
@@ -196,6 +206,7 @@ struct stmt {
 	union {
 		struct expr		*expr;
 		struct counter_stmt	counter;
+		struct payload_stmt	payload;
 		struct meta_stmt	meta;
 		struct log_stmt		log;
 		struct limit_stmt	limit;
diff --git a/src/evaluate.c b/src/evaluate.c
index 7842471..15fed26 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1342,6 +1342,14 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	return stmt_evaluate_arg(ctx, stmt,
+				 stmt->payload.expr->dtype,
+				 stmt->payload.expr->len,
+				 &stmt->payload.val);
+}
+
 static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	return stmt_evaluate_arg(ctx, stmt,
@@ -1905,6 +1913,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_expr(ctx, stmt);
 	case STMT_VERDICT:
 		return stmt_evaluate_verdict(ctx, stmt);
+	case STMT_PAYLOAD:
+		return stmt_evaluate_payload(ctx, stmt);
 	case STMT_META:
 		return stmt_evaluate_meta(ctx, stmt);
 	case STMT_CT:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3584de7..8a91d63 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -397,9 +397,9 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
-static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
-				  const struct location *loc,
-				  const struct nftnl_expr *nle)
+static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
+				       const struct location *loc,
+				       const struct nftnl_expr *nle)
 {
 	enum nft_registers dreg;
 	uint32_t base, offset, len;
@@ -416,6 +416,39 @@ static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
+				       const struct location *loc,
+				       const struct nftnl_expr *nle)
+{
+	enum nft_registers sreg;
+	uint32_t base, offset, len;
+	struct expr *expr, *val;
+	struct stmt *stmt;
+
+	base   = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_BASE) + 1;
+	offset = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE;
+	len    = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE;
+
+	expr = payload_expr_alloc(loc, NULL, 0);
+	payload_init_raw(expr, base, offset, len);
+
+	sreg = netlink_parse_register(nle, NFT_EXPR_PAYLOAD_SREG);
+	val  = netlink_get_register(ctx, loc, sreg);
+	stmt = payload_stmt_alloc(loc, expr, val);
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
+static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
+				  const struct location *loc,
+				  const struct nft_rule_expr *nle)
+{
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_PAYLOAD_DREG))
+		netlink_parse_payload_expr(ctx, loc, nle);
+	else
+		netlink_parse_payload_stmt(ctx, loc, nle);
+}
+
 static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *nle)
@@ -1554,6 +1587,13 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_EXPRESSION:
 			stmt_expr_postprocess(&rctx, prev);
 			break;
+		case STMT_PAYLOAD:
+			expr_postprocess(&rctx, &stmt->payload.expr);
+			expr_set_type(stmt->payload.val,
+				      stmt->payload.expr->dtype,
+				      stmt->payload.expr->byteorder);
+			expr_postprocess(&rctx, &stmt->payload.val);
+			break;
 		case STMT_META:
 			if (stmt->meta.expr != NULL)
 				expr_postprocess(&rctx, &stmt->meta.expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c9af036..0b6af57 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -680,6 +680,41 @@ static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
+				     const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+	const struct proto_desc *desc;
+	const struct expr *expr;
+	enum nft_registers sreg;
+	unsigned int csum_off;
+
+	sreg = get_register(ctx, stmt->payload.val);
+	netlink_gen_expr(ctx, stmt->payload.val, sreg);
+	release_register(ctx, stmt->payload.val);
+
+	expr = stmt->payload.expr;
+
+	csum_off = 0;
+	desc = expr->payload.desc;
+	if (desc != NULL && desc->checksum_key)
+		csum_off = desc->templates[desc->checksum_key].offset;
+
+	nle = alloc_nft_expr("payload");
+	netlink_put_register(nle, NFTNL_EXPR_PAYLOAD_SREG, sreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_BASE,
+			   expr->payload.base - 1);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET,
+			   expr->payload.offset / BITS_PER_BYTE);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_LEN,
+			   expr->len / BITS_PER_BYTE);
+	if (csum_off)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
+				   csum_off / BITS_PER_BYTE);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 				  const struct stmt *stmt)
 {
@@ -990,6 +1025,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_verdict_stmt(ctx, stmt);
 	case STMT_COUNTER:
 		return netlink_gen_counter_stmt(ctx, stmt);
+	case STMT_PAYLOAD:
+		return netlink_gen_payload_stmt(ctx, stmt);
 	case STMT_META:
 		return netlink_gen_meta_stmt(ctx, stmt);
 	case STMT_LOG:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ab4524b..67d25bb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -447,6 +447,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc
+%type <stmt>			payload_stmt
+%destructor { stmt_free($$); }	payload_stmt
 %type <stmt>			ct_stmt
 %destructor { stmt_free($$); }	ct_stmt
 %type <stmt>			meta_stmt
@@ -1312,6 +1314,7 @@ stmt_list		:	stmt
 stmt			:	verdict_stmt
 			|	match_stmt
 			|	counter_stmt
+			|	payload_stmt
 			|	meta_stmt
 			|	log_stmt
 			|	limit_stmt
@@ -2061,6 +2064,12 @@ ct_stmt			:	CT	ct_key		SET	expr
 			}
 			;
 
+payload_stmt		:	payload_expr		SET	expr
+			{
+				$$ = payload_stmt_alloc(&@$, $1, $3);
+			}
+			;
+
 payload_expr		:	payload_raw_expr
 			|	eth_hdr_expr
 			|	vlan_hdr_expr
diff --git a/src/payload.c b/src/payload.c
index b75527a..a97041e 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -138,6 +138,30 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
 	expr->len		= len;
 }
 
+static void payload_stmt_print(const struct stmt *stmt)
+{
+	expr_print(stmt->payload.expr);
+	printf(" set ");
+	expr_print(stmt->payload.val);
+}
+
+static const struct stmt_ops payload_stmt_ops = {
+	.type		= STMT_PAYLOAD,
+	.name		= "payload",
+	.print		= payload_stmt_print,
+};
+
+struct stmt *payload_stmt_alloc(const struct location *loc,
+				struct expr *expr, struct expr *val)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &payload_stmt_ops);
+	stmt->payload.expr = expr;
+	stmt->payload.val  = val;
+	return stmt;
+}
+
 /**
  * payload_gen_dependency - generate match expression on payload dependency
  *
-- 
2.5.0

