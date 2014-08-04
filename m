From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/5 v3] src: fix byteorder conversions in constant values
Date: Mon,  4 Aug 2014 18:00:09 +0200
Message-ID: <1407168011-6424-4-git-send-email-alvaroneay@gmail.com>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55949 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaHDQAh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:00:37 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so7949560wgh.30
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2014 09:00:34 -0700 (PDT)
In-Reply-To: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the byteorder conversion happens in many places: the parser,
the evaluation and the code generation steps. This a problem because
the constant expression is converted several times into big endian
byteorder at different steps.

With this patch, we don't change byteorder in the code generation
step anymore because we assume that all expressions are in the
appropriate byteorder after the parsing and the evaluation steps.
This patch solves rules like:

nft add rule bridge filter input ether type ip

With this rule we create a expression like:

[ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000800 ]

With this patch, we have a expresion with the correct conversion:

[ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]

This is also a problem in the delinearize step because the expression
are already converted to the correct byteorder and we change it again.

Also this patch, add a new datatype integer_big_endian for fixing some case
that we have use integer_type with a invalid byteorder when we must associate
a big endian byteorder. This solution is based in a previously patch of Yuxuan
Shui.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v3]
* Fixed the expressions with invalid byteorder and renamed the patch name.

 include/datatype.h        |    1 +
 include/expression.h      |    2 ++
 include/netlink.h         |    3 +--
 src/datatype.c            |   16 ++++++++++++++--
 src/evaluate.c            |    5 +++--
 src/expression.c          |   17 +++++++++++++++--
 src/gmputil.c             |    9 +++++++--
 src/netlink.c             |   13 +++++++++----
 src/netlink_delinearize.c |   16 ++++++++++++----
 src/netlink_linearize.c   |   10 +++++-----
 src/proto.c               |    2 +-
 11 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2c66e9d..0a29506 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -182,6 +182,7 @@ extern const struct datatype verdict_type;
 extern const struct datatype nfproto_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
+extern const struct datatype big_endian_integer_type;
 extern const struct datatype string_type;
 extern const struct datatype lladdr_type;
 extern const struct datatype ipaddr_type;
diff --git a/include/expression.h b/include/expression.h
index edb6dc5..4679316 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -351,4 +351,6 @@ extern struct expr *map_expr_alloc(const struct location *loc,
 extern struct expr *set_ref_expr_alloc(const struct location *loc,
 				       struct set *set);
 
+extern void expr_switch_byteorder(struct expr *expr);
+
 #endif /* NFTABLES_EXPRESSION_H */
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
index 55af227..96bf915 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -270,6 +270,14 @@ const struct datatype integer_type = {
 	.parse		= integer_type_parse,
 };
 
+const struct datatype big_endian_integer_type = {
+	.type = TYPE_INTEGER,
+	.byteorder = BYTEORDER_BIG_ENDIAN,
+	.name = "big_endian_integer",
+	.desc = "big endian integer",
+	.basetype = &integer_type,
+};
+
 static void string_type_print(const struct expr *expr)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
@@ -545,14 +553,18 @@ static struct error_record *inet_service_type_parse(const struct expr *sym,
 		if (errno == ERANGE || i > UINT16_MAX)
 			return error(&sym->location, "Service out of range");
 
-		port = htons(i);
+		port = i;
 	} else {
 		err = getaddrinfo(NULL, sym->identifier, NULL, &ai);
 		if (err != 0)
 			return error(&sym->location, "Could not resolve service: %s",
 				     gai_strerror(err));
 
-		port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
+		/* The port is in network byteorder, we must convert it because
+		 * we create a big endian constant and we make a wrong
+		 * reconversion.
+		 */
+		port = ntohs(((struct sockaddr_in *)ai->ai_addr)->sin_port);
 		freeaddrinfo(ai);
 	}
 
diff --git a/src/evaluate.c b/src/evaluate.c
index e05473a..8aaf1bf 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -168,9 +168,10 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
 
-	if (expr_is_constant(*expr))
+	if (expr_is_constant(*expr)) {
+		expr_switch_byteorder(*expr);
 		(*expr)->byteorder = byteorder;
-	else {
+	} else {
 		op = byteorder_conversion_op(*expr, byteorder);
 		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
 		if (expr_evaluate(ctx, expr) < 0)
diff --git a/src/expression.c b/src/expression.c
index fa14d99..ebd0ebb 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -303,8 +303,13 @@ struct expr *constant_expr_join(const struct expr *e1, const struct expr *e2)
 	assert(e2->ops->type == EXPR_VALUE);
 
 	tmp = e1->len / BITS_PER_BYTE;
-	mpz_export_data(data, e1->value, e1->byteorder, tmp);
-	mpz_export_data(data + tmp, e2->value, e2->byteorder,
+
+	/* We assume that the expression already comes in the
+	 * appropriate byteorder from the parse/evaluation steps, so
+	 * use BYTEORDER_HOST_ENDIAN to leave it as is.
+	 */
+	mpz_export_data(data, e1->value, BYTEORDER_HOST_ENDIAN, tmp);
+	mpz_export_data(data + tmp, e2->value, BYTEORDER_HOST_ENDIAN,
 			e2->len / BITS_PER_BYTE);
 
 	return constant_expr_alloc(&e1->location, &invalid_type,
@@ -863,6 +868,14 @@ static void set_ref_expr_destroy(struct expr *expr)
 	set_free(expr->set);
 }
 
+void expr_switch_byteorder(struct expr *expr)
+{
+	uint32_t len;
+
+	len = div_round_up(expr->len, BITS_PER_BYTE);
+	mpz_switch_byteorder(expr->value, len);
+}
+
 static const struct expr_ops set_ref_expr_ops = {
 	.type		= EXPR_SET_REF,
 	.name		= "set reference",
diff --git a/src/gmputil.c b/src/gmputil.c
index cb46445..2d1ee3c 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -103,11 +103,11 @@ void *mpz_export_data(void *data, const mpz_t op,
 
 	switch (byteorder) {
 	case BYTEORDER_BIG_ENDIAN:
-	default:
 		order = MPZ_MSWF;
 		endian = MPZ_BIG_ENDIAN;
 		break;
 	case BYTEORDER_HOST_ENDIAN:
+	default:
 		order = MPZ_HWO;
 		endian = MPZ_HOST_ENDIAN;
 		break;
@@ -125,13 +125,18 @@ void mpz_import_data(mpz_t rop, const void *data,
 	enum mpz_word_order order;
 	enum mpz_byte_order endian;
 
+	/* This function is called from the parser. At that stage,
+	 * some constant values may still have BYTEORDER_INVALID. In
+	 * that case, fall back to BYTEORDER_HOST_ENDIAN which leave
+	 * it as is until this is passed to the evaluation step.
+	 */
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
diff --git a/src/netlink.c b/src/netlink.c
index e149215..35ef4d8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -239,11 +239,16 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
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
 
@@ -277,7 +282,7 @@ static void netlink_gen_constant_data(const struct expr *expr,
 				      struct nft_data_linearize *data)
 {
 	assert(expr->ops->type == EXPR_VALUE);
-	netlink_gen_raw_data(expr->value, expr->byteorder,
+	netlink_gen_raw_data(expr->value,
 			     div_round_up(expr->len, BITS_PER_BYTE), data);
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..1035e32 100644
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
 
+			/* We have to convert the values that we obtained from
+			 * the kernel to host byteorder. Therefore, we assume
+			 * that the values are in host endian after the
+			 * delinearization.
+			 */
+			if (tmp->byteorder == BYTEORDER_BIG_ENDIAN)
+				expr_switch_byteorder(nexpr->right);
+
 			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
 			list_add_tail(&nstmt->list, &stmt->list);
 
@@ -831,8 +837,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 		payload_dependency_kill(ctx, expr);
 		break;
 	case EXPR_VALUE:
-		// FIXME
-		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		/* Everything has to be in host byteorder after the
+		 * delinearization step.
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
diff --git a/src/proto.c b/src/proto.c
index e5f49cb..b8eb6f7 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -190,7 +190,7 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			   field_sizeof(__type, __member) * 8)
 
 #define HDR_FIELD(__name, __struct, __member)				\
-	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
+	HDR_TEMPLATE(__name, &big_endian_integer_type, __struct, __member)
 #define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype, __offset, __len)
 #define HDR_TYPE(__name, __dtype, __struct, __member)			\
-- 
1.7.10.4

