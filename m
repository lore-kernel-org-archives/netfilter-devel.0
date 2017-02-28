From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nft v2] src: hash: support of symmetric hash
Date: Tue, 28 Feb 2017 18:42:50 +0100
Message-ID: <20170228174250.wx4sjfa6dr5kcno6@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35623 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdB1Sy3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 13:54:29 -0500
Received: by mail-wr0-f196.google.com with SMTP id q39so2692628wrb.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 10:53:09 -0800 (PST)
Received: from nevthink ([91.126.74.89])
        by smtp.gmail.com with ESMTPSA id l140sm19489044wmg.12.2017.02.28.09.42.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Feb 2017 09:42:52 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch provides symmetric hash support according to source
ip address and port, and destination ip address and port.

The new attribute NFTA_HASH_TYPE has been included to support
different types of hashing functions. Currently supported
NFT_HASH_JENKINS through jhash and NFT_HASH_SYM through symhash.

The main difference between both types are:
 - jhash requires an expression with sreg, symhash doesn't.
 - symhash supports modulus and offset, but not seed.

Examples:

 nft add rule ip nat prerouting ct mark set jhash ip saddr mod 2
 nft add rule ip nat prerouting ct mark set symhash mod 2

Signed-off-by: Laura Garcia Liebana <laura.garcia@zevenet.com>
---
v2:
	- Discard new line remove

 include/expression.h                |  1 +
 include/hash.h                      |  2 +-
 include/linux/netfilter/nf_tables.h | 13 +++++++++++++
 src/evaluate.c                      |  3 ++-
 src/hash.c                          | 28 +++++++++++++++++++++-------
 src/netlink_delinearize.c           | 35 +++++++++++++++++++++--------------
 src/netlink_linearize.c             | 19 ++++++++++++-------
 src/parser_bison.y                  | 16 ++++++++++------
 src/scanner.l                       |  1 +
 tests/py/ip/hash.t                  |  1 +
 tests/py/ip/hash.t.payload          |  4 ++++
 11 files changed, 87 insertions(+), 36 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index ec90265..56cb310 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -308,6 +308,7 @@ struct expr {
 			uint32_t		mod;
 			uint32_t		seed;
 			uint32_t		offset;
+			enum nft_hash_types	type;
 		} hash;
 		struct {
 			/* EXPR_FIB */
diff --git a/include/hash.h b/include/hash.h
index 8bf53e2..7f9c6f1 100644
--- a/include/hash.h
+++ b/include/hash.h
@@ -3,6 +3,6 @@
 
 extern struct expr *hash_expr_alloc(const struct location *loc,
 				    uint32_t modulus, uint32_t seed,
-				    uint32_t offset);
+				    uint32_t offset, enum nft_hash_types type);
 
 #endif /* NFTABLES_HASH_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d..74a42fa 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -793,6 +793,17 @@ enum nft_rt_keys {
 };
 
 /**
+ * enum nft_hash_types - nf_tables hash expression types
+ *
+ * @NFT_HASH_JENKINS: Jenkins Hash
+ * @NFT_HASH_SYM: Symmetric Hash
+ */
+enum nft_hash_types {
+	NFT_HASH_JENKINS,
+	NFT_HASH_SYM,
+};
+
+/**
  * enum nft_hash_attributes - nf_tables hash expression netlink attributes
  *
  * @NFTA_HASH_SREG: source register (NLA_U32)
@@ -801,6 +812,7 @@ enum nft_rt_keys {
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
  * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)
+ * @NFTA_HASH_TYPE: hash operation (NLA_U32: nft_hash_types)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -810,6 +822,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
 	NFTA_HASH_OFFSET,
+	NFTA_HASH_TYPE,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 94412f2..18884be 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1249,7 +1249,8 @@ static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
 	expr_dtype_integer_compatible(ctx, expr);
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &expr->hash.expr) < 0)
+	if (expr->hash.expr &&
+	    expr_evaluate(ctx, &expr->hash.expr) < 0)
 		return -1;
 
 	/* expr_evaluate_primary() sets the context to what to the input
diff --git a/src/hash.c b/src/hash.c
index d26b2ed..a7a9612 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -17,10 +17,18 @@
 
 static void hash_expr_print(const struct expr *expr)
 {
-	printf("jhash ");
-	expr_print(expr->hash.expr);
+	switch (expr->hash.type) {
+	case NFT_HASH_SYM:
+		printf("symhash");
+	break;
+	case NFT_HASH_JENKINS:
+	default:
+		printf("jhash ");
+		expr_print(expr->hash.expr);
+	}
+
 	printf(" mod %u", expr->hash.mod);
-	if (expr->hash.seed)
+	if (expr->hash.type & NFT_HASH_JENKINS && expr->hash.seed)
 		printf(" seed 0x%x", expr->hash.seed);
 	if (expr->hash.offset)
 		printf(" offset %u", expr->hash.offset);
@@ -28,18 +36,22 @@ static void hash_expr_print(const struct expr *expr)
 
 static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
-	return expr_cmp(e1->hash.expr, e2->hash.expr) &&
+	return (e1->hash.expr ||
+		expr_cmp(e1->hash.expr, e2->hash.expr)) &&
 	       e1->hash.mod == e2->hash.mod &&
 	       e1->hash.seed == e2->hash.seed &&
-	       e1->hash.offset == e2->hash.offset;
+	       e1->hash.offset == e2->hash.offset &&
+	       e1->hash.type == e2->hash.type;
 }
 
 static void hash_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->hash.expr = expr_clone(expr->hash.expr);
+	if (expr->hash.expr)
+		new->hash.expr = expr_clone(expr->hash.expr);
 	new->hash.mod = expr->hash.mod;
 	new->hash.seed = expr->hash.seed;
 	new->hash.offset = expr->hash.offset;
+	new->hash.type = expr->hash.type;
 }
 
 static const struct expr_ops hash_expr_ops = {
@@ -51,7 +63,8 @@ static const struct expr_ops hash_expr_ops = {
 };
 
 struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
-			     uint32_t seed, uint32_t offset)
+			     uint32_t seed, uint32_t offset,
+			     enum nft_hash_types type)
 {
 	struct expr *expr;
 
@@ -60,6 +73,7 @@ struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
 	expr->hash.mod  = mod;
 	expr->hash.seed = seed;
 	expr->hash.offset = offset;
+	expr->hash.type = type;
 
 	return expr;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4896844..27301d5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -521,27 +521,33 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 	enum nft_registers sreg, dreg;
 	struct expr *expr, *hexpr;
 	uint32_t mod, seed, len, offset;
+	enum nft_hash_types type;
 
-	sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
-	hexpr = netlink_get_register(ctx, loc, sreg);
-	if (hexpr == NULL)
-		return netlink_error(ctx, loc,
-				     "hash statement has no expression");
-
+	type = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_TYPE);
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_OFFSET);
 	seed = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_SEED);
 	mod  = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_MODULUS);
-	len = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_LEN) * BITS_PER_BYTE;
 
-	if (hexpr->len < len) {
-		hexpr = netlink_parse_concat_expr(ctx, loc, sreg, len);
+	expr = hash_expr_alloc(loc, mod, seed, offset, type);
+
+	if (type != NFT_HASH_SYM) {
+		sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
+		hexpr = netlink_get_register(ctx, loc, sreg);
+
 		if (hexpr == NULL)
-			return;
+			return
+			netlink_error(ctx, loc,
+				      "hash statement has no expression");
+		len = nftnl_expr_get_u32(nle,
+					 NFTNL_EXPR_HASH_LEN) * BITS_PER_BYTE;
+		if (hexpr->len < len) {
+			hexpr = netlink_parse_concat_expr(ctx, loc, sreg, len);
+			if (hexpr == NULL)
+				return;
+		}
+		expr->hash.expr = hexpr;
 	}
 
-	expr = hash_expr_alloc(loc, mod, seed, offset);
-	expr->hash.expr = hexpr;
-
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
@@ -1848,7 +1854,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_FIB:
 		break;
 	case EXPR_HASH:
-		expr_postprocess(ctx, &expr->hash.expr);
+		if (expr->hash.expr)
+			expr_postprocess(ctx, &expr->hash.expr);
 		break;
 	case EXPR_CT:
 		ct_expr_update_type(&ctx->pctx, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5030135..2fa2c04 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -125,18 +125,23 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 	enum nft_registers sreg;
 	struct nftnl_expr *nle;
 
-	sreg = get_register(ctx, expr->hash.expr);
-	netlink_gen_expr(ctx, expr->hash.expr, sreg);
-	release_register(ctx, expr->hash.expr);
-
 	nle = alloc_nft_expr("hash");
-	netlink_put_register(nle, NFTNL_EXPR_HASH_SREG, sreg);
+
+	if (expr->hash.expr) {
+		sreg = get_register(ctx, expr->hash.expr);
+		netlink_gen_expr(ctx, expr->hash.expr, sreg);
+		release_register(ctx, expr->hash.expr);
+		netlink_put_register(nle, NFTNL_EXPR_HASH_SREG, sreg);
+
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_LEN,
+				   div_round_up(expr->hash.expr->len,
+						BITS_PER_BYTE));
+	}
 	netlink_put_register(nle, NFTNL_EXPR_HASH_DREG, dreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_LEN,
-			   div_round_up(expr->hash.expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_OFFSET, expr->hash.offset);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_TYPE, expr->hash.type);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d543e3e..226ce9a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -418,6 +418,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token OFFSET			"offset"
 
 %token JHASH			"jhash"
+%token SYMHASH			"symhash"
 %token SEED			"seed"
 
 %token POSITION			"position"
@@ -493,7 +494,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
-%type <val>			nf_nat_flags nf_nat_flag offset_opt
+%type <val>			nf_nat_flags nf_nat_flag offset_opt seed_opt
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
@@ -2892,15 +2893,18 @@ numgen_expr		:	NUMGEN	numgen_type	MOD	NUM	offset_opt
 			}
 			;
 
-hash_expr		:	JHASH	expr	MOD	NUM	SEED	NUM	offset_opt
+seed_opt		:	/* empty */	{ $$ = 0; }
+			|	SEED	NUM	{ $$ = $2; }
+			;
+
+hash_expr		:	JHASH		expr	MOD	NUM	seed_opt	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, $6, $7);
+				$$ = hash_expr_alloc(&@$, $4, $5, $6, NFT_HASH_JENKINS);
 				$$->hash.expr = $2;
 			}
-			|	JHASH	expr	MOD	NUM	offset_opt
+			|	SYMHASH		MOD	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, 0, $5);
-				$$->hash.expr = $2;
+				$$ = hash_expr_alloc(&@$, $3, 0, $4, NFT_HASH_SYM);
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index d0d25ea..bbd99f3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -467,6 +467,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "offset"		{ return OFFSET; }
 
 "jhash"			{ return JHASH; }
+"symhash"		{ return SYMHASH; }
 "seed"			{ return SEED; }
 
 "dup"			{ return DUP; }
diff --git a/tests/py/ip/hash.t b/tests/py/ip/hash.t
index 0d01a11..2becef6 100644
--- a/tests/py/ip/hash.t
+++ b/tests/py/ip/hash.t
@@ -6,3 +6,4 @@ ct mark set jhash ip saddr . ip daddr mod 2;ok
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100;ok
 ct mark set jhash ip saddr . ip daddr mod 2 offset 100;ok
 dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
+ct mark set symhash mod 2 offset 100;ok
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index c410a8c..5735559 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -36,3 +36,7 @@ ip test-ip4 pre
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
+# ct mark set symhash mod 2 offset 100
+ip test-ip4 pre
+  [ hash reg 1 = symhash() % mod 2 offset 100 ]
+  [ ct set mark with reg 1 ]
-- 
2.11.0

