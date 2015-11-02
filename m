From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v2] src: add interface wildcard matching
Date: Mon,  2 Nov 2015 12:48:35 +0100
Message-ID: <1446464915-2407-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53964 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbbKBLle (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2015 06:41:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Contrary to iptables, we use the asterisk character '*' as wildcard.

 # nft --debug=netlink add rule test test iifname eth\*
 ip test test
  [ meta load iifname => reg 1 ]
  [ cmp eq reg 1 0x00687465 ]

Note that this generates an optimized comparison without bitwise.

In case you want to match a device that contains an asterisk, you have
to escape the asterisk, ie.

 # nft add rule test test iifname eth\\*

The wildcard string handling occurs from the evaluation step, where we
convert from:

          relational
             /  \
            /    \
         meta   value
       oifname   eth*

to:
          relational
           /    \
          /      \
        meta    prefix
      ofiname

As Patrick suggested, this not actually a wildcard but a prefix since it
only applies to the string when placed at the end.

More comments:

* This relaxes the left->size > right->size from netlink_parse_cmp()
  for strings since the optimization that this patch applies may now
  result in bogus errors.

* This patch can be later on extended to apply a similar optimization to
  payload expressions when:

	expr->len % BITS_PER_BYTE == 0

  For meta and ct, the kernel checks for the exact length of the attributes
  (it expects integer 32 bits) so we can't do it unless we relax that.

* Wildcard strings are not supported from sets and maps yet. Error
  reporting is not very good at this stage since expr_evaluate_prefix()
  doesn't have enough context (ctx->set is NULL, the set object is
  currently created later after evaluating the lhs and rhs of the
  relational). I'll be following up on this later.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Use prefix expression instead of binop and optimize netlink bytecode not
    to generate bitwise.

 include/utils.h                     |   1 +
 src/evaluate.c                      |  91 +++++++++++++++++++++++-----
 src/netlink_delinearize.c           | 115 +++++++++++++++++++++++++++++-------
 src/netlink_linearize.c             |  17 +++++-
 src/parser_bison.y                  |   4 +-
 src/scanner.l                       |   6 ++
 src/utils.c                         |  13 ++++
 tests/regression/any/meta.t         |   4 ++
 tests/regression/any/meta.t.payload |  20 +++++++
 9 files changed, 231 insertions(+), 40 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 397c197..e94ae81 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -129,5 +129,6 @@ extern void *xmalloc(size_t size);
 extern void *xrealloc(void *ptr, size_t size);
 extern void *xzalloc(size_t size);
 extern char *xstrdup(const char *s);
+extern void xstrunescape(const char *in, char *out);
 
 #endif /* NFTABLES_UTILS_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index ea43fc1..7b4ba62 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -203,6 +203,56 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 	return expr_evaluate(ctx, expr);
 }
 
+static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE), datalen;
+	struct expr *value, *prefix;
+	char data[len + 1];
+
+	if (ctx->ectx.len > 0) {
+		if (expr->len > ctx->ectx.len)
+			return expr_error(ctx->msgs, expr,
+					  "String exceeds maximum length of %u",
+					  ctx->ectx.len / BITS_PER_BYTE);
+		expr->len = ctx->ectx.len;
+	}
+
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+
+	datalen = strlen(data) - 1;
+	if (data[datalen] != '*')
+		return 0;
+
+	if (datalen - 1 >= 0 &&
+	    data[datalen - 1] == '\\') {
+		char unescaped_str[len];
+
+		memset(unescaped_str, 0, sizeof(unescaped_str));
+		xstrunescape(data, unescaped_str);
+
+		value = constant_expr_alloc(&expr->location, &string_type,
+					    BYTEORDER_HOST_ENDIAN,
+					    expr->len, unescaped_str);
+		expr_free(expr);
+		*exprp = value;
+		return 0;
+	}
+	value = constant_expr_alloc(&expr->location, &string_type,
+				    BYTEORDER_HOST_ENDIAN,
+				    datalen * BITS_PER_BYTE, data);
+
+	prefix = prefix_expr_alloc(&expr->location, value,
+				   datalen * BITS_PER_BYTE);
+	prefix->dtype = &string_type;
+	prefix->flags |= EXPR_F_CONSTANT;
+	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
+
+	expr_free(expr);
+	*exprp = prefix;
+	return 0;
+}
+
 static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 {
 	mpz_t mask;
@@ -226,13 +276,8 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 		mpz_clear(mask);
 		break;
 	case TYPE_STRING:
-		if (ctx->ectx.len > 0) {
-			if ((*expr)->len > ctx->ectx.len)
-				return expr_error(ctx->msgs, *expr,
-						  "String exceeds maximum length of %u",
-						  ctx->ectx.len / BITS_PER_BYTE);
-			(*expr)->len = ctx->ectx.len;
-		}
+		if (expr_evaluate_string(ctx, expr) < 0)
+			return -1;
 		break;
 	default:
 		BUG("invalid basetype %s\n", expr_basetype(*expr)->name);
@@ -370,8 +415,9 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 }
 
 /*
- * Prefix expression: the argument must be a constant value of integer base
- * type; the prefix length must be less than or equal to the type width.
+ * Prefix expression: the argument must be a constant value of integer or
+ * string base type; the prefix length must be less than or equal to the type
+ * width.
  */
 static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 {
@@ -386,10 +432,15 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 				  "Prefix expression is undefined for "
 				  "non-constant expressions");
 
-	if (expr_basetype(base)->type != TYPE_INTEGER)
+	switch (expr_basetype(base)->type) {
+	case TYPE_INTEGER:
+	case TYPE_STRING:
+		break;
+	default:
 		return expr_error(ctx->msgs, prefix,
 				  "Prefix expression is undefined for "
 				  "%s types", base->dtype->desc);
+	}
 
 	if (prefix->prefix_len > base->len)
 		return expr_error(ctx->msgs, prefix,
@@ -398,11 +449,18 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 				  prefix->prefix_len, base->len);
 
 	/* Clear the uncovered bits of the base value */
-	mask = constant_expr_alloc(&prefix->location, &integer_type,
+	mask = constant_expr_alloc(&prefix->location, expr_basetype(base),
 				   BYTEORDER_HOST_ENDIAN, base->len, NULL);
-	mpz_prefixmask(mask->value, base->len, prefix->prefix_len);
+	switch (expr_basetype(base)->type) {
+	case TYPE_INTEGER:
+		mpz_prefixmask(mask->value, base->len, prefix->prefix_len);
+		break;
+	case TYPE_STRING:
+		mpz_init2(mask->value, base->len);
+		mpz_bitmask(mask->value, prefix->prefix_len);
+		break;
+	}
 	and  = binop_expr_alloc(&prefix->location, OP_AND, base, mask);
-
 	prefix->prefix = and;
 	if (expr_evaluate(ctx, &prefix->prefix) < 0)
 		return -1;
@@ -615,11 +673,16 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = op->right;
 
-	if (expr_basetype(left)->type != TYPE_INTEGER)
+	switch (expr_basetype(left)->type) {
+	case TYPE_INTEGER:
+	case TYPE_STRING:
+		break;
+	default:
 		return expr_binary_error(ctx->msgs, left, op,
 					 "Binary operation (%s) is undefined "
 					 "for %s types",
 					 sym, left->dtype->desc);
+	}
 
 	if (expr_is_constant(left) && !expr_is_singleton(left))
 		return expr_binary_error(ctx->msgs, left, op,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 09f5932..3584de7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -232,11 +232,11 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_CMP_DATA, &nld.len);
 	right = netlink_alloc_value(loc, &nld);
 
-	if (left->len != right->len) {
-		if (left->len > right->len)
-			return netlink_error(ctx, loc,
-					     "Relational expression size "
-					     "mismatch");
+	if (left->len > right->len &&
+	    left->dtype != &string_type) {
+		return netlink_error(ctx, loc,
+				     "Relational expression size mismatch");
+	} else if (left->len < right->len) {
 		left = netlink_parse_concat_expr(ctx, loc, sreg, right->len);
 		if (left == NULL)
 			return;
@@ -1088,7 +1088,7 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 }
 
 /* Convert a bitmask to a prefix length */
-static unsigned int expr_mask_to_prefix(struct expr *expr)
+static unsigned int expr_mask_to_prefix(const struct expr *expr)
 {
 	unsigned long n;
 
@@ -1214,6 +1214,91 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 	}
 }
 
+static struct expr *string_wildcard_expr_alloc(struct location *loc,
+					       const struct expr *mask,
+					       const struct expr *expr)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	char data[len + 2];
+	int pos;
+
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	pos = div_round_up(expr_mask_to_prefix(mask), BITS_PER_BYTE);
+	data[pos] = '*';
+	data[pos + 1] = '\0';
+
+	return constant_expr_alloc(loc, &string_type, BYTEORDER_HOST_ENDIAN,
+				   expr->len + BITS_PER_BYTE, data);
+}
+
+static void escaped_string_wildcard_expr_alloc(struct expr **exprp,
+					       unsigned int len)
+{
+	struct expr *expr = *exprp, *tmp;
+	char data[len + 3];
+	int pos;
+
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	pos = div_round_up(len, BITS_PER_BYTE);
+	data[pos - 1] = '\\';
+	data[pos] = '*';
+
+	tmp = constant_expr_alloc(&expr->location, &string_type,
+				  BYTEORDER_HOST_ENDIAN,
+				  expr->len + BITS_PER_BYTE, data);
+	expr_free(expr);
+	*exprp = tmp;
+}
+
+/* This calculates the string length and checks if it is nul-terminated, this
+ * function is quite a hack :)
+ */
+static bool __expr_postprocess_string(struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+	unsigned int len = expr->len;
+	bool nulterminated = false;
+	mpz_t tmp;
+
+	mpz_init(tmp);
+	while (len >= BITS_PER_BYTE) {
+		mpz_bitmask(tmp, BITS_PER_BYTE);
+		mpz_lshift_ui(tmp, len - BITS_PER_BYTE);
+		mpz_and(tmp, tmp, expr->value);
+		if (mpz_cmp_ui(tmp, 0))
+			break;
+		else
+			nulterminated = true;
+		len -= BITS_PER_BYTE;
+	}
+
+	mpz_rshift_ui(tmp, len - BITS_PER_BYTE);
+
+	if (nulterminated &&
+	    mpz_cmp_ui(tmp, '*') == 0)
+		escaped_string_wildcard_expr_alloc(exprp, len);
+
+	mpz_clear(tmp);
+	expr->len = len;
+
+	return nulterminated;
+}
+
+static struct expr *expr_postprocess_string(struct expr *expr)
+{
+	struct expr *mask;
+
+	assert(expr->dtype->type == TYPE_STRING);
+	if (__expr_postprocess_string(&expr))
+		return expr;
+
+	mask = constant_expr_alloc(&expr->location, &integer_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   expr->len + BITS_PER_BYTE, NULL);
+	mpz_init_bitmask(mask->value, expr->len);
+	return string_wildcard_expr_alloc(&expr->location, mask, expr);
+}
+
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *i;
@@ -1299,22 +1384,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
-		// Quite a hack :)
-		if (expr->dtype->type == TYPE_STRING) {
-			unsigned int len = expr->len;
-			mpz_t tmp;
-			mpz_init(tmp);
-			while (len >= BITS_PER_BYTE) {
-				mpz_bitmask(tmp, BITS_PER_BYTE);
-				mpz_lshift_ui(tmp, len - BITS_PER_BYTE);
-				mpz_and(tmp, tmp, expr->value);
-				if (mpz_cmp_ui(tmp, 0))
-					break;
-				len -= BITS_PER_BYTE;
-			}
-			mpz_clear(tmp);
-			expr->len = len;
-		}
+		if (expr->dtype->type == TYPE_STRING)
+			*exprp = expr_postprocess_string(expr);
 
 		if (expr->dtype->basetype != NULL &&
 		    expr->dtype->basetype->type == TYPE_BITMASK)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index a4cd370..c9af036 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -325,6 +325,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 	enum nft_registers sreg;
 	struct expr *right;
+	int len;
 
 	assert(dreg == NFT_REG_VERDICT);
 
@@ -332,14 +333,24 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_range(ctx, expr, dreg);
 
 	sreg = get_register(ctx, expr->left);
-	netlink_gen_expr(ctx, expr->left, sreg);
 
 	switch (expr->right->ops->type) {
 	case EXPR_PREFIX:
-		right = netlink_gen_prefix(ctx, expr, sreg);
+		if (expr->left->dtype->type != TYPE_STRING) {
+			len = div_round_up(expr->right->len, BITS_PER_BYTE);
+			netlink_gen_expr(ctx, expr->left, sreg);
+			right = netlink_gen_prefix(ctx, expr, sreg);
+		} else {
+			len = div_round_up(expr->right->prefix_len, BITS_PER_BYTE);
+			right = expr->right->prefix;
+			expr->left->len = expr->right->prefix_len;
+			netlink_gen_expr(ctx, expr->left, sreg);
+		}
 		break;
 	default:
+		len = div_round_up(expr->right->len, BITS_PER_BYTE);
 		right = expr->right;
+		netlink_gen_expr(ctx, expr->left, sreg);
 		break;
 	}
 
@@ -349,7 +360,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 			      netlink_gen_cmp_op(expr->op));
 	payload_shift_value(expr->left, right);
 	netlink_gen_data(right, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
+	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
 	release_register(ctx, expr->left);
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 98480b6..49fe180 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -216,7 +216,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
-%destructor { xfree($$); }	STRING QUOTED_STRING
+%token <string> ASTERISK_STRING
+%destructor { xfree($$); }	STRING QUOTED_STRING ASTERISK_STRING
 
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
@@ -1159,6 +1160,7 @@ identifier		:	STRING
 
 string			:	STRING
 			|	QUOTED_STRING
+			|	ASTERISK_STRING
 			;
 
 time_spec		:	STRING
diff --git a/src/scanner.l b/src/scanner.l
index b827489..be84500 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -114,6 +114,7 @@ range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
+asteriskstring	({string}\*|{string}\\\*)
 comment		#.*$
 slash		\/
 
@@ -498,6 +499,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return QUOTED_STRING;
 			}
 
+{asteriskstring}	{
+				yylval->string = xstrdup(yytext);
+				return ASTERISK_STRING;
+			}
+
 {string}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/src/utils.c b/src/utils.c
index 88708e7..65dabf4 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -66,3 +66,16 @@ char *xstrdup(const char *s)
 		memory_allocation_error();
 	return res;
 }
+
+void xstrunescape(const char *in, char *out)
+{
+	unsigned int i, k = 0;
+
+	for (i = 0; i < strlen(in); i++) {
+		if (in[i] == '\\')
+			continue;
+
+		out[k++] = in[i];
+	}
+	out[k++] = '\0';
+}
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index ddb360d..6d9f9d2 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -66,6 +66,8 @@ meta iifname "eth0";ok;iifname "eth0"
 meta iifname != "eth0";ok;iifname != "eth0"
 meta iifname {"eth0", "lo"};ok
 - meta iifname != {"eth0", "lo"};ok
+meta iifname "eth*";ok;iifname "eth*"
+meta iifname "eth\*";ok;iifname "eth\*"
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
@@ -83,6 +85,8 @@ meta oifname "eth0";ok;oifname "eth0"
 meta oifname != "eth0";ok;oifname != "eth0"
 meta oifname { "eth0", "lo"};ok
 - meta iifname != {"eth0", "lo"};ok
+meta oifname "eth*";ok;oifname "eth*"
+meta oifname "eth\*";ok;oifname "eth\*"
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
diff --git a/tests/regression/any/meta.t.payload b/tests/regression/any/meta.t.payload
index 0243d80..9f7a6d9 100644
--- a/tests/regression/any/meta.t.payload
+++ b/tests/regression/any/meta.t.payload
@@ -217,6 +217,16 @@ ip test-ip4 input
   [ meta load iifname => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# meta iifname "eth*"
+ip test-ip4 input
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x00687465 ]
+
+# meta iifname "eth\*"
+ip test-ip4 input
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
+
 # meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 set%d test-ip4 3
 set%d test-ip4 0
@@ -284,6 +294,16 @@ ip test-ip4 input
   [ meta load oifname => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# meta oifname "eth*"
+ip test-ip4 input
+  [ meta load oifname => reg 1 ]
+  [ cmp eq reg 1 0x00687465 ]
+
+# meta oifname "eth\*"
+ip test-ip4 input
+  [ meta load oifname => reg 1 ]
+  [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
+
 # meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 set%d test-ip4 3
 set%d test-ip4 0
-- 
2.1.4

