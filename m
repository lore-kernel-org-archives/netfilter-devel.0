From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 06/12] ct expr: protocol context updates and dynamic typing
Date: Wed,  8 Jan 2014 13:08:57 +0000
Message-ID: <1389186543-6919-7-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40194 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaAHNJS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:18 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include the protocols defined through relational ct expressions in the
protocol context and use the protocol context to dynamically determine
the types of network and transport layer ct expression types.

Before:

$ nft filter output ct proto-dst ssh
<cmdline>:1:28-30: Error: Can't parse symbolic invalid expressions
filter output ct proto-dst ssh
                           ^^^
$ nft filter output ip protocol tcp ct proto-dst ssh
<cmdline>:1:44-46: Error: Can't parse symbolic invalid expressions
filter output ip protocol tcp ct proto-dst ssh
                                           ^^^
$ nft filter output ct protocol tcp ct proto-dst ssh
<cmdline>:1:44-46: Error: Can't parse symbolic invalid expressions
filter output ct protocol tcp ct proto-dst ssh
                                           ^^^
After:

$ nft filter output ct proto-dst ssh
<cmdline>:1:28-30: Error: Can't parse symbolic invalid expressions
filter output ct proto-dst ssh
                           ^^^
$ nft filter output ip protocol tcp ct proto-dst ssh
$ nft filter output ct protocol tcp ct proto-dst ssh

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/ct.h   |  1 +
 src/ct.c       | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/evaluate.c | 16 +++++++++++++++-
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/include/ct.h b/include/ct.h
index 67718c8..64366ab 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -25,5 +25,6 @@ struct ct_template {
 
 extern struct expr *ct_expr_alloc(const struct location *loc,
 				  enum nft_ct_keys key);
+extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 #endif /* NFTABLES_CT_H */
diff --git a/src/ct.c b/src/ct.c
index e5ca593..b8f7632 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -23,6 +23,7 @@
 #include <expression.h>
 #include <datatype.h>
 #include <ct.h>
+#include <gmputil.h>
 #include <utils.h>
 
 static const struct symbol_table ct_state_tbl = {
@@ -139,11 +140,32 @@ static void ct_expr_clone(struct expr *new, const struct expr *expr)
 	new->ct.key = expr->ct.key;
 }
 
+static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
+{
+	const struct expr *left = expr->left, *right = expr->right;
+	const struct proto_desc *base, *desc;
+
+	assert(expr->op == OP_EQ);
+
+	switch (left->ct.key) {
+	case NFT_CT_PROTOCOL:
+		base = ctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+		desc = proto_find_upper(base, mpz_get_uint32(right->value));
+
+		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR,
+				 &expr->location, desc);
+		break;
+	default:
+		break;
+	}
+}
+
 static const struct expr_ops ct_expr_ops = {
 	.type		= EXPR_CT,
 	.name		= "ct",
 	.print		= ct_expr_print,
 	.clone		= ct_expr_clone,
+	.pctx_update	= ct_expr_pctx_update,
 };
 
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key)
@@ -154,9 +176,45 @@ struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key)
 	expr = expr_alloc(loc, &ct_expr_ops, tmpl->dtype,
 			  tmpl->byteorder, tmpl->len);
 	expr->ct.key = key;
+
+	switch (key) {
+	case NFT_CT_PROTOCOL:
+		expr->flags = EXPR_F_PROTOCOL;
+		break;
+	default:
+		break;
+	}
+
 	return expr;
 }
 
+void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
+{
+	const struct proto_desc *desc;
+
+	switch (expr->ct.key) {
+	case NFT_CT_SRC:
+	case NFT_CT_DST:
+		desc = ctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc == &proto_ip)
+			expr->dtype = &ipaddr_type;
+		else if (desc == &proto_ip6)
+			expr->dtype = &ip6addr_type;
+
+		expr->len = expr->dtype->size;
+		break;
+	case NFT_CT_PROTO_SRC:
+	case NFT_CT_PROTO_DST:
+		desc = ctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+		if (desc == NULL)
+			break;
+		expr->dtype = &inet_service_type;
+		break;
+	default:
+		break;
+	}
+}
+
 static void __init ct_init(void)
 {
 	datatype_register(&ct_state_type);
diff --git a/src/evaluate.c b/src/evaluate.c
index 3fe9da4..257c67e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -290,6 +290,19 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
 }
 
 /*
+ * CT expression: update the protocol dependant types bases on the protocol
+ * context.
+ */
+static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
+{
+	struct expr *ct = *expr;
+
+	ct_expr_update_type(&ctx->pctx, ct);
+
+	return expr_evaluate_primary(ctx, expr);
+}
+
+/*
  * Prefix expression: the argument must be a constant value of integer base
  * type; the prefix length must be less than or equal to the type width.
  */
@@ -1042,10 +1055,11 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_VERDICT:
 	case EXPR_EXTHDR:
 	case EXPR_META:
-	case EXPR_CT:
 		return expr_evaluate_primary(ctx, expr);
 	case EXPR_PAYLOAD:
 		return expr_evaluate_payload(ctx, expr);
+	case EXPR_CT:
+		return expr_evaluate_ct(ctx, expr);
 	case EXPR_PREFIX:
 		return expr_evaluate_prefix(ctx, expr);
 	case EXPR_RANGE:
-- 
1.8.4.2

