From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/4 v2] src: fix byteorder conversions in simple values
Date: Mon, 28 Jul 2014 13:51:49 +0200
Message-ID: <1406548311-31354-3-git-send-email-alvaroneay@gmail.com>
References: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34758 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaG1LwA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:52:00 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so4231175wiv.11
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2014 04:51:59 -0700 (PDT)
In-Reply-To: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the byteorder conversion happens in the parser,
the evaluation and the code generation steps. This is a problem
because the expression which are already in big endian byteorder
are converted again.

With this patch, we don't change byteorder in the code generation
step anymore because we assume that all expressions are in the
appropriate byteorder. This patch solves rules like:

nft add rule bridge filter input ether type ip

With this rule we create a expression like:

[ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000800 ]

With this patch, we have a expresion with the correct conversion:

[ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]

This is also a problem in the delinearize step because the expression
are already converted to the correctly byteorder and we change it again.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* Added some comments for explaining better the changes that I have done
* Fixed a wrong byteorder conversions when we use a string in some rules,
  for example "nft add rule filter input tcp dport ssh".
* I have changed the function byteorder_conversion for making the byteorder
  conversion of single values in case that we must to changing it. Previously,
  we change the byteorder and we make convert the value in netlink with the
  new byteorder.

 include/gmputil.h         |    1 +
 include/netlink.h         |    3 +--
 src/datatype.c            |    8 ++++++--
 src/evaluate.c            |    7 ++++---
 src/expression.c          |    8 ++++++--
 src/gmputil.c             |   15 ++++++++++++++-
 src/netlink.c             |   13 +++++++++----
 src/netlink_delinearize.c |   16 ++++++++++++----
 src/netlink_linearize.c   |   10 +++++-----
 src/payload.c             |    3 +--
 10 files changed, 59 insertions(+), 25 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index 63eb0ba..566d7d7 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -48,4 +48,5 @@ extern void mpz_import_data(mpz_t rop, const void *data,
 			    unsigned int len);
 extern void mpz_switch_byteorder(mpz_t rop, unsigned int len);
 
+extern void mpz_switch_expr_byteorder(struct expr *expr);
 #endif /* NFTABLES_GMPUTIL_H */
diff --git a/include/netlink.h b/include/netlink.h
index af5dcd9..603da80 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -55,8 +55,7 @@ struct nft_data_delinearize {
 
 extern void netlink_gen_data(const struct expr *expr,
 			     struct nft_data_linearize *data);
-extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
-				 unsigned int len,
+extern void netlink_gen_raw_data(const mpz_t value, unsigned int len,
 				 struct nft_data_linearize *data);
 
 extern struct expr *netlink_alloc_value(const struct location *loc,
diff --git a/src/datatype.c b/src/datatype.c
index 55af227..6b49a4a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -255,8 +255,11 @@ static struct error_record *integer_type_parse(const struct expr *sym,
 			     sym->dtype->desc);
 	}
 
+	/* If we use integer type, we must to convert it to big endian for
+	 * using it in internet format (big endian).
+	 */
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
-				   BYTEORDER_HOST_ENDIAN, 1, NULL);
+				   BYTEORDER_BIG_ENDIAN, 1, NULL);
 	mpz_set((*res)->value, v);
 	mpz_clear(v);
 	return NULL;
@@ -545,7 +548,7 @@ static struct error_record *inet_service_type_parse(const struct expr *sym,
 		if (errno == ERANGE || i > UINT16_MAX)
 			return error(&sym->location, "Service out of range");
 
-		port = htons(i);
+		port = i;
 	} else {
 		err = getaddrinfo(NULL, sym->identifier, NULL, &ai);
 		if (err != 0)
@@ -553,6 +556,7 @@ static struct error_record *inet_service_type_parse(const struct expr *sym,
 				     gai_strerror(err));
 
 		port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
+		port = htons(port);
 		freeaddrinfo(ai);
 	}
 
diff --git a/src/evaluate.c b/src/evaluate.c
index e05473a..ecd7dfa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -168,9 +168,10 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
 
-	if (expr_is_constant(*expr))
-		(*expr)->byteorder = byteorder;
-	else {
+	if (expr_is_constant(*expr)) {
+		if ((*expr)->byteorder == BYTEORDER_BIG_ENDIAN)
+			mpz_switch_expr_byteorder(*expr);
+	} else {
 		op = byteorder_conversion_op(*expr, byteorder);
 		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
 		if (expr_evaluate(ctx, expr) < 0)
diff --git a/src/expression.c b/src/expression.c
index fa14d99..d2c61f7 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -303,8 +303,12 @@ struct expr *constant_expr_join(const struct expr *e1, const struct expr *e2)
 	assert(e2->ops->type == EXPR_VALUE);
 
 	tmp = e1->len / BITS_PER_BYTE;
-	mpz_export_data(data, e1->value, e1->byteorder, tmp);
-	mpz_export_data(data + tmp, e2->value, e2->byteorder,
+
+	/* All the values here have been converted to the correctly byteorder
+	 * we don't need to change it again for joining it
+	 */
+	mpz_export_data(data, e1->value, BYTEORDER_HOST_ENDIAN, tmp);
+	mpz_export_data(data + tmp, e2->value, BYTEORDER_HOST_ENDIAN,
 			e2->len / BITS_PER_BYTE);
 
 	return constant_expr_alloc(&e1->location, &invalid_type,
diff --git a/src/gmputil.c b/src/gmputil.c
index cb46445..cc1ceca 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -20,6 +20,7 @@
 #include <datatype.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <expression.h>
 
 void mpz_bitmask(mpz_t rop, unsigned int width)
 {
@@ -125,13 +126,17 @@ void mpz_import_data(mpz_t rop, const void *data,
 	enum mpz_word_order order;
 	enum mpz_byte_order endian;
 
+/* We can import data from the parser, the datatype is invalid there.
+ * Handle invalid byteorder as host endian, we'll get the real datatype
+ * in the evaluation step, then it will be converted to big endian if needed.
+ */
 	switch (byteorder) {
 	case BYTEORDER_BIG_ENDIAN:
-	default:
 		order  = MPZ_MSWF;
 		endian = MPZ_BIG_ENDIAN;
 		break;
 	case BYTEORDER_HOST_ENDIAN:
+	default:
 		order  = MPZ_HWO;
 		endian = MPZ_HOST_ENDIAN;
 		break;
@@ -140,6 +145,14 @@ void mpz_import_data(mpz_t rop, const void *data,
 	mpz_import(rop, len, order, 1, endian, 0, data);
 }
 
+void mpz_switch_expr_byteorder(struct expr *expr)
+{
+	uint32_t len;
+
+	len = div_round_up(expr->len, BITS_PER_BYTE);
+	mpz_switch_byteorder(expr->value, len);
+}
+
 void mpz_switch_byteorder(mpz_t rop, unsigned int len)
 {
 	char data[len];
diff --git a/src/netlink.c b/src/netlink.c
index 05fae10..00c3cb1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -240,11 +240,16 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 	return nlse;
 }
 
-void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
-			  unsigned int len, struct nft_data_linearize *data)
+void netlink_gen_raw_data(const mpz_t value, unsigned int len,
+			  struct nft_data_linearize *data)
 {
 	assert(len > 0);
-	mpz_export_data(data->value, value, byteorder, len);
+
+	/* After the evaluation step we assume that the values are always in
+	 * the appropriate byteorder. Use BYTEORDER_HOST_ENDIAN here not to
+	 * alter endianness.
+	 */
+	mpz_export_data(data->value, value, BYTEORDER_HOST_ENDIAN, len);
 	data->len = len;
 }
 
@@ -278,7 +283,7 @@ static void netlink_gen_constant_data(const struct expr *expr,
 				      struct nft_data_linearize *data)
 {
 	assert(expr->ops->type == EXPR_VALUE);
-	netlink_gen_raw_data(expr->value, expr->byteorder,
+	netlink_gen_raw_data(expr->value,
 			     div_round_up(expr->len, BITS_PER_BYTE), data);
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..c45b3b4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -642,14 +642,20 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		list_for_each_entry(left, &list, list) {
 			tmp = constant_expr_splice(right, left->len);
 			expr_set_type(tmp, left->dtype, left->byteorder);
-			if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
-				mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
 
 			nexpr = relational_expr_alloc(&expr->location, expr->op,
 						      left, tmp);
 			if (expr->op == OP_EQ)
 				left->ops->pctx_update(&ctx->pctx, nexpr);
 
+
+	 /* We have to convert the values that we obtained from the kernel to
+	  * host byteorder. Therefore, we assume that the values are in host
+	  * endian after the delinearization.
+	  */
+			if (tmp->byteorder != BYTEORDER_HOST_ENDIAN)
+				mpz_switch_expr_byteorder(nexpr->right);
+
 			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
 			list_add_tail(&nstmt->list, &stmt->list);
 
@@ -831,8 +837,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 		payload_dependency_kill(ctx, expr);
 		break;
 	case EXPR_VALUE:
-		// FIXME
-		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		/* If we have value with big endian byteorder, we must to change
+		 * it for showing it in host endian byteorder.
+		 */
+		if (expr->byteorder == BYTEORDER_BIG_ENDIAN)
 			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
 		// Quite a hack :)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5c1b46d..8788813 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -206,8 +206,8 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 
 		mpz_init(mask);
 		mpz_prefixmask(mask, expr->right->len, expr->right->prefix_len);
-		netlink_gen_raw_data(mask, expr->right->byteorder,
-				     expr->right->len / BITS_PER_BYTE, &nld);
+		netlink_gen_raw_data(mask, expr->right->len / BITS_PER_BYTE,
+				     &nld);
 		mpz_clear(mask);
 
 		zero.len = nld.len;
@@ -315,7 +315,7 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 
 	mpz_init_set_ui(zero, 0);
 
-	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
+	netlink_gen_raw_data(zero, len, &nld);
 	netlink_gen_data(expr->right, &nld2);
 
 	nle = alloc_nft_expr("bitwise");
@@ -423,9 +423,9 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, dreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
 
-	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
+	netlink_gen_raw_data(mask, len, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, nld.value, nld.len);
-	netlink_gen_raw_data(xor, expr->byteorder, len, &nld);
+	netlink_gen_raw_data(xor, len, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, nld.value, nld.len);
 
 	mpz_clear(tmp);
diff --git a/src/payload.c b/src/payload.c
index be3d610..8b10a79 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -213,8 +213,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
 
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
-				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len,
+				    tmpl->dtype->byteorder, tmpl->len,
 				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-- 
1.7.10.4

