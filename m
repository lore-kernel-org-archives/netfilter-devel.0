From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft V2] hash: generate a random seed if seed option is empty
Date: Sat, 15 Apr 2017 17:22:17 +0800
Message-ID: <1492248137-13776-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, laura.garcia@zevenet.com,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:56372 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752705AbdDOJYY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:24:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Typing the "nft add rule x y ct mark set jhash ip saddr mod 2" will
not generate a random seed, instead, the seed will always be zero.

So if seed option is empty, we shoulde not set the NFTA_HASH_SEED
attribute, then a random seed will be generated in the kernel.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: using seed_set instead of 0 to stand for "unset", suggested by Pablo

 include/expression.h       |  1 +
 include/hash.h             |  6 ++++--
 src/hash.c                 | 11 ++++++++---
 src/netlink_delinearize.c  |  4 +++-
 src/netlink_linearize.c    |  3 ++-
 src/parser_bison.y         | 17 +++++++++--------
 tests/py/ip/hash.t         |  1 +
 tests/py/ip/hash.t.payload |  7 +++++++
 8 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 94573de..9ba87e8 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -310,6 +310,7 @@ struct expr {
 			/* EXPR_HASH */
 			struct expr		*expr;
 			uint32_t		mod;
+			bool			seed_set;
 			uint32_t		seed;
 			uint32_t		offset;
 			enum nft_hash_types	type;
diff --git a/include/hash.h b/include/hash.h
index 7f9c6f1..693d08a 100644
--- a/include/hash.h
+++ b/include/hash.h
@@ -2,7 +2,9 @@
 #define NFTABLES_HASH_H
 
 extern struct expr *hash_expr_alloc(const struct location *loc,
-				    uint32_t modulus, uint32_t seed,
-				    uint32_t offset, enum nft_hash_types type);
+				    uint32_t modulus,
+				    bool seed_set, uint32_t seed,
+				    uint32_t offset,
+				    enum nft_hash_types type);
 
 #endif /* NFTABLES_HASH_H */
diff --git a/src/hash.c b/src/hash.c
index bec1684..c738d0b 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -28,7 +28,7 @@ static void hash_expr_print(const struct expr *expr)
 	}
 
 	printf(" mod %u", expr->hash.mod);
-	if ((expr->hash.type == NFT_HASH_JENKINS) && expr->hash.seed)
+	if (expr->hash.seed_set)
 		printf(" seed 0x%x", expr->hash.seed);
 	if (expr->hash.offset)
 		printf(" offset %u", expr->hash.offset);
@@ -39,6 +39,7 @@ static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
 	return (e1->hash.expr ||
 		expr_cmp(e1->hash.expr, e2->hash.expr)) &&
 	       e1->hash.mod == e2->hash.mod &&
+	       e1->hash.seed_set == e2->hash.seed_set &&
 	       e1->hash.seed == e2->hash.seed &&
 	       e1->hash.offset == e2->hash.offset &&
 	       e1->hash.type == e2->hash.type;
@@ -49,6 +50,7 @@ static void hash_expr_clone(struct expr *new, const struct expr *expr)
 	if (expr->hash.expr)
 		new->hash.expr = expr_clone(expr->hash.expr);
 	new->hash.mod = expr->hash.mod;
+	new->hash.seed_set = expr->hash.seed_set;
 	new->hash.seed = expr->hash.seed;
 	new->hash.offset = expr->hash.offset;
 	new->hash.type = expr->hash.type;
@@ -62,8 +64,10 @@ static const struct expr_ops hash_expr_ops = {
 	.clone		= hash_expr_clone,
 };
 
-struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
-			     uint32_t seed, uint32_t offset,
+struct expr *hash_expr_alloc(const struct location *loc,
+			     uint32_t mod,
+			     bool seed_set, uint32_t seed,
+			     uint32_t offset,
 			     enum nft_hash_types type)
 {
 	struct expr *expr;
@@ -71,6 +75,7 @@ struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
 	expr = expr_alloc(loc, &hash_expr_ops, &integer_type,
 			  BYTEORDER_HOST_ENDIAN, 4 * BITS_PER_BYTE);
 	expr->hash.mod  = mod;
+	expr->hash.seed_set = seed_set;
 	expr->hash.seed = seed;
 	expr->hash.offset = offset;
 	expr->hash.type = type;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9ad1e2c..4a0b8dc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -525,13 +525,15 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 	struct expr *expr, *hexpr;
 	uint32_t mod, seed, len, offset;
 	enum nft_hash_types type;
+	bool seed_set;
 
 	type = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_TYPE);
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_OFFSET);
+	seed_set = nftnl_expr_is_set(nle, NFTNL_EXPR_HASH_SEED);
 	seed = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_SEED);
 	mod  = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_MODULUS);
 
-	expr = hash_expr_alloc(loc, mod, seed, offset, type);
+	expr = hash_expr_alloc(loc, mod, seed_set, seed, offset, type);
 
 	if (type != NFT_HASH_SYM) {
 		sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b2f27b7..3d68456 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -139,7 +139,8 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 	}
 	netlink_put_register(nle, NFTNL_EXPR_HASH_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
+	if (expr->hash.seed_set)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_OFFSET, expr->hash.offset);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_TYPE, expr->hash.type);
 	nftnl_rule_add_expr(ctx->nlr, nle);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9f993fd..8db887a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -520,7 +520,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
-%type <val>			nf_nat_flags nf_nat_flag offset_opt seed_opt
+%type <val>			nf_nat_flags nf_nat_flag offset_opt
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
@@ -3092,18 +3092,19 @@ numgen_expr		:	NUMGEN	numgen_type	MOD	NUM	offset_opt
 			}
 			;
 
-seed_opt		:	/* empty */	{ $$ = 0; }
-			|	SEED	NUM	{ $$ = $2; }
-			;
-
-hash_expr		:	JHASH		expr	MOD	NUM	seed_opt	offset_opt
+hash_expr		:	JHASH		expr	MOD	NUM	SEED	NUM	offset_opt
+			{
+				$$ = hash_expr_alloc(&@$, $4, true, $6, $7, NFT_HASH_JENKINS);
+				$$->hash.expr = $2;
+			}
+			|	JHASH		expr	MOD	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, $5, $6, NFT_HASH_JENKINS);
+				$$ = hash_expr_alloc(&@$, $4, false, 0, $5, NFT_HASH_JENKINS);
 				$$->hash.expr = $2;
 			}
 			|	SYMHASH		MOD	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $3, 0, $4, NFT_HASH_SYM);
+				$$ = hash_expr_alloc(&@$, $3, false, 0, $4, NFT_HASH_SYM);
 			}
 			;
 
diff --git a/tests/py/ip/hash.t b/tests/py/ip/hash.t
index 2becef6..cbfc7ee 100644
--- a/tests/py/ip/hash.t
+++ b/tests/py/ip/hash.t
@@ -3,6 +3,7 @@
 
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef;ok
 ct mark set jhash ip saddr . ip daddr mod 2;ok
+ct mark set jhash ip saddr . ip daddr mod 2 seed 0x0;ok
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100;ok
 ct mark set jhash ip saddr . ip daddr mod 2 offset 100;ok
 dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index 21227e9..71ab065 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -12,6 +12,13 @@ ip test-ip4 pre
   [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 2 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set jhash ip saddr . ip daddr mod 2 seed 0x0
+ip test-ip4 pre
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 2 ]
+  [ ct set mark with reg 1 ]
+
 # ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100
 ip test-ip4 pre
   [ payload load 4b @ network header + 12 => reg 2 ]
-- 
2.5.5


