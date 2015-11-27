From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft] datatype: add scaled integer types
Date: Fri, 27 Nov 2015 16:29:58 +0000
Message-ID: <1448641798-7754-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48286 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbbK0QaC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 11:30:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add two types for integers scaled by factor 4 and 8 for various length values.
An alternative to new types would be annotating the header templates with
the scaling factor, however that would not work for standalone sets, which
are missing the necessary context.

# nft filter input ip hdrlength 20 counter
# nft filter input tcp doff 32 counter
# nft filter input ip hdrlength 21 counter
<cmdline>:1:27-28: Error: Value 21 is not a multiple of 4
filter input ip hdrlength 21 counter
                          ^^
# nft filter input ip hdrlength 61 counter
<cmdline>:1:27-28: Error: Value 61 exceeds valid range 0-60
filter input ip hdrlength 61 counter
                          ^^
# nft list table filter
table ip filter {
	chain input {
		type filter hook input priority 0; policy accept;
		tcp doff 32 counter packets 584 bytes 867617
		ip hdrlength 20 counter packets 597 bytes 868670
	}
...

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h        |  8 ++++++
 src/datatype.c            | 18 +++++++++++++
 src/evaluate.c            | 64 +++++++++++++++++++++++++++++++----------------
 src/netlink_delinearize.c |  7 ++++--
 src/proto.c               |  4 +--
 5 files changed, 75 insertions(+), 26 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 07fedce..580e16f 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -9,6 +9,8 @@
  * @TYPE_NFPROTO:	netfilter protocol (integer subtype)
  * @TYPE_BITMASK:	bitmask
  * @TYPE_INTEGER:	integer
+ * @TYPE_INTEGER_SC4:	integer scaled by factor 4
+ * @TYPE_INTEGER_SC8:	integer scaled by factor 8
  * @TYPE_STRING:	string
  * @TYPE_LLADDR:	link layer address (integer subtype)
  * @TYPE_IPADDR:	IPv4 address (integer subtype)
@@ -78,6 +80,8 @@ enum datatypes {
 	TYPE_ICMPV6_CODE,
 	TYPE_ICMPX_CODE,
 	TYPE_DEVGROUP,
+	TYPE_INTEGER_SC4,
+	TYPE_INTEGER_SC8,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -119,6 +123,7 @@ enum datatype_flags {
  * @flags:	flags
  * @size:	type size (fixed sized non-basetypes only)
  * @subtypes:	number of subtypes (concat type)
+ * @scale:	scaling factor
  * @name:	type name
  * @desc:	type description
  * @basetype:	basetype for subtypes, determines type compatibilty
@@ -133,6 +138,7 @@ struct datatype {
 	unsigned int			flags;
 	unsigned int			size;
 	unsigned int			subtypes;
+	unsigned int			scale;
 	const char			*name;
 	const char			*desc;
 	const struct datatype		*basetype;
@@ -197,6 +203,8 @@ extern const struct datatype verdict_type;
 extern const struct datatype nfproto_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
+extern const struct datatype integer_sc4_type;
+extern const struct datatype integer_sc8_type;
 extern const struct datatype string_type;
 extern const struct datatype lladdr_type;
 extern const struct datatype ipaddr_type;
diff --git a/src/datatype.c b/src/datatype.c
index f56763b..e1b2482 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -33,6 +33,8 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_VERDICT]		= &verdict_type,
 	[TYPE_NFPROTO]		= &nfproto_type,
 	[TYPE_BITMASK]		= &bitmask_type,
+	[TYPE_INTEGER_SC4]	= &integer_sc4_type,
+	[TYPE_INTEGER_SC8]	= &integer_sc8_type,
 	[TYPE_INTEGER]		= &integer_type,
 	[TYPE_STRING]		= &string_type,
 	[TYPE_LLADDR]		= &lladdr_type,
@@ -308,6 +310,22 @@ const struct datatype integer_type = {
 	.parse		= integer_type_parse,
 };
 
+const struct datatype integer_sc4_type = {
+	.type		= TYPE_INTEGER,
+	.name		= "integer_scaled_4",
+	.desc		= "integer scaled by factor 4",
+	.basetype	= &integer_type,
+	.scale		= 2,
+};
+
+const struct datatype integer_sc8_type = {
+	.type		= TYPE_INTEGER,
+	.name		= "integer_scaled_8",
+	.desc		= "integer scaled by factor 8",
+	.basetype	= &integer_type,
+	.scale		= 3,
+};
+
 static void string_type_print(const struct expr *expr)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
diff --git a/src/evaluate.c b/src/evaluate.c
index 7aab6aa..a27f2dd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -203,6 +203,46 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 	return expr_evaluate(ctx, expr);
 }
 
+static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+	const char *valstr, *rangestr;
+	unsigned int scale;
+	mpz_t mask;
+	int err = 0;
+
+	valstr = mpz_get_str(NULL, 10, expr->value);
+
+	mpz_init_bitmask(mask, ctx->ectx.len);
+	scale = expr->dtype->scale;
+	if (scale)
+		mpz_lshift_ui(mask, scale);
+
+	if (mpz_cmp(expr->value, mask) > 0) {
+		rangestr = mpz_get_str(NULL, 10, mask);
+		err = expr_error(ctx->msgs, expr,
+				 "Value %s exceeds valid range 0-%s",
+				 valstr, rangestr);
+		xfree(rangestr);
+		goto out;
+	}
+	if (mpz_scan1(expr->value, 0) < scale) {
+		err = expr_error(ctx->msgs, expr,
+				 "Value %s is not a multiple of %u",
+				 valstr, 1 << scale);
+		goto out;
+	}
+
+	mpz_rshift_ui(expr->value, scale);
+
+	expr->byteorder = ctx->ectx.byteorder;
+	expr->len = ctx->ectx.len;
+out:
+	xfree(valstr);
+	mpz_clear(mask);
+	return err;
+}
+
 static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
@@ -266,34 +306,14 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 
 static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 {
-	mpz_t mask;
-
 	switch (expr_basetype(*expr)->type) {
 	case TYPE_INTEGER:
-		mpz_init_bitmask(mask, ctx->ectx.len);
-		if (mpz_cmp((*expr)->value, mask) > 0) {
-			char *valstr = mpz_get_str(NULL, 10, (*expr)->value);
-			char *rangestr = mpz_get_str(NULL, 10, mask);
-			expr_error(ctx->msgs, *expr,
-				   "Value %s exceeds valid range 0-%s",
-				   valstr, rangestr);
-			free(valstr);
-			free(rangestr);
-			mpz_clear(mask);
-			return -1;
-		}
-		(*expr)->byteorder = ctx->ectx.byteorder;
-		(*expr)->len = ctx->ectx.len;
-		mpz_clear(mask);
-		break;
+		return expr_evaluate_integer(ctx, expr);
 	case TYPE_STRING:
-		if (expr_evaluate_string(ctx, expr) < 0)
-			return -1;
-		break;
+		return expr_evaluate_string(ctx, expr);
 	default:
 		BUG("invalid basetype %s\n", expr_basetype(*expr)->name);
 	}
-	return 0;
 }
 
 /*
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 614fbe0..c750ac6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -950,6 +950,8 @@ struct rule_pp_ctx {
 	struct stmt		*stmt;
 };
 
+static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp);
+
 /*
  * Kill a redundant payload dependecy that is implied by a higher layer payload expression.
  */
@@ -1017,8 +1019,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	list_for_each_entry(left, &list, list) {
 		tmp = constant_expr_splice(right, left->len);
 		expr_set_type(tmp, left->dtype, left->byteorder);
-		if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
+		expr_postprocess(ctx, &tmp);
 
 		nexpr = relational_expr_alloc(&expr->location, expr->op,
 					      left, tmp);
@@ -1416,6 +1417,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		// FIXME
 		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+		if (expr->dtype->scale > 1)
+			mpz_lshift_ui(expr->value, expr->dtype->scale);
 
 		if (expr->dtype->type == TYPE_STRING)
 			*exprp = expr_postprocess_string(expr);
diff --git a/src/proto.c b/src/proto.c
index 0fe0b88..6a00106 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -406,7 +406,7 @@ const struct proto_desc proto_tcp = {
 		[TCPHDR_DPORT]		= INET_SERVICE("dport", struct tcphdr, dest),
 		[TCPHDR_SEQ]		= TCPHDR_FIELD("sequence", seq),
 		[TCPHDR_ACKSEQ]		= TCPHDR_FIELD("ackseq", ack_seq),
-		[TCPHDR_DOFF]		= HDR_BITFIELD("doff", &integer_type,
+		[TCPHDR_DOFF]		= HDR_BITFIELD("doff", &integer_sc4_type,
 						       (12 * BITS_PER_BYTE) + 4, 4),
 		[TCPHDR_RESERVED]	= HDR_BITFIELD("reserved", &integer_type,
 						       (12 * BITS_PER_BYTE) + 0, 4),
@@ -509,7 +509,7 @@ const struct proto_desc proto_ip = {
 	},
 	.templates	= {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_sc4_type, 0, 4),
 		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
-- 
2.5.0

