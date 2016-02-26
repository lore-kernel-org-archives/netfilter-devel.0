From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] datatype, meta: add new ifname_type for iifname/oifname
Date: Fri, 26 Feb 2016 20:19:34 +0100
Message-ID: <1456514374-28827-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42702 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422790AbcBZT0E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Feb 2016 14:26:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

String is an unqualified type and we do not have a data element to
derive the element size from at set creation time.

Add a new string subtype -- iface_name -- and switch
meta iifname/oifname to use it instead of string.

One can then define a named set for interface names with

nft add set filter ifnames '{type iface_name; }'

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml               |  6 +++---
 include/datatype.h        |  2 ++
 src/evaluate.c            |  9 +++++----
 src/meta.c                | 31 +++++++++++++++++++++++++++----
 src/netlink_delinearize.c |  6 +++---
 src/netlink_linearize.c   |  2 +-
 6 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 7cc9988..b94e696 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1044,7 +1044,7 @@ filter output ip6 daddr ::1
 							<row>
 								<entry>iifname</entry>
 								<entry>Input interface name</entry>
-								<entry>string</entry>
+								<entry>iface_name</entry>
 							</row>
 							<row>
 								<entry>iiftype</entry>
@@ -1059,7 +1059,7 @@ filter output ip6 daddr ::1
 							<row>
 								<entry>oifname</entry>
 								<entry>Output interface name</entry>
-								<entry>string</entry>
+								<entry>iface_name</entry>
 							</row>
 							<row>
 								<entry>oiftype</entry>
@@ -1141,7 +1141,7 @@ filter output ip6 daddr ::1
 								</entry>
 							</row>
 							<row>
-								<entry>ifname</entry>
+								<entry>iface_type</entry>
 								<entry>
 									Interface name (16 byte string). Does not have to exist.
 								</entry>
diff --git a/include/datatype.h b/include/datatype.h
index 91ca2dd..91aa550 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -40,6 +40,7 @@
  * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
  * @TYPE_ICMPX_CODE:	icmpx code (integer subtype)
  * @TYPE_DEVGROUP:	devgroup code (integer subtype)
+ * @TYPE_IFNAME:	interface name (string subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -78,6 +79,7 @@ enum datatypes {
 	TYPE_ICMPV6_CODE,
 	TYPE_ICMPX_CODE,
 	TYPE_DEVGROUP,
+	TYPE_IFNAME,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index ed78896..1390900 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -209,6 +209,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE), datalen;
 	struct expr *value, *prefix;
 	int data_len = ctx->ectx.len > 0 ? ctx->ectx.len : len + 1;
+	const struct datatype *dtype = expr->dtype;
 	char data[data_len];
 
 	if (ctx->ectx.len > 0) {
@@ -227,7 +228,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		/* We need to reallocate the constant expression with the right
 		 * expression length to avoid problems on big endian.
 		 */
-		value = constant_expr_alloc(&expr->location, &string_type,
+		value = constant_expr_alloc(&expr->location, dtype,
 					    BYTEORDER_HOST_ENDIAN,
 					    expr->len, data);
 		expr_free(expr);
@@ -242,20 +243,20 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		memset(unescaped_str, 0, sizeof(unescaped_str));
 		xstrunescape(data, unescaped_str);
 
-		value = constant_expr_alloc(&expr->location, &string_type,
+		value = constant_expr_alloc(&expr->location, dtype,
 					    BYTEORDER_HOST_ENDIAN,
 					    expr->len, unescaped_str);
 		expr_free(expr);
 		*exprp = value;
 		return 0;
 	}
-	value = constant_expr_alloc(&expr->location, &string_type,
+	value = constant_expr_alloc(&expr->location, dtype,
 				    BYTEORDER_HOST_ENDIAN,
 				    datalen * BITS_PER_BYTE, data);
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
-	prefix->dtype = &string_type;
+	prefix->dtype = dtype;
 	prefix->flags |= EXPR_F_CONSTANT;
 	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
 
diff --git a/src/meta.c b/src/meta.c
index b8db0f8..914d3c2 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -173,6 +173,28 @@ const struct datatype ifindex_type = {
 	.parse		= ifindex_type_parse,
 };
 
+static struct error_record *ifname_type_parse(const struct expr *sym,
+					      struct expr **res);
+const struct datatype ifname_type = {
+	.type		= TYPE_IFNAME,
+	.name		= "iface_name",
+	.desc		= "network interface name",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= IFNAMSIZ * BITS_PER_BYTE,
+	.basetype	= &string_type,
+	.parse		= ifname_type_parse,
+};
+
+static struct error_record *ifname_type_parse(const struct expr *sym,
+					      struct expr **res)
+{
+	*res = constant_expr_alloc(&sym->location, &ifname_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
+				   sym->identifier);
+	return NULL;
+}
+
 static const struct symbol_table arphrd_tbl = {
 	.symbols	= {
 		SYMBOL("ether",		ARPHRD_ETHER),
@@ -375,14 +397,14 @@ static const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIF]		= META_TEMPLATE("iif",       &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &string_type,
+	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &string_type,
+	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
@@ -395,10 +417,10 @@ static const struct meta_template meta_templates[] = {
 						1    , BYTEORDER_HOST_ENDIAN),
 	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid", &realm_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("ibriport",  &string_type,
+	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("ibriport",  &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &string_type,
+	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",   &pkttype_type,
@@ -583,6 +605,7 @@ struct stmt *meta_stmt_alloc(const struct location *loc, enum nft_meta_keys key,
 static void __init meta_init(void)
 {
 	datatype_register(&ifindex_type);
+	datatype_register(&ifname_type);
 	datatype_register(&realm_type);
 	datatype_register(&tchandle_type);
 	datatype_register(&uid_type);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..a28174c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -233,7 +233,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	right = netlink_alloc_value(loc, &nld);
 
 	if (left->len > right->len &&
-	    left->dtype != &string_type) {
+	    expr_basetype(left) != &string_type) {
 		return netlink_error(ctx, loc,
 				     "Relational expression size mismatch");
 	} else if (left->len > 0 && left->len < right->len) {
@@ -1383,7 +1383,7 @@ static struct expr *expr_postprocess_string(struct expr *expr)
 {
 	struct expr *mask;
 
-	assert(expr->dtype->type == TYPE_STRING);
+	assert(expr_basetype(expr)->type == TYPE_STRING);
 	if (__expr_postprocess_string(&expr))
 		return expr;
 
@@ -1490,7 +1490,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
-		if (expr->dtype->type == TYPE_STRING)
+		if (expr_basetype(expr)->type == TYPE_STRING)
 			*exprp = expr_postprocess_string(expr);
 
 		if (expr->dtype->basetype != NULL &&
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 86b49c6..73d7944 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -349,7 +349,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 
 	switch (expr->right->ops->type) {
 	case EXPR_PREFIX:
-		if (expr->left->dtype->type != TYPE_STRING) {
+		if (expr_basetype(expr->left)->type != TYPE_STRING) {
 			len = div_round_up(expr->right->len, BITS_PER_BYTE);
 			netlink_gen_expr(ctx, expr->left, sreg);
 			right = netlink_gen_prefix(ctx, expr, sreg);
-- 
2.4.10

