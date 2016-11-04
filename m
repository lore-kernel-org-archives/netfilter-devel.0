From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3 nft 2/4] src: add offset attribute for hash expression
Date: Fri, 4 Nov 2016 14:01:12 +0100
Message-ID: <20161104130109.GA20452@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35053 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934248AbcKDNBR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 09:01:17 -0400
Received: by mail-wm0-f66.google.com with SMTP id 68so3830055wmz.2
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Nov 2016 06:01:16 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id q134sm4538924wme.3.2016.11.04.06.01.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 04 Nov 2016 06:01:15 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to add an offset to the hash generator, eg.

 ct mark set hash ip saddr mod 10 offset 100

This will generate marks with series between 100-109.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v3:
	- This patch depends on 1/4.

 include/expression.h                |  1 +
 include/hash.h                      |  3 ++-
 include/linux/netfilter/nf_tables.h |  2 ++
 src/hash.c                          |  9 +++++++--
 src/netlink_delinearize.c           |  5 +++--
 src/netlink_linearize.c             |  1 +
 src/parser_bison.y                  |  8 ++++----
 tests/py/ip/hash.t                  |  2 ++
 tests/py/ip/hash.t.payload          | 14 ++++++++++++++
 9 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 3a52a45..71e9c43 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -307,6 +307,7 @@ struct expr {
 			struct expr		*expr;
 			uint32_t		mod;
 			uint32_t		seed;
+			uint32_t		offset;
 		} hash;
 		struct {
 			/* EXPR_FIB */
diff --git a/include/hash.h b/include/hash.h
index bc8c86a..8bf53e2 100644
--- a/include/hash.h
+++ b/include/hash.h
@@ -2,6 +2,7 @@
 #define NFTABLES_HASH_H
 
 extern struct expr *hash_expr_alloc(const struct location *loc,
-				    uint32_t modulus, uint32_t seed);
+				    uint32_t modulus, uint32_t seed,
+				    uint32_t offset);
 
 #endif /* NFTABLES_HASH_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c6567ac..0fb63fe 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -773,6 +773,7 @@ enum nft_rt_keys {
  * @NFTA_HASH_LEN: source data length (NLA_U32)
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
+ * @NFTA_HASH_OFFSET: offset value (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -781,6 +782,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_LEN,
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
+	NFTA_HASH_OFFSET,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/src/hash.c b/src/hash.c
index 125b320..d26b2ed 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -22,13 +22,16 @@ static void hash_expr_print(const struct expr *expr)
 	printf(" mod %u", expr->hash.mod);
 	if (expr->hash.seed)
 		printf(" seed 0x%x", expr->hash.seed);
+	if (expr->hash.offset)
+		printf(" offset %u", expr->hash.offset);
 }
 
 static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return expr_cmp(e1->hash.expr, e2->hash.expr) &&
 	       e1->hash.mod == e2->hash.mod &&
-	       e1->hash.seed == e2->hash.seed;
+	       e1->hash.seed == e2->hash.seed &&
+	       e1->hash.offset == e2->hash.offset;
 }
 
 static void hash_expr_clone(struct expr *new, const struct expr *expr)
@@ -36,6 +39,7 @@ static void hash_expr_clone(struct expr *new, const struct expr *expr)
 	new->hash.expr = expr_clone(expr->hash.expr);
 	new->hash.mod = expr->hash.mod;
 	new->hash.seed = expr->hash.seed;
+	new->hash.offset = expr->hash.offset;
 }
 
 static const struct expr_ops hash_expr_ops = {
@@ -47,7 +51,7 @@ static const struct expr_ops hash_expr_ops = {
 };
 
 struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
-			     uint32_t seed)
+			     uint32_t seed, uint32_t offset)
 {
 	struct expr *expr;
 
@@ -55,6 +59,7 @@ struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
 			  BYTEORDER_HOST_ENDIAN, 4 * BITS_PER_BYTE);
 	expr->hash.mod  = mod;
 	expr->hash.seed = seed;
+	expr->hash.offset = offset;
 
 	return expr;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f0df884..434089b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -513,7 +513,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 {
 	enum nft_registers sreg, dreg;
 	struct expr *expr, *hexpr;
-	uint32_t mod, seed, len;
+	uint32_t mod, seed, len, offset;
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
 	hexpr = netlink_get_register(ctx, loc, sreg);
@@ -521,6 +521,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "hash statement has no expression");
 
+	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_OFFSET);
 	seed = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_SEED);
 	mod  = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_MODULUS);
 	len = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_LEN) * BITS_PER_BYTE;
@@ -531,7 +532,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 			return;
 	}
 
-	expr = hash_expr_alloc(loc, mod, seed);
+	expr = hash_expr_alloc(loc, mod, seed, offset);
 	expr->hash.expr = hexpr;
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_DREG);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0458af9..6c0f39b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -136,6 +136,7 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 			   div_round_up(expr->hash.expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_OFFSET, expr->hash.offset);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 82fec99..74f24a5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2580,14 +2580,14 @@ numgen_expr		:	NUMGEN	numgen_type	MOD	NUM	offset_opt
 			}
 			;
 
-hash_expr		:	JHASH	expr	MOD	NUM	SEED	NUM
+hash_expr		:	JHASH	expr	MOD	NUM	SEED	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, $6);
+				$$ = hash_expr_alloc(&@$, $4, $6, $7);
 				$$->hash.expr = $2;
 			}
-			|	JHASH	expr	MOD	NUM
+			|	JHASH	expr	MOD	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, 0);
+				$$ = hash_expr_alloc(&@$, $4, 0, $5);
 				$$->hash.expr = $2;
 			}
 			;
diff --git a/tests/py/ip/hash.t b/tests/py/ip/hash.t
index 306ebfd..0d01a11 100644
--- a/tests/py/ip/hash.t
+++ b/tests/py/ip/hash.t
@@ -3,4 +3,6 @@
 
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef;ok
 ct mark set jhash ip saddr . ip daddr mod 2;ok
+ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100;ok
+ct mark set jhash ip saddr . ip daddr mod 2 offset 100;ok
 dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index 1188a1b..c410a8c 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -12,6 +12,20 @@ ip test-ip4 pre
   [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 2 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100
+ip test-ip4 pre
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ hash reg 1 = jhash(reg 2, 8, 0xdeadbeef) % mod 2 offset 100 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set jhash ip saddr . ip daddr mod 2 offset 100
+ip test-ip4 pre
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 2 offset 100 ]
+  [ ct set mark with reg 1 ]
+
 # dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-- 
2.9.3

